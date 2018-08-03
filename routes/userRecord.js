var express = require('express');
var mock = require("mockjs");
var Member = require("../models/member");
var Target = require("../models/target");
var AnswerRecord = require("../models/answerR");


var router = express.Router();



router.get("/" , ( req, res , next ) => { 
    var mid  = req.session.user.id;
    var page = req.query.page || 1;
    getUserAnswerRecord(null,mid).then((rows)=>{
        res.render('userRecord.html', {
            userRecordData: rows.slice( (page - 1) * 20, page * 20),
            userRecordDataCount: rows.length,
            page: page
        });
    });
});

router.get("/:type", ( req, res, next ) => {
    var mid = req.session.user.id;
    var tid;
    switch (req.params.type) {
        case 'read':
            tid = 2;
            break;
        case 'spoke':
            tid = 1;
            break;
        case 'listen':
            tid = 3;
            break;
        case 'write':
            tid = 4;
            break;  
        default:
            break;
    }

    getUserAnswerRecord(tid, mid).then((rows) => {
        var page = req.query.page || 1;
        res.render('userRecord.html', {
            userRecordData: rows.slice((page - 1) * 20, page * 20),
            userRecordDataCount: rows.length,
            page : page
        });
    })
});





const getUserAnswerRecord  = (tyid,mid) => {
    return new Promise((resolve, reject) => {
        AnswerRecord.findAnswerRecord4TM(tyid, mid, (err, rows) => {
            if(err){
                reject(err);
            }else{
                resolve(rows);
            }
        });
    });
};


module.exports = router;