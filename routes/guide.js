/**
 *  指南路由
 */





var express = require("express");
var router = express.Router();
var MemberR = require("../models/memberR");

// 进入会员推荐列表页
router.get("/", (req, res, next) => {
    var page = req.query.page ? req.query.page * 1 : 1;
    var tyId = 0;
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    din(tyId, page, (err, memberRs, num, top) => {
        if (err) {
            res.send(err);
        }
        res.render('guide.html', {
            data: JSON.parse(JSON.stringify(memberRs)),
            num: num,
            page: page,
            top: JSON.parse(JSON.stringify(top))
        });
    })
})

router.get("/read", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var page = req.query.page ? req.query.page * 1 : 1;
    var tyId = 2;
    din(tyId, page, (err, memberRs, num, top) => {
        if (err) {
            res.send(err);
        }
        res.render('guide.html', {
            data: JSON.parse(JSON.stringify(memberRs)),
            num: num,
            page: page,
            top: JSON.parse(JSON.stringify(top))
        });
    })
})
router.get("/spoken", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var page = req.query.page ? req.query.page * 1 : 1;
    var tyId = 1;
    din(tyId, page, (err, memberRs, num, top) => {
        if (err) {
            res.send(err);
        }
        res.render('guide.html', {
            data: JSON.parse(JSON.stringify(memberRs)),
            num: num,
            page: page,
            top: JSON.parse(JSON.stringify(top))
        });
    })
})
router.get("/listen", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var page = req.query.page ? req.query.page * 1 : 1;
    var tyId = 3;
    din(tyId, page, (err, memberRs, num, top) => {
        if (err) {
            res.send(err);
        }
        res.render('guide.html', {
            data: JSON.parse(JSON.stringify(memberRs)),
            num: num,
            page: page,
            top: JSON.parse(JSON.stringify(top))
        });
    })
})
router.get("/write", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var page = req.query.page ? req.query.page * 1 : 1;
    var tyId = 4;
    din(tyId, page, (err, memberRs, num, top) => {
        if (err) {
            res.send(err);
        }
        res.render('guide.html', {
            data: JSON.parse(JSON.stringify(memberRs)),
            num: num,
            page: page,
            top: JSON.parse(JSON.stringify(top))
        });
    })
});
// 进入会员推荐详情
router.get("/Mdetails", (req, res, next) => {
    var id = req.query.id;
    var data = [],
        next = [],
        last = [];
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    if(req.session.user.pay != '1'){
        res.redirect("/guide");
        return;
    }
    MemberR.findMemberR(id, (err, rows) => {
        if (err) {
            res.send(err)
        }
        data = rows;
        MemberR.findNext(id, (err, rows_1) => {
            if (err) {
                res.send(err)
            }
            next = rows_1;
            MemberR.findLast(id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                last = rows_2;
                MemberR.findMemberRTop(5, (err, rows_3) => {
                    if (err) {
                        res.send(err);
                    }
                    top = rows_3;
                    MemberR.addPageView(id, (err, sta) => {
                        if (err) {
                            res.send(err);
                        }
                        if (sta == 'success') {
                            res.render("Mdetails.html", {
                                data: data,
                                last: last,
                                next: next,
                                top: top
                            });
                        }
                    })
                })
            })
        })
    });
})


function din(tyId, page, callback) {
    var start = (page - 1) * 10;
    var memberRs = [],
        top = [],
        num = 0;
    MemberR.findMemberRByNum(tyId, start, 10, (err, rows) => {
        if (err) {
            return callback(err);
        } else {
            memberRs = JSON.parse(JSON.stringify(rows));
            MemberR.findNumByTyId(tyId, (err, rows_1) => {
                if (err) {
                    return callback(err);
                };
                num = rows_1[0].num;
                num = Math.ceil(num / 10);
                MemberR.findMemberRTop(5, (err, rows_2) => {
                    if (err) {
                        return callback(err);
                    }
                    top = rows_2;
                    callback(err, memberRs, num, top)
                })
            });
        }
    })
}
module.exports = router;