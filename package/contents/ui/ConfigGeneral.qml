import QtQuick 2.0
import QtQuick.Controls 2.0

import org.kde.kirigami 2.3 as Kirigami

Kirigami.FormLayout {

    property alias cfg_appId: appId.text
    property alias cfg_updateInterval: updateInterval.value
    property alias cfg_itemsDownloadLimit: itemsDownloadLimit.value
    property alias cfg_autoRead: autoRead.checked
    property alias cfg_fetchUnreadOnly: fetchUnreadOnly.checked

    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("API")
    }

    Text {
        text: `<a href="https://www.inoreader.com/?show_dialog=preferences_dialog&params={set_category:%27preferences_developer%27,ajax:true}">
            ${i18n("Register application to get id and key")}
            </a>`
        textFormat: Text.StyledText
        onLinkActivated: Qt.openUrlExternally(link)
        visible: !(appId.text && appKey.text)
    }

    Secrets {
        id: secrets
        onReady: getAppKey()
        
        function getAppKey() {
            return get(appId.text).then(r => appKey.text = r)
        }
    }

    TextField {
        id: appId
        validator: IntValidator {}
        onEditingFinished: secrets.getAppKey(appId.text)
        Kirigami.FormData.label: i18n("App id")
    }

    TextField {
        id: appKey
        onEditingFinished: secrets.set(appId.text, text)
        Kirigami.FormData.label: i18n("App key")
    }

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Behavior")
    }

    SpinBox {
        id: updateInterval
        from: 1
        to: 1440
        Kirigami.FormData.label: i18n("Update interval [min]")
    }

    SpinBox {
        id: itemsDownloadLimit
        from: 1
        Kirigami.FormData.label: i18n("Items download limit")
    }

    CheckBox {
        id: fetchUnreadOnly
        Kirigami.FormData.label: i18n("Fetch unread only")
    }

    CheckBox {
        id: autoRead
        Kirigami.FormData.label: i18n("Automatically mark an article as read")
    }

}