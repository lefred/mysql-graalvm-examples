DROP function IF EXISTS js_uuidv7;
CREATE FUNCTION js_uuidv7 ()
RETURNS CHAR(36) LANGUAGE JAVASCRIPT AS $$

    const UNIX_TS_MS_BITS = 48;
    const VER_DIGIT = "7";
    const SEQ_BITS = 12;
    const VAR = 0b10;
    const VAR_BITS = 2;
    const RAND_BITS = 62;
    const MAX_RANDOM_NUM = 6553699999;

    let prevTimestamp = -1;
    let seq = 0;

    const timestamp = Math.max(Date.now(), prevTimestamp);
          
    const var_rand = new Uint32Array(3);
    var_rand[0] = Math.random() * MAX_RANDOM_NUM;
    var_rand[1] = Math.random() * MAX_RANDOM_NUM;
    var_rand[2] = Math.random() * MAX_RANDOM_NUM;

    var_rand[0] = (VAR << (32 - VAR_BITS)) | (var_rand[0] >>> VAR_BITS);
    
    const digits =
    timestamp.toString(16).padStart(UNIX_TS_MS_BITS / 4, "0") +
    VER_DIGIT +
    var_rand[2].toString(16).padStart(SEQ_BITS / 4, "0") +
    var_rand[0].toString(16).padStart((VAR_BITS + RAND_BITS) / 2 / 4, "0") +
    var_rand[1].toString(16).padStart((VAR_BITS + RAND_BITS) / 2 / 4, "0");
    
    return (
        digits.slice(0, 8) +
        "-" +
        digits.slice(8, 12) +
        "-" +
        digits.slice(12, 16) +
        "-" +
        digits.slice(16, 20) +
        "-" +
        digits.slice(20).substring(0, 12)
    );

$$

;
DROP function IF EXISTS js_uuidv7_to_unixtime;
CREATE FUNCTION js_uuidv7_to_unixtime (uuid_in CHAR(36))
RETURNS CHAR(23) LANGUAGE JAVASCRIPT AS $$
    
const UUID_T_LENGTH = 16;
const UNIX_TS_LENGTH = 6;

function uuidToUnixTs(uuid) {
    let unixTs = BigInt(0);

    for (let i = 0; i < UNIX_TS_LENGTH; i++) {
        unixTs |= BigInt(uuid[UNIX_TS_LENGTH - 1 - i]) << BigInt(8 * i);
    }

    return unixTs;
}

function hexToByte(c) {
    if (c >= '0' && c <= '9') {
        return c.charCodeAt(0) - '0'.charCodeAt(0);
    } else if (c >= 'a' && c <= 'f') {
        return c.charCodeAt(0) - 'a'.charCodeAt(0) + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c.charCodeAt(0) - 'A'.charCodeAt(0) + 10;
    }

    return 0;
}

function stringToUuid(str, uuid) {
    if (str.length !== 36) {
        return 1;
    }
    if (str[14] !== '7') {
        return 1;
    }

    let idx = 0;
    for (let i = 0; i < UUID_T_LENGTH; ++i) {
        if (str[idx] === '-') {
            ++idx;
        }
        if (!isHexChar(str[idx]) || !isHexChar(str[idx + 1])) {
            return 1;
        }
        uuid[i] = (hexToByte(str[idx]) << 4) | hexToByte(str[idx + 1]);
        idx += 2;
    }
    return 0;
}

