#ifndef SONGS_H
#define SONGS_H

#include <QObject>
#include <QMap>
#include <QString>
#include <QDir>

class Songs : public QObject
{
    Q_OBJECT
public:
    explicit Songs(QObject* root, QObject *parent = 0);

    Q_INVOKABLE QString get_cover_path_for_song(const QString &artist, const QString &album);
    Q_INVOKABLE bool valid_song_file(const QString &file);

    void load_songs(const QString &path);
    void load_songs(const QStringList &files);
    void append_song(const QString& file);

signals:

public slots:

private:
    QObject* root;
    QMap<QString, QString> coverMap;
    QDir* coverDir;

    bool save_image_for_file(const QString& artist, const QString& album, const char *file);
    void create_temp_folder();
};

#endif // SONGS_H
