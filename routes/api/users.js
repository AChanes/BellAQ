var express = require("express");
var router = express.Router();
var Member = require("../../models/member");
var Target = require("../../models/target");
var jwt = require("jsonwebtoken")
var sendSMS = require("../../util/sendSMS");

// 检测账号是否存在
router.post("/findAccount", (req, res, next) => {
    var account = req.body.account;
    Member.findAccount(account, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows[0]);
    })
})

// 注册
router.post("/reg", (req, res, next) => {
    var img = req.body.img ? req.body.img : "/images/0.7057596386216727.jpg";
    var account = req.body.account;
    var nickname = req.body.nickname;
    var password = req.body.password;
    var phoneNum = account;
    // 注册
    Member.reg(img, nickname, account, password, phoneNum, (err, sta) => {
        if (err) {
            res.send(err);
        }
        console.log(sta);
        res.send(JSON.parse(JSON.stringify(sta)));
    });
});
// 登陆
router.post("/login", (req, res, next) => {
    var account = req.body.account;
    var password = req.body.password;
    Member.login(account, password, (err, rows) => {
        if (err) {
            res.send(err);
        }
        if (rows == "defeat") {
            res.send(rows);
        } else {
            var str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var n = 12,
                s = "";
            for (var i = 0; i < n; i++) {
                var rand = Math.floor(Math.random() * str.length);
                s += str.charAt(rand);
            }
            res.cookie("user", {
                KPOs0vHlz4v: rows[0].pay + s
            }, {
                maxAge: 1000 * 60 * 60,
                signed: true
            });
            res.send(rows);
        }
    });
});

// 退出登陆
router.get("/unLogin", (req, res, next) => {
    res.clearCookie('user');
    res.send("success");
})

function int(arr) {
    for (var i = 0, len = arr.length; i < len; i++) {
        arr[i] = arr[i] * 1;
    }
    return arr;
}

// 验证
router.post("/findCheckCode", (req, res, next) => {
    var phoneNum = req.body.phoneNum;
    Member.findCheckCode(phoneNum, (err, sta) => {
        if (err) {
            res.send(err);
        }
        if (sta == "1") {
            sendSMS.send(phoneNum, (rows) => {
                if(rows.status == 200){
                    var data=[{phoneNum:phoneNum,code:rows.code}]
                    res.send(data);
                }else{
                    res.send(rows.status);
                }
            })
        } else {
            res.send(sta);
        }
    })
})
module.exports = router;