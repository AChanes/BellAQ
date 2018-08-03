var express = require("express");
var router = express.Router();
var MemberR = require("../../models/memberR");
var upload = require("../../util/multerUtil");

// 添加点击量
router.get("/addPageView", (req, res, next) => {
    var id = req.query.id;
    MemberR.addPageView(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询所有会员推荐
router.get("/findAllMemberR", (req, res, next) => {
    MemberR.findAllMemberR((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 会员推荐详情
router.get("/findMemberR", (req, res, next) => {
    var id = req.query.id;
    MemberR.findMemberR(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 推荐阅读前六
router.get("/findMemberRTop", (req, res, next) => {
    MemberR.findMemberRTop((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照条数查询会员推荐
router.get("/findMemberRByNum", (req, res, next) => {
    var tyId = req.query.tyId;
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    MemberR.findMemberRByNum(tyId, startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 按照分类查询会员推荐
router.get("/findMemberRByTyId", (req, res, next) => {
    var tyId = req.query.tyId;
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    MemberR.findMemberRByTyId(tyId, startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
})

// 按照分类查询会员推荐总数
router.get("/findNumByTyId", (req, res, next) => {
    var tyId = req.query.tyId;
    MemberR.findNumByTyId(tyId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 查询下一个会员推荐
router.get("/findNext", (req, res, next) => {
    var id = req.query.id;
    MemberR.findNext(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询上一个会员推荐
router.get("/findLast", (req, res, next) => {
    var id = req.query.id;
    MemberR.findLast(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})
module.exports = router;
