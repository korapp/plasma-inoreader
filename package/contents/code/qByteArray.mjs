export function parseBytes(string) {
    if (!string) {
        return new Uint8Array()
    }
    return Uint8Array.from(string.match(/[0-9a-f]{2}/g).map(n => Number.parseInt(n, 16)))
}

export function bytesToString(bytes, offset = 0, length = bytes.length) {
    let result = ""
    for(let i = offset; i < length; i+= 2) {
        result += String.fromCharCode(bytes[i] << 8 | bytes[i+1])
    }
    return result
}

export function stringToBytes(str, bytes = new Uint8Array(str.length * 2), offset = 0) {
    for (let i = 0; i < str.length; i++) {
        const c = str.charCodeAt(i), b = 2 * i + offset
        bytes[b] = c >>> 8
        bytes[b+1] = c
    }
    return bytes
}

export function qBytesToMap(bytes) {
    const length = bytes.length
    const dv = new DataView(bytes.buffer)
    const output = {}
    let entryCount = dv.getUint32() * 2
    let key
    let pointer = 4
    while (entryCount--) {
        const counter = dv.getUint32(pointer)
        const start = pointer + 4
        const string = bytesToString(bytes, start, start + counter)
        pointer = start + counter
        if (entryCount % 2) {
            key = string
        } else {
            output[key] = string
        }
    }
    return output
}

export function mapToQBytes(map) {
    const object = stringifyValues(map)
    const entriesBytesCount = qMapSize(object)
    const bytes = new Uint8Array(entriesBytesCount)
    const dv = new DataView(bytes.buffer)
    let entryCount = 0
    let pointer = 4
    for(const k in object) {
        dv.setInt32(pointer, k.length * 2)
        pointer += 4
        stringToBytes(k, bytes, pointer)
        pointer += k.length * 2
        dv.setInt32(pointer, object[k].length * 2)
        pointer += 4
        stringToBytes(object[k], bytes, pointer)
        pointer += object[k].length * 2
        entryCount++
    }
    dv.setInt32(0, entryCount)
    return bytes 
}

export function stringToQBytes(str) {
    const size = str.length * 2
    const bytes = new Uint8Array(size + 4)
    const dv = new DataView(bytes.buffer)
    dv.setUint32(0, size)
    stringToBytes(str, bytes, 4)
    return bytes
}

export function qBytesToString(bytes) {
    const byteRange = new Uint8Array(bytes.buffer, 4, bytes.length - 4)
    return bytesToString(byteRange)
}

export function parseEntryList(list) {
    return list.split(/\s\s+/).filter(Boolean)
}

function qMapSize(o) {
	let size = 4
	for(const key in o) {
		size += (key.length + o[key].length) * 2 + 8
	}
	return size
}

function stringifyValues(obj) {
    const n = {}
    for(const key in obj) {
        n[key] = JSON.stringify(obj[key])
    }
    return n
}