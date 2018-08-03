var express = require('express');
var mock = require("mockjs");
var Member = require("../models/member");
var Target = require("../models/target");
var AnswerRecord = require("../models/answerR");
var Read = require('../models/read');

var router = express.Router();


router.get("/", (req, res, next) => {
    let mid = req.session.user.id;
    Member.findMemberById(mid, (err, rows) => {
        if (!err) {
            req.session.user = rows[0];
            //并且用户计划不为零
            Promise.all([getPlanInfo(mid), getAnswerRecord(mid), getRecommendTask(), getExerciseDays(mid)]).then((datas, err) => {
                res.render('userCenter.html', {
                    userPlan: datas[0] || [],
                    answerRecord: datas[1] || [],
                    recommend: datas[2] || [],
                    mock: mock,
                    days:datas[3]||0
                });
            })
        } else {
            res.render('userCenter.html');
        }
    });
});





//获取计划数据
const getPlanInfo = (mid) => {
    return new Promise(((resolve, reject) => {
        Target.findTarget(mid, (err, plan_rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(plan_rows[0]);
            }
        });
    }));
}

//获取做题记录
const getAnswerRecord = (mid) => {
    return new Promise(((resolve, reject) => {
        AnswerRecord.findAnswerRByMid(mid, (err, answerRecord_rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(answerRecord_rows);
            }
        });
    }));
}


//获取最新的推荐

const getRecommendTask = () => {
    return new Promise((resolve, reject) => {
        Read.findNewTask((err, tasks) => {
            if (err) {
                reject(err);
            } else {
                resolve(tasks);
            }
        });
    });
}

const getExerciseDays = (mid) => {
    return new Promise((resolve, reject) => {
        AnswerRecord.findMessage(mid, (err, rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(findDays(rows))
            }
        })
    })
}

function findDays(arr) {
    var day = [];
    arr.forEach((time, index) => {
        arr[index] = new Date(time.startTime * 1000).toLocaleDateString();
    })
    arr.forEach((time) => {
        if (day.indexOf(time) == -1) {
            day.push(time)
        }
    })
    return day.length;
}
module.exports = router;