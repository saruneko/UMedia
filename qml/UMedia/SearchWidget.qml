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

    property alias searchInput: search_input

    Background {}

    Behavior on opacity { NumberAnimation { duration: 200 } }

    Column {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5
        SearchInput {
            id: search_input
        }
        Component {
            id: songDelegate
            Item {
                width: currentPlaylist.width; height: 40
                Column {
                    Text { text: "<b>" + title + "</b>"; color: "white"; width: currentPlaylist.width }
                    Text { text: artist; color: "white"; width: currentPlaylist.width }
                }
            }
        }

        ListView {
            id: view
            height: searchWidget.height - search_input.height - 10
            width: searchWidget.width - 10
            model: ListModel { id: songModel }
            delegate: songDelegate
            highlight: Rectangle { width: view.width; color: "lightsteelblue"; radius: 4; opacity: 0.5; }
            focus: true

            Keys.onReturnPressed: {
//                if(currentPlaylist.x == 0){
//                    _play_song_for_index(view.currentIndex);
//                }else{
//                    controls.play_pressed();
//                }
            }
        }
    }

    Component.onCompleted: {
        songModel.append({title: "title", artist: "artist", path: "path", album: "album"});
        songModel.append({title: "title", artist: "artist", path: "path", album: "album"});
        songModel.append({title: "title", artist: "artist", path: "path", album: "album"});
        songModel.append({title: "title", artist: "artist", path: "path", album: "album"});
    }

}
