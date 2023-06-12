import QtQuick 2.0

import "components"
import "../code/model.mjs" as Model
import "../code/http.mjs" as Http
import "../code/htmlUtils.js" as Html

BaseObject {
    property var authService
    readonly property string baseUrl: "https://www.inoreader.com"
    readonly property string apiUrl: baseUrl + "/reader/api/0"
   
    readonly property var httpClient: {
        const httpClient = new Http.HttpClient({ baseUrl: apiUrl })
        httpClient.middleware.request.push(req => {
            req.headers = Object.assign({}, req.headers, authService.getAuthHeaders())
            return req
        })
        httpClient.middleware.response.push(Http.jsonResponse)
        httpClient.middleware.error.push(({ request, response }) => {
            if (response.status === 401 || response.status === 403) {
                return authService.refreshToken()
                    .then(() => httpClient.request(request))
                    .catch(e => e.status === 400 && authService.logout())
            }
            throw { request, response }
        })
        return httpClient
    }

    readonly property QtObject systemTags: QtObject {
        readonly property string read: "user/-/state/com.google/read"
        readonly property string starred: "user/-/state/com.google/starred"
        readonly property string broadcast: "user/-/state/com.google/broadcast"
        readonly property string like: "user/-/state/com.google/like"
    }

    readonly property QtObject tagAction: QtObject {
        readonly property string add: "a"
        readonly property string remove: "r"
    }

    function getUserInfo() {
        return httpClient.get("/user-info")
    }

    function getUnreadCount() {
        return httpClient.get("/unread-count")
    }

    function getStreamContent(params) {
        return httpClient.get("/stream/contents", { params })
            .then(adaptStream)
    }

    function getStreamIds(params) {
        return httpClient.get("/stream/items/ids", { params })
    }

    function editTag(tag, action, id) {
        const params = {
            [action]: tag,
            i: Array.isArray(id) ? id.map(shortenId) : shortenId(id)
        }
        return httpClient.post("/edit-tag", { params })
    }

    function shortenId(fullId) {
        const hexId = /[0-9a-f]{16}$/.exec(fullId)[0]
        return Number.parseInt(hexId, 16)
    }

    function adaptStream({ id, title, updatedUsec, items, continuation }) {
        return new Model.Stream({ id, title, updated: updatedUsec, continuation, items: items.map(adaptArticle) })
    }

    function adaptArticle({ id, title, origin, author, categories, published, canonical, summary, enclosure }) {
        const newSummary = trimAd(summary.content)
        return new Model.Article({
            id,
            title: Html.unescapeEntities(title),
            origin,
            author,
            categories,
            publishDate: new Date(published * 1000),
            canonical: getFirstHref(canonical),
            summary: newSummary,
            cover: enclosure ? getFirstHref(enclosure) : Html.findImage(newSummary),
            read: categories.some(c => compareTags(systemTags.read, c)),
            starred: categories.some(c => compareTags(systemTags.starred, c))
        })
    }

    function getFirstHref(array) {
        return array && array[0] && array[0].href
    }

    function compareTags(generic, specific) {
        return specific.replace(/\d+/, "-") === generic
    }

    function trimAd(text) {
        const adClosingTag = "</center>"
        const adClosingTagIndex = text.indexOf(adClosingTag)
        return adClosingTagIndex > 0 ? text.slice(adClosingTagIndex + adClosingTag.length) : text
    }
}