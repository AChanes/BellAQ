var express = require("express");
var router = express.Router();
var ListenQ = require("../../models/listenq");
var upload = require("../../util/multerUtil");

// 查询单个题目
router.get("/TfindListenQuestionById", function (req, res, next) {
    var id = req.query.id;
    ListenQ.TfindListenQuestionById(id, function (err, rows) {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
})

// 查询一个材料下所有题目
router.get("/TfindListenQuestionByLMId", function (req, res, next) {
    var LMId = req.query.LMId;
    ListenQ.TfindListenQuestionByLMId(LMId, function (err, rows) {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
})

// 按照听力材料ID查询单个题目
router.get("/findListenQuestionByLMId", function (req, res, next) {
    var LMId = req.query.LMId;
    var numForLM = req.query.numForLM;
    ListenQ.findListenQuestionByLMId(LMId, numForLM, function (err, rows) {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
})
module.exports = router;