#ifndef YOUTUBEDOWNLOADER_H
#define YOUTUBEDOWNLOADER_H

#include <QObject>
#include <QProcess>
#include <QString>
#include <QDir>
#include "songs.h"

class YouTubeDownloader : public QObject
{
    Q_OBJECT
public:
    explicit YouTubeDownloader(QObject* root, Songs* songs, QObject *parent = 0);

    void start_download(QString url);

signals:

public slots:

private slots:
    void start_conversion();
    void add_file_converted();

private:
    Songs* songs;
    QObject* root;
    QProcess downloadProcess;
    QProcess convertProcess;
    QString cclive;
    QString ffmpeg;
    QString videofile;
    QString newsong;
    QDir* downloadDir;
    QStringList queued;

    void create_download_dir();
};

#endif // YOUTUBEDOWNLOADER_H
