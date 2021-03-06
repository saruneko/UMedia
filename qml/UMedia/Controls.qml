// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: controls
    width: parent.width
    height: 80
    anchors.bottom: parent.bottom
    border.width: 2
    border.color: "gray"

    property int buttons_top_margin: 35

    Background{ source: "img/bg-controls.png" }

    Slider {
        width: controls.width - 40
        anchors.left: controls.left
        anchors.top: controls.top
        anchors.leftMargin: 10
        anchors.topMargin: 12
    }

    Image {
        width: 20
        height: 20
        anchors.right: controls.right
        anchors.top: controls.top
        anchors.rightMargin: 5
        anchors.topMargin: 6
        fillMode: Image.PreserveAspectFit
        source: "img/volume.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(volumeSlider.x > umedia.width){
                    volumeSlider.z = 2;
                    volumeSlider.x = umedia.width - volumeSlider.width - 13;
                }else{
                    volumeSlider.x = umedia.width + 20;
                }
            }
        }
    }

    Button {
        id: btn_playlist
        width: 30
        height: 30
        anchors.left: controls.left
        anchors.top: controls.top
        anchors.leftMargin: 10
        anchors.topMargin: buttons_top_margin + 5
        smooth: true
        button_icon.source: "img/list.svg"
        button_icon.height: 20
        button_icon.width: 20

        MouseArea {
            anchors.fill: parent
            onClicked: {
                umedia.toggle_current_playlist_visibility();
            }
        }
    }
    Button {
        id: btn_back
        anchors.left: controls.left
        anchors.top: controls.top
        anchors.leftMargin: (umedia.width - 170) / 2
        anchors.topMargin: buttons_top_margin
        button_icon.source: "img/media_previous.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentPlaylist.previous_song();
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
        button_icon.source: "img/media_play.png"
        button_icon.height: 40
        button_icon.width: 40

        MouseArea {
            id: playArea
            anchors.fill: parent
            onPressed:  {
                play_pressed();
            }
        }
    }
    Button {
        id: btn_fwd
        anchors.left: btn_play.right
        anchors.top: controls.top
        anchors.leftMargin: 5
        anchors.topMargin: buttons_top_margin
        button_icon.source: "img/media_next.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentPlaylist.next_song();
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
        button_icon.source: "img/media_stop.png"
        button_icon.height: 20
        button_icon.width: 20

        MouseArea {
            anchors.fill: parent
            onClicked: {
                playMusic.stop();
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Functions
    ////////////////////////////////////////////////////////////////////////////
    function play_pressed(){
        if(playMusic.source == ""){
            currentPlaylist.next_song();
            btn_play.button_icon.source = "img/media_pause.png";
        }
        else if(playMusic.paused){
            playMusic.play();
            btn_play.button_icon.source = "img/media_pause.png";
        }else{
            playMusic.pause();
            btn_play.button_icon.source = "img/media_play.png";
        }
    }

}
