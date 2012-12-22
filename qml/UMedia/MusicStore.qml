// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7

Rectangle {
    id: musicStore
    width: parent.width
    height: parent.height - 45
    anchors.leftMargin: 0
    opacity: 1

    property alias searchInput: search_input
    property alias searchList: view

    Background {}

    Behavior on opacity { NumberAnimation { duration: 200 } }

    Column {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5
        Text {
            id: label_store
            color: "#ff7b00"
            text: qsTr("Ubuntu One: Music Store")
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 17
            font.bold: true
        }
        SearchInput {
            id: search_input

            Keys.onDownPressed: {
                view.focus = true;
                view.currentIndex = 1;
            }

            Keys.onReleased: {
                if((event.key != Qt.Key_Left) && (event.key != Qt.Key_Right) &&
                   (event.key != Qt.Key_Down) && (event.key != Qt.Key_Up)){
                    busyIndicator.visible = true;
                    busyIndicator.on = true;
                    view.model.clear();
                    umedia.search_store(textSearch.text);
                }
            }
        }

        BusyIndicator {
            id: busyIndicator
            visible: false
            x: (musicStore.width / 2) - (width / 2)
        }

        Component {
            id: storeDelegate
            Item {
                height: 75
                width: musicStore.width
                Row{
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5
                    Image {
                        source: image
                        height: 65
                        width: 65
                    }
                    Column {
                        Text { text: "<b>" + title + "</b>"; color: "white"; width: musicStore.width }
                        Text { text: "<i>Artist</i>: " + artist; horizontalAlignment: Text.AlignRight;
                            color: "white"; width: musicStore.width - 100 }
                        Text { text: "<i>Album</i>: " + album; horizontalAlignment: Text.AlignRight;
                            color: "white"; width: musicStore.width - 100 }
                        Text { text: "<i>Price</i>: " + price; horizontalAlignment: Text.AlignRight;
                            color: "white"; width: musicStore.width - 100 }
                    }
                }
            }
        }

        ListView {
            id: view
            height: musicStore.height - search_input.height - 10
            width: musicStore.width - 10
            model: ListModel { id: storeModel }
            delegate: storeDelegate
            highlight: Rectangle { width: view.width; color: "lightsteelblue"; radius: 4; opacity: 0.5; }
            focus: true

            Keys.onUpPressed: {
                if(view.currentIndex == 0){
                    searchInput.textSearch.focus = true;
                }else{
                    event.accepted = false;
                }
            }

            Keys.onReturnPressed: {
                buy_song();
            }

            onCountChanged: {
                if(view.count != 0){
                    busyIndicator.visible = false;
                    busyIndicator.on = false;
                }
            }
        }
    }

    function buy_song(){
        var index = view.currentIndex
        var purchase_url = view.model.get(index).purchase_url;
        umedia.purchase_song(purchase_url);
    }

    function load_store_result(title, artist, album, price, image, purchase_url){
        storeModel.append({title: title, artist: artist, image: image, album: album, price: price, purchase_url: purchase_url});
    }

}
