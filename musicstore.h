#ifndef MUSICSTORE_H
#define MUSICSTORE_H

#include <QObject>
#include <QString>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <qjson/parser.h>

class MusicStore : public QObject
{
    Q_OBJECT
public:
    explicit MusicStore(QObject* root, QObject *parent = 0);

signals:

public slots:
    void search(QString);
    void purchase_song(QString);

private slots:
    void data_obtained(QNetworkReply*);

private:
    QObject* root;
    QJson::Parser parser;
    QNetworkAccessManager* nam;


};

#endif // MUSICSTORE_H
