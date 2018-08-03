var express = require("express");
var router = express.Router();
var Member = require("../../models/member");
var MemberR = require("../../models/memberR");
var Listen = require("../../models/listen");
var Speak = require("../../models/speak");
var Read = require("../../models/read");
var Write = require("../../models/write");
var Mockexam = require("../../models/mockexam");
var upload = require("../../util/multerUtil");
var sendSMS = require("../../util/sendSMS");
var fs = require("fs");
// 随机推荐题
router.get("/findMaterials", (req, res, next) => {
    var recommendListen, recommendSpeak, recommendRead, arr = [];
    // 随机推荐题目
    // 听力题
    Listen.findAllListenMaterial((err, rows) => {
        if (err) {
            return res.send(err);
        } else {
            var index = Math.floor(Math.random() * rows.length);
            arr[0] = rows[index];
            // 口语题
            Speak.findAllSpeakMaterial((err, rows) => {
                if (err) {
                    return res.send(err);
                } else {
                    var index = Math.floor(Math.random() * rows.length);
                    arr[1] = rows[index];
                    // 阅读题
                    Read.findAllReadMaterial((err, rows) => {
                        if (err) {
                            return res.send(err);
                        } else {
                            var index = Math.floor(Math.random() * rows.length);
                            arr[2] = rows[index];
                            res.send(arr);
                        }
                    });
                }
            });
        }
    });
})

// 修改信息
router.post("/updateMasg", upload.fields([{name: "img",maxCount: 1}]), (req, res, next) => {
    var id = req.body.id;
    var nickname = req.body.nickname;
    var password = req.body.password;
    var phoneNum = req.body.phoneNum;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : req.body.img1 ? req.body.img1 : null : req.body.img1 ? req.body.img1 : null;
    var age = req.body.age ? req.body.age : null;
    var sex = req.body.sex ? 　req.body.sex : "0";
    var sno = req.body.sno ? req.body.sno : null;
    var stage = req.body.stage ? req.body.stage : "6";
    if (req.files && req.files.img && req.body.img1) {
        fs.exists("public"+req.body.img1,(exists)=>{
            if(exists){
                fs.unlink("public"+req.body.img1, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })
    }
    Member.updateMasg(id, img, nickname, password, phoneNum, age, sex, sno, stage, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 修改密码
router.post("/updatePassword", (req, res, next) => {
    var account = req.body.account;
    var password = req.body.password;
    Member.updatePassword(account, password, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 添加成绩
router.post("/updateScore", (req, res, next) => {
    var id = req.body.id;
    var score = req.body.score;
    Member.updateScore(id, score, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 添加答题数
router.get("/updateQuestionNum", (req, res, next) => {
    var id = req.query.id;
    Member.updateQuestionNum(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 排行榜前十
router.get("/findScoreTop", (req, res, next) => {
    Member.findScoreTop((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询用户信息
router.get("/findMemberById", (req, res, next) => {
    var id = req.query.id;
    Member.findMemberById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 修改计划状态
router.post("/updateIsPlan", (req, res, next) => {
    var id = req.body.id;
    var isPlan = req.body.isPlan;
    Member.updateIsPlan(id, isPlan, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 找回密码
router.post("/findBackPassword", (req, res, next) => {
    var account = req.body.account;
    Member.findPhoneNum(account, (err, num) => {
        if (err) {
            res.send(err)
        }
        if (num &&num.length > 8) {
            sendSMS.send(num, (rows) => {
                if (rows.status == 200) {
                    var data = [{ phoneNum: num, code: rows.code }]
                    res.send(data);
                } else {
                    res.send(rows.status);
                }
            })
        } else {
            res.send("defeat");
        }
    })
})
module.exports = router;
