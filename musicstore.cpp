#include "musicstore.h"
#include <QDesktopServices>
#include <QVariant>
#include <QMap>
#include <QDebug>

#define MUSIC_URI "http://musicsearch.ubuntu.com/v1/"
#define SEARCH "search?q="
#define GROUPING "&grouping=1"  // To group results in artists, album, tracks

MusicStore::MusicStore(QObject* root, QObject *parent) :
    QObject(parent)
{
    this->root = root;
    this->nam = new QNetworkAccessManager(this);

    QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
             this, SLOT(data_obtained(QNetworkReply*)));
    QObject::connect(this->root, SIGNAL(search_store(QString)), this, SLOT(search(QString)));
    QObject::connect(this->root, SIGNAL(purchase_song(QString)), this, SLOT(purchase_song(QString)));
}

void MusicStore::purchase_song(QString url)
{
    QUrl uri;
    uri.setEncodedUrl(url.toAscii());
    QDesktopServices::openUrl(uri);
}

void MusicStore::search(QString words)
{
    QUrl url(MUSIC_URI SEARCH + QUrl::toPercentEncoding(words) + GROUPING);
    this->nam->get(QNetworkRequest(url));
}

void MusicStore::data_obtained(QNetworkReply* reply)
{
    bool ok;
    QVariantMap result = parser.parse(reply->readAll(), &ok).toMap();
    if(!ok){
        return;
    }

    QMap<QString, QVariant> songs = result["results"].toMap();
    foreach (QVariant song, songs["track"].toList()) {
        QString title = song.toMap()["title"].toString();
        QString artist = song.toMap()["artist"].toString();
        QString album = song.toMap()["album"].toString();
        QString price = song.toMap()["currency"].toString() + " "  + song.toMap()["formatted_price"].toString();
        QString image = song.toMap()["image"].toString();
        QString purchase_url = song.toMap()["web_purchase_url"].toString();
        QMetaObject::invokeMethod(root, "load_store_result", Q_ARG(QVariant, title), Q_ARG(QVariant, artist),
                                  Q_ARG(QVariant, album), Q_ARG(QVariant, price), Q_ARG(QVariant, image),
                                  Q_ARG(QVariant, purchase_url));
    }

    foreach (QVariant song, songs["album"].toList()) {
        if(song.toMap()["price"].toString() == "") continue;
        QString title = song.toMap()["title"].toString();
        QString artist = song.toMap()["artist"].toString();
        QString album = song.toMap()["album"].toString();
        QString price = song.toMap()["currency"].toString() + " "  + song.toMap()["formatted_price"].toString();
        QString image = song.toMap()["image"].toString();
        QString purchase_url = song.toMap()["web_purchase_url"].toString();
        QMetaObject::invokeMethod(root, "load_store_result", Q_ARG(QVariant, title), Q_ARG(QVariant, artist),
                                  Q_ARG(QVariant, album), Q_ARG(QVariant, price), Q_ARG(QVariant, image),
                                  Q_ARG(QVariant, purchase_url));
    }

}
