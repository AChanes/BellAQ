

// 用于对口语类题目的操作（口语材料与问题是一对一关系，所以无题目类）

var db = require("../util/db");

// 口语类
function Speak(){
    this.id;
    this.tId;
    this.dId;
    this.title;
    this.img;
    this.mp4ForO;
    this.mp4ForA;
    this.mp4ForQ;
    this.question;
    this.timedown
    this.rMaterial;
    this.original;
    this.topicId;
    this.isMockexam;
}

module.exports = Speak;


// 教师操作
// 发布口语材料
Speak.TaddSpeakMaterial = function(tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId,isMockexam,callback){
    var sql = "insert into speakingMaterial(tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId,isMockexam) value(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    db.exec(sql,[tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId,isMockexam],function(err){
        if(err){
            return callback(err);
        }else{
            sql = "select speakingMaterial.id as id,speakingMaterial.tId as tId,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,speakingMaterial.isMockexam as isMockexam,difficultyLevel.level as level,speakingMaterial.title as title,speakingMaterial.mp4ForA as mp4ForA,speakingMaterial.mp4ForQ as mp4ForQ,speakingMaterial.question as question,topic.topicName as topic,speakingMaterial.img as img,speakingMaterial.mp4ForO as mp4ForO,speakingMaterial.timedown as timedown,speakingMaterial.rMaterial as rMaterial,speakingMaterial.original as original from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) where speakingMaterial.tId = ? order by id desc limit 1";
            db.exec(sql,[tId],(err,rows)=>{
                if(err){
                    return callback(err);
                }
                callback(err, rows);
            })
        }
        
    })
}

