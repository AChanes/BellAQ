var express = require("express");
var router = express.Router();
var Read = require("../../models/read");
var ReadQ = require("../../models/readq");

// 查询单个题目
router.get("/TfindReadQuestionById", (req, res, next) => {
    var id = req.query.id;
    ReadQ.TfindReadQuestionById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
});

// 查询一个材料下所有题目
router.get("/TfindReadQuestionByRid", (req, res, next) => {
    var rId = req.query.rId;
    ReadQ.TfindReadQuestionByRid(rId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
});

// 查询单个题目
router.get("/findReadQuestionByRid", (req, res, next) => {
    var rId = req.query.rId;
    var numForRM = req.query.numForRM;
    ReadQ.findReadQuestionByRid(rId, numForRM, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    });
});

module.exports = router;