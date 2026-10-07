import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import org.kde.kirigami 2.0 as Kirigami
import Qt5Mozilla 1.0

Kirigami.ApplicationWindow {
    id: window

    width: 1100
    height: 760
    visible: true
    title: webView.title.length > 0
           ? webView.title + " — " + qsTr("Gecko Browser")
           : qsTr("Gecko Browser")

    pageStack.initialPage: Kirigami.Page {
        id: browserPage
        title: qsTr("Browse")

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                ToolButton {
                    text: qsTr("Back")
                    enabled: webView.canGoBack
                    onClicked: webView.goBack()
                }

                ToolButton {
                    text: qsTr("Forward")
                    enabled: webView.canGoForward
                    onClicked: webView.goForward()
                }

                TextField {
                    id: addressField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Enter a website or search")
                    selectByMouse: true
                    onAccepted: window.navigate(text)
                }

                ToolButton {
                    text: webView.loading ? qsTr("Stop") : qsTr("Reload")
                    onClicked: webView.loading ? webView.stop() : webView.reload()
                }
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.preferredHeight: 3
                from: 0
                to: 100
                value: webView.loadProgress
                visible: webView.loading
            }

            QmlMozView {
                id: webView
                Layout.fillWidth: true
                Layout.fillHeight: true
                active: true
                focus: true

                Component.onCompleted: url = "about:blank"
            }
        }
    }

    function navigate(address) {
        var value = address.trim()
        if (!value.length)
            return

        if (/^(https?|ftp|file):/i.test(value)
                || /^(about|data|mailto):/i.test(value)
                || /^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//.test(value)) {
            webView.url = value
        } else if (!/\s/.test(value)
                   && (value.indexOf(".") !== -1
                       || /^localhost(?::\d+)?(?:\/|$)/i.test(value))) {
            webView.url = "https://" + value
        } else {
            webView.url = "https://duckduckgo.com/?q=" + encodeURIComponent(value)
        }
        webView.forceActiveFocus()
    }

    Connections {
        target: webView
        onUrlChanged: {
            if (!addressField.activeFocus)
                addressField.text = webView.url.toString()
        }
    }
}
