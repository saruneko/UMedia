// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtMultimediaKit 1.1

Rectangle {
    id: currentPlaylist
    width: umedia.width / 2
    height: umedia.height - 80
    x: -width
    color: "white"

    Background{}

    property alias show: show_playlist
    property alias hide: hide_playlist
    property int current_index: -1
    property bool repeat: false
    property bool shuffle: false

    NumberAnimation { id: show_playlist; target: currentPlaylist; property: "x"; to: 0; duration: 200 }
    NumberAnimation { id: hide_playlist; target: currentPlaylist; property: "x"; to: -currentPlaylist.width; duration: 200 }

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

        MouseArea {
            anchors.fill: parent

            onClicked: {
                var index = view.indexAt(mouseX, mouseY);
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

    ////////////////////////////////////////////////////////////////////////////
    // Functions
    ////////////////////////////////////////////////////////////////////////////
    function add_song(title, artist, album, path){
        songModel.append({title: title, artist: artist, path: path, album: album});
    }

    function _play_song_for_index(index){
        var title = view.model.get(index).title;
        var artist = view.model.get(index).artist;
        var album = view.model.get(index).album;
        var path = view.model.get(index).path;
        current_index = index;
        umedia.play_song(title, artist, album, path);
    }

    function previous_song() {
        var i = shuffle ? (Math.random() * (view.count - 1)) : (current_index - 1);
        if (i < 0)
            i = repeat ? (view.count - 1) : 0;
        _play_song_for_index(i);
    }

    function next_song() {
        var i = shuffle ? (Math.random() * (view.count - 1)) : (current_index + 1);
        if (i > view.count - 1) {
            if (repeat) {
                i = 0;
            } else {
                i = view.count - 1;
            }
        }
        _play_song_for_index(i);
    }
}
