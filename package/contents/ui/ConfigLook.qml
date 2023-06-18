import QtQuick 2.0
import QtQuick.Controls 2.0

import org.kde.kirigami 2.3 as Kirigami

Kirigami.FormLayout {

    property alias cfg_unreadCount: unreadCount.checked
    property alias cfg_unreadCountHighlight: unreadCountHighlight.checked
    property alias cfg_viewStyle: viewStyle.value
    property alias cfg_plasmoidHeight: plasmoidHeight.value
    property alias cfg_plasmoidWidth: plasmoidWidth.value
    property alias cfg_plasmoidHeightFull: plasmoidHeightFull.checked
    property alias cfg_streamViewFixedColumns: streamViewFixedColumns.value
    property alias cfg_articleImages: articleImages.checked
    property alias cfg_articleTextSize: articleTextSize.value

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Compact")
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

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Listing")
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

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Article")
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