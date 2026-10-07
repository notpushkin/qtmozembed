# Kirigami Gecko browser example

This example is a small QtQuick/Kirigami browser UI backed by `QmlMozView`
from the `Qt5Mozilla` plugin. It uses qtmozembed's Gecko engine; it does not
use QtWebEngine.

## Requirements

- A built and installed qtmozembed Qt 5 library and `Qt5Mozilla` QML plugin
- The Gecko EmbedLite runtime components and manifest files
- QtQuick Controls 2 and KDE Kirigami 2 QML modules

## Build and run

From this directory, run `qmake browser.pro` and `make`, then launch
`./qtmozembed-kirigami-browser`. If the EmbedLite manifests are installed
outside `$$[QT_INSTALL_LIBS]/mozembedlite`, pass the directory containing the
`components` and `chrome` directories when running qmake, for example:

```sh
qmake QTMOZEMBED_COMPONENTS_PATH=/path/to/mozembedlite browser.pro
make
```

The qtmozembed library, QML plugin, and Gecko runtime components must be
available at runtime. The plugin is loaded from `$$[QT_INSTALL_LIBS]/qt5/qml`.
