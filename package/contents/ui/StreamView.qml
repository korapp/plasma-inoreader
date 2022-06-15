import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents //for Highlight, ListItem
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras

import "components"

FocusScope {
    readonly property var viewMinSizeMap: ({
        Card: [250, 300],
        Magazine: [400, 96],
        List: [400, 43]
    })
    property InoreaderModel stream

    signal selected(var item)

    Component {
        id: newArticlesButton
        PlasmaComponents3.Button {
            action: logic.fetchStreamAction
            text: action.text + ` (${stream.unreadNewCount})`
            flat: true
            width: parent.width
        }
    }

    Component {
        id: fetchMoreButton
        PlasmaComponents3.Button {
            action: logic.fetchStreamContinuationAction
            flat: true
            width: parent.width
            enabled: !stream.isPending("fetchStreamContinuation")

            indicator: PlasmaComponents3.ProgressBar {
                visible: !parent.enabled
                indeterminate: true
                width: parent.width
                anchors.centerIn: parent
            }
        }
    }

    property PageToolBar header: PageToolBar {
        PlasmaExtras.Heading {
            id: heading
            level: 1
            text: stream.title
            Layout.fillWidth: true
        }
        ToolButton {
            action: logic.reloadAction
        }
    }
    
    PlasmaComponents3.ScrollView {
        anchors.fill: parent
        focus: true
        
        /*ListView {
            id: listView
            currentIndex: -1
            clip: true
            focus: true
            model: stream.articles
            spacing: PlasmaCore.Units.smallSpacing
            boundsBehavior: Flickable.StopAtBounds
            highlight: PlasmaComponents.Highlight {}
            highlightMoveDuration: PlasmaCore.Units.shortDuration
            header: stream.unreadNewCount ? newArticlesButton : null
            footer: stream.hasContinuation ? fetchMoreButton : null
            delegate: PlasmaComponents.ListItem {
                id: wrapper
                width: ListView.view.width
                enabled: true
                opacity: model.read ? 0.6 : 1
                onContainsMouseChanged: listView.currentIndex = index
                onClicked: selected(model)
                Keys.onReturnPressed: clicked()
                content: Loader {
                    source: `ItemDelegate${plasmoid.configuration.viewStyle}.qml`
                    width: parent.width
                }
                property bool isCurrentItem: ListView.isCurrentItem
            }
        }*/

        GridView {
            readonly property var cellSizes: viewMinSizeMap[plasmoid.configuration.viewStyle]
            readonly property int fixedColumnNumber: plasmoid.configuration.streamViewFixedColumns || 0
            readonly property int minCellWidth: cellSizes[0] + 12 // declared size + PlasmaComponents.ListItem margins
            readonly property int minCellHeight: cellSizes[1] + 12 // declared size + PlasmaComponents.ListItem margins
            readonly property int dynamicColumnNumber: fixedColumnNumber || Math.max(width / minCellWidth | 0, 1)
            readonly property int dynamicCellWidth: Math.max(width / dynamicColumnNumber, fixedColumnNumber ? 0 : minCellWidth)

            id: listView
            cellWidth: dynamicCellWidth
            cellHeight: minCellHeight
            currentIndex: -1
            clip: true
            focus: true
            model: stream.articles
            boundsBehavior: Flickable.StopAtBounds
            highlight: PlasmaComponents.Highlight {}
            header: stream.unreadNewCount ? newArticlesButton : null
            footer: stream.hasContinuation ? fetchMoreButton : null
            delegate: PlasmaComponents.ListItem {
                id: listItem
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                enabled: true
                clip: true
                opacity: model.read ? 0.6 : 1
                onContainsMouseChanged: listView.currentIndex = index
                onClicked: selected(model)
                Keys.onReturnPressed: clicked()
                content: Loader {
                    source: `ItemDelegate${plasmoid.configuration.viewStyle}.qml`
                    anchors.fill: parent
                }
                property bool isCurrentItem: GridView.isCurrentItem
            }
        }
    }
}
