// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: playlistButtons
    Background{}
    width: currentPlaylist.width
    height: 50

    Row {
        spacing: 5
        anchors.fill: parent
        anchors.margins: 5
        Button {
            id: addSongs
            width: 40
            height: 40
            color: "transparent"
            back_image.anchors.margins: 1
            radius: 5
            button_icon.source: ""
        }
        Button {
            id: repeat
            width: 40
            height: 40
            color: "transparent"
            back_image.anchors.margins: 1
            radius: 5
            button_icon.source: "img/media_repeat.png"

            Behavior on color { ColorAnimation{duration: 200} }
            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    currentPlaylist.repeat = !currentPlaylist.repeat;
                    if(currentPlaylist.repeat){
                        repeat.color = "#2bb7d5";
                    }else{
                        repeat.color = "transparent";
                    }
                }
            }
        }
        Button {
            id: shuffle
            width: 40
            height: 40
            color: "transparent"
            back_image.anchors.margins: 1
            radius: 5
            button_icon.source: "img/media_shuffle.png"

            Behavior on color { ColorAnimation{duration: 200} }
            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    currentPlaylist.shuffle = !currentPlaylist.shuffle;
                    if(currentPlaylist.shuffle){
                        shuffle.color = "#2bb7d5";
                    }else{
                        shuffle.color = "transparent";
                    }
                }
            }
        }
        Button {
            id: expand
            width: 40
            height: 40
            color: "transparent"
            back_image.anchors.margins: 1
            radius: 5
            button_icon.source: ""
        }
    }
}
