import QtQuick 2.0
import QtQuick.Layouts 1.0

import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaExtras.PlasmoidHeading {
    
    default property alias children: layout.children

    RowLayout {
        id: layout
        anchors.fill: parent
    }
}