// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7
import QtMultimediaKit 1.1

Rectangle {
    id: umedia
    width: 350
    height: 500

    signal songEnded
    signal nextSongRequested

    Image {
        anchors.fill: parent
        fillMode: Image.Tile
        source: "img/bg-dark_grain.png"
    }

    Audio {
        id: playMusic
        source: "/home/gatox/Downloads/temp/Of Monsters And Men-My Head Is An Animal (2011) 320Kbit(mp3) DMT/06 - Of Monsters And Men - Little Talks.mp3"
        autoLoad: true

        onStarted: {
            var title = playMusic.metaData.title;
            var band = playMusic.metaData.albumArtist;
            cover.set_song_title(title, band);
        }

//        onStopped: {
//            songEnded();
//        }
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
                if(cover.x < (umedia.width / 2)){
                    cover.x = 0;
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

    function play_song(song_path){
        playMusic.source = song_path;
        playMusic.play();
    }

}
