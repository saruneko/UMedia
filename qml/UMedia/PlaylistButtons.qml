// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: playlistButtons
    width: currentPlaylist.width
    height: 50

    property alias btn_repeat: repeat
    property alias btn_shuffle: shuffle

    Background{}

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
            button_icon.source: "img/plus.png"

            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    if(currentPlaylist.addSongs.opacity == 0){
                        currentPlaylist.addSongs.opacity = 1;
                    }else{
                        currentPlaylist.addSongs.opacity = 0;
                    }
                }
            }
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
                    umedia.repeat_changed(currentPlaylist.repeat);
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
                    umedia.shuffle_changed(currentPlaylist.shuffle);
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
            button_icon.source: "img/expand_icon.png"

            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    umedia.toggle_current_playlist_expanded();
                }
            }
        }
        Button {
            id: search
            width: 40
            height: 40
            color: "transparent"
            back_image.anchors.margins: 1
            radius: 5
            button_icon.source: "img/search.png"
            opacity: 0

            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    currentPlaylist.toggle_search_widget_visibility();
                }
            }

            Behavior on opacity { NumberAnimation { duration: 100 } }
        }
    }

    onWidthChanged: {
        if(playlistButtons.width == umedia.width){
            search.opacity = 1;
        }else{
            search.opacity = 0;
        }
    }

}
