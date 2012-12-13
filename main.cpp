#include <QApplication>
#include "umediaviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    UMediaViewer viewer;

    return app->exec();
}
