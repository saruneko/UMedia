// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: menu
    width: 75
    height: parent.height - 300
    anchors.top: parent.top
    anchors.topMargin: 60
    anchors.rightMargin: 50
    opacity: 0.2
    color: "black"
    radius: 15
    x: parent.width

    property alias btnCover: btn_cover

    Behavior on x { NumberAnimation { duration: 200 } }
    Behavior on opacity { NumberAnimation { duration: 200 } }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            menu.opacity = 0.9;
            show_menu();
        }
        onExited: {
            menu.opacity = 0.2;
            hide_menu();
        }
    }

    Column {
        anchors.top: menu.top
        anchors.topMargin: (menu.height / 2) - 80 // 1 + 1/2 button + spacing
        anchors.right: menu.right
        anchors.rightMargin: 20
        spacing: 5

        Button{
            id: btn_cover
            height: 50
            width: 50
            button_icon.source: "img/umedia.png"
            button_icon.width: 40
            button_icon.height: 40

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    generalContainer.slideContainer.running = true;
                    currentPlaylist.playlistItems.focus = true;
                }
            }
        }
//        Button{
//            height: 50
//            width: 50
//        }
        Button{
            height: 50
            width: 50
            button_icon.source: "img/cart.png"
            button_icon.width: 40
            button_icon.height: 40

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    cover.slideCover.running = true;
                    generalContainer.musicStore.searchInput.textSearch.focus = true;
                }
            }
        }
    }

    function show_menu(){
        menu.x = (parent.width + 15) - menu.width;
    }

    function hide_menu(){
        menu.x = parent.width;
    }
}
