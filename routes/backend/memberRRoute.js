var express = require("express");
var router = express.Router();
var MemberR = require("../../models/memberR");
var upload = require("../../util/multerUtil");
// 跳转至会员推荐管理界面
router.get("/",(req,res,next)=>{
    var aId = req.query.aId;
    MemberR.findAllMemberRByAid(aId, function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.render("backEnd/memberRs.html", rows[0]);
    });
})
// 添加会员推荐
router.post("/api/addMemberR",upload.fields([{name: "img",maxCount: 1}]),function (req, res, next) {
    var img = "/picture/" + req.files.img[0].filename;
    var aId = req.body.aId;
    var title = req.body.title;
    var digest = req.body.digest;
    var pullTime = new Date();
    pullTime = pullTime.getFullYear() + "-" + (pullTime.getMonth() + 1) + "-" + pullTime.getDate();
    var content = req.body.content;
    var tyId = req.body.tyId;
    MemberR.addMemberR(img, aId, title, digest, pullTime, content, tyId, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除会员推荐
router.get("/api/deleteMemberR", function (req, res, next) {
    var id = req.query.id;
    MemberR.deleteMemberR(id, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除某位会员管理的会员推荐
router.get("/api/deleteMemberRByAid", function (req, res, next) {
    var aId = req.query.aId;
    MemberR.deleteMemberRByAid(aId, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询某位老师的所有会员推荐
router.get("/api/findAllMemberRByAid", function (req, res, next) {
    var aId = req.query.aId;
    MemberR.findAllMemberRByAid(aId, function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 会员推荐详情
router.get("/api/findMemberR", function (req, res, next) {
    var id = req.query.id;
    MemberR.findMemberR(id, function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 修改会员推荐
router.post("/api/updateMemberR",upload.fields([{name: "img",maxCount: 1}]),function (req, res, next) {
    var id = req.body.id;
    var img = req.body.img ? req.body.img : "/picture/" + req.files.img[0].filename;
    var title = req.body.title;
    var digest = req.body.digest;
    var content = req.body.content;
    var tyId = req.body.tyId;
    MemberR.updateMemberR(id, img, title, digest, content, tyId, function (err,sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 修改点击量
router.post("/api/addPageViews", function (req, res, next) {
    var id = req.body.id;
    var pageView = req.body.pageView;
    MemberR.addPageViews(id, pageView, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 分类查找老师的会员推荐
router.get("/api/findMemberRByTyidAndAid",(req,res,next)=>{
    var tyId = req.query.tyId;
    var aId = req.query.aId;
    MemberR.findMemberRByTyidAndAid(aId, tyId, (err, rows) => {
        if(err){
            res.send(err);
        }
        res.send(rows);
    })
})
module.exports = router;