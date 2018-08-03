var db = require("../util/db");

// 听力题目类
function ListenQ() {
    this.id;
    this.LMId;
    this.numForLM;
    this.isD;
    this.mp4;
    this.question;
    this.mp4ForQ;
    this.options;
    this.rightAnswer;
    this.score;
}

module.exports = ListenQ;

// 教师操作
// 添加题目
ListenQ.TaddListenQuestion = function (LMId, isD, mp4, question, options, rightAnswer, score, mp4ForQ, callback) {
    var sql = "insert into listeningQuestion(LMId, isD, mp4, question, options, rightAnswer, score, mp4ForQ) value(?,?,?,?,?,?,?,?)";
    db.exec(sql, [LMId, isD, mp4, question, options, rightAnswer, score, mp4ForQ], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 删除单个题目
ListenQ.TdeleteListenQuestionById = function (id, callback) {
    var sql = "select LMId,numForLM from listeningQuestion where id = ?";
    var numForLM;
    var LMId;
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }else{
            LMId = rows[0].LMId;
            numForLM = rows[0].numForLM;
            var sql = "delete from listeningQuestion where id = ?";
            db.exec(sql, [id], function (err) {
                if (err) {
                    return callback(err);
                }else{
                    var sql = "update listeningQuestion set numForLM = numForLM - 1 where LMId = ? and numForLM > ?";
                    db.exec(sql,[LMId,numForLM],function(err){
                        if(err){
                            return callback(err);
                        }else{
                            callback(err, 'success');
                        }
                    })
                }
            })
        }
    })
    
}

// 删除一个材料下的所有题目
ListenQ.TdeleteListenQuestionByLMId = function (LMId, callback) {
    var sql = "delete from listeningQuestion where LMId = ?";
    db.exec(sql, [LMId], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查询单个题目
ListenQ.TfindListenQuestionById = function (id, callback) {
    var sql = "select * from listeningQuestion where id = ?";
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 查询一个材料下所有题目
ListenQ.TfindListenQuestionByLMId = function (LMId, callback) {
    var sql = "select * from listeningQuestion where LMId = ?";
    db.exec(sql, [LMId], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 修改题目
ListenQ.TupdateListenQuestion = function (id, isD, mp4, question, options, rightAnswer, score, mp4ForQ, callback) {
    var sql = "update listeningQuestion set isD =? , mp4 = ? , question = ? , mp4ForQ = ? , options = ? , rightAnswer = ? , score = ? where id =?";
    db.exec(sql, [isD, mp4, question, mp4ForQ, options, rightAnswer, score, id], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}


// 前台操作
// 按照听力材料ID查询单个题目
ListenQ.findListenQuestionByLMId = function (LMId, numForLM, callback) {
    var sql = "select * from listeningQuestion where LMId = ? and numForLM = ?";
    db.exec(sql, [LMId, numForLM], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 查询答题结果
ListenQ.findListenResult = function(mId,LMId,callback){
    var sql = "select count(id) as num from listeningQuestion where LMId = ?";
    db.exec(sql,[LMId],function(err,rows){
        if(err){
            return callback(err);
        }else{
            var num = rows[0].num;
            sql = "select allAnswerRecord.id as id, listeningQuestion.mp4 as mp4,listeningQuestion.question as question,listeningQuestion.mp4ForQ as mp4ForQ,listeningQuestion.options as options,listeningQuestion.rightAnswer as rightAnswer,listeningQuestion.score as score,allAnswerRecord.mAnswer as mAnswer from listeningQuestion join allAnswerRecord on(listeningQuestion.LMId=allAnswerRecord.materialId) where allAnswerRecord.mId = ? and listeningQuestion.LMId = ? and allAnswerRecord.tyId = 3 and listeningQuestion.numForLM = allAnswerRecord.numForM order by allAnswerRecord.id desc limit ?";
            db.exec(sql,[mId,LMId,num],function(err,rows){
                if(err){
                    return callback(err);
                }
                callback(err,rows);
            })
        }
    })
}

// 查询一个材料下小题总数
ListenQ.findMaxNumForLM = function(LMId,callback){
    var sql = "select count(id) as num from listeningQuestion where LMId = ?";
    db.exec(sql,[LMId],(err,rows)=>{
        if(err){
            return callback(err)
        }
        callback(err,rows)
    })
}