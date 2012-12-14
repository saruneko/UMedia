#ifndef UMEDIAVIEWER_H
#define UMEDIAVIEWER_H

#include <QtCore>
#include <QImage>
#include <taglib/id3v2header.h>
#include <taglib/id3v2tag.h>
#include <taglib/tag.h>
#include "qmlapplicationviewer.h"

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
    QUrl* path;
    int previous_index;
    int actual_index;

    void load_songs();
    QImage imageForFile(const char *file);
    QImage imageForTag(TagLib::ID3v2::Tag *tag);

};

#endif // UMEDIAVIEWER_H
