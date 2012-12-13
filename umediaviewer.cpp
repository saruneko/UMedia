#include "umediaviewer.h"

#include <QtGlobal>
#include <QGraphicsObject>
#include <QDebug>

UMediaViewer::UMediaViewer(QWidget *parent) :
    QmlApplicationViewer(parent)
{
    this->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    this->setMainQmlFile(QLatin1String("qml/UMedia/main.qml"));
    this->showExpanded();

    this->path = new QUrl("/home/gatox/Downloads/temp/Of Monsters And Men-My Head Is An Animal (2011) 320Kbit(mp3) DMT/" );

    this->root = this->rootObject();
    QObject::connect(this->root, SIGNAL(songEnded()), this, SLOT(change_song()));
    QObject::connect(this->root, SIGNAL(nextSongRequested()), this, SLOT(change_song()));
}

void UMediaViewer::change_song()
{
    QDir musicDir(this->path->toString());
    QStringList files_list = musicDir.entryList(QStringList("*.mp3"), QDir::Files, QDir::Name);
    int i;
    QTime now = QTime::currentTime();
    qsrand(now.msec());
    int selected = qrand() % files_list.size();
    QVariant path = musicDir.filePath(files_list[selected]);
    QMetaObject::invokeMethod(root, "play_song", Q_ARG(QVariant, path));
}
