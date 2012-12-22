// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: parent.width
    height: parent.height - 80
    anchors.leftMargin: 0
    opacity: 1

    property alias musicStore: music_store

    Background {}

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            menu.show_menu();
        }
        onExited: {
            menu.hide_menu();
        }
    }

    MusicStore {
        id: music_store
    }
}
