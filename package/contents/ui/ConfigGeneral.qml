import QtQuick 2.0
import QtQuick.Controls 2.0

import org.kde.kirigami 2.3 as Kirigami

Kirigami.FormLayout {

    property alias cfg_appId: appId.text
    property alias cfg_updateInterval: updateInterval.value
    property alias cfg_itemsDownloadLimit: itemsDownloadLimit.value
    property alias cfg_autoRead: autoRead.checked
    property alias cfg_unreadCount: unreadCount.checked
    property alias cfg_unreadCountHighlight: unreadCountHighlight.checked
    property alias cfg_viewStyle: viewStyle.value
    property alias cfg_fetchUnreadOnly: fetchUnreadOnly.checked
    property alias cfg_plasmoidHeight: plasmoidHeight.value
    property alias cfg_plasmoidWidth: plasmoidWidth.value
    property alias cfg_plasmoidHeightFull: plasmoidHeightFull.checked
    property alias cfg_streamViewFixedColumns: streamViewFixedColumns.value
    property alias cfg_articleImages: articleImages.checked
    property alias cfg_articleTextSize: articleTextSize.value

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

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Look")
    }

    CheckBox {
        id: unreadCount
        Kirigami.FormData.label: i18n("Unread count")
    }

    CheckBox {
        id: unreadCountHighlight
        enabled: unreadCount.checked
        Kirigami.FormData.label: i18n("Highlight unread count")
    }

    Row {
        Kirigami.FormData.label: i18n("Height")
        SpinBox {
            id: plasmoidHeight
            to: 2147483647
            enabled: !plasmoidHeightFull.checked
        }
        CheckBox {
            id: plasmoidHeightFull
            text: i18n("Fill screen")
        }
    }

    SpinBox {
        id: plasmoidWidth
        to: 2147483647
        Kirigami.FormData.label: i18n("Width")
    }

    Row {
        Kirigami.FormData.label: i18n("Listing view columns")
        SpinBox {
            id: streamViewFixedColumns
            to: 10
            enabled: !streamViewFixedColumnsAuto.checked
        }
        CheckBox {
            id: streamViewFixedColumnsAuto
            text: i18n("Auto")
            checked: streamViewFixedColumns.value == 0
            onCheckedChanged: streamViewFixedColumns.value = !checked
        }
    }

    ButtonGroup {
        id: viewStyle
        buttons: viewButtons.children
        property string value
        onClicked: value = button.value
    }

    Row {
        id: viewButtons
        Kirigami.FormData.label: i18n("View style")
        
        Button {
            text: i18n("List")
            icon.name: "view-list-text"
            checked: cfg_viewStyle === value
            property string value: "List"
        }

        Button {
            text: i18n("Magazine")
            icon.name: "view-list-details"
            checked: cfg_viewStyle === value
            property string value: "Magazine"
        }

        Button {
            text: i18n("Card")
            icon.name: "viewimage"
            checked: cfg_viewStyle === value
            property string value: "Card"
        }
    }

    CheckBox {
        id: articleImages
        Kirigami.FormData.label: i18n("Show article images")
    }

    SpinBox {
        id: articleTextSize
        Kirigami.FormData.label: i18n("Text size")
    }

}