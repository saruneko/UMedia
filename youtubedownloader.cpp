#include "youtubedownloader.h"

#include <QStringList>
#include <QFileInfo>
#include <QVariant>

YouTubeDownloader::YouTubeDownloader(QObject* root, Songs* songs, QObject *parent) :
    QObject(parent)
  , downloadProcess(parent)
  , convertProcess(parent)
  , cclive("cclive")
  , ffmpeg("ffmpeg")
{
    this->songs = songs;
    this->root = root;
    this->create_download_dir();

    // Connect signals
    QObject::connect(&(this->downloadProcess), SIGNAL(finished(int, QProcess::ExitStatus)),
                     this, SLOT(start_conversion()));
    QObject::connect(&(this->convertProcess), SIGNAL(finished(int, QProcess::ExitStatus)),
                     this, SLOT(add_file_converted()));
}

void YouTubeDownloader::start_download(QString url)
{
    if(this->downloadProcess.state() == QProcess::NotRunning){
        QStringList arguments;
        arguments << "-W" << "-f" << "best" << "--filename-format" << "%t";
        arguments << "--output-dir" << this->downloadDir->absolutePath() << url;

        this->downloadProcess.start(this->cclive, arguments);
    }else{
        this->queued << url;
    }
}

void YouTubeDownloader::start_conversion()
{
    QStringList files = this->downloadDir->entryList(QStringList("*"), QDir::Files, QDir::Time);
    if(files.size() > 0){
        QFileInfo info(files[0]);
        if(info.suffix() != "mp3"){
            QString filename = this->downloadDir->filePath(files[0]);
            QString newfile = filename + ".mp3";

            QStringList arguments;
            arguments << "-y" << "-i" << filename << "-vn" << "-acodec" << "libmp3lame" << "-ac";
            arguments << "2" << "-ab" << "160k" << "-ar" << "48000" << newfile;

            videofile = filename;
            newsong = newfile;

            this->convertProcess.start(this->ffmpeg, arguments);
        }else{
            this->add_file_converted();
        }
    }
}

void YouTubeDownloader::add_file_converted()
{
    if(this->videofile != "" && this->newsong != ""){
        this->downloadDir->remove(this->videofile);
        this->songs->append_song(this->newsong);
        this->videofile = "";
        this->newsong = "";
        QMetaObject::invokeMethod(root, "show_notification", Q_ARG(QVariant, "Song Downloaded"));
    }

    if(!queued.isEmpty()){
        this->start_download(this->queued.takeFirst());
    }
}

void YouTubeDownloader::create_download_dir(){
    QString tempPath = QDir::tempPath();
    this->downloadDir = new QDir(QDir(tempPath).filePath("umedia/download"));
    if(!this->downloadDir->exists()){
        this->downloadDir->mkpath(this->downloadDir->absolutePath());
    }
}
