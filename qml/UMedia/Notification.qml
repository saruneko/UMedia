// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: notification
    width: cover.width / 2
    height: 50
    radius: 10
    opacity: 0

    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 10
    border.width: 2
    border.color: "gray"

    property alias showNotification: show_notification
    property alias text: textNotification

    SequentialAnimation {
        id: show_notification
        NumberAnimation { target: notification; property: "opacity"; duration: 2000; easing.type: Easing.InOutQuad; to: 0.8 }
        NumberAnimation { target: notification; property: "opacity"; duration: 2000; easing.type: Easing.InOutQuad; to: 0 }
    }

    Image {
        id: btn_icon
        source: "img/youtube.png"
        width: 40
        height: 40
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 5
        anchors.topMargin: 5
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    Text{
        id: textNotification
        anchors.fill: parent
        anchors.rightMargin: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: "Downloading"
        font.pointSize: 12
        font.bold: true
        color: "#2a6ddb"
    }
}
