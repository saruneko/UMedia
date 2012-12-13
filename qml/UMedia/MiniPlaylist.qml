// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtMultimediaKit 1.1

Rectangle {
    id: miniPlaylist
    width: umedia.width / 2
    height: umedia.height - 80
    x: -width
    color: "white"

    Background{}

    property alias show: show_mini
    property alias hide: hide_mini

    NumberAnimation { id: show_mini; target: mini_playlist; property: "x"; to: 0; duration: 200 }
    NumberAnimation { id: hide_mini; target: mini_playlist; property: "x"; to: -mini_playlist.width; duration: 200 }

    Component {
        id: songDelegate
        Item {
            width: miniPlaylist.width; height: 40
            Column {
                Text { text: "<b>" + name + "</b>"; color: "white" }
                Text { text: artist; color: "white" }
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
        songModel.append({name: title, artist: artist, path: path});
    }
}
