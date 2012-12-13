// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7
import QtMultimediaKit 1.1

Rectangle {
    id: umedia
    width: 400
    height: 600

    signal songEnded
    signal nextSongRequested
    signal previousSongRequested

    Background{}

    Audio {
        id: playMusic
        source: ""

        onStarted: {
            var title = playMusic.metaData.title;
            var band = playMusic.metaData.albumArtist;
            cover.set_song_title(title, band);
        }

        onStatusChanged: {
             if (status == Audio.EndOfMedia) {
                 nextSongRequested();
             }
         }
    }

    Cover {
        id: cover2
        image: "img/The-Killers-Sams-Town-371666.jpg"

        Behavior on x { PropertyAnimation{duration: 200} }
        SequentialAnimation {
            id: slide_cover2
            running: false
            NumberAnimation { target: cover2; property: "x"; to: umedia.width; duration: 200 }
            NumberAnimation { target: cover2; property: "z"; to: 0; }
            NumberAnimation { target: cover; property: "z"; to: 1; }
            NumberAnimation { target: cover2; property: "x"; to: 0; }
         }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            drag.target: cover2
            drag.axis: Drag.XAxis

            onReleased: {
                if(cover2.x < (umedia.width / 2)){
                    cover2.x = 0;
                }
                else if(cover2.x > (umedia.width / 2)){
                    slide_cover2.running = true;
                }
            }
        }
    }

    MiniPlaylist {
        id: mini_playlist
    }

    Cover {
        id: cover

        Behavior on x { PropertyAnimation{duration: 200} }
        SequentialAnimation {
            id: slide_cover
            running: false
            NumberAnimation { target: cover; property: "x"; to: umedia.width; duration: 200 }
            NumberAnimation { target: cover; property: "z"; to: 0; }
            NumberAnimation { target: cover2; property: "z"; to: 1; }
            NumberAnimation { target: cover; property: "x"; to: 0; }
         }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            drag.target: cover
            drag.axis: Drag.XAxis

            onReleased: {
                if(cover.x > ((umedia.width / 2) - 40) && cover.x < ((umedia.width / 2) + 40)){
                    cover.x = (umedia.width / 2);
                    mini_playlist.show.running = true;
                }else if(cover.x < (umedia.width / 2)){
                    cover.x = 0;
                    mini_playlist.hide.running = true;
                }
                else if(cover.x > (umedia.width / 2)){
                    slide_cover.running = true;
                }
            }
        }
    }

    AnchorChanges {
        target: cover
        anchors.left: cover2.anchors.left
        anchors.top: cover2.anchors.top
    }

    Controls {
        id: controls
    }
    Rectangle {
        width: controls.width
        height: 5
        anchors.bottom: controls.top

        gradient: Gradient {
             GradientStop { position: 0.0; color: "#494848" }
             GradientStop { position: 0.5; color: "#ababab" }
             GradientStop { position: 1.0; color: "#494848" }
         }
    }

    Keys.onSpacePressed: {
        play_pressed();
    }

    Keys.onEscapePressed: {
        toggle_mini_playlist_visibility();
    }

    function play_pressed(){
        if(playMusic.source == ""){
            umedia.nextSongRequested();
            controls.play_image.source = "img/media_pause.png";
        }
        else if(playMusic.paused){
            playMusic.play();
            controls.play_image.source = "img/media_pause.png";
        }else{
            playMusic.pause();
            controls.play_image.source = "img/media_play.png";
        }
    }

    function play_song(song_path){
        playMusic.source = song_path;
        playMusic.play();
    }

    function add_song(title, artist, path){
        mini_playlist.add_song(title, artist, path);
    }

    function toggle_mini_playlist_visibility(){
        if(mini_playlist.x == 0){
            cover.x = 0;
            mini_playlist.hide.running = true;
        }else{
            cover.x = (umedia.width / 2);
            mini_playlist.show.running = true;
        }
    }

}
