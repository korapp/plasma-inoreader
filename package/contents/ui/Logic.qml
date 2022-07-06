import QtQuick 2.0
import QtQuick.Controls 2.5

QtObject {
    signal login()
    signal logout()

    signal fetchStreamUnreadCount()
    signal fetchStream()
    signal fetchStreamContinuation()

    signal setAllArticlesRead(bool read)
    signal setArticleRead(var article, bool read)
    signal setArticleStarred(var article, bool starred)

    signal backPage()

    readonly property Action loginAction: Action {
        text: i18n("Login")
        icon.name: "user"
        onTriggered: login()
    }
   
    readonly property Action logoutAction: Action {
        text: i18n("Logout")
        icon.name: "system-log-out"
        onTriggered: logout()
    }

    readonly property Action backAction: Action {
        text: i18n("Back")
        icon.name: "go-previous-view"
        shortcut: "Backspace"
        onTriggered: backPage()
    }

    readonly property Action reloadAction: Action {
        icon.name: "view-refresh"
        text: i18n("Refresh")
        shortcut: "F5"
        onTriggered: fetchStream()
    }

    readonly property Action readAction: Action {
        readonly property var icons: ({ false: "mail-unread", true: "mail-thread-watch" })
        text: i18n("Read")
        shortcut: "M"
        onTriggered: setArticleRead(source.actionTarget, !source.actionTarget.read)
    }
   
    readonly property Action readAllAction: Action {
        icon.name: "checkbox"
        text: i18n("Read all")
        onTriggered: setAllArticlesRead(true)
    } 

    readonly property Action starAction: Action {
        readonly property var icons: ({ false: "non-starred-symbolic", true: "starred-symbolic" })
        text: i18n("Star")
        shortcut: "F"
        onTriggered: setArticleStarred(source.actionTarget, !source.actionTarget.starred)
    }

    readonly property Action fetchStreamContinuationAction: Action {
        text: i18n("More…")
        onTriggered: fetchStreamContinuation()
    }
   
}