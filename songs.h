#ifndef SONGS_H
#define SONGS_H

#include <QObject>
#include <QMap>
#include <QString>

class Songs : public QObject
{
    Q_OBJECT
public:
    explicit Songs(QObject* root, QObject *parent = 0);

    Q_INVOKABLE bool valid_song_file(const QString &file);

    void load_songs(const QString &file);
    void load_songs(const QStringList &files);

signals:

public slots:

private:
    QObject* root;
    QMap<QString, QString> map;

    bool save_image_for_file(const char *file);
};

#endif // SONGS_H
