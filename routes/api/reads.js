var express = require("express");
var router = express.Router();
var Read = require("../../models/read");

// 查询所有阅读材料
router.get("/findAllReadMaterial", (req, res, next) => {
    Read.findAllReadMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照条数查询阅读材料
router.get("/findReadMaterial", (req, res, next) => {
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    Read.findReadMaterial(startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 查询材料总数
router.get("/findReadMaterialNum", (req, res, next) => {
    Read.findReadMaterialNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 查询单个阅读材料
router.get("/TfindReadMaterialById", (req, res, next) => {
    var id = req.query.id;
    Read.TfindReadMaterialById(id, function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照难度查询材料
router.get("/findReadingMaterialByDid", (req, res, next) => {
    var dId = req.query.dId;
    Read.findReadingMaterialByDid(dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});
module.exports = router;
