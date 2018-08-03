var express = require("express");
var router = express.Router();
var Write = require("../../models/write");
var upload = require("../../util/multerUtil");

// 查询某一个写作材料
router.get("/TfindWriteMaterialById", (req, res, next) => {
    var id = req.query.id;
    Write.TfindWriteMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 提交写作答案
router.post("/addAnswerRecord", (req, res, next) => {
    var mId = req.body.mId;
    var materialId = req.body.materialId;
    var wContent = req.body.wContent;
    Write.addAnswerRecord(mId, materialId, wContent, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

//查询所有写作题
router.get("/findWrite", (req, res, next) => {
    Write.findWrite((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照条数查询写作材料
router.get("/findWriteMaterial", (req, res, next) => {
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    Write.findWriteMaterial(startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

//题id查材料 第一页
router.get("/findWriteR1", (req, res, next) => {
    var id = req.query.id;
    Write.findWriteR1(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

//题id查材料 第二页
router.get("/findWriteR2", (req, res, next) => {
    var id = req.query.id;
    Write.findWriteR2(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

//题id查材料 第三页
router.get("/findWriteR3", (req, res, next) => {
    var id = req.query.id;
    Write.findWriteR3(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

//题id查材料 第四页
router.get("/findWriteR4", (req, res, next) => {
    var id = req.query.id;
    Write.findWriteR4(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 查询写作结果
router.get("/findAnswerRecord", (req, res, next) => {
    var mId = req.query.mId;
    var materialId = req.query.materialId;
    Write.findAnswerRecord(mId, materialId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});


// 查询材料总数
router.get("/findWriteMaterialNum", (req, res, next) => {
    Write.findWriteMaterialNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照难度查询材料
router.get("/findWritingMaterialByDid", (req, res, next) => {
    var dId = req.query.dId;
    Write.findWritingMateralByDid(dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});
module.exports = router;