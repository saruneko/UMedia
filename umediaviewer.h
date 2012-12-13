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
    void change_song();

private:
    QObject *root;
    QUrl* path;

};

#endif // UMEDIAVIEWER_H
