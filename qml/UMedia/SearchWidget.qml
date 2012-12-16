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
    property alias searchList: view

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

            Keys.onUpPressed: {
                if(view.currentIndex == 0){
                    searchInput.textSearch.focus = true;
                }else{
                    event.accepted = false;
                }
            }

            Keys.onReturnPressed: {
                searchInput._play_song_from_search();
            }
        }
    }

    onOpacityChanged: {
        if(opacity == 1){
            load_songs();
        }
    }

    function load_songs(){
        for(var i=0; i < currentPlaylist.playlistItems.count; i++){
            var title = currentPlaylist.playlistItems.model.get(i).title;
            var artist = currentPlaylist.playlistItems.model.get(i).artist;
            var album = currentPlaylist.playlistItems.model.get(i).album;
            var path = currentPlaylist.playlistItems.model.get(i).path;
            songModel.append({title: title, artist: artist, path: path, album: album});
        }
    }

    function filter_list(text){
        view.model.clear();
        for(var i=0; i < currentPlaylist.playlistItems.count; i++){
            var title = currentPlaylist.playlistItems.model.get(i).title;
            if(!(new RegExp(text, "i")).test(title)){
                continue;
            }
            var artist = currentPlaylist.playlistItems.model.get(i).artist;
            var album = currentPlaylist.playlistItems.model.get(i).album;
            var path = currentPlaylist.playlistItems.model.get(i).path;
            songModel.append({title: title, artist: artist, path: path, album: album});
        }
    }

}
