#ifndef UMEDIAVIEWER_H
#define UMEDIAVIEWER_H

#include <QtCore>
#include "qmlapplicationviewer.h"
#include "songs.h"

class UMediaViewer : public QmlApplicationViewer
{
    Q_OBJECT
public:
    explicit UMediaViewer(int argc, char *argv[], QWidget *parent = 0);

public slots:
    void add_songs();
    void change_title(QString title);
    void set_repeat_setting(bool value);
    void set_shuffle_setting(bool value);

private:
    QObject *root;
    QString path;
    QSettings settings;
    Songs* songs;
};

#endif // UMEDIAVIEWER_H
