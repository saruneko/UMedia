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
    QObject::connect(this->root, SIGNAL(songEnded()), this, SLOT(next_song()));
    QObject::connect(this->root, SIGNAL(nextSongRequested()), this, SLOT(next_song()));
    QObject::connect(this->root, SIGNAL(previousSongRequested()), this, SLOT(previous_song()));
}

void UMediaViewer::next_song()
{
    QDir musicDir(this->path->toString());
    QStringList files_list = musicDir.entryList(QStringList("*.mp3"), QDir::Files, QDir::Name);
    QTime now = QTime::currentTime();
    qsrand(now.msec());
    int selected = qrand() % files_list.size();
    QString path_song = musicDir.filePath(files_list[selected]);
    QFileInfo info(path_song);
    if(selected != this->actual_index && info.isFile() && info.isReadable()){
        this->previous_index = this->actual_index;
        this->actual_index = selected;
        QMetaObject::invokeMethod(root, "play_song", Q_ARG(QVariant, path_song));
    }else{
        this->next_song();
    }
}

void UMediaViewer::previous_song()
{
    QDir musicDir(this->path->toString());
    QStringList files_list = musicDir.entryList(QStringList("*.mp3"), QDir::Files, QDir::Name);
    QString path_song = musicDir.filePath(files_list[this->previous_index]);
    QFileInfo info(path_song);
    if(info.isFile() && info.isReadable()){
        QMetaObject::invokeMethod(root, "play_song", Q_ARG(QVariant, path_song));
    }else{
        this->previous_song();
    }
}
