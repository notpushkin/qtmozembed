#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QMozContext>
#include <QMozEngineSettings>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QMozContext *context = QMozContext::instance();

    context->setProfile(QStringLiteral("qtmozembed-kirigami-browser"));
    const QString componentsPath = QStringLiteral(QTMOZEMBED_COMPONENTS_PATH);
    context->addComponentManifest(QDir(componentsPath).filePath(
                                      QStringLiteral("components/EmbedLiteBinComponents.manifest")));
    context->addComponentManifest(QDir(componentsPath).filePath(
                                      QStringLiteral("chrome/EmbedLiteJSScripts.manifest")));
    context->addComponentManifest(QDir(componentsPath).filePath(
                                      QStringLiteral("chrome/EmbedLiteOverrides.manifest")));
    context->addComponentManifest(QDir(componentsPath).filePath(
                                      QStringLiteral("components/EmbedLiteJSComponents.manifest")));

    QObject::connect(&app, &QCoreApplication::aboutToQuit,
                     context, &QMozContext::stopEmbedding);

    context->runEmbedding();
    QMozEngineSettings::instance();

    QQmlApplicationEngine engine;
    engine.addImportPath(QStringLiteral(QTMOZEMBED_QML_IMPORT_PATH));
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Could not load the Kirigami browser interface";
        context->stopEmbedding();
        return 1;
    }

    return app.exec();
}
