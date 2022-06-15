export class HttpClient {
    constructor({ baseUrl = '' }) {
        this.baseUrl = baseUrl
        this.middleware = {
            request: [],
            response: [],
            error: []
        }
    }

    get(url, { headers, params } = {}) {
        return this.request({ url, headers, params, method: "GET" })
    }
    
    post(url, { headers, params, body } = {}) {
        return this.request({ url, headers, params, body, method: "POST" })
    }

    put(url, { headers, params, body } = {}) {
        return this.request({ url, headers, params, body, method: "PUT" })
    }

    delete(url, { headers, params } = {}) {
        return this.request({ url, headers, params, method: "DELETE" })
    }

    request(opts) {
        const req = chain(this.middleware.request, Object.assign({}, { headers: {} }, opts))
        const url = this.baseUrl + req.url + (req.url.includes("?") ? "&" : "?") + urlParams(req.params)

        return fetch(url, req)
            .then(response => chainPromises(this.middleware.response, { request: req, response }, Promise.resolve))
            .catch(response => chainPromises(this.middleware.error, { request: req, response }, Promise.reject))
    }
}

export function fetch(url, { method = 'GET', headers, body = "" } = {}) {
    return new Promise(function (resolve, reject) {
        const xhr = new XMLHttpRequest();

        xhr.open(method, url);

        // set headers
        Object.entries(headers).forEach(([key, value]) => xhr.setRequestHeader(key, value))

        xhr.onload = () => {
            if (xhr.status >= 200 && xhr.status < 300) {
                resolve(xhr);
            } else {
                reject(xhr);
            }
        };

        xhr.onerror = () => reject(xhr)
        xhr.ontimeout = () => reject(xhr)

        xhr.send(body);
    });
}

export function urlParams(params = {}) {
    return Object.entries(params).map(entry => entry.map(encodeURIComponent).join("=")).join("&")
}

export function jsonResponse({ response }) {
    try {
        return JSON.parse(response.responseText)
    } catch(e) {
        return {}
    }
}

function chain(functions, arg) {
    return functions.reduce((a, fn) => fn(a), arg)
}

function chainPromises(functions, arg, promiseFlow = Promise.resolve) {
    const flow = { resolve: 'then', reject: 'catch' }[promiseFlow.name]
    return functions.reduce((a, fn) => a[flow](fn), promiseFlow.call(Promise, arg))
}