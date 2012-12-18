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
    this->create_temp_folder();

    // Load Generic covers
    QDir currentDir = QDir(QDir::currentPath());
    this->coverMap["0"] = currentDir.filePath("qml/UMedia/img/cover/mass_effect.jpg");
    this->coverMap["1"] = currentDir.filePath("qml/UMedia/img/cover/einstein.jpg");
    this->coverMap["2"] = currentDir.filePath("qml/UMedia/img/cover/evolution.jpg");
}

QString Songs::get_cover_path_for_song(const QString &artist, const QString &album)
{
    QString cover_code = QString(QCryptographicHash::hash((artist + album).toAscii(), QCryptographicHash::Md5));
    if(this->coverMap.contains(cover_code)){
        return this->coverMap[cover_code];
    }else{
        QTime time = QTime::currentTime();
        qsrand((uint)time.msec());

        QString index = QString::number((rand() % 3));
        return this->coverMap[index];
    }
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
        this->append_song(path_song);
    }
}

void Songs::load_songs(const QStringList &files)
{
    int i;
    for(i = 0; i < files.size(); i++){
        this->append_song(files[i]);
    }
}

void Songs::append_song(const QString& file)
{
    QFileInfo info(file);
    if(info.isFile() && info.isReadable()){
        QDir dir(file);
        TagLib::FileRef f(file.toUtf8());
        QString artist(f.tag()->artist().toCString());
        QString title(f.tag()->title().toCString());
        QString album(f.tag()->album().toCString());
        if(title == ""){
            title = info.baseName();
        }
        if(artist == ""){
            artist = dir.dirName();
        }
        if(album == ""){
            artist = dir.dirName();
        }
        this->save_image_for_file(artist, album, file.toUtf8());
        QMetaObject::invokeMethod(root, "add_song", Q_ARG(QVariant, title), Q_ARG(QVariant, artist),
                                  Q_ARG(QVariant, album), Q_ARG(QVariant, file));
    }
}

bool Songs::save_image_for_file(const QString& artist, const QString& album, const char *file)
{
    QString cover_code = QString(QCryptographicHash::hash((artist + album).toAscii(), QCryptographicHash::Md5));
    if(!this->coverMap.contains(cover_code)){
        TagLib::MPEG::File f(file);

        if(!f.isValid() || !f.ID3v2Tag())
            return false;

        TagLib::ID3v2::FrameList l = f.ID3v2Tag()->frameList("APIC");

        if(l.size() < 1){
            return false;
        }

        TagLib::ID3v2::AttachedPictureFrame *af =
            static_cast<TagLib::ID3v2::AttachedPictureFrame *>(l.front());

        QFile fi(this->coverDir->filePath(cover_code));
        fi.open(QIODevice::WriteOnly);
        fi.write((const char *) af->picture().data(), af->picture().size());
        fi.flush();
        fi.close();

        this->coverMap[cover_code] = fi.fileName();
    }

    return true;
}

void Songs::create_temp_folder()
{
    QString tempPath = QDir::tempPath();
    this->coverDir = new QDir(QDir(tempPath).filePath("umedia/covers"));
    if(!this->coverDir->exists()){
        this->coverDir->mkpath(this->coverDir->absolutePath());
    }
}
