#include "umediaviewer.h"

#include <QtGlobal>
#include <QGraphicsObject>
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
        this->path = "/home/gatox/Downloads/Of Monsters And Men-My Head Is An Animal (2011) 320Kbit(mp3) DMT/";
    }

    this->root = this->rootObject();
    QObject::connect(this->root, SIGNAL(songEnded()), this, SLOT(next_song()));
    QObject::connect(this->root, SIGNAL(nextSongRequested()), this, SLOT(next_song()));
    QObject::connect(this->root, SIGNAL(previousSongRequested()), this, SLOT(previous_song()));

    this->songs = new Songs(this->root);
    this->songs->load_songs(this->path);
}

void UMediaViewer::next_song()
{
    QDir musicDir(this->path);
    QStringList files_list = musicDir.entryList(QStringList("*.mp3"), QDir::Files, QDir::Name);
    QTime now = QTime::currentTime();
    qsrand(now.msec());
    int selected = qrand() % files_list.size();
    QString path_song = musicDir.filePath(files_list[selected]);
    QFileInfo info(path_song);
    if(info.isFile() && info.isReadable()){ // selected != this->actual_index &&
//        this->previous_index = this->actual_index;
//        this->actual_index = selected;
        QMetaObject::invokeMethod(root, "play_song", Q_ARG(QVariant, path_song));
    }else{
        this->next_song();
    }
}

void UMediaViewer::previous_song()
{
    QDir musicDir(this->path);
    QStringList files_list = musicDir.entryList(QStringList("*.mp3"), QDir::Files, QDir::Name);
//    QString path_song = musicDir.filePath(files_list[this->previous_index]);
//    QFileInfo info(path_song);
//    if(info.isFile() && info.isReadable()){
//        QMetaObject::invokeMethod(root, "play_song", Q_ARG(QVariant, path_song));
//    }else{
//        this->previous_song();
//    }
}
