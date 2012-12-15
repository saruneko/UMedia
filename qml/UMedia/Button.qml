// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: button
    width: 40
    height: 40
    smooth: true
    color: "transparent"

    property alias back_image: background
    property alias button_icon: btn_icon

    BorderImage {
        id: background
        source: "img/button.svg"
        anchors.fill: parent
        smooth: true
    }
    Image {
        id: btn_icon
        source: ""
        width: 30
        height: 30
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
    }
}
