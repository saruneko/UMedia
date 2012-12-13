// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: container

    property int minimum: 0
    property int maximum: 100
    property int value: playMusic.position * 100 / playMusic.duration

    Rectangle {
        id: slider
        width: container.width
        height: 8
        smooth: true
        radius: 5
        border.width: 1
        border.color: "#191919"
        clip: true

        gradient: Gradient {
             GradientStop { position: 0.0; color: "#494949" }
             GradientStop { position: 1.0; color: "#636363" }
         }

        Rectangle {
            id: highlight

            property int widthDest: ((slider.width * (value - minimum)) / (maximum - minimum) - 6)

            width: highlight.widthDest
            Behavior on width { SmoothedAnimation { velocity: 1200 } }

            anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 2 }
            radius: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#4ea1ff" }
                GradientStop { position: 1.0; color: "#2784ec" }
            }

        }

        MouseArea {
            id: slider_mouse
            anchors.fill: parent

            onClicked: {
                var value = (mouseX * 100 / slider.width) * playMusic.duration / 100;
                playMusic.position = value;
            }

            onMouseXChanged: {
                if(slider_mouse.pressed){
                    var value = (mouseX * 100 / slider.width) * playMusic.duration / 100;
                    playMusic.position = value;
                }
            }
        }
    }

    function millisecondsToTime(milli)
    {
        var milliseconds = milli % 1000;
        var seconds = Math.floor((milli / 1000) % 60);
        var minutes = Math.floor((milli / (60 * 1000)) % 60);
        if(seconds < 10){
            seconds = "0" + seconds
        }

        return minutes + ":" + seconds;
    }

    Rectangle {
        id: circle_shadow
        width: 20
        height: 20
        radius: width * 0.5
        anchors.left: slider.left
        y: slider.y - ((height - slider.height) / 2)
        opacity: 0.3
        smooth: true

        property int x_pos: ((slider.width * (value - minimum)) / (maximum - minimum))
        anchors.leftMargin: x_pos - (width / 2)

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4ea1ff" }
            GradientStop { position: 1.0; color: "#2784ec" }
        }
    }

    Rectangle {
        id: circle
        width: 10
        height: 10
        radius: width * 0.5
        anchors.left: slider.left
        y: slider.y - ((height - slider.height) / 2)
        smooth: true

        property int x_pos: ((slider.width * (value - minimum)) / (maximum - minimum))
        anchors.leftMargin: x_pos - (width / 2)

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4ea1ff" }
            GradientStop { position: 1.0; color: "#2784ec" }
        }
    }

    Text {
        anchors { centerIn: slider }
        color: "white"
        font.bold: true
        text: millisecondsToTime(playMusic.position)
    }

}
