
var db = require("../util/db");
var Member = require("./member");

// 答题记录
function AnswerR(){
    this.id;
    this.mId;
    this.tyId;
    this.isM;
    this.materialId;
    this.materialTitle;
    this.dId;
    this.level;
    this.numForM;
    this.mp4;
    this.likeClick;
    this.mAnswer;
    this.rightAnswer;
    this.isRight;
    this.wContent;
    this.score;
    this.startTime;
    this.endTime;
}

module.exports = AnswerR;

// 添加答题记录
AnswerR.addAnswerR = function(mId, tyId, isM, materialId, numForM, mp4, mAnswer, rightAnswer, isRight, wContent, score,startTime,endTime,callback){
    var sql = "insert into allAnswerRecord(mId, tyId, isM, materialId, numForM, mp4, mAnswer, rightAnswer, isRight, wContent, score,startTime,endTime) value(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    db.exec(sql,[mId, tyId, isM, materialId, numForM, mp4, mAnswer, rightAnswer, isRight, wContent, score,startTime,endTime],function(err){
        if(err){
            return callback(err);
        }
        
        callback(err, 'success');
    })
}

// 查询全部答题记录
AnswerR.findAnswerRByMid = function(mId,callback){
    var sql = "select * from allAnswerRecord where mId = ?";
    db.exec(sql,[mId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询错题记录
AnswerR.findWrongAnswerR = function(mId,callback){
    var sql = "select * from allAnswerRecord where mId = ? and isRight = '0'";
    db.exec(sql,[mId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询正确记录
AnswerR.findRightAnswerR = function(mId,callback){
    var sql = "select * from allAnswerRecord where mId = ? and isRight = '1'";
    db.exec(sql,[mId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询答题结果
AnswerR.findAnswerRByNumForM = function(mId, tyId, materialId, numForM,callback){
    var sql = "select * from allAnswerRecord where mId = ? and tyId = ? and materialId = ? and numForM = ? order by id desc limit 1";
    db.exec(sql, [mId, tyId, materialId, numForM], function(err, rows) {
      if (err) {
        return callback(err);
      }
      callback(err, rows);
    });
}

// 查询单个答题记录
AnswerR.findAnswerRById = function(id,callback){
    var sql = "select * from allAnswerRecord where id = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询单个材料的答题记录
AnswerR.findAnswerRByMaterialId = function(mId,tyId,materialId,num,callback){
    var sql = "select * from allAnswerRecord where mId = ? and tyId = ? and materialId = ? order by id desc limit 0,?";
    db.exec(sql,[mId,tyId,materialId,num],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 口语查询口语例子语音
AnswerR.findExample = function(id,callback){
    var sql = "select allanswerrecord.id as id,member.nickname as nickname,member.id as mId,member.img as img,allAnswerRecord.mp4 as mp4,allAnswerRecord.likeClick as likeClick from allAnswerRecord join member on(allAnswerRecord.mId = member.id) where allAnswerRecord.tyId =1 and allAnswerRecord.materialId = ? order by allanswerrecord.likeClick desc limit 6";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows)
    })
}

//查询阅读结果
AnswerR.findReadResult = function(mId,materialId,numForM,callback){
   var sql = "select allAnswerRecord.mAnswer as mAnswer,allAnswerRecord.isRight as isRight,allAnswerRecord.materialId as materialId,readingMaterial.englishTitle as englishTitle,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial from allAnswerRecord join readingMaterial on(allAnswerRecord.materialId = readingMaterial.id) where allAnswerRecord.materialId = ? and allAnswerRecord.tyId = 2 and allAnswerRecord.mId = ? and allAnswerRecord.numForM = ? order by allAnswerRecord.id desc limit 1";
    db.exec(sql,[materialId,mId,numForM],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows)
    })
}

// 查询单个材料的所有语音
AnswerR.findAllMp4ByMaterialId = function(id,callback){
    var sql = "select allanswerrecord.id as id,member.nickname as nickname,member.img as img,allanswerrecord.mp4 as mp4,allanswerrecord.likeClick as likeClick from allanswerrecord join member on(allanswerrecord.mId = member.id) where allanswerrecord.materialId = ? order by allanswerrecord.likeClick desc";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err)
        }
        callback(err,rows)
    })
}

// 查询一个材料的指定用户的录音
AnswerR.findMyMp4 =function(mId,id,callback){
    var sql = "select allanswerrecord.id as id,member.nickname as nickname,member.img as img,allanswerrecord.mp4 as mp4,allanswerrecord.likeClick as likeClick from allanswerrecord join member on(allanswerrecord.mId = member.id) where allanswerrecord.materialId = ? and mId = ? order by allAnswerRecord.likeClick limit 4";
    db.exec(sql,[id,mId],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 根据类型和用户ID获取答题记录
AnswerR.findAnswerRecord4TM = function (tyid , mid, callback) {
    if(tyid == 4){
        var sql = "select t1.id as id,t1.mId as mId,t1.tyId as tyId,t1.isM as isM,t1.materialId as materialId,t1.materialTitle as materialTitle,t1.dId as dId,t1.level as level,t1.numForM as numForM,t1.mp4 as mp4,t1.likeClick as likeClick,t1.mAnswer as mAnswer,t1.rightAnswer as rightAnswer,t1.isRight as isRight,t1.wContent as wContent,t1.score as score,t1.startTime as startTime,t1.endTime as endTime,t2.score as totalScore from allAnswerRecord as t1 join writingMaterial as t2 on(t1.materialId = t2.id)  where   t1.tyId = ? and t1.mId = ? order by t1.endTime desc";
    }else{
        var sql = "select * from allAnswerRecord  where   allAnswerRecord.tyid = ? and allAnswerRecord.mId = ? order by allAnswerRecord.endTime desc";
    }
    
    var allSql = "select * from allAnswerRecord  where   allAnswerRecord.mId = ? order by allAnswerRecord.endTime desc";
    if(tyid){
        db.exec(sql, [tyid,mid], (err, rows) => {
            if (err) {
                return callback(err)
            }
            callback(err, rows)
        })
    }else{
        db.exec(allSql, [mid], (err, rows) => {
             if (err) {
                 return callback(err)
             }
             callback(err, rows)
        })
    }
}

AnswerR.findMessage = function(id,callback){
    var today = new Date(new Date().setHours(0, 0, 0, 0)) / 1000-1;
    var tomorrow = today + 86400+1;
    var obj = [{}];
    var sql = "select count(id) as num from allAnswerRecord where startTime > ? and startTime < ? and mId = ? ";
    db.exec(sql,[today,tomorrow,id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        obj[0].num = rows[0].num;
        sql = "select  sum(score) as score from allAnswerRecord where startTime > ? and startTime < ? and mId = ? and isRight ='1'";
        db.exec(sql,[today,tomorrow,id],(err,rows_1)=>{
            if(err){
                return callback(err);
            }
            obj[0].score = rows_1[0].score;
            sql = "select startTime from allAnswerRecord where mId = ?";
            db.exec(sql,[id],(err,rows_2)=>{
                if(err){
                    return callback(err);
                }
                obj[0].times = rows_2;
                callback(err,obj);
            })
        })
    })
}

// 答题数前十
AnswerR.findQuestionTop = function(callback){
    var sql = "select t1.img,t1.nickname,t1.questionNum,t1.score as score,t2.rightNum as rightNum,t3.totalNum as totalNum from member as t1 join (select count(id) as rightNum,mId from allAnswerRecord where isRight ='1' group by allAnswerRecord.mId) as t2 on(t1.id = t2.mId) join (select count(id) as totalNum,mId from allAnswerRecord where isRight ='1' or isRight = '0' group by allAnswerRecord.mId) as t3 on(t1.id = t3.mId) order by t1.questionNum desc limit 10";
    db.exec(sql,"",(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 成绩前十
AnswerR.findScoreTop = function (callback) {
    var sql = "select t1.img,t1.nickname,t1.questionNum,t1.score as score,t2.rightNum as rightNum,t3.totalNum as totalNum from member as t1 join (select count(id) as rightNum,mId from allAnswerRecord where isRight ='1' group by allAnswerRecord.mId) as t2 on(t1.id = t2.mId) join (select count(id) as totalNum,mId from allAnswerRecord where isRight ='1' or isRight = '0' group by allAnswerRecord.mId) as t3 on(t1.id = t3.mId) order by t1.score desc limit 10";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 阅读题的正确率
AnswerR.read = function(callback){
    var sql = "select(select count(id) from allAnswerRecord where isRight = '1' and tyId =2)/(select count(id) from allAnswerRecord where tyId =2) as readCorrectRate";
    db.exec(sql,"",(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows)
    })
}

// 听力题的正确率
AnswerR.listen = function (callback) {
    var sql = "select(select count(id) from allAnswerRecord where isRight = '1' and tyId =3)/(select count(id) from allAnswerRecord where tyId =3) as listenCorrectRate";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows)
    })
}

// 写作平均分
AnswerR.wirte = function(callback){
    var sql = "select count(id) as total from allAnswerRecord where score > 0 and tyId = 4";
    db.exec(sql,"",(err,rows)=>{
        if(err){
            return callback(err);
        }
        if(rows[0].total == 0){
            callback(err, [{
                writeAverageScore: 0
            }]);
        }else{
            sql = "select sum(score) as score from allAnswerRecord where score > 0 and tyId = 4";
            db.exec(sql,"",(err,rows_1)=>{
                if(err){
                    return callback(err);
                }
                callback(err, [{
                    writeAverageScore: rows_1[0].score / rows[0].total
                }])
            })
        }
    })
}

AnswerR.spoken = function(callback){
    var timeStamp = new Date(new Date().setHours(0, 0, 0, 0)) / 1000;
    var OneDayAgo = timeStamp - 86400;
    var sql = "select count(id) as times from allAnswerRecord where tyId = 1 and endTime > ? and endTime < ?";
    db.exec(sql,[OneDayAgo,timeStampy],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}