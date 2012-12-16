// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7
import QtMultimediaKit 1.1

Rectangle {
    id: umedia
    width: 400
    height: 600

    signal add_songs
    signal playing_song(string title)
    signal repeat_changed(bool value)
    signal shuffle_changed(bool value)

    Background{}

    Audio {
        id: playMusic
        source: ""

        onStatusChanged: {
             if (status == Audio.EndOfMedia) {
                 currentPlaylist.next_song();
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

    CurrentPlaylist {
        id: currentPlaylist
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
                    currentPlaylist.show.running = true;
                }else if(cover.x < (umedia.width / 2)){
                    cover.x = 0;
                    currentPlaylist.hide.running = true;
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
        z: 2

        gradient: Gradient {
             GradientStop { position: 0.0; color: "#494848" }
             GradientStop { position: 0.5; color: "#ababab" }
             GradientStop { position: 1.0; color: "#494848" }
         }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Keys
    ////////////////////////////////////////////////////////////////////////////
    Keys.onSpacePressed: {
        controls.play_pressed();
    }

    Keys.onEscapePressed: {
        toggle_current_playlist_visibility();
    }

    Keys.onLeftPressed: {
        if(playMusic.position >= 5000){
            playMusic.position = playMusic.position - 5000;
        }else{
            playMusic.position = 0;
        }
    }

    Keys.onRightPressed: {
        if(playMusic.position < (playMusic.duration - 5000)){
            playMusic.position = playMusic.position + 5000;
        }else{
            playMusic.position = playMusic.duration;
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Functions
    ////////////////////////////////////////////////////////////////////////////
    function play_song(title, artist, album, song_path){
        // Validate song
        if(songs.valid_song_file(song_path)){
            //cover
            var cover_path = songs.get_cover_path_for_song(artist, album);
            cover.image = cover_path;
            // Set song
            playMusic.source = song_path;
            playMusic.play();
            cover.set_song_title(title, artist);
        }else{
            cover.set_error_message("Invalid Song", "This song can't be reproduced.");
        }
        playing_song(title);
    }

    function add_song(title, artist, album, path){
        currentPlaylist.add_song(title, artist, album, path);
    }

    function toggle_current_playlist_visibility(){
        if(currentPlaylist.x == 0){
            cover.x = 0;
            currentPlaylist.hide.running = true;
        }else{
            cover.x = (umedia.width / 2);
            currentPlaylist.show.running = true;
        }
    }

    function toggle_current_playlist_expanded(){
        if(currentPlaylist.width == umedia.width){
            currentPlaylist.z = 1;
            currentPlaylist.hide_expanded.running = true;
        }else{
            currentPlaylist.z = 1;
            currentPlaylist.show_expanded.running = true;
        }
    }

    function set_repeat(value){
        currentPlaylist.repeat = value;
    }

    function set_shuffle(value){
        currentPlaylist.shuffle = value;
    }

}
