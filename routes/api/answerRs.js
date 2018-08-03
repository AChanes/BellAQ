var express = require("express");
var router = express.Router();
var AnswerR = require("../../models/answerR");
var upload = require("../../util/multerUtil");

// 添加答题记录
router.post("/addAnswerR", upload.fields([{name: "mp4",maxCount: 1}]), (req, res, next) => {
    var mId = req.body.mId;
    var tyId = req.body.tyId;
    var isM = req.body.isM ? req.body.isM*1 : 0;
    var materialId = req.body.materialId;
    var numForM = req.body.numForM ? req.body.numForM : 0;
    var mp4 = req.files ? req.files.mp4 ? "/video/" + req.files.mp4[0].filename : null : null;
    var mAnswer = req.body.mAnswer ? req.body.mAnswer : null;
    var rightAnswer = req.body.rightAnswer ? req.body.rightAnswer : null;
    var isRight = req.body.isRight ? req.body.isRight : "-1";
    var wContent = req.body.wContent ? req.body.wContent : null;
    var score = req.body.score ? req.body.score :0;
    var startTime = req.body.startTime/1000+"";
    var endTime = Date.parse(new Date())/1000+"";
    AnswerR.addAnswerR(mId, tyId, isM, materialId, numForM, mp4, mAnswer, rightAnswer, isRight, wContent, score,startTime,endTime, (err, sta) => {
        if(err){
            res.send(err);
        }
        res.send(sta);
    });
})

// 查询全部答题记录
router.post("/findAnswerRByMid", (req, res, next) => {
    var mId = req.body.mId;
    AnswerR.findAnswerRByMid(mId, (err, rows) => {
        if(err){
            res.send(err);
        }
        rows.forEach(row => {
          var time = new Date(row.completeDate);
          row.completeDate = time.toLocaleString();
        });
        res.send(rows);
    })
});

// 查询错题记录
router.get("/findWrongAnswerR", (req, res, next) => {
    var mId = req.query.mId;
    AnswerR.findWrongAnswerR(mId, (err, rows) => {
      if (err) {
        res.send(err);
      }
      rows.forEach(row => {
        var time = new Date(row.completeDate);
        row.completeDate = time.toLocaleString();
      });
      res.send(rows);
    });
});

//查询正确的答题记录
router.get("/findRightAnswerR", (req, res, next) => {
    var mId = req.query.mId;
    AnswerR.findRightAnswerR(mId, (err, rows) => {
      if (err) {
        res.send(err);
      }
      rows.forEach(row => {
        var time = new Date(row.completeDate);
        row.completeDate = time.toLocaleString();
      });
      res.send(rows);
    });
});

// 查询答题结果
router.get("/findAnswerRByNumForM", (req, res, next) => {
    var mId = req.query.mId;
    var tyId = req.query.tyId;
    var materialId = req.query.materialId;
    var numForM = req.query.numForM ? req.query.numForM : 0;
    AnswerR.findAnswerRByNumForM(mId, tyId, materialId, numForM, (err, rows) => {
      if (err) {
        res.send(err);
      }
      rows.forEach(row => {
        var time = new Date(row.completeDate);
        row.completeDate = time.toLocaleString();
      });
      res.send(rows);
    });
});

// 查询单个答题记录
router.get("/findAnswerRById", (req, res, next) => {
    var id = req.query.id;
    AnswerR.findAnswerRById(id, (err, rows) => {
        if(err){
            res.send(err);
        }
        rows.forEach(row => {
          var time = new Date(row.completeDate);
          row.completeDate = time.toLocaleString();
        });
        res.send(rows);
    })
})

// 查询单个材料的答题记录
router.get("/findAnswerRByMaterialId", (req, res, next) => {
    var mId = req.query.mId;
    var tyId = req.query.tyId;
    var materialId = req.query.materialId;
    var num = req.query.num*1;
    AnswerR.findAnswerRByMaterialId(mId, tyId, materialId, num, (err, rows) => {
        if(err){
            res.send(err);
        }
        res.send(rows);
    })
});


module.exports = router;