// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: cover
    width: parent.width
    height: parent.height - 80

    property alias image: image_cover.source

    Image {
        anchors.fill: parent
        fillMode: Image.Tile
        source: "img/bg-dark_grain.png"
    }

    Image {
        id: image_cover
        anchors.fill: parent
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: ""
    }

    Rectangle {
        color: "black"
        opacity: 0.6
        width: cover.width
        height: 80
        anchors.bottom: cover.bottom
        anchors.left: cover.left
    }

    Text {
        id: txt_title
        text: ""
        horizontalAlignment: Text.AlignHCenter
        color: "white"
        smooth: true
        anchors.bottom: cover.bottom
        anchors.bottomMargin: 12
        anchors.left: cover.left
        anchors.leftMargin: (cover.width / 2) - (width / 2)
    }

    ////////////////////////////////////////////////////////////////////////////
    // Functions
    ////////////////////////////////////////////////////////////////////////////
    function set_song_title(title, artist){
        var text = "<h2>" + title + "</h2><h3>" + artist + "</h3>";
        txt_title.text = text;
    }

    function set_error_message(title, msg){
        var text = "<h2><span style='color: #f00;'> " + title + "</span></h2><h3>" + msg + "</h3>";
        txt_title.text = text;
    }
}
