import QtQuick 2.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

import org.kde.kcoreaddons 1.0 as KCoreAddons

import "components"

GridLayout {
    columns: 2
    rows: 2

    PlasmaExtras.Heading {
        level: 3
        text: model.title
        elide: Text.ElideRight
        maximumLineCount: 1
        width: parent.width
        wrapMode: Text.NoWrap
        Layout.fillWidth: true
    }

    PlasmaComponents3.Label {
        font.pointSize: PlasmaCore.Theme.smallestFont.pointSize
        text: model.origin.title + ' | ' + KCoreAddons.Format.formatRelativeDateTime(model.date, Locale.ShortFormat)
        enabled: false
        width: parent.width
        Layout.row: 1
    }
    
    Loader {
        id: loader
        active: isCurrentItem
        visible: active
        sourceComponent: actions
        Layout.column: 1
        Layout.row: 0
        Layout.rowSpan: 2
    }

    Component {
        id: actions
        Row {
            ToolButton {
                action: logic.readAction
                actionTarget: model
                value: model.read
                size: PlasmaCore.Units.iconSizes.small
            }
            ToolButton {
                action: logic.starAction
                actionTarget: model
                value: model.starred
                size: PlasmaCore.Units.iconSizes.small
            }
        }
    }
}
