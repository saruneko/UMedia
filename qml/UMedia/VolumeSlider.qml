// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: container

    property int minimum: 0
    property int maximum: 100
    property int value: 100

    Behavior on x { NumberAnimation { duration: 300 } }

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
                value = (mouseX * 100 / slider.width);
            }

            onMouseXChanged: {
                if(value < 0){
                    value = 0;
                }else if(value > 100){
                    value = 100;
                }else if(slider_mouse.pressed){
                    value = (mouseX * 100 / slider.width);
                }
            }
        }
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

        property int x_pos: set_circle_position(circle_shadow)
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

        property int x_pos: set_circle_position(circle)
        anchors.leftMargin: x_pos - (width / 2)

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4ea1ff" }
            GradientStop { position: 1.0; color: "#2784ec" }
        }
    }

    function set_circle_position(obj){
        if(value >= 0 && value <= 100){
            return ((slider.width * (value - minimum)) / (maximum - minimum));
        }
        return obj.x_pos;
    }

    Text {
        id: txtSlider
        anchors { centerIn: slider }
        color: "white"
        font.bold: true
        text: update_volume()

        function update_volume(){
            // Return string representation of the current volume
            if(value >= 0 && value <= 100){
                playMusic.volume = (value / 100);
                return value + "%";
            }
            return txtSlider.text
        }
    }

}
