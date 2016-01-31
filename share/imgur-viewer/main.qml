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

    Text {
      id: image_title

      anchors {
        left: parent.left
        right: parent.right
        top: parent.top
      }

      text: ctrl.current.title
    }

    AnimatedImage {
      id: animated_image

      anchors {
        left: parent.left
        right: parent.right
        top: image_title.bottom
        bottom: buttons_row.top
      }
      fillMode: Image.PreserveAspectFit
      source: ctrl.current.link
      paused: true

      onStatusChanged: ctrl.imageStatusChanged(animated_image)

      ActivityIndicator {
        id: activity

        running: animated_image.status === Image.Loading
        anchors {
          horizontalCenter: animated_image.horizontalCenter
          verticalCenter: animated_image.verticalCenter
        }
      }
    }

    Row {
      id: buttons_row

      spacing: units.gu(1)
      anchors.bottom: parent.bottom

      Button {
        text: i18n.tr("Previous")

        onClicked: ctrl.moveIteratorImageArray(-1)
      }

      Button {
        text: i18n.tr("Next")

        onClicked: ctrl.moveIteratorImageArray(+1)
      }
    }

  }
}
