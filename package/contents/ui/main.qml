import QtQuick 2.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import "components"
import "../lib/secrets"

Item {
    id: root
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.status: inoreader.loggedIn ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus

    Plasmoid.switchWidth: PlasmaCore.Units.gridUnit * 14
    Plasmoid.switchHeight: PlasmaCore.Units.gridUnit * 7

    Plasmoid.configurationRequired: !(appId && auth.clientSecret)

    Plasmoid.toolTipSubText: i18n("%1 unread articles", inoreaderStream.unreadCountFormatted)
   
    readonly property int updateIntervalInMilliseconds: plasmoid.configuration.updateInterval * 1000 * 60
    readonly property string appId: plasmoid.configuration.appId || ''
    readonly property string userId: plasmoid.configuration.userId || ''
    
    property bool busy: !plasmoid.configurationRequired && (secrets.pending || inoreaderStream.isPending("fetchStream"))
    property int unreadCount: inoreaderStream.unreadCount
    property var user: ({})

    Logic {
        id: logic
    }

    Timer {
        id: timer
        interval: updateIntervalInMilliseconds
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: logic.fetchStreamUnreadCount()
        onIntervalChanged: timer.running && timer.restart()
    }

    OAuth {
        readonly property string baseUrl: "https://www.inoreader.com/oauth2"
        id: auth
        clientId: appId
        authUrl: baseUrl + "/auth"
        tokenUrl: baseUrl + "/token"
        scope: 'read'
        redirectUri: 'localhost'
        onLoggedInChanged: {
            if (loggedIn) {
                timer.start()
                inoreader.getUserInfo().then(u => user = u)
            }
        }
    }

    InoreaderClient {
        id: inoreader
        authService: auth
    }

    InoreaderModel {
        id: inoreaderStream
        inoreader: inoreader
        dispatcher: logic
    }

    Connections {
        target: logic
        onLogin: auth.login()
        onLogout: auth.logout()
    }

    onUserChanged: {
        if (!plasmoid.configuration.userId) {
            plasmoid.configuration.userId = user.userId
        }
    }

    Secrets {
        id: secrets
        appId: "Inoreader"
        property bool pending: true 
        readonly property string tokenKey: (userId && root.appId) ? userId + "@" + root.appId : ""

        function stopPending() {
            pending = false
        }

        function restore() {
            const promises = []
            if (root.appId) {
                promises.push(get(root.appId).then(key => auth.clientSecret = key))
            }
            if (tokenKey) {
                promises.push(get(tokenKey).then(token => {
                    if (token) {
                        auth.token = JSON.parse(token)
                    }
                }))
            }
            Promise.all(promises).then(stopPending).catch(stopPending)
        }

        function init() {
            if (root.appId) {
                return restore()
            }
            const isUserEntry = e => e.includes("@")
            return list().then(d => {
                const userIds = d.filter(isUserEntry)
                const appIds = d.filter(e => !isUserEntry(e))

                if (userIds.length === 1) {
                    plasmoid.configuration.userId = userIds[0].split('@')[0] || ""
                }
                if (appIds.length === 1) {
                    plasmoid.configuration.appId = appIds[0]
                }
            })
        }

        onReady: {
            init()
            root.onAppIdChanged.connect(restore)
            root.onUserChanged.connect(() => set(tokenKey, JSON.stringify(auth.token)))
            plasmoid.onUserConfiguringChanged.connect(() => !plasmoid.userConfiguring && restore())
        }
    }
}
