// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: addsongs
    width: parent.width
    height: parent.height - 50
    anchors.fill: parent
    anchors.leftMargin: 0
    anchors.topMargin: 50
    opacity: 0

    Behavior on opacity { NumberAnimation { duration: 200 } }

    onOpacityChanged: {
        if(opacity == 0){
            youtubeInput.opacity = 0;
            youtubeButton.opacity = 0;
            currentPlaylist.playlistItems.focus = true;
        }
    }

    Background{}

    Column {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10

        Button {
            width: addsongs.width - 20
            Text{
                anchors.centerIn: parent
                text: "Add Songs"
                font.pointSize: 14
                font.bold: true
                color: "#2a6ddb"
            }
            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    umedia.add_songs();
                }
            }
        }

        Button {
            width: addsongs.width - 20
            Text{
                anchors.centerIn: parent
                text: "Add Folder"
                font.pointSize: 14
                font.bold: true
                color: "#2a6ddb"
            }
            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    umedia.add_folder();
                }
            }
        }

        Button {
            width: addsongs.width - 20
            Text{
                anchors.centerIn: parent
                text: "From YouTube"
                font.pointSize: 14
                font.bold: true
                color: "#2a6ddb"
            }
            MouseArea {
                anchors.fill: parent
                onPressed:  {
                    youtubeInput.opacity = 1;
                    youtubeButton.opacity = 1;
                    youtubeInput.textSearch.focus = true;
                }
            }
        }

        UserInput{
            id: youtubeInput
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Keys.onReturnPressed: {
                start_download();
            }
        }
        Button {
            id: youtubeButton
            opacity: 0
            width: 80
            x: addsongs.width - width - 20
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Image {
                id: btn_icon
                source: "img/youtube.png"
                width: 30
                height: 30
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 5
                anchors.topMargin: 5
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text{
                anchors.fill: parent
                anchors.rightMargin: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: "Add"
                font.pointSize: 12
                font.bold: true
                color: "#2a6ddb"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    start_download();
                }
            }
        }
    }

    function start_download(){
        var url = youtubeInput.textSearch.text;
        if(url.indexOf("http://") == -1){
            url = "http://youtu.be/" + url;
        }

        umedia.add_from_youtube(url);
        youtubeInput.textSearch.text = "";
        umedia.show_notification("Downloading...");
    }
}
