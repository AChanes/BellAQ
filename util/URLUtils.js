/**
 *  URL路径获取封装方法
 *  guotingchaopr@gmail.com
 */
const URL = require("url");
function parseQueryString(str) {
    var reg = /(([^?&=]+)(?:=([^?&=]*))*)/g;
    var result = {};
    var match;
    var key;
    var value;
    while (match = reg.exec(str)) {
        key = match[2];
        value = match[3] || '';
        if(key == "null")break;
        result[key] = decodeURIComponent(value);
    }
    return result;
}

module.exports = {
    getUrlLevelArray: function (originalUrl) {
        var urlObject = URL.parse(originalUrl);
        return {
            host: urlObject.host,
            hostname: urlObject.hostname,
            path: urlObject.pathname,
            pathArr: urlObject.pathname.slice(1).split("/"),
            query: urlObject.query,
            queryObject: parseQueryString(urlObject.query),
            protocol: urlObject.protocol || 'http'
        }
    }
}