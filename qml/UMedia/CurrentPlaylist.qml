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

    NumberAnimation { id: show_playlist; target: current_playlist; property: "x"; to: 0; duration: 200 }
    NumberAnimation { id: hide_playlist; target: current_playlist; property: "x"; to: -current_playlist.width; duration: 200 }

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
        model: ListModel { id: songModel }
        delegate: songDelegate
        highlight: Rectangle { color: "lightsteelblue"; radius: 4; opacity: 0.5; }
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
            umedia.play_song(view.model.get(view.currentIndex).path);
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                var index = view.indexAt(mouseX, mouseY);
                view.currentIndex = index;
                umedia.play_song(view.model.get(index).path);
            }
        }
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

    function add_song(title, artist, path){
        songModel.append({title: title, artist: artist, path: path});
    }
}
