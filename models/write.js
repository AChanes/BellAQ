var db = require("../util/db");

// 写作类
function Write(){
    this.id;
    this.tId;
    this.dId;
    this.title;
    this.timedown;
    this.original;
    this.material;
    this.img;
    this.mp4;
    this.question;
    this.topicId;
    this.includeMaterial
    this.score;
    this.isMockexam;
}

module.exports = Write;

// 教师操作
// 添加写作材料
Write.TaddWriteMaterial = function(tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score,isMockexam,callback){
    var sql = "insert into writingMaterial(tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score,isMockexam) value(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    db.exec(sql,[tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score,isMockexam],function(err){
        if(err){
            return callback(err);
        }else{
            sql = "select writingMaterial.id as id,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,writingMaterial.isMockexam as isMockexam,topic.topicName as topic,writingMaterial.includeMaterial as includeMaterial,writingMaterial.score as score,writingMaterial.timedown as timedown,writingMaterial.original as original,writingMaterial.material as material,writingMaterial.img as img,writingMaterial.mp4 as mp4 from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) where writingMaterial.tId = ? order by id desc limit 1";
            db.exec(sql,[tId],(err,rows)=>{
                if(err){
                    return callback(err);
                }
                callback(err,rows);
            })
        }
        
    });
};

// 删除单个写作材料
Write.TdeleteWriteMaterialById = function(id,callback){
    var sql = "delete from writingMaterial where id = ? and isMockexam = '0'";
    db.exec(sql,[id],function(err){
        if(err){
            return callback(err);
        }
        callback(err,"success");
    });
};

// 删除某位老师所有的写作材料
Write.TdeleteWriteMaterialByTid = function(tId, callback) {
  var sql = "delete from writingMaterial where tId = ? and isMockexam = '0'";
  db.exec(sql, [tId], function(err) {
    if (err) {
      return callback(err);
    }
    callback(err, "success");
  });
};

