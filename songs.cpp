#include "songs.h"

#include <QtCore>
#include <taglib/id3v2header.h>
#include <taglib/id3v2tag.h>
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/mpegfile.h>
#include <attachedpictureframe.h>

Songs::Songs(QObject* root, QObject *parent) :
    QObject(parent)
  , root(root)
{
}

bool Songs::valid_song_file(const QString &file){
    QFileInfo info(file);
    if(info.isFile() && info.isReadable()){
        return true;
    }
    return false;
}

void Songs::load_songs(const QString &file)
{
    QDir musicDir(file);
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
//            this->save_image_for_file(musicDir.filePath(files_list[i]).toAscii());
            QMetaObject::invokeMethod(root, "add_song", Q_ARG(QVariant, title), Q_ARG(QVariant, artist), Q_ARG(QVariant, path_song));
        }
    }
}

void Songs::load_songs(const QStringList &files){}

bool Songs::save_image_for_file(const char *file)
{
    TagLib::MPEG::File f(file);

    if(!f.isValid() || !f.ID3v2Tag())
        return false;

    TagLib::ID3v2::FrameList l = f.ID3v2Tag()->frameList("APIC");

    TagLib::ID3v2::AttachedPictureFrame *af =
        static_cast<TagLib::ID3v2::AttachedPictureFrame *>(l.front());

    QFile fi("/home/gatox/Desktop/prueba.jpg");
    fi.open(QIODevice::WriteOnly);
    fi.write((const char *) af->picture().data(), af->picture().size());
    fi.flush();
    fi.close();

    return true;
}
