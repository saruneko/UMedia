#include <QApplication>
#include "umediaviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QCoreApplication::setOrganizationName("Saruneko");
    QCoreApplication::setOrganizationDomain("saruneko.org");
    QCoreApplication::setApplicationName("UMedia");

    UMediaViewer viewer(argc, argv);

    return app->exec();
}
