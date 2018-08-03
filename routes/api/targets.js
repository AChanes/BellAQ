var express = require("express");
var router = express.Router();
var Target = require("../../models/target");

//用户添加学习计划
router.post("/addTarget", (req, res, next) => {
  var mId = req.body.mId;
  var dId = req.body.dId;
  var starts = new Date();
  var month = (starts.getMonth() + 1) < 10 ? '0' + (starts.getMonth() + 1) : starts.getMonth() + 1;
  var day = starts.getDate() < 10 ? '0' + starts.getDate() : starts.getDate();
      starts = starts.getFullYear() + "-" + month + "-" + day;
  var complete = req.body.complete;
  var score = req.body.score;
  Target.addTarget(mId, dId, starts, complete, score, (err, sta) => {
    if (err) {
      res.send(err);
    }
    res.send(sta);
  });
});

// 更改计划状态
router.post("/updateTargetStatus", (req, res, next) => {
    var mId = req.body.mId;
    var targetStatus = req.body.targetStatus;
    Target.updateTargetStatus(mId, targetStatus, (err, sta) => {
        if (err) {
          res.send(err);
        }
        res.send(sta);
    })
});

// 查询计划
router.get("/findTarget", (req, res, next) => {
  var mId = req.query.mId;
  Target.findTarget(mId, (err, rows) => {
    if(err){
      res.send(err);
    }
    res.send(rows);
  })
});


module.exports = router;