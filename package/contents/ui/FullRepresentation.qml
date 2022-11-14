import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaExtras.Representation {
    id: full
    header: stack.currentItem.header

    readonly property var appletInterface: plasmoid.self
    
    readonly property int plasmoidHeight: plasmoid.configuration.plasmoidHeightFull
        ? plasmoid.availableScreenRect.height
        : plasmoid.configuration.plasmoidHeight

    Layout.preferredWidth: plasmoid.configuration.plasmoidWidth * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: plasmoidHeight * PlasmaCore.Units.devicePixelRatio

    property string errorMessage: ''

    Connections {
        target: auth
        onLoggedInChanged: load()
    }
    
    Connections {
        target: plasmoid
        onExpandedChanged: {
            if (expanded && auth.loggedIn && inoreaderStream.articles.count == 0) {
                load()
            }
        }
    }

    function load() {
        logic.fetchStream()
    }

    PlasmaExtras.PlaceholderMessage {
        id: placeholderMessage
        width: parent.width
        visible: false
        anchors.centerIn: parent
        state: "loading"

        PlasmaComponents3.BusyIndicator {
            id: busyIndicator
            running: visible
            visible: false
            Layout.alignment: Qt.AlignHCenter
        }

        states: [
            State {
                name: "loading"
                when: root.busy
                changes: [
                    PropertyChanges {
                        target: placeholderMessage
                        visible: true
                        text: i18n("Loading…")
                    },
                    PropertyChanges {
                        target: busyIndicator
                        visible: true
                    }
                ]
            },
            State {
                name: "error"
                when: !!errorMessage
                PropertyChanges {
                    target: placeholderMessage
                    visible: true
                    text: errorMessage
                    iconName: "error"
                }
            },
            State {
                name: "no_user"
                when: !auth.loggedIn && !plasmoid.configurationRequired
                PropertyChanges { 
                    target: placeholderMessage
                    visible: true
                    text: i18n("No user logged in")
                    iconName: "error"
                    helpfulAction: logic.loginAction
                }
            },
            State {
                name: "no_articles"
                when: auth.loggedIn && inoreaderStream.articles.count === 0
                PropertyChanges {
                    target: placeholderMessage
                    visible: true
                    text: i18n("No articles")
                    iconName: "view-pages-overview"
                    helpfulAction: logic.reloadAction
                }
            }
        ]
    }

    Component {
        id: streamView
        StreamView {
            stream: inoreaderStream
            onSelected: {
                stack.push(itemPage, { entry: item })
                
                if (plasmoid.configuration.autoRead) {
                    logic.setArticleRead(item, true)
                }
            }
        }
    }

    Component {
        id: itemPage
        ArticleView {
            showImages: plasmoid.configuration.articleImages
            textSize: plasmoid.configuration.articleTextSize
        }
    }

    StackView {
        id: stack
        clip: true
        initialItem: streamView
        visible: !placeholderMessage.visible
        onCurrentItemChanged: currentItem.forceActiveFocus()

        anchors.fill: parent

        Connections {
            target: logic
            onBackPage: stack.pop()
        }
    }
}