// 修改写作材料
Write.TupdateWriteMaterial = function(id,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score,callback){
    var sql = "update writingMaterial set dId = ? , title = ? , timedown = ? , original = ? , material = ? , img = ? , mp4 = ? , question = ? , topicId = ? , includeMaterial = ? , score = ? where id = ?";
    db.exec(sql,[dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查询某一个写作材料
Write.TfindWriteMaterialById = function(id, callback) {
  var sql = "select writingMaterial.id as id,writingMaterial.tId as tId,writingMaterial.dId as dId,writingMaterial.topicId as topicId,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,topic.topicName as topic,writingMaterial.score as score,writingMaterial.timedown as timedown,writingMaterial.original as original,writingMaterial.material as material,writingMaterial.img as img,writingMaterial.mp4 as mp4 from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) where writingMaterial.id = ?";
  db.exec(sql, [id], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};

// 查询某位老师所有的写作材料
Write.TfindWriteMaterialByTid = function(tId, callback) {
  var sql = "select writingMaterial.id as id,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,writingMaterial.isMockexam as isMockexam,topic.topicName as topic,writingMaterial.includeMaterial as includeMaterial,writingMaterial.score as score,writingMaterial.timedown as timedown,writingMaterial.original as original,writingMaterial.material as material,writingMaterial.img as img,writingMaterial.mp4 as mp4 from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) where writingMaterial.tId = ?";
  db.exec(sql, [tId], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};

// 老师打分
Write.addScore = function(id,score,callback){
    var sql = "update allAnswerRecord set score = ? where id = ?";
    db.exec(sql,[score,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 展示所有未打分的写作
Write.findAllWriteNoScore = function(callback){
    var sql = "select allAnswerRecord.id as id,allAnswerRecord.materialTitle as materialTitle,allAnswerRecord.mId as mId,member.nickname as nickname from allAnswerRecord join member on(allAnswerRecord.mId = member.id) where allAnswerRecord.score = 0 and allAnswerRecord.tyId = '4'";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查找作文详情
Write.findWriteDetail = function(id,callback){
    var sql = "select t1.id as id,t1.wContent as wContent,t1.endTime as endTime,t1.level as level,t1.materialTitle as materialTitle,t2.score from allAnswerRecord as t1 join writingMaterial as t2 on(t1.materialId = t2.id)  where t1.id = ?";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 前台操作（查询单个写作材料，前后台公用）
// 提交写作答案
Write.addAnswerRecord = function(mId,materialId,wContent,callback){
    var sql = "insert into allAnswerRecord(mId,tyId,materialId,wContent) value(?,?,?,?)";
    db.exec(sql,[mId,4,materialId,wContent],function(err){
        if(err){
            return callback(err);
        }
        callback(err,'success');
    })
}


//前台所需
//查询所有的写作题
Write.findWrite=function(callback){
    var sql = "select writingMaterial.id as id,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,topic.topicName as topic,writingMaterial.score as score,writingMaterial.original as original,writingMaterial.material as material,writingMaterial.img as img,writingMaterial.mp4 as mp4 from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) order by writingMaterial.id desc";
    db.exec(sql,[],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err, rows);
    })

}
//题id查材料 第一页
Write.findWriteR1 = function(id, callback) {
  var sql ="select id,original,mp4,material,question,topic from  writingMaterial where id=?";
  db.exec(sql, [id], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};
//题id查材料 第二页
Write.findWriteR2=function(id,callback){
    var sql ='select id,material,title from writingMaterial where id=?';
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })

}
//题id 查材料 第三页
Write.findWriteR3 = function (id, callback) {
    var sql = 'select id,img,mp4 from writingMaterial where id=?';
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })

}
//题id 查材料 第四页
Write.findWriteR4 = function (id, callback) {
    var sql = 'select id,question, material from writingMaterial where id=?';
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })

}

// 按照条数查询口语材料
Write.findWriteMaterial = function(startIndex,num,callback){
    var sql = "select writingMaterial.id as id,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,topic.topicName as topic,writingMaterial.score as score,writingMaterial.material as material,writingMaterial.img as img from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) order by writingMaterial.id asc limit ?,?";
    db.exec(sql,[startIndex,num],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询材料总数
Write.findWriteMaterialNum = function(callback){
    var sql = "select count(*) as MaterialNum from writingMaterial";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询写作结果
Write.findAnswerRecord = function(mId,materialId,callback){
    var sql = "select allAnswerRecord.id as id,allAnswerRecord.materialId as materialId,allAnswerRecord.wContent as wContent,writingMaterial.material as material,writingMaterial.title as title from allAnswerRecord join writingMaterial on(allAnswerRecord.materialId = writingMaterial.id) where allAnswerRecord.mId = ? and allAnswerRecord.tyId = 4 and allAnswerRecord.materialId = ? order by allAnswerRecord.id desc limit 1";
    db.exec(sql,[mId,materialId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照难度查询某位老师的材料
Write.findWriteMaterialByDid = function(tId,dId,callback){
    var sql = "select writingMaterial.id as id,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,topic.topicName as topic,writingMaterial.includeMaterial as includeMaterial,writingMaterial.score as score,writingMaterial.timedown as timedown,writingMaterial.original as original,writingMaterial.material as material,writingMaterial.img as img,writingMaterial.mp4 as mp4 from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) where writingMaterial.tId = ? and writingMaterial.dId = ?";
    db.exec(sql,[tId,dId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照难度查询材料
Write.findWritingMaterialByDid = function(dId,callback){
    var sql = "select writingMaterial.id as id,difficultyLevel.level as level,writingMaterial.title as title,writingMaterial.question as question,topic.topicName as topic,writingMaterial.includeMaterial as includeMaterial,writingMaterial.score as score,writingMaterial.timedown as timedown,writingMaterial.original as original,writingMaterial.material as material,writingMaterial.img as img,writingMaterial.mp4 as mp4 from writingMaterial join difficultyLevel on(writingMaterial.dId = difficultyLevel.id) join topic on(writingMaterial.topicId = topic.id) where writingMaterial.dId = ?";
    db.exec(sql,[dId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询分类下题目数量
Write.findTopicNum = function (callback) {
    var sql = "select topic.id as topicId,count(writingMaterial.id) as num,topic.topicName as topicName from writingMaterial right join  topic on(writingMaterial.topicId = topic.id) group by topic.id";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows)
    })
}