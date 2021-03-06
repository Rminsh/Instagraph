/*
 * Copyright (C) 2016 Stefano Verzegnassi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License 3 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Page {
    id: picker

    signal cancel()
    signal imported(var fileUrl)

    header: PageHeader {
        title: i18n.tr("Choose from")
    }

    ContentPeerPicker {
        anchors {
            fill: parent
            top: picker.header.bottom
            topMargin: units.gu(2)
        }
        visible: parent.visible
        showTitle: false
        contentType: ContentType.Pictures
        handler: ContentHandler.Source

        onPeerSelected: {
            peer.selectionType = ContentTransfer.Single
            mainView.activeTransfer = peer.request(appStore)
            mainView.activeTransfer.stateChanged.connect(function() {
                if (mainView.activeTransfer.state === ContentTransfer.Charged) {
                    picker.imported(mainView.activeTransfer.items[0].url)
                    mainView.activeTransfer = null
                }
            })
        }

        onCancelPressed: {
            pageStack.pop()
        }
    }

    ContentTransferHint {
        id: transferHint
        anchors.fill: parent
        activeTransfer: mainView.activeTransfer
    }
}
