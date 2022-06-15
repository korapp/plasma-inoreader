import QtQuick 2.0
import QtQuick.Controls 2.0

import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaComponents3.ToolButton {
    property var actionTarget
    property var value
    property int size
    
    icon.width: size
    icon.height: size
    display: AbstractButton.IconOnly

    PlasmaComponents3.ToolTip {
        parent: parent
        text: (action && action.text + (action.shortcut ? ` (${action.shortcut})` : '')) || parent.text
    }

    onValueChanged: {
        if (action && action.icons) {
            icon.name = action.icons[value] || ''
        }
    }
}