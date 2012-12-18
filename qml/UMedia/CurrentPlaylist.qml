// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7

Rectangle {
    id: currentPlaylist
    width: umedia.width / 2
    height: umedia.height - 80
    x: -width
    color: "white"

    Background{}

    property alias playlistItems: view
    property alias show: show_playlist
    property alias hide: hide_playlist
    property alias show_expanded: show_playlist_expanded
    property alias hide_expanded: hide_playlist_expanded
    property alias buttons: playlistButtons
    property alias searchEnabled: searchWidget.opacity
    property alias addSongs: add_songs
    property int current_index: -1
    property bool repeat: false
    property bool shuffle: false

    NumberAnimation { id: show_playlist; target: currentPlaylist; property: "x"; to: 0; duration: 200 }
    SequentialAnimation {
        id: hide_playlist
        NumberAnimation { target: currentPlaylist; property: "x"; to: -currentPlaylist.width; duration: 200 }
        NumberAnimation { target: currentPlaylist; property: "z"; to: 0; duration: 200 }
        NumberAnimation { target: currentPlaylist; property: "width"; to: (umedia.width / 2); duration: 200 }
    }
    ParallelAnimation {
        id: show_playlist_expanded
        NumberAnimation { target: currentPlaylist; property: "width"; to: umedia.width; duration: 200 }
        NumberAnimation { target: currentPlaylist; property: "x"; to: 0; duration: 200 }
    }
    ParallelAnimation {
        id: hide_playlist_expanded
        NumberAnimation { target: currentPlaylist; property: "width"; to: (umedia.width / 2); duration: 200 }
        NumberAnimation { target: currentPlaylist; property: "x"; to: 0; duration: 200 }
        NumberAnimation { target: currentPlaylist; property: "z"; to: 0; duration: 200 }
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
        anchors.fill: parent
        anchors.margins: 5
        anchors.topMargin: 50
        model: ListModel { id: songModel }
        delegate: songDelegate
        highlight: Rectangle { width: view.width; color: "lightsteelblue"; radius: 4; opacity: 0.5; }
        focus: true

        // Only show the scrollbars when the view is moving.
        states: State {
            name: "ShowBars"
            when: view.movingVertically
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 400 }
        }

        Keys.onReturnPressed: {
            if(currentPlaylist.x == 0){
                _play_song_for_index(view.currentIndex);
            }else{
                controls.play_pressed();
            }
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Q){

            }else if(event.key == Qt.Key_Minus){
                var index = view.currentIndex;
                view.model.remove(index);
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                var index = view.indexAt(mouseX, mouseY + view.contentY);
                view.currentIndex = index;
                _play_song_for_index(index);
            }
        }
    }

    PlaylistButtons{
        id: playlistButtons
    }

    ScrollBar {
        id: verticalScrollBar
        width: 12; height: view.height-12
        anchors.right: view.right
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio
    }

    onRepeatChanged: {
        if(repeat){
            playlistButtons.btn_repeat.color = "#2bb7d5";
        }else{
            playlistButtons.btn_repeat.color = "transparent";
        }
    }

    onShuffleChanged: {
        if(shuffle){
            playlistButtons.btn_shuffle.color = "#2bb7d5";
        }else{
            playlistButtons.btn_shuffle.color = "transparent";
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Search Component
    ////////////////////////////////////////////////////////////////////////////
    SearchWidget {
        id: searchWidget
    }

    ////////////////////////////////////////////////////////////////////////////
    // Add Songs Component
    ////////////////////////////////////////////////////////////////////////////
    AddSongs {
        id: add_songs
    }

    ////////////////////////////////////////////////////////////////////////////
    // Functions
    ////////////////////////////////////////////////////////////////////////////
    function add_song(title, artist, album, path){
        songModel.append({title: title, artist: artist, path: path, album: album});
    }

    function _play_song_for_index(index){
        if(index != -1 && index < view.count){
            var title = view.model.get(index).title;
            var artist = view.model.get(index).artist;
            var album = view.model.get(index).album;
            var path = view.model.get(index).path;
            current_index = index;
            umedia.play_song(title, artist, album, path);
            view.currentIndex = index;
        }
    }

    function previous_song() {
        var i = shuffle ? (Math.random() * (view.count - 1)) : (current_index - 1);
        if (i < 0)
            i = repeat ? (view.count - 1) : 0;
        _play_song_for_index(i);
    }

    function next_song() {
        var i = shuffle ? parseInt(Math.random() * (view.count - 1)) : (current_index + 1);
        if (i > view.count - 1) {
            if (repeat) {
                i = 0;
            } else {
                i = view.count - 1;
            }
        }
        _play_song_for_index(i);
    }

    function toggle_search_widget_visibility(){
        if(searchWidget.opacity == 0){
            searchWidget.opacity = 1;
            searchWidget.searchInput.textSearch.focus = true;
        }else{
            searchWidget.opacity = 0;
            view.focus = true;
        }
    }
}
