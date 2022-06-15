import QtQuick 2.6
import QtGraphicalEffects 1.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

import org.kde.kcoreaddons 1.0 as KCoreAddons

import "components"

Image {
    id: image
    sourceSize: Qt.size(parent.width, parent.height)
    fillMode: Image.PreserveAspectCrop
    source: model.cover
    clip: true
    anchors.fill: parent

    ShaderEffectSource{
        id: shader
        sourceItem: image
        anchors.fill: overlay
        sourceRect: Qt.rect(x,y, width, height)
    }
    
    FastBlur {
        anchors.fill: shader
        source: shader
        radius: 32
    }

    Rectangle {
        opacity: 0.6
        color: PlasmaCore.Theme.backgroundColor
        anchors.fill: overlay
    }

    Column {
        id: overlay
        width: parent.width
        padding: PlasmaCore.Units.smallSpacing
        anchors.bottom: parent.bottom

        PlasmaExtras.Heading {
            level: 3
            text: model.title
            elide: Text.ElideRight
            maximumLineCount: 3
            width: parent.width
        }
        
        PlasmaComponents3.Label {
            font.pointSize: PlasmaCore.Theme.smallestFont.pointSize
            text: model.origin.title + ' | ' + KCoreAddons.Format.formatRelativeDateTime(model.date, Locale.ShortFormat)
            enabled: false
            width: parent.width
            height: PlasmaCore.Units.iconSizes.small + PlasmaCore.Units.smallSpacing
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