// 删除口语材料
Speak.TdeleteSpeakMaterialById = function(id,callback){
    var sql = "delete from speakingMaterial where id = ? and isMockexam = '0'";
    db.exec(sql,[id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 删除某位老师的所有口语材料
Speak.TdeleteSpeakMaterialByTid = function(tId,callback){
    var sql = "delete from speakingMaterial where tId = ? and isMockexam = '0'";
    db.exec(sql, [tId], function(err) {
      if (err) {
        return callback(err);
      }
      callback(err, "successs");
    });
}

// 修改口语材料
Speak.TupdateSpeakMaterial = function(id,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId,callback){
    var sql = "update speakingMaterial set dId = ? , title = ? , img = ? , mp4ForO = ? , mp4ForA = ? , mp4ForQ = ? , question = ? , timedown = ? , rMaterial = ? , original = ? , topicId = ? where id = ?";
    db.exec(sql,[dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 按照教师id查询口语材料
Speak.TfindSpeakMaterialByTid = function(tId,callback){
    var sql = "select speakingMaterial.id as id,speakingMaterial.tId as tId,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,speakingMaterial.isMockexam as isMockexam,difficultyLevel.level as level,speakingMaterial.title as title,speakingMaterial.mp4ForA as mp4ForA,speakingMaterial.mp4ForQ as mp4ForQ,speakingMaterial.question as question,topic.topicName as topic,speakingMaterial.img as img,speakingMaterial.mp4ForO as mp4ForO,speakingMaterial.timedown as timedown,speakingMaterial.rMaterial as rMaterial,speakingMaterial.original as original from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) where speakingMaterial.tId = ?";
    db.exec(sql,[tId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询该教师任意难度的所有口语材料
Speak.TfindSpeakMaterialByTidAndDid = function(tId,dId,callback){
    var sql = "select speakingMaterial.id as id,speakingMaterial.tId as tId,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,difficultyLevel.level as level,speakingMaterial.title as title,speakingMaterial.mp4ForA as mp4ForA,speakingMaterial.mp4ForQ as mp4ForQ,speakingMaterial.question as question,topic.topicName as topic,speakingMaterial.img as img,speakingMaterial.mp4ForO as mp4ForO,speakingMaterial.timedown as timedown,speakingMaterial.rMaterial as rMaterial,speakingMaterial.original as original from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) where speakingMaterial.tId = ? and speakingMaterial.dId = ?";
    db.exec(sql,[tId,dId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 教师按照材料ID查询口语材料
Speak.TfindSpeakMaterialById = function(id, callback) {
  var sql = "select speakingMaterial.id as id,speakingMaterial.tId as tId,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,difficultyLevel.level as level,speakingMaterial.title as title,speakingMaterial.mp4ForA as mp4ForA,speakingMaterial.mp4ForQ as mp4ForQ,speakingMaterial.question as question,topic.topicName as topic,speakingMaterial.img as img,speakingMaterial.mp4ForO as mp4ForO,speakingMaterial.timedown as timedown,speakingMaterial.rMaterial as rMaterial,speakingMaterial.original as original from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) where speakingMaterial.id = ?";
  db.exec(sql, [id], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};


// 前台用户操作
// 查询所有的口语材料(结果：id，情景类型，难度等级)
Speak.findAllSpeakMaterial = function(callback){
    var sql = "select speakingMaterial.id as id,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,difficultyLevel.level as level,speakingMaterial.title as title,topic.topicName as topic,speakingMaterial.img as img from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) order by speakingMaterial.id desc";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照条数查询口语材料
Speak.findSpeakMaterial = function(startIndex, num, callback) {
  var sql = "select speakingMaterial.id as id,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,difficultyLevel.level as level,speakingMaterial.title as title,topic.topicName as topic,speakingMaterial.img as img from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) order by speakingMaterial.id asc limit ?,?";
  db.exec(sql, [startIndex, num], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};

// 口语查看详情
// 按照id查询口语材料（id，问题，问题录音，原文，原文录音，阅读材料,情景类型）
Speak.findSpeakMaterialById = function(id,callback){
    var sql = "select speakingMaterial.id as id,speakingMaterial.tId as tId,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,difficultyLevel.level as level,speakingMaterial.title as title,speakingMaterial.mp4ForA as mp4ForA,speakingMaterial.mp4ForQ as mp4ForQ,speakingMaterial.question as question,topic.topicName as topic,speakingMaterial.img as img,speakingMaterial.mp4ForO as mp4ForO,speakingMaterial.timedown as timedown,speakingMaterial.rMaterial as rMaterial,speakingMaterial.original as original from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) where speakingMaterial.id = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照口语材料id查询该材料的所有录音(结果：录音者头像，录音者昵称，录音日期，录音，点赞数)
Speak.findAllAnswerRecord = function(materialId,callback){
    var sql = "select member.img as img,member.nickname as nickname,allAnswerRecord.id as id,allAnswerRecord.mId as mId,allAnswerRecord.likeClick as likeClick,allAnswerRecord.completeDate as completeDate,allAnswerRecord.mp4 as mp4,allAnswerRecord.likeClick as likeClick from member join allAnswerRecord on(member.id = allAnswerRecord.mId) where tyId = 1 and materialId = ? order by allAnswerRecord.likeClick desc";
    db.exec(sql,[materialId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 进入练习
// 按照材料ID查询题目要求（结果：mp4ForQ）
Speak.findMp4ForQ = function(id,callback){
    var sql = "select id,title,mp4ForQ,question from speakingMaterial where id = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照材料id查询问题
Speak.findQuestionById = function(id,callback){
    var sql = "select id,title,question from speakingMaterial where id = ?"
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 上传录音
Speak.addAnswerRecord = function(mId,materialId,mp4,callback){
    var sql = "insert into allAnswerRecord(mId,tyId,materialId,mp4) value(?,?,?,?)";
    db.exec(sql, [mId, 3, materialId, mp4],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    });
}

// 查询当前用户当前材料的录音（结果：录音ID，MP4,用户ID，材料ID）
Speak.findMp4 = function(mId,materialId,callback){
    var sql = "select allAnswerRecord.id as id,allAnswerRecord.mp4 as mp4,allAnswerRecord.mId as mId,member.nickname as nickname,allAnswerRecord.materialId as materialId,allAnswerRecord.likeClick as likeClick from allAnswerRecord join member on(allAnswerRecord.mId = member.id) where allAnswerRecord.mId = ? and allAnswerRecord.tyId = 1 and allAnswerRecord.materialId = ?";
    db.exec(sql,[mId,materialId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 删除录音(上传录音之前先删除 保证每个用户在每份材料之下只保存一份录音)
Speak.deleteMp4 = function(mId,materialId,callback){
    var sql = "delete from allAnswerRecord where mId = ? and tyId = 1 and materialId = ?";
    db.exec(sql,[mId,materialId],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}


// 查询材料总数
Speak.findSpeakMaterialNum = function(callback){
    var sql = "select count(id) as MaterialNum from speakingMaterial";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照难度查询材料
Speak.findSpeakingMaterialByDid = function(dId,callback){
    var sql = "select speakingMaterial.id as id,speakingMaterial.tId as tId,speakingMaterial.dId as dId,speakingMaterial.topicId as topicId,difficultyLevel.level as level,speakingMaterial.title as title,speakingMaterial.mp4ForA as mp4ForA,speakingMaterial.mp4ForQ as mp4ForQ,speakingMaterial.question as question,topic.topicName as topic,speakingMaterial.img as img,speakingMaterial.mp4ForO as mp4ForO,speakingMaterial.timedown as timedown,speakingMaterial.rMaterial as rMaterial,speakingMaterial.original as original from speakingMaterial join difficultyLevel on(speakingMaterial.dId = difficultyLevel.id) join topic on(speakingMaterial.topicId = topic.id) where speakingMaterial.dId = ?";
    db.exec(sql,[dId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 录音点赞
Speak.addLikeClick = function(id,anId,callback){
    var sql = "update allAnswerRecord set likeClick = concat(likeClick,?) where id =?";
    db.exec(sql,[id,anId],function(err){
        if(err){
            return callback(err);
        }
        callback(err,"success");
    })
}

// 查询题目要求录音
Speak.findMp4ForA = function(id,callback){
    var sql = "select id,title,mp4ForA,img,rMaterial from speakingMaterial where id = ?";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows)
    })
}

// 查询口语阅读材料
Speak.findRMaterial = function(id,callback){
    var sql = "select id,title,rMaterial from speakingMaterial where id = ?";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows)
    })
}

// 查询原文录音
Speak.findMp4ForO = function(id,callback){
    var sql = "select id,title,mp4ForO from speakingMaterial where id = ?";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows)
    })
}

// 查询分类下题目数量
Speak.findTopicNum = function (callback) {
    var sql = "select topic.id as topicId,count(speakingMaterial.id) as num,topic.topicName as topicName from speakingMaterial right join  topic on(speakingMaterial.topicId = topic.id) group by topic.id";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows)
    })
}