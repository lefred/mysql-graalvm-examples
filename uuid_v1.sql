DROP function IF EXISTS js_uuid_to_unixtime;
CREATE FUNCTION js_uuid_to_unixtime (uuid_in CHAR(36))
RETURNS CHAR(23) LANGUAGE JAVASCRIPT AS $$
    
const UUID_T_LENGTH = 16;
const UNIX_TS_LENGTH = 6;

function uuidToUnixTs(uuid_str) {
    const MS_FROM_100NS_FACTOR = 10000;
    const OFFSET_FROM_15_10_1582_TO_EPOCH = 122192928000000000n;

    // Split UUID with '-' as delimiter
    let uuid_parts = uuid_str.split('-');

    // Construct UUID timestamp from its parts
    let uuid_timestamp =
        uuid_parts[2].substring(1) +
        uuid_parts[1] +
        uuid_parts[0];

    // Parse hexadecimal timestamp string to integer
    let timestamp = BigInt('0x' + uuid_timestamp);

    // Calculate Unix timestamp in milliseconds
    let unixTimestampMs = Number((timestamp - OFFSET_FROM_15_10_1582_TO_EPOCH) / BigInt(MS_FROM_100NS_FACTOR));

    return unixTimestampMs;
}

function stringToUuid(str) {
    if (str.length !== 36) {
        return 1;
    }
    if (str[14] !== '1') {
        return 1;
    }
    return 0;
}

let result = stringToUuid(uuid_in);
let timestamp_out;
if (result === 0) {
    timestamp_out = uuidToUnixTs(uuid_in)/1000;
} else {
    timestamp_out="Error parsing UUID";
}

return (timestamp_out);

$$    

;    

DROP function IF EXISTS js_uuid_to_datetime;
CREATE FUNCTION js_uuid_to_datetime (uuid_in CHAR(36))
RETURNS CHAR(23) LANGUAGE JAVASCRIPT AS $$

const UUID_T_LENGTH = 16;
const UNIX_TS_LENGTH = 6;

function uuidToUnixTs(uuid_str) {
    const MS_FROM_100NS_FACTOR = 10000;
    const OFFSET_FROM_15_10_1582_TO_EPOCH = 122192928000000000n;

    // Split UUID with '-' as delimiter
    let uuid_parts = uuid_str.split('-');

    // Construct UUID timestamp from its parts
    let uuid_timestamp =
        uuid_parts[2].substring(1) +
        uuid_parts[1] +
        uuid_parts[0];

    // Parse hexadecimal timestamp string to integer
    let timestamp = BigInt('0x' + uuid_timestamp);

    // Calculate Unix timestamp in milliseconds
    let unixTimestampMs = Number((timestamp - OFFSET_FROM_15_10_1582_TO_EPOCH) / BigInt(MS_FROM_100NS_FACTOR));

    return unixTimestampMs;
}

function stringToUuid(str) {
    if (str.length !== 36) {
        return 1;
    }
    if (str[14] !== '1') {
        return 1;
    }
    return 0;
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

let result = stringToUuid(uuid_in);
let timestamp_out;
if (result === 0) {
    let milliseconds = uuidToUnixTs(uuid_in);
    timestamp_out = getTimestamp(milliseconds); 
} else {
    timestamp_out="Error parsing UUID";
}

return (timestamp_out);

$$    

;   


DROP function IF EXISTS js_uuid_to_datetime_long;
CREATE FUNCTION js_uuid_to_datetime_long (uuid_in CHAR(36))
RETURNS CHAR(55) LANGUAGE JAVASCRIPT AS $$

const UUID_T_LENGTH = 16;
const UNIX_TS_LENGTH = 6;

function uuidToUnixTs(uuid_str) {
    const MS_FROM_100NS_FACTOR = 10000;
    const OFFSET_FROM_15_10_1582_TO_EPOCH = 122192928000000000n;

    // Split UUID with '-' as delimiter
    let uuid_parts = uuid_str.split('-');

    // Construct UUID timestamp from its parts
    let uuid_timestamp =
        uuid_parts[2].substring(1) +
        uuid_parts[1] +
        uuid_parts[0];

    // Parse hexadecimal timestamp string to integer
    let timestamp = BigInt('0x' + uuid_timestamp);

    // Calculate Unix timestamp in milliseconds
    let unixTimestampMs = Number((timestamp - OFFSET_FROM_15_10_1582_TO_EPOCH) / BigInt(MS_FROM_100NS_FACTOR));

    return unixTimestampMs;
}

function stringToUuid(str) {
    if (str.length !== 36) {
        return 1;
    }
    if (str[14] !== '1') {
        return 1;
    }
    return 0;
}

function getTimestampLong(milliseconds) {
    let seconds = Math.floor(milliseconds / 1000);
    let date = new Date(seconds * 1000); // Convert seconds to milliseconds

    let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', timeZoneName: 'short' };
    let timestamp = date.toLocaleString(undefined, options);

    return timestamp;
}

let result = stringToUuid(uuid_in);
let timestamp_out;
if (result === 0) {
    let milliseconds = uuidToUnixTs(uuid_in);
    timestamp_out = getTimestampLong(milliseconds); 
} else {
    timestamp_out="Error parsing UUID";
}

return (timestamp_out);

$$    

; 
