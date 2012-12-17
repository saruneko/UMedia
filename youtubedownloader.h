#ifndef YOUTUBEDOWNLOADER_H
#define YOUTUBEDOWNLOADER_H

#include <QObject>
#include <QProcess>

class YouTubeDownloader : public QObject
{
    Q_OBJECT
public:
    explicit YouTubeDownloader(QObject *parent = 0);

    void start_download(QString url);

signals:

public slots:

private:
    QProcess process;
};

#endif // YOUTUBEDOWNLOADER_H
