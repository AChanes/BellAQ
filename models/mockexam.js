var db = require("../util/db");

// 模拟套题类
function Mockexam(){
    this.id;
    this.tId;
    this.lId;
    this.sId;
    this.rId;
    this.wId;
    this.dId;
    this.timedown;
}

module.exports = Mockexam;

// 添加套题
Mockexam.addMockexam = function(tId,lId,sId,rId,wId,dId,timedown,callback){
    var sql = "insert into mockExam(tId,lId,sId,rId,wId,dId,timedown) value(?,?,?,?,?,?,?)";
    db.exec(sql, [tId, lId, sId, rId, wId, dId,timedown],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    });
}

// 删除套题(id)
Mockexam.deleteMockexamById = function(id,callback){
    var sql = "delete from mockExam where id = ?";
    db.exec(sql,[id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 删除套题(tId)
Mockexam.deleteMockexamByTid = function(tId,callback){
    var sql = "delete from mockExam where tId = ?";
    db.exec(sql,[tId],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 修改套题
Mockexam.updateMockexam = function(id, lId, sId, rId, wId, dId,timedown,callback){
    var sql = "update mockExam set lId = ?,sId = ?,rId = ?,wId = ?,dId = ?,timedown = ? where id = ?";
    db.exec(sql, [lId, sId, rId, wId, dId, timedown, id], function (err) {
      if (err) {
        return callback(err);
      }
      callback(err, "success");
    });
}

// 查询所有套题
Mockexam.findAllMockexam = function(callback){
    var sql = "select mockExam.id as id,sum(readScore)/count(mockExamR.id) as readScore,sum(listenScore)/count(mockExamR.id) as listenScore from mockExam left join mockExamR on(mockExam.id = mockExamR.mEId) group by mockExam.id";
    db.exec(sql,"",(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询套题(tid)
Mockexam.findMockexamByTid = function(id,callback){
    var sql = "select mockExam.id as id,mockExam.tId as tId,mockExam.lId as lId,mockExam.sId as sId,mockExam.rId as rId,mockExam.wId as wId,difficultyLevel.level as level,mockExam.timedown as timedown from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) where mockExam.tId = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 用户已做模拟题套数
Mockexam.findMockexamNumByMid = function(mId,callback){
    var sql = "select count(*) as num from mockExamR where mId = ?";
    db.exec(sql, [mId], function(err, rows) {
      if (err) {
        return callback(err);
      }
      callback(err, rows);
    });
}

// 按照条数查询套题
Mockexam.findMockexam = function(startIndex,num,callback){
    var sql = "select mockExam.id as id,mockExam.tId as tId,mockExam.lId as lId,mockExam.sId as sId,mockExam.rId as rId,mockExam.wId as wId,difficultyLevel.level as level,mockExam.timedown as timedown from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) limit ?,?";
    db.exec(sql,[startIndex,num],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询套题记录
Mockexam.findMockexamR = function(mId,callback){
    var sql = "select * from mockExamR where mId = ?";
    db.exec(sql,[mId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询一个套题记录
Mockexam.findMockexamRById = function (id, callback) {
    var sql = "select * from mockexamR where id = ?";
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 查询套题(id)
Mockexam.findMockexamById = function(id,callback){
    var sql = "select mockExam.id as id,mockExam.sId as sId,mockExam.rId as rId,mockExam.lId as lId,mockExam.wId as wId from mockExam where mockExam.id = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}
// 查询套题内的某一类题
Mockexam.findMaterial = function(id,type,callback){
    var sql;
    if (type == 3) {
      sql = "select mockExam.id as id,mockExam.lId as lId,difficultyLevel.level as level from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) where mockExam.id = ?";
    } else if (type == 1) {
      sql = "select mockExam.id as id,mockExam.sId as sId,difficultyLevel.level as level from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) where mockExam.id= ?";
    } else if (type == 2) {
      sql = "select mockExam.id as id,mockExam.rId as rId,difficultyLevel.level as level from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) where mockExam.id = ?";
    } else if (type == 4) {
      sql = "select mockExam.id as id,mockExam.wId as wId,difficultyLevel.level as level from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) where mockExam.id = ?";
    }
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 添加套题记录
Mockexam.addMockexamR = function(mId,mEId,callback){
    var sql = "select mockExam.dId as dId,difficultyLevel.level as level from mockExam join difficultyLevel on(mockExam.dId = difficultyLevel.id) where mockExam.id = ?";
    db.exec(sql,[mEId],function(err,rows){
        if(err){
            return callback(err);
        }else{
            var dId = rows[0].dId;
            var level = rows[0].level;
            var startTime = Date.parse(new Date()) / 1000 + "";
            var sql = "insert into mockExamR(mId,mEId,dId,level,startTime) value(?,?,?,?,?)";
            db.exec(sql, [mId, mEId, dId, level,startTime], function (err) {
                if(err){
                    return callback(err);
                }else{
                    sql = "select id from mockExamR where mId = ? and mEId = ? order by id desc limit 1";
                    db.exec(sql,[mId,mEId],function(err,rows_1){
                        if(err){
                            return callback(err);
                        }
                        callback(err,rows_1);
                    })
                }
            });
        }
    })
}

// 修改套题成绩
Mockexam.updateMockexamR = function(id,score,callback){
    var sql = "update mockExamR set score = score + ? where id =?";
    db.exec(sql,[score,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 修改题目是否在套题内
Mockexam.updateIsMockexam = function(id,type,isMockexam,callback){
    var sql;
    if (type === 1) {
      sql = "update speakingMaterial set isMockexam = ? where id = ?";
    } else if (type === 2) {
      sql = "update readingMaterial set isMockexam = ? where id = ?";
    } else if (type === 3) {
      sql = "update listeningMaterial set isMockexam = ? where id = ?";
    } else if (type === 4) {
      sql = "update writingMaterial set isMockexam = ? where id = ?";
    }
    db.exec(sql,[isMockexam,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查询套题总数
Mockexam.findMockexamMaterialNum = function(callback){
    var sql = "select count(id) as MaterialNum from mockExam";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}