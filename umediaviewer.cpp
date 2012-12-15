#include "umediaviewer.h"

#include <QtGlobal>
#include <QGraphicsObject>
#include <QDeclarativeContext>
#include <QDebug>

UMediaViewer::UMediaViewer(int argc, char *argv[], QWidget *parent) :
    QmlApplicationViewer(parent)
{
    this->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    this->setMainQmlFile(QLatin1String("qml/UMedia/main.qml"));
    this->showExpanded();

    if(argc > 1){
        qDebug() << argv[1];
        this->path = argv[1];
    }else{
        this->path = "/media/gatox/leeloo/musica/Polaris";
    }

    this->root = this->rootObject();
    this->songs = new Songs(this->root);
    this->songs->load_songs(this->path);

    // Set qml/c++ properties
    this->rootContext()->setContextProperty("songs", this->songs);

    // Connect signals
    QObject::connect(this->root, SIGNAL(playing_song(QString)), this, SLOT(change_title(QString)));
}

void UMediaViewer::change_title(QString title)
{
    this->setWindowTitle("UMedia - " + title);
}
