var express = require("express");
var router = express.Router();
var ClockIn = require("../../models/clockin");
// 用户打卡
router.get("/doClock", (req, res, next) => {
  var mId = req.query.mId;
  var currentDay = new Date();
  var type = req.query.type,
    signedYear = currentDay.getFullYear(),
    signedMonth = currentDay.getMonth() + 1 < 10 ? '0' + (currentDay.getMonth() + 1) : currentDay.getMonth() + 1,
    signedDay = currentDay.getDate() < 10 ? '0' + currentDay.getDate() : currentDay.getDate();


  signedYear = req.query.signedYear ? req.query.signedYear : signedYear;
  signedMonth = req.query.signedMonth ? (req.query.signedMonth < 10 ? '0' + req.query.signedMonth : req.query.signedMonth) : signedMonth;
  signedDay = req.query.signedDay ? (req.query.signedDay < 10 ? '0' + req.query.signedDay : req.query.signedDay) : signedDay;

  var resultObj = {
    "result": true,
    "respObject": {
      "continuityCount": 0,
      "totalCount": 0,
      "signedDays": ""
    },
    "errorCode": "",
    "errorMsg": ""
  }

  var record = "",
    recordArr = [],
    clocked = false,
    time = signedYear + "-" + signedMonth + "-" + signedDay;
    
  ClockIn.findRecord(mId, (err, rows) => {
    if (err) {
      res.send(err);
    }
    // 查询结果不为空
    if (rows.length > 0 && rows[0].record) {
      record = rows[0].record;
      recordArr = record.split(",");
      // 未打卡
      if (recordArr.indexOf(time) == -1) {
        if (type == 0) {
          if(req.query.signedMonth == (currentDay.getMonth() + 1)){
            resultObj.result = false;
          }
          resultObj.respObject = chioce(record, signedYear, signedMonth, signedDay);
          res.send(resultObj)
        } else {
          ClockIn.addRecord(mId, (record + "," + time), (err, sta) => {
            if (err) {
              resultObj.result = false;
              resultObj.respObject = chioce(record, signedYear, signedMonth, signedDay);
              resultObj.errorCode = "-1";
              resultObj.errorMsg = "打卡失败";
            } else {
              resultObj.result = true;
              resultObj.respObject = chioce((record + "," + time), signedYear, signedMonth, signedDay);
            }
            res.send(resultObj)
          });
        }
      } else {
        if (type == 0) {
          resultObj.result = true;
          resultObj.respObject = chioce(record, signedYear, signedMonth, signedDay);
        } else {
          resultObj.result = false;
          resultObj.respObject = chioce(record, signedYear, signedMonth, signedDay);
          resultObj.errorCode = "-1";
          resultObj.errorMsg = "已经打卡";
        }
        res.send(resultObj)
      }
    } else {
      // 查询结果为空 未打卡
      if (type == 0) {
        if (req.query.signedMonth == (currentDay.getMonth() + 1)) {
          resultObj.result = false;
        }
        res.send(resultObj)
      } else {
        ClockIn.addRecord(mId, time, (err, sta) => {
          if (err) {
            resultObj.result = false;
            resultObj.respObject = chioce(record, signedYear, signedMonth, signedDay);
            resultObj.errorCode = "-1";
            resultObj.errorMsg = "打卡失败";
          } else {
            resultObj.result = true;
            resultObj.respObject = chioce(time, signedYear, signedMonth, signedDay);
          }
          res.send(resultObj)
        });
      }
    }
  });
})

function chioce(str, signedYear, signedMonth, signedDay) {
  var arr = str.split(",");
  var time = signedYear + "-" + signedMonth;
  var arrs = [],
    arrs_1 = [],
    t = max = 0;
  arr.forEach((tim, index) => {
    if (tim.substr(0, 7) == time) {
      arrs.push(tim.substr(8, 2) * 1);
      arrs_1.push(tim.substr(8, 2));
    }
  });
  for (var i = 1; i < 33; i++) {
    if (arrs.indexOf(i) != -1) {
      t += 1;
    } else {
      if (max < t) {
        max = t;
      }
      t = 0;
    }
    if (i == 32) {
      return {
        "continuityCount": max,
        "totalCount": arrs.length,
        "signedDays": arrs_1.join(",")
      }
    }
  }
}
module.exports = router;
