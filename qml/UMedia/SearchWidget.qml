// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: searchWidget
    width: parent.width
    height: parent.height - 50
    anchors.fill: parent
    anchors.leftMargin: 0
    anchors.topMargin: 50
    opacity: 0

    Background {}

    Behavior on opacity { NumberAnimation { duration: 200 } }
}