function isHexChar(c) {
    return ((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'));
}


let uuid_out = new Uint8Array(UUID_T_LENGTH);
let result = stringToUuid(uuid_in, uuid_out);
let timestamp_out;
if (result === 0) {
    let unixTs = uuidToUnixTs(uuid_out);
    let unixTsInSeconds = Number(unixTs) / 1000; 
    timestamp_out = unixTsInSeconds;    
} else {
    timestamp_out="Error parsing UUID";
}

return (timestamp_out);

$$    

;    

DROP function IF EXISTS js_uuidv7_to_datetime;
CREATE FUNCTION js_uuidv7_to_datetime (uuid_in CHAR(36))
RETURNS CHAR(23) LANGUAGE JAVASCRIPT AS $$
    
const UUID_T_LENGTH = 16;
const UNIX_TS_LENGTH = 6;

function uuidToUnixTs(uuid) {
    let unixTs = BigInt(0);

    for (let i = 0; i < UNIX_TS_LENGTH; i++) {
        unixTs |= BigInt(uuid[UNIX_TS_LENGTH - 1 - i]) << BigInt(8 * i);
    }

    return unixTs;
}

function hexToByte(c) {
    if (c >= '0' && c <= '9') {
        return c.charCodeAt(0) - '0'.charCodeAt(0);
    } else if (c >= 'a' && c <= 'f') {
        return c.charCodeAt(0) - 'a'.charCodeAt(0) + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c.charCodeAt(0) - 'A'.charCodeAt(0) + 10;
    }

    return 0;
}

function stringToUuid(str, uuid) {
    if (str.length !== 36) {
        return 1;
    }
    if (str[14] !== '7') {
        return 1;
    }

    let idx = 0;
    for (let i = 0; i < UUID_T_LENGTH; ++i) {
        if (str[idx] === '-') {
            ++idx;
        }
        if (!isHexChar(str[idx]) || !isHexChar(str[idx + 1])) {
            return 1;
        }
        uuid[i] = (hexToByte(str[idx]) << 4) | hexToByte(str[idx + 1]);
        idx += 2;
    }
    return 0;
}

function isHexChar(c) {
    return ((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'));
}

function getTimestamp(milliseconds) {
    let seconds = Math.floor(milliseconds / 1000);
    let date = new Date(seconds * 1000); // Convert seconds to milliseconds

    let year = date.getFullYear();
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let day = String(date.getDate()).padStart(2, '0');
    let hours = String(date.getHours()).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');
    let secondsPart = String(date.getSeconds()).padStart(2, '0');
    let millisecondsPart = String(milliseconds % 1000).padStart(3, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}:${secondsPart}.${millisecondsPart}`;
}

let uuid_out = new Uint8Array(UUID_T_LENGTH);
let result = stringToUuid(uuid_in, uuid_out);
let timestamp_out;
if (result === 0) {
    let unixTs = uuidToUnixTs(uuid_out);
    let milliseconds = Number(unixTs);
    timestamp_out = getTimestamp(milliseconds);    
} else {
    timestamp_out="Error parsing UUID";
}

return (timestamp_out);

$$    

;   


DROP function IF EXISTS js_uuidv7_to_datetime_long;
CREATE FUNCTION js_uuidv7_to_datetime_long (uuid_in CHAR(36))
RETURNS CHAR(55) LANGUAGE JAVASCRIPT AS $$
    
const UUID_T_LENGTH = 16;
const UNIX_TS_LENGTH = 6;

function uuidToUnixTs(uuid) {
    let unixTs = BigInt(0);

    for (let i = 0; i < UNIX_TS_LENGTH; i++) {
        unixTs |= BigInt(uuid[UNIX_TS_LENGTH - 1 - i]) << BigInt(8 * i);
    }

    return unixTs;
}

function hexToByte(c) {
    if (c >= '0' && c <= '9') {
        return c.charCodeAt(0) - '0'.charCodeAt(0);
    } else if (c >= 'a' && c <= 'f') {
        return c.charCodeAt(0) - 'a'.charCodeAt(0) + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c.charCodeAt(0) - 'A'.charCodeAt(0) + 10;
    }

    return 0;
}

function stringToUuid(str, uuid) {
    if (str.length !== 36) {
        return 1;
    }
    if (str[14] !== '7') {
        return 1;
    }

    let idx = 0;
    for (let i = 0; i < UUID_T_LENGTH; ++i) {
        if (str[idx] === '-') {
            ++idx;
        }
        if (!isHexChar(str[idx]) || !isHexChar(str[idx + 1])) {
            return 1;
        }
        uuid[i] = (hexToByte(str[idx]) << 4) | hexToByte(str[idx + 1]);
        idx += 2;
    }
    return 0;
}

function isHexChar(c) {
    return ((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'));
}

function getTimestampLong(milliseconds) {
    let seconds = Math.floor(milliseconds / 1000);
    let date = new Date(seconds * 1000); // Convert seconds to milliseconds

    let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', timeZoneName: 'short' };
    let timestamp = date.toLocaleString(undefined, options);

    return timestamp;
}

let uuid_out = new Uint8Array(UUID_T_LENGTH);
let result = stringToUuid(uuid_in, uuid_out);
let timestamp_out;
if (result === 0) {
    let unixTs = uuidToUnixTs(uuid_out);
    let milliseconds = Number(unixTs);
    timestamp_out = getTimestampLong(milliseconds);    
} else {
    timestamp_out="Error parsing UUID";
}

return (timestamp_out);

$$    

; 
