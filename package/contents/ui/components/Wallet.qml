import QtQuick 2.0

import "../../code/qByteArray.mjs" as Qbytes

Exec {
    property string appId
    property int handler
    
    readonly property string commandBase: "dbus-send --session --type=method_call --print-reply=literal --dest=org.kde.kwalletd5 /modules/kwalletd5 org.kde.KWallet."
    
    enum EntryType {
        Password = 1,
        Binary,
        Map
    }
   
    function setHandler(h) {
        handler = h
    }

    function call(command) {
        return exec(commandBase + command)
            .then(parseResponse)
    }

    function callWallet(command, ...args) {
        return call([command, f(handler), ...args, f(appId)].join(" "))
    }

    function formatEntryValue(value, type) {
        switch(type) {
            case Wallet.EntryType.Password: return Qbytes.stringToQBytes(value)
            case Wallet.EntryType.Binary: return Qbytes.stringToBytes(value)
            case Wallet.EntryType.Map: return Qbytes.mapToQBytes(value)
        }
    }

    function f(value, type) {
        if (!type) {
            type = {
                number: 'int32',
                object: 'array:byte'
            }[typeof value] || typeof value
        }
        return `${type}:"${value}"`
    }

    function parseResponse(str) {
        const t = str.trim()
        const typeEndIndex = t.indexOf(" ")
        const dataType = t.slice(0, typeEndIndex)
        const data = ~typeEndIndex ? t.slice(typeEndIndex + 1) : t
        if (dataType === 'array') {
            return data.slice(data.indexOf("[") + 1, data.lastIndexOf("]") - 1)
        }
        return data
    }

    function open(wallet) {
        if (handler) {
            return Promise.resolve(handler)
        }
        return call(`open ${f(wallet)} int64:0 ${f(appId)}`)
            .then(Number.parseInt)
            .then(h => (setHandler(h), h))
    }

    function close() {
        return callWallet('close', 'int64:0')
            .then(() => setHandler())
    }

    function localWallet() {
        return call('localWallet')
    }

    function hasFolder(folderName) {
        return callWallet('hasFolder', f(folderName)).then(JSON.parse)
    }

    function createFolder(folderName) {
        return callWallet('createFolder', f(folderName))
    }

    function removeFolder(folderName) {
        return callWallet('removeFolder', f(folderName))
    }

    function writeEntry(folderName, key, value, type = Wallet.EntryType.Binary) {
        return callWallet('writeEntry',
            f(folderName),
            f(key),
            f(formatEntryValue(value, type)),
            f(type))
    }

    function readEntry(folderName, key) {
        return callWallet('readEntry', f(folderName), f(key))
            .then(Qbytes.parseBytes)
    }

    function removeEntry(folderName, key) {
        return callWallet('removeEntry', f(folderName), f(key))
    }

    function entryList(folderName) {
        return callWallet('entryList', f(folderName))
            .then(Qbytes.parseEntryList)
    }

    function readMap(folderName, key) {
        return readEntry(f(folderName), f(key))
            .then(Qbytes.qBytesToMap)
            .catch(e => ({}))
    }
    
    function writeMap(folderName, key, value) {
        return writeEntry(
            f(folderName),
            f(key),
            f(formatEntryValue(value, Wallet.EntryType.Map)),
            f(Wallet.EntryType.Map))
    }

    function readPassword(folderName, key) {
        return readEntry(f(folderName), f(key))
            .then(Qbytes.bytesToString)
    }    

    function writePassword(folderName, key, value) {
        return writeEntry(
            f(folderName),
            f(key),
            f(formatEntryValue(value, Wallet.EntryType.Password)),
            f(Wallet.EntryType.Password))
    }
}