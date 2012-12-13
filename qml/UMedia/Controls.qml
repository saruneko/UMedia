// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: controls
    width: parent.width
    height: 80
    anchors.bottom: parent.bottom
    border.width: 2
    border.color: "gray"

    property bool playing: false
    property int buttons_top_margin: 35

    Image {
        anchors.fill: parent
        fillMode: Image.Tile
        source: "img/bg-controls.png"
    }

    Slider {
        width: controls.width - 20
        anchors.left: controls.left
        anchors.top: controls.top
        anchors.leftMargin: 10
        anchors.topMargin: 12
    }

    Button {
        id: btn_playlist
        width: 30
        height: 30
        anchors.left: controls.left
        anchors.top: controls.top
        anchors.leftMargin: 10
        anchors.topMargin: buttons_top_margin + 5

        Image {
            source: "img/play.png"
            height: 20
            width: 20
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }
    Button {
        id: btn_back
        anchors.left: controls.left
        anchors.top: controls.top
        anchors.leftMargin: (umedia.width - 170) / 2
        anchors.topMargin: buttons_top_margin

        Image {
            source: "img/play.png"
            height: 30
            width: 30
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                umedia.previousSongRequested();
            }
        }
    }
    Button {
        id: btn_play
        width: 70
        anchors.left: btn_back.right
        anchors.top: controls.top
        anchors.leftMargin: 5
        anchors.topMargin: buttons_top_margin

        Image {
            source: "img/play.png"
            height: 40
            width: 40
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        MouseArea {
            id: playArea
            anchors.fill: parent

            onPressed:  {
                if(playMusic.source == ""){
                    umedia.nextSongRequested();
                }
                else if(playing){
                    playMusic.pause();
                    playing = false;
                }else{
                    playMusic.play();
                    playing = true;
                }
            }
        }
    }
    Button {
        id: btn_fwd
        anchors.left: btn_play.right
        anchors.top: controls.top
        anchors.leftMargin: 5
        anchors.topMargin: buttons_top_margin

        Image {
            source: "img/play.png"
            height: 30
            width: 30
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                umedia.nextSongRequested();
            }
        }
    }

    Button {
        id: btn_stop
        width: 30
        height: 30
        anchors.right: controls.right
        anchors.top: controls.top
        anchors.rightMargin: 10
        anchors.topMargin: buttons_top_margin + 5

        Image {
            source: "img/play.png"
            height: 20
            width: 20
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }

}
