#include "umediaviewer.h"

#include <QtGlobal>
#include <QGraphicsObject>
#include <QDeclarativeContext>
#include <QFileDialog>

UMediaViewer::UMediaViewer(int argc, char *argv[], QWidget *parent) :
    QmlApplicationViewer(parent)
{
    this->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    this->setMainQmlFile(QLatin1String("qml/UMedia/main.qml"));
    this->showExpanded();

    QStringList list;
    if(argc > 1){
        this->path = argv[1];
        list << this->path;
    }

    this->root = this->rootObject();
    this->songs = new Songs(this->root);
    this->songs->load_songs(list);

    // Set qml/c++ properties
    this->rootContext()->setContextProperty("songs", this->songs);

    // Connect signals
    QObject::connect(this->root, SIGNAL(playing_song(QString)), this, SLOT(change_title(QString)));
    QObject::connect(this->root, SIGNAL(repeat_changed(bool)), this, SLOT(set_repeat_setting(bool)));
    QObject::connect(this->root, SIGNAL(shuffle_changed(bool)), this, SLOT(set_shuffle_setting(bool)));
    QObject::connect(this->root, SIGNAL(add_songs()), this, SLOT(add_songs()));
    QObject::connect(this->root, SIGNAL(add_folder()), this, SLOT(add_folder()));
    QObject::connect(this->root, SIGNAL(add_from_youtube(QString)), this, SLOT(add_from_youtube(QString)));

    // Load Settings
    bool repeat = settings.value("playlist/repeat", false).toBool();
    bool shuffle = settings.value("playlist/shuffle", false).toBool();

    QMetaObject::invokeMethod(this->root, "set_repeat", Q_ARG(QVariant, repeat));
    QMetaObject::invokeMethod(this->root, "set_shuffle", Q_ARG(QVariant, shuffle));

    // Downloader
    this->downloader = new YouTubeDownloader(this->root, this->songs, this);

    // Music Store
    this->musicStore = new MusicStore(this->root, this);
}

void UMediaViewer::add_songs()
{
    QStringList files = QFileDialog::getOpenFileNames(this, "Add Songs",
                                                      QDir::homePath(),
                                                      "Music (*.mp3)");
    this->songs->load_songs(files);
}

void UMediaViewer::add_folder()
{
    QString directory = QFileDialog::getExistingDirectory(this, "Add Music Folder",
                                                          QDir::homePath());
    this->songs->load_songs(directory);
}

void UMediaViewer::add_from_youtube(QString url)
{
    this->downloader->start_download(url);
}

void UMediaViewer::change_title(QString title)
{
    this->setWindowTitle("UMedia - " + title);
}

void UMediaViewer::set_repeat_setting(bool value)
{
    settings.setValue("playlist/repeat", value);
}

void UMediaViewer::set_shuffle_setting(bool value)
{
    settings.setValue("playlist/shuffle", value);
}
