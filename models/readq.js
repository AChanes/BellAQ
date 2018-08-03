var db = require("../util/db");

//阅读问题类
function ReadQ() {
    this.id;
    this.rId;
    this.numForRM;
    this.isD;
    this.question;
    this.options;
    this.rightAnswer;
    this.numF;
    this.score;
}

module.exports = ReadQ;

// 教师操作
// 添加题目
ReadQ.TaddReadMaterial = function (rId, isD, question, options, rightAnswer, score,numF, callback) {
    var sql = "insert into readingQuestion(rId, isD, question, options, rightAnswer, score,numF) value(?,?,?,?,?,?,?)";
    db.exec(sql, [rId, isD, question, options, rightAnswer, score, numF], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, "success");
    })
}

// 删除单个题目
ReadQ.TdeleteReadQuestionById = function (id, callback) {
    var sql = "select rId,numForRM from readingQuestion where id = ?";
    var rId,numForRM;
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }else{
            rId = rows[0].rId;
            numForRM = rows[0].numForRM;
            var sql = "delete from readingQuestion where id = ?";
            db.exec(sql, [id], function (err) {
                if (err) {
                    return callback(err);
                }else{
                    var sql = "update readingQuestion set numForRM = numForRM - 1 where rId = ? and numForRM > ?";
                    db.exec(sql,[rId,numForRM],function(err){
                        if(err){
                            return callback(err);
                        }
                        callback(err, "success");
                    })
                }
                
            })
        }
    })
    
}

// 删除一个材料下的所有题目
ReadQ.TdeleteReadQuestionByRid = function (rId, callback) {
    var sql = "delete from readingQuestion where rId = ?";
    db.exec(sql, [rId], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, "success");
    })
}

// 修改题目
ReadQ.TupdateReadQuestion = function (id, question, isD, options, rightAnswer, score,numF, callback) {
    var sql = "update readingQuestion set question = ? , isD = ? , options = ? , rightAnswer = ? , score = ?,numF= ? where id = ?";
    db.exec(sql, [question, isD, options, rightAnswer, score,numF, id], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查询单个题目
ReadQ.TfindReadQuestionById = function (id, callback) {
    var sql = "select * from readingQuestion where id = ?";
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 查询一个材料下的所有题目
ReadQ.TfindReadQuestionByRid = function (rId, callback) {
    var sql = "select * from readingQuestion where rId = ?";
    db.exec(sql, [rId], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 前台操作
// 查询单个题目
ReadQ.findReadQuestionByRid = function (rId, numForRM, callback) {
    var sql = "select * from readingQuestion where rId = ? and numForRM = ?";
    db.exec(sql, [rId, numForRM], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 查询结果详情
// 查询答题结果
ReadQ.findReadResult = function (mId, rId, callback) {
    var sql = "select count(id) as num from readingQuestion where rId = ?";
    db.exec(sql, [rId], function (err, rows) {
        if (err) {
            return callback(err);
        } else {
            var num = rows[0].num;
            sql = "select allAnswerRecord.id as id,readingQuestion.question as question,readingQuestion.options as options,readingQuestion.rightAnswer as rightAnswer,readingQuestion.score as score,allAnswerRecord.mAnswer as mAnswer from readingQuestion join allAnswerRecord on(readingQuestion.rId=allAnswerRecord.materialId) where allAnswerRecord.mId = ? and readingQuestion.rId = ? and allAnswerRecord.tyId = 2 and readingQuestion.numForRM = allAnswerRecord.numForM order by allAnswerRecord.id desc limit ?";
            db.exec(sql, [mId, rId, num], function (err, rows) {
                if (err) {
                    return callback(err);
                }
                callback(err, rows);
            })
        }
    })
}
// 查询一个材料下的小题数
ReadQ.findMaxNumForRM = function(rId,callback){
    var sql = "select count(id) as num from readingQuestion where rId = ?";
    db.exec(sql,[rId],(err,rows)=>{
        if(err){
            return callback(err)
        }
        callback(err,rows)
    })
}