// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: button
    width: 40
    height: 40
    smooth: true
    color: "transparent"
//    border.width: 1
//    border.color: "gray"

    BorderImage {
        id: background
        source: "img/button.svg"
        anchors.fill: parent
        smooth: true
    }
}
