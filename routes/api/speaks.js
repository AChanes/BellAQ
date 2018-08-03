var express = require("express");
var router = express.Router();
var Speak = require("../../models/speak");
var upload = require("../../util/multerUtil");

// 按照材料id查询口语材料
router.get("/TfindSpeakMaterialById", (req, res, next) => {
    var id = req.query.id;
    Speak.TfindSpeakMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询所有的口语材料(结果：id，情景类型，难度等级)
router.get("/findAllSpeakMaterial", (req, res, next) => {
    Speak.findAllSpeakMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照id段查询口语材料
router.get("/findSpeakMaterial", (req, res, next) => {
    var startIndex = req.query.startIndex - 1;
    var num = req.query.num * 1;
    Speak.findSpeakMaterial(startIndex, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照id查询口语材料（id，问题，问题录音，原文，原文录音，阅读材料,情景类型）
router.get("/findSpeakMaterialById", (req, res, next) => {
    var id = req.query.id;
    Speak.findSpeakMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照口语材料id查询该材料的所有录音(结果：录音者头像，录音者昵称，录音日期，录音，点赞数)
router.get("/findAllAnswerRecord", (req, res, next) => {
    var materialId = req.query.id;
    Speak.findAllAnswerRecord(materialId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.likeClick = int(row.likeClick.split(","));
        });
        res.send(rows);
    })
})

// 按照材料ID查询题目要求（结果：mp4ForQ）
router.get("/findMp4ForQ", (req, res, next) => {
    var id = req.query.id;
    Speak.findMp4ForQ(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照材料id查询问题
router.get("/findQuestionById", (req, res, next) => {
    var id = req.query.id;
    Speak.findQuestionById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 上传录音
router.post("/addAnswerRecord", (req, res, next) => {
    var mId = req.body.mId;
    var materialId = req.body.materialId;
    var mp4 = req.body.mp4;
    Speak.deleteMp4(mId, materialId, (err, sta) => {
        if (err) {
            res.send(err);
        } else {
            Speak.addAnswerRecord(mId, materialId, mp4, (err, stas) => {
                if (err) {
                    res.send(err);
                }
                res.send(stas);
            })
        }
    })
})

// 查询当前用户当前材料的录音（结果：录音ID，MP4,用户ID，材料ID）
router.get("/findMp4", (req, res, next) => {
    var mId = req.query.mId;
    var materialId = req.query.materialId;
    Speak.findMp4(mId, materialId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.likeClick = int(row.likeClick.split(","));
        });
        res.send(rows);
    })
})

// 查询材料总数
router.get("/findSpeakMaterialNum", (req, res, next) => {
    Speak.findSpeakMaterialNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 按照难度查询材料
router.get("/findSpeakingMaterialByDid", (req, res, next) => {
    var dId = req.query.dId;
    Speak.findSpeakingMaterialByDid(dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 录音点赞
router.get("/addLikeClick",(req,res,next)=>{
    var id = "," + req.query.id;
    var anId = req.query.anId;
    Speak.addLikeClick(id,anId,(err,sta)=>{
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

function int(arr) {
    for (var i = 0, len = arr.length; i < len; i++) {
        arr[i] = arr[i] * 1;
    }
    return arr;
}
module.exports = router;