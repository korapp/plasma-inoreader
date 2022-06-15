export function Article (props) {
    this.id = props.id || ''
    this.title = props.title || ''
    this.origin = props.origin || {}
    this.author = props.author || ''
    this.categories = props.categories || []
    this.date = props.publishDate || new Date()
    this.canonical = props.canonical || ''
    this.summary = props.summary || ''
    this.cover = props.cover || ''
    this.read = props.read
    this.starred = props.starred
}

export function Stream (props) {
    this.id = props.id || ''
    this.title = props.title || ''
    this.updated = props.updated || new Date(),
    this.items = props.items || []
    this.continuation = props.continuation || ''
}

export function Token(props) {
    this.access_token = props.access_token
    this.expires = props.expires || getExpirationDate(props.expires_in)
    this.token_type = props.token_type
    this.scope = props.scope
    this.refresh_token = props.refresh_token
}

function getExpirationDate(timeSpan) {
    return new Date(new Date().getTime() + timeSpan * 1000)
}