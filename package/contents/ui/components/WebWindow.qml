import QtQuick 2.0
import QtQuick.Window 2.5
import QtWebEngine 1.5

Window {
    property alias url: web.url

    WebEngineView {
        id: web
        anchors.fill: parent
    }
}