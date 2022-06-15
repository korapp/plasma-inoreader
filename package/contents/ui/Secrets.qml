import QtQuick 2.0

import "components"
import "../code/qByteArray.mjs" as Qbytes

BaseObject {
    signal ready

    function set(key, value) {
        if (!key) {
            return
        }
        return wallet.writeEntry(wallet.folder, key, value)
    }

    function get(key) {
        return wallet.readEntry(wallet.folder, key).then(Qbytes.bytesToString)
    }

    function list() {
        return wallet.entryList(wallet.folder)
    }

    Wallet {
        id: wallet
        appId: "Inoreader"
        readonly property string folder: appId
        
        Component.onCompleted: localWallet()
            .then(open)
            .then(() => hasFolder(folder))
            .then(hasFolder => hasFolder || createFolder(folder))
            .then(ready)
    }
}