import QtQuick 2.0

import org.kde.plasma.core 2.0 as PlasmaCore

import "components"

MouseArea {
    onClicked: plasmoid.expanded = !plasmoid.expanded
   
    readonly property int minSize: Math.min(width, height)

    PlasmaCore.IconItem {
        anchors.centerIn: parent
        width: minSize
        height: minSize
        enabled: unreadCount > 0
        source: plasmoid.icon

        Loader {
            sourceComponent: badge
            active: plasmoid.configuration.unreadCount && unreadCount > 0
            visible: active

            height: parent.height / 2
            width: parent.width * (inoreaderStream.unreadCountFormatted.length > 2 ? .75 : .5)
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Component {
        id: badge
        Badge {
            text: inoreaderStream.unreadCountFormatted
            
            Binding on color {
                value: PlasmaCore.Theme.textColor
                when: !plasmoid.configuration.unreadCountHighlight
            }

            Binding on backgroundColor {
                value: PlasmaCore.Theme.backgroundColor
                when: !plasmoid.configuration.unreadCountHighlight
            }
        }
    }
}