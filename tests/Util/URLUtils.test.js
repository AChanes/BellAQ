require("should");
var URLUtils = require('../../util/URLUtils');
var should = require('should');
describe('./URLUtils.test.js', function () {
    it('/user/userRecord?a=1 无域名带参数测试方法返回结果', function () {
        URLUtils.getUrlLevelArray('/user/userRecord?a=1').should.be.ok().and.be.an.Object().and.eql({
                "host": null,
                "hostname": null,
                "path": "/user/userRecord",
                "pathArr": [
                    "user",
                    "userRecord"
                ],
                "protocol": "http",
                "query": "a=1",
                "queryObject": {
                    "a": "1"
                }
        });
    });


    it('https://localhost:3000/user/userRecord?a=1 带域名带参数测试方法返回结果', function () {
        URLUtils.getUrlLevelArray('https://localhost:3000/user/userRecord?a=1').should.be.ok().and.be.an.Object().and.eql({
            "host": "localhost:3000",
            "hostname": "localhost",
            "path": "/user/userRecord",
            "pathArr": [
                "user",
                "userRecord"
            ],
            "protocol": "https:",
            "query": "a=1",
            "queryObject": {
                "a": "1"
            }
        });
    });


    it('https://localhost:3000/user/userRecord 带域名无参数测试方法返回结果', function () {
        URLUtils.getUrlLevelArray('https://localhost:3000/user/userRecord').should.be.ok().and.be.an.Object().and.eql({
            "host": "localhost:3000",
            "hostname": "localhost",
            "path": "/user/userRecord",
            "pathArr": [
                "user",
                "userRecord"
            ],
            "protocol": "https:",
            "query": null,
            "queryObject": {}
        });
    });
});
