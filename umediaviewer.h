#ifndef UMEDIAVIEWER_H
#define UMEDIAVIEWER_H

#include <QtCore>
#include "qmlapplicationviewer.h"

class UMediaViewer : public QmlApplicationViewer
{
    Q_OBJECT
public:
    explicit UMediaViewer(QWidget *parent = 0);

signals:

public slots:
    void previous_song();
    void next_song();

private:
    QObject *root;
    QUrl* path;
    int previous_index;
    int actual_index;

};

#endif // UMEDIAVIEWER_H
