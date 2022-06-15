import QtQuick 2.0

import "../../code/http.mjs" as Http
import "../../code/model.mjs" as Model

QtObject {
    id: auth
    property string clientId
    property string clientSecret
    property string authUrl
    property string tokenUrl
    property string scope
    property string redirectUri
    property var token: ({})

    readonly property bool loggedIn: !!token.access_token

    function getAuthenticateData() {
        const state = randomString()
        const url = getAuthenticatePageUrl(state)
        const urlAcceptRegex = new RegExp(`${redirectUri}/?\\?code=(\\w+)&state=(\\w+)`)
        
        function redirectUriMatcher(uri) {
            const match = urlAcceptRegex.exec(decodeURIComponent(uri))
            const stateValid = match && match[2] === state
            if (!stateValid) {
                return console.error("Invalid state", state)
            }
            return match[1]
        }
        
        return { url, redirectUriMatcher }
    }

    function retrieveToken(authCode) {
        const params = {
            code: authCode,
            redirect_uri: redirectUri,
            client_id: clientId,
            client_secret: clientSecret,
            grant_type: "authorization_code"
        }
        return authRequest(tokenUrl, params).then(setToken)
    }
    
    function refreshToken() {
        const params = {
            client_id: clientId,
            client_secret: clientSecret,
            grant_type: "refresh_token",
            refresh_token: token.refresh_token
        }
        return authRequest(tokenUrl, params)
            .then(setToken)
    }

    function setToken(t) {
        token = new Model.Token(t)
    }

    function getAuthenticatePageUrl(state) {
        const params = {
            client_id: clientId,
            redirect_uri: redirectUri,
            response_type: "code",
            scope,
            state
        }
        return this.authUrl + "?" + Http.urlParams(params)
    }

    function isTokenExpired(token) {
        return !token.expires || isNaN(token.expires) || new Date(token.expires) < new Date()
    }

    function getAuthHeaders() {
        return { 
            "Authorization": `${token.token_type} ${token.access_token}`
        }
    }
    
    function authRequest(url, body) {
        return Http.fetch(url, {
            body: Http.urlParams(body),
            method: "POST",
            headers: { "Content-type": "application/x-www-form-urlencoded" } 
        })
        .then(res => JSON.parse(res.response))
        .catch(e => {
            console.error(JSON.stringify(e))
            throw e
        })
    }

    function randomString() {
        return Qt.btoa(Math.random()).replace(/=/g, "")
    }

    function webWindow() {
        return Qt.createQmlObject(`
            WebWindow {
                width: 640
                height: 500
                title: plasmoid.title
            }`, auth)
    }

    function login() {
        const { url, redirectUriMatcher } = getAuthenticateData()
        const loginWindow = webWindow()
        loginWindow.url = url
        loginWindow.show()

        loginWindow.onUrlChanged.connect(() => {
            
            const code = redirectUriMatcher(loginWindow.url)
            if (code) {
                retrieveToken(code)
                loginWindow.close()
                loginWindow.destroy()
            }
        })
    }

    function logout() {
        token = ({})
    }
}