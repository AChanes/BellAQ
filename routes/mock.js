/**
 *  模考路由 
 */
var express = require('express');
var router = express.Router();
var Mockexam = require("../models/mockexam");
var Member = require("../models/member");
var AnswerR = require("../models/answerR");
// 进入模考
router.get("/", (req, res, next) => {
if (!req.session.user) {
    res.redirect("/login");
    return;
}
    var mocks = [],
        top = [];
    Mockexam.findAllMockexam((err, rows) => {
        if (err) {
            res.send(err);
        }
        mocks = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            AnswerR.findMessage(req.session.user.id, (err, rows_3) => {
                if (err) {
                    res.send(err);
                }
                var days = findDays(rows_3[0].times);
                res.render('mock.html', {
                    data: mocks,
                    top: top,
                    questionNum: rows_3[0].num,
                    score: rows_3[0].score,
                    days: days
                });
            })
        })
    })
})

// 模考页面一
router.get("/first", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mockRId = 0,
        mock = [],
        sId = rId = lId = wId = [];
    Mockexam.addMockexamR(mId, id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        mockRId = rows[0].id;
        Mockexam.findMockexamById(id, (err, rows_1) => {
            if (err) {
                res.send(err);
            }
            lId = rows_1[0].lId;
            sId = rows_1[0].sId;
            rId = rows_1[0].rId;
            wId = rows_1[0].wId;
            res.render("mock/mockfist.html", {
                mock: 1,
                mockRId: mockRId,
                lId: lId,
                sId: sId,
                rId: rId,
                wId: wId
            })
        })
    })
})

// 模考页面二（该页面后接口语页面一）
router.get("/second", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var mock = req.query.mock;
    var mockRId = req.query.mockRId,
        sId = req.query.sId ? req.query.sId : "",
        rId = req.query.rId ? req.query.rId : "",
        lId = req.query.lId ? req.query.lId : "",
        wId = req.query.wId ? req.query.wId : "";
    res.render("mock/mocksecond.html", {
        mock: mock,
        mockRId: mockRId,
        lId: lId,
        sId: sId,
        rId: rId,
        wId: wId
    })
})

// 模考得分页面
router.get("/result", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var mockRId = req.query.mockRId;
    Mockexam.findMockexamRById(mockRId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render("mock/mockend.html", {
            data: rows
        });
    })
})

// 进入模考答题记录
router.get("/mockRcord", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var mId = req.query.mId;
    Mockexam.findMockexamR(mId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render("/")
    })
})

function findDays(arr) {
    var day = [];
    arr.forEach((time, index) => {
        arr[index] = new Date(time.startTime * 1000).toLocaleDateString();
    })
    arr.forEach((time) => {
        if (day.indexOf(time) == -1) {
            day.push(time)
        }
    })
    return day.length;
}
module.exports = router;