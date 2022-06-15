import QtQuick 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaComponents3.Label {
    property alias backgroundColor: background.color

    minimumPointSize: 3
    font.pixelSize: height
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    fontSizeMode: Text.Fit
    color: PlasmaCore.Theme.highlightedTextColor
    background: Rectangle {
        id: background
        radius: parent.height / 2
        color: PlasmaCore.Theme.highlightColor
    }
}