var express = require("express");
var router = express.Router();
var Listen = require("../../models/listen");
var ListenQ = require("../../models/listenq");
var upload = require("../../util/multerUtil");



// 查询单个听力材料
router.get("/TfindListenMaterialById", (req, res, next) => {
    var id = req.query.id;
    console.log(id);
    Listen.TfindListenMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询某位老师的所有听力材料
router.get("/TfindListenMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Listen.TfindListenMaterialByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询所有听力材料
router.get("/findAllListenMaterial", (req, res, next) => {
    Listen.findAllListenMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询听力材料MP4
router.get("/findAllListenMaterialMp4", (req, res, next) => {
    var id = req.query.id;
    Listen.findAllListenMaterialMp4(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照条数查询听力材料
router.get("/findListenMaterial", (req, res, next) => {
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    Listen.findListenMaterial(startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询材料总数
router.get("/findListenMaterialNum", (req, res, next) => {
    Listen.findListenMaterialNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 按照难度查询听力材料
router.get("findListeningMaterialByDid", (req, res, next) => {
    var dId = req.query.dId;
    Listen.findListeningMaterialByDid(dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})
module.exports = router;