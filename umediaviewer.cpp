#include "umediaviewer.h"

#include <QtGlobal>
#include <QGraphicsObject>
#include <taglib/fileref.h>
#include <attachedpictureframe.h>
#include <taglib/mpegfile.h>
#include <QDebug>

#include <QLabel>

UMediaViewer::UMediaViewer(int argc, char *argv[], QWidget *parent) :
    QmlApplicationViewer(parent)
{
    this->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    this->setMainQmlFile(QLatin1String("qml/UMedia/main.qml"));
    this->showExpanded();

    if(argc > 1){
        qDebug() << argv[1];
        this->path = new QUrl(argv[1]);
    }else{
        this->path = new QUrl("/home/gatox/Downloads/Of Monsters And Men-My Head Is An Animal (2011) 320Kbit(mp3) DMT/" );
    }

    this->root = this->rootObject();
    QObject::connect(this->root, SIGNAL(songEnded()), this, SLOT(next_song()));
    QObject::connect(this->root, SIGNAL(nextSongRequested()), this, SLOT(next_song()));
    QObject::connect(this->root, SIGNAL(previousSongRequested()), this, SLOT(previous_song()));

    this->load_songs();

//    QImage image = imageForFile(this->path->toString().toAscii());
//    QLabel myLabel;
//    myLabel.setPixmap(QPixmap::fromImage(image));

//    myLabel.show();
}

void UMediaViewer::load_songs()
{
    QDir musicDir(this->path->toString());
    QStringList files_list = musicDir.entryList(QStringList("*.mp3"), QDir::Files, QDir::Name);

    int i;
    for(i = 0; i < files_list.size(); i++){
        QString path_song = musicDir.filePath(files_list[i]);
        QFileInfo info(path_song);
        if(info.isFile() && info.isReadable()){
            TagLib::FileRef f(musicDir.filePath(files_list[i]).toAscii());
            QString artist(f.tag()->artist().toCString());
            QString title(f.tag()->title().toCString());
            if(title == ""){
                title = info.baseName();
            }
            if(artist == ""){
                artist = musicDir.dirName();
            }
            this->imageForFile(musicDir.filePath(files_list[i]).toAscii());
            QMetaObject::invokeMethod(root, "add_song", Q_ARG(QVariant, title), Q_ARG(QVariant, artist), Q_ARG(QVariant, path_song));
        }
    }
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

QImage UMediaViewer::imageForTag(TagLib::ID3v2::Tag *tag)
{
    TagLib::ID3v2::FrameList l = tag->frameList("APIC");

    QImage image;

    if(l.isEmpty())
        return image;

    TagLib::ID3v2::AttachedPictureFrame *f =
        static_cast<TagLib::ID3v2::AttachedPictureFrame *>(l.front());

    image.loadFromData((const uchar *) f->picture().data(), f->picture().size());
    QFile fi("/home/gatox/Desktop/prueba.jpg");
    fi.open(QIODevice::WriteOnly);
    fi.write((const char *) f->picture().data(), f->picture().size());
    fi.flush();
    fi.close();

    return image;
}

QImage UMediaViewer::imageForFile(const char *file)
{
    TagLib::MPEG::File f(file);

    if(!f.isValid() || !f.ID3v2Tag())
        return QImage();

    return imageForTag(f.ID3v2Tag());
}
