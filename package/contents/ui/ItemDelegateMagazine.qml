import QtQuick 2.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

import org.kde.kcoreaddons 1.0 as KCoreAddons

import "components"
import "../code/htmlUtils.js" as Html

Item {
    readonly property int imageSize: parent.height

    RowLayout {
        anchors.fill: parent
            
        Image {
            sourceSize: Qt.size(imageSize, imageSize)
            fillMode: Image.PreserveAspectCrop
            source: model.cover
            clip: true
            Layout.preferredWidth: imageSize
            Layout.preferredHeight: imageSize
        }
        
        ColumnLayout {
            Layout.fillWidth: true

            PlasmaExtras.Heading {
                id: title
                level: 4
                text: model.title
                elide: Text.ElideRight
                maximumLineCount: 2
                width: parent.width
                font.weight: Font.Bold

                Layout.fillWidth: true
            }

            Paragraph {
                text: { text = Html.plainText(model.summary, 160) }
                elide: Text.ElideRight
                maximumLineCount: 3

                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            PlasmaComponents3.Label {
                font.pointSize: PlasmaCore.Theme.smallestFont.pointSize
                text: model.origin.title + ' | ' + KCoreAddons.Format.formatRelativeDateTime(model.date, Locale.ShortFormat)
                enabled: false
                elide: Text.ElideRight
                
                Layout.fillWidth: true
                Layout.minimumHeight: PlasmaCore.Units.iconSizes.small + PlasmaCore.Units.smallSpacing
            }
        }
    }
    
    Loader {
        id: loader
        active: isCurrentItem
        visible: active
        sourceComponent: actions
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
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