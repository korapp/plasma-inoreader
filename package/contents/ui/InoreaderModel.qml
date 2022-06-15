import QtQuick 2.0

import "components"

BaseObject {
    property InoreaderClient inoreader
    property Logic dispatcher

    readonly property alias title: _.title
    readonly property alias unreadNewCount: _.unreadNewCount
    readonly property alias unreadMaxCount: _.unreadMaxCount
    readonly property alias updated: _.updated
    readonly property alias articles: _.articles

    readonly property bool hasContinuation: !!_.continuation
    readonly property int unreadCount: Math.max(_.unreadCount, 0)
    readonly property string unreadCountFormatted: _.kNumber(unreadCount) + (_.unreadMaxReached ? "+" : "")

    Connections {
        target: dispatcher

        onFetchStreamUnreadCount: _.callPending(_.updateUnreadCount, 'fetchStreamUnreadCount')
        onFetchStream: _.callPending(_.loadData, 'fetchStream')
        onFetchStreamContinuation: _.callPending(_.fetchMore, 'fetchStreamContinuation')

        onSetArticleRead: _.setArticleRead(article, read)
        onSetArticleStarred: _.setArticleStarred(article, starred)
    }

    function isPending(action) {
        return _.pending.includes(action)
    }

    QtObject {
        id: _
        property string title: ""
        property int unreadCount: -1
        property int unreadNewCount: 0
        property int unreadMaxCount
        property string continuation
        property string updated
        property bool unreadMaxReached: unreadCount === unreadMaxCount
        property ListModel articles: ListModel {}
        property var pending: []

        function reset() {
            title = ""
            unreadCount = -1
            unreadNewCount = 0
            articles.clear()
        }

        function callPending(fn, label = fn.name) {
            pending = [...pending, label]
            const removePending = () => pending = pending.filter(p => p !== label)
            fn().then(removePending).catch(removePending)
        }

        function setArticleRead(article, read) {
            if (article.read === read) return
            return inoreader
                .editTag(inoreader.systemTags.read, inoreader.tagAction.add, article.id)
                .then(() => {
                    article.read = read
                    if (!unreadMaxReached) {
                        _.unreadCount += read ? -1 : 1
                    }
                })
        }

        function setArticleStarred(article, starred) {
            if (article.starred === starred) return
            return inoreader
                .editTag(inoreader.systemTags.starred, inoreader.tagAction.add, article.id)
                .then(() => article.starred = starred)
        }

        function updateUnreadCount() {     
            return inoreader.getUnreadCount().then(data => {
                _.unreadMaxCount = data.max
                const unread = data.unreadcounts.reduce((s, u, i) => i ? s + Number(u.count) : s, 0)
                if (_.unreadCount > -1) {
                    _.unreadNewCount += Math.max(unread - _.unreadCount, 0)
                }
                _.unreadCount = unread
            })
        }

        function fetchMore() {
            return loadData({ continuation: _.continuation })
        }

        function loadData({ continuation } = {}) {
            const fetchParams = {
                n: plasmoid.configuration.itemsDownloadLimit,
                xt: plasmoid.configuration.fetchUnreadOnly ? inoreader.systemTags.read : "",
                c: continuation
            }
            return inoreader.getStreamContent(fetchParams).then(stream => {
                _.title = stream.title,
                _.continuation = stream.continuation,
                _.updated = stream.updated
                
                if (!continuation) {
                    _.articles.clear()
                }
                _.articles.append(stream.items)
                _.unreadNewCount = 0
            })
        }

        function kNumber(num) {
            return num < 1e3 ? num : ((num / 1e3) | 0) + 'k'
        }
    }
}