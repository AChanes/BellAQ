var express = require("express");
var router = express.Router();
var Mockexam = require("../../models/mockexam");

// 添加套题
router.post("/addMockexam", (req, res, next) => {
    var tId = req.body.tId;
    var lId = req.body.lId.join(",");
    var sId = req.body.sId.join(",");
    var rId = req.body.rId.join(",");
    var wId = req.body.rId.join(",");
    var dId = req.body.dId;
    var timedown = req.body.timedown ? req.body.timedown : null;
    Mockexam.addMockexam(tId, lId, sId, rId, wId, dId, timedown, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除某位老师所有套题
router.get("/deleteMockexamByTid", (req, res, next) => {
    var tId = req.body.tId;
    Mockexam.deleteMockexamByTid(tId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 删除套题（id）
router.get("/deleteMockexamById", (req, res, next) => {
    var id = req.query.id;
    Mockexam.deleteMockexamById(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 修改套题
router.post("/updateMockexam", (req, res, next) => {
    var id = req.body.id;
    var lId = req.body.lId.join(",");
    var sId = req.body.sId.join(",");
    var rId = req.body.rId.join(",");
    var wId = req.body.rId.join(",");
    var dId = req.body.dId;
    var timedown = req.body.timedown ? req.body.timedown : null;
    Mockexam.updateMockexam(id, lId, sId, rId, wId, dId, timedown, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
})

// 按照条数查询套题
router.get("/findMockexam", (req, res, next) => {
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    Mockexam.findMockexam(startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.lId = int(row.lId.split(","));
            row.sId = int(row.sId.split(","));
            row.rId = int(row.rId.split(","));
            row.wId = int(row.wId.split(","));
        });
        res.send(rows);
    });
});

function int(arr) {
    for (var i = 0, len = arr.length; i < len; i++) {
        arr[i] = arr[i] * 1;
    }
    return arr;
}

// 查询套题内的某一类题
router.get("/findMaterial", (req, res, next) => {
    var id = req.query.id;
    var type = req.query.type;
    Mockexam.findMaterial(id, type, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            if (type == 1) {
                row.sId = int(row.sId.split(","));
            } else if (type == 2) {
                row.rId = int(row.rId.split(","));
            } else if (type == 3) {
                row.lId = int(row.lId.split(","));
            } else if (type == 4) {
                row.wId = int(row.wId.split(","));
            }
        });
        res.send(rows);
    });
})

// 查询某位老师所有套题
router.get("/findMockexamByTid", (req, res, next) => {
    var tId = req.query.tId;
    Mockexam.findMockexamByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.lId = int(row.lId.split(","));
            row.sId = int(row.sId.split(","));
            row.rId = int(row.rId.split(","));
            row.wId = int(row.wId.split(","));
        });
        res.send(rows);
    })
});

// 用户已做套题数
router.get("/findMockexamNumByMid", (req, res, next) => {
    var mId = req.query.mId;
    Mockexam.findMockexamNumByMid(mId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询套题（id）
router.get("/findMockexamById", (req, res, next) => {
    var id = req.query.id;
    Mockexam.findMockexamById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.lId = int(row.lId.split(","));
            row.sId = int(row.sId.split(","));
            row.rId = int(row.rId.split(","));
            row.wId = int(row.wId.split(","));
        });
        res.send(rows);
    })
});

// 查询用户套题记录
router.get("/findMockexamR", (req, res, next) => {
    var mId = req.query.mId;
    Mockexam.findMockexamR(mId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询单个套题记录
router.get("/findMockexamRById", (req, res, next) => {
    var id = req.query.id;
    Mockexam.findMockexamRById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 添加套题记录
router.post("/addMockexamR", (req, res, next) => {
    var mId = req.body.mId;
    var mEId = req.body.mEId;
    var time = new Date();
    var month = (time.getMonth() + 1) < 10 ? '0' + (time.getMonth() + 1) : time.getMonth() + 1;
    var day = time.getDate() < 10 ? '0' + time.getDate() : time.getDate();
    time = time.getFullYear() + "-" + month + "-" + day;
    Mockexam.addMockexamR(mId, mEId, time, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 修改套题成绩
router.post("/updateMockexamR", (req, res, next) => {
    var id = req.body.id;
    var score = req.body.score;
    Mockexam.updateMockexamR(id, score, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改题目是否在套题内
router.get("/updateIsMockexam", (req, res, next) => {
    var id = req.query.id;
    var type = req.query.type;
    var isMockexam = req.query.isMockexam;
    Mockexam.updateIsMockexam(id, type, isMockexam, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 查询材料总数
router.get("/findMockexamMaterialNum", (req, res, next) => {
    Mockexam.findMockexamMaterialNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

module.exports = router;