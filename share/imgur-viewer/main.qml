import QtQuick 2.4
import Ubuntu.Components 1.3

MainView {
    objectName: "mainView"
    applicationName: "imgur-viewer.vayan"
    automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    Page {
        title: i18n.tr("Simple Imgur App")

        Column {
            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
                fill: parent
            }
            Button {
                objectName: "button"
                width: parent.width
                text: i18n.tr("Next")
                onClicked: ctrl.next()
            }

            AnimatedImage {
              width: parent.width
              height: parent.height
              fillMode: Image.PreserveAspectFit
              source: ctrl.source
              playing: true
              paused: false
              onStatusChanged: playing = true
            }
        }
    }
}
