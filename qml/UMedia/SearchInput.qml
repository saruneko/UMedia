// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle{
    id: search_box
    color: "#3a3d42"
    radius: 20
    width: parent.width
    height: 30
    smooth: true

    property alias textSearch: txt_search

    Behavior on border.color { ColorAnimation{duration: 200} }

    TextInput{
        id: txt_search
        x: 10
        y: 4
        width: 158
        height: 28
        text: ""
        selectionColor: "#286daa"
        anchors.right: parent.right
        anchors.rightMargin: 32
        cursorVisible: true
        horizontalAlignment: TextInput.AlignLeft
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: 14
        color: "#a7afb8"

        Image{
            x: 160
            y: -2
            anchors.leftMargin: 0
            anchors.left: txt_search.right
            source: "img/search_icon.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    txt_search.selectAll();
                    txt_search.focus = true;
                }
                onEntered: {
                    search_box.border.color = "white";
                }
                onExited: {
                    search_box.border.color = "#3a3d42";
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                txt_search.selectAll();
                txt_search.focus = true;
            }
            onEntered: {
                search_box.border.color = "white";
            }
            onExited: {
                search_box.border.color = "#3a3d42";
            }
        }
    }

}
