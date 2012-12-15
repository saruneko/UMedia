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

signals:

public slots:
    void previous_song();
    void next_song();

private:
    QObject *root;
    QString path;
    Songs* songs;
};

#endif // UMEDIAVIEWER_H
