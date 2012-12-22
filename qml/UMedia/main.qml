// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7
import QtMultimediaKit 1.1

Rectangle {
    id: umedia
    width: 400
    height: 600

    signal add_songs
    signal add_folder
    signal add_from_youtube(string url)
    signal playing_song(string title)
    signal repeat_changed(bool value)
    signal shuffle_changed(bool value)
    signal search_store(string search)
    signal purchase_song(string url)

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

    GeneralContainer {
        id: generalContainer

        property alias slideContainer: slide_container

        Behavior on x { PropertyAnimation{duration: 200} }
        SequentialAnimation {
            id: slide_container
            running: false
            NumberAnimation { target: generalContainer; property: "x"; to: umedia.width; duration: 400 }
            NumberAnimation { target: generalContainer; property: "z"; to: 0; }
            NumberAnimation { target: cover; property: "z"; to: 1; }
            NumberAnimation { target: generalContainer; property: "x"; to: 0; }
            NumberAnimation { target: currentPlaylist; property: "z"; to: 1; }
            NumberAnimation { target: menu; property: "z"; to: 2; }
         }
    }

    CurrentPlaylist {
        id: currentPlaylist
        playlistItems.focus: true
        x: cover.x - currentPlaylist.width
    }

    Cover {
        id: cover

        property alias slideCover: slide_cover

        Behavior on x { PropertyAnimation{duration: 200} }
        SequentialAnimation {
            id: slide_cover
            running: false
            NumberAnimation { target: cover; property: "x"; to: -cover.width; duration: 400 }
            NumberAnimation { target: cover; property: "z"; to: 0; }
            NumberAnimation { target: generalContainer; property: "z"; to: 1; }
            NumberAnimation { target: cover; property: "x"; to: 0; }
            NumberAnimation { target: currentPlaylist; property: "z"; to: 1; }
            NumberAnimation { target: menu; property: "z"; to: 2; }
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
                    cover.x = umedia.width;
                    toggle_current_playlist_expanded();
                }
            }

            onEntered: {
                menu.show_menu();
            }
            onExited: {
                menu.hide_menu();
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
        z: 2
    }
    Rectangle {
        width: controls.width
        height: 5
        anchors.bottom: controls.top
        z: 3

        gradient: Gradient {
             GradientStop { position: 0.0; color: "#494848" }
             GradientStop { position: 0.5; color: "#ababab" }
             GradientStop { position: 1.0; color: "#494848" }
         }
    }

    Menu {
        id: menu
    }

    Notification {
        id: notification
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
        if(event.modifiers & Qt.ControlModifier){
            currentPlaylist.previous_song();
        }else if(playMusic.position >= 5000){
            playMusic.position = playMusic.position - 5000;
        }else{
            playMusic.position = 0;
        }
    }

    Keys.onRightPressed: {
        if(event.modifiers & Qt.ControlModifier){
            currentPlaylist.next_song();
        }else if(playMusic.position < (playMusic.duration - 5000)){
            playMusic.position = playMusic.position + 5000;
        }else{
            playMusic.position = playMusic.duration;
        }
    }

    Keys.onTabPressed: {
        if(generalContainer.z == 1) {
            toggle_current_playlist_visibility();
        }else if(currentPlaylist.x == 0){
            if(cover.x == umedia.width){
                cover.x = (umedia.width / 2);
            }
            toggle_current_playlist_expanded();
        }
    }

    Keys.onMenuPressed: {
        if(currentPlaylist.searchEnabled == 0){
            currentPlaylist.z = 2;
            currentPlaylist.show_expanded.running = true;
            currentPlaylist.toggle_search_widget_visibility();
        }else{
            currentPlaylist.toggle_search_widget_visibility();
        }
    }

    Keys.onPressed: {
        if(event.key == Qt.Key_A){
            if(currentPlaylist.addSongs.opacity == 0){
                currentPlaylist.addSongs.opacity = 1;
                if(currentPlaylist.x != 0){
                    toggle_current_playlist_visibility();
                }
            }else{
                currentPlaylist.addSongs.opacity = 0;
            }
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
            menu.btnCover.button_icon.source = cover_path;
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
            if(currentPlaylist.searchEnabled == 1){
                currentPlaylist.toggle_search_widget_visibility();
            }
            currentPlaylist.addSongs.opacity = 0;
        }else{
            cover.x = (umedia.width / 2);
            currentPlaylist.z = 2;
            currentPlaylist.show.running = true;
        }
    }

    function toggle_current_playlist_expanded(){
        if(currentPlaylist.width == umedia.width){
            currentPlaylist.hide_expanded.running = true;
            if(currentPlaylist.searchEnabled == 1){
                currentPlaylist.toggle_search_widget_visibility();
                cover.x = (umedia.width / 2);
            }
        }else{
            currentPlaylist.z = 2;
            currentPlaylist.show_expanded.running = true;
        }
    }

    function set_repeat(value){
        currentPlaylist.repeat = value;
    }

    function set_shuffle(value){
        currentPlaylist.shuffle = value;
    }

    function load_store_result(title, artist, album, price, image, purchase_url){
        generalContainer.musicStore.load_store_result(title, artist, album, price, image, purchase_url);
    }

    function show_notification(text){
        notification.text.text = text;
        notification.showNotification.running = true;
    }

}
