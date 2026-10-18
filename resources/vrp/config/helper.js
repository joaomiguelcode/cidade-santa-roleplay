const regexValidHwidToken = /^[0-9A-Fa-f]{1,2}:[0-9A-Fa-f]{64}$/;

const filterPlayerHwids = (hwids) => {
    if (!Array.isArray(hwids)) {
        throw new TypeError('Expected an array of HWIDs');
    }

    let invalidHwidsArray = [];
    let validHwidsArray = [];

    for (const hwidString of hwids) {
        if (typeof hwidString !== 'string') continue;
        if (regexValidHwidToken.test(hwidString)) {
            validHwidsArray.push(hwidString);
        } else {
            invalidHwidsArray.push(hwidString);
        }
    }

    return { invalidHwidsArray, validHwidsArray };
};

const ConvertTableToBase64URL = (Table) => {
    const json = JSON.stringify(Table);
    const base64url = Buffer.from(json).toString('base64url');
    return base64url;
};

exports("ConvertTableToBase64URL", (Table) => {
    return ConvertTableToBase64URL(Table)
});

exports("filterPlayerHwids", (hwids) => {
    return filterPlayerHwids(hwids)
});