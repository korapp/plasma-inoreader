import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

import "components"
import "../code/htmlUtils.js" as Html

PlasmaComponents3.ScrollView {
    property var entry
    property bool showImages
    property int textSize

    id: page
    clip: true
    padding: PlasmaCore.Units.smallSpacing
    
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    Keys.onUpPressed: ScrollBar.vertical.decrease()
    Keys.onDownPressed: ScrollBar.vertical.increase()

    property PageToolBar header: PageToolBar {
        ToolButton {
            action: logic.backAction
        }
        Item {
            Layout.fillWidth: true
        }
        ToolButton {
            action: logic.readAction
            actionTarget: entry
            value: entry.read
        }
        ToolButton {
            action: logic.starAction
            actionTarget: entry
            value: entry.starred
        }
    }
        
    Column {
        width: page.availableWidth - spacing
        spacing: PlasmaCore.Units.smallSpacing
        
        PlasmaExtras.Heading {
            text: entry.title
            level: 1
            elide: Text.ElideRight
            maximumLineCount: 3
            width: parent.width
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Qt.openUrlExternally(entry.canonical)
            }
        }   

        PlasmaComponents3.Label {
            font.pointSize: PlasmaCore.Theme.smallestFont.pointSize
            text: (entry.author ? entry.author + "\n" : "") + entry.origin.title + " | " + entry.date.toLocaleString(Locale.ShortFormat)
            enabled: false
            width: parent.width
        }
        
        Paragraph {
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link)
            onLinkHovered: mouseArea.cursorShape = link ? Qt.PointingHandCursor : Qt.ArrowCursor
            text: { 
                // force one time binding
                text = showImages
                    ? Html.adjustImages(entry.summary, width)
                    : Html.removeImages(entry.summary)
            }

            Binding on font.pointSize {
                when:  !!textSize
                value: textSize
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
            }
        }
    }
}
