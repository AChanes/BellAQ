var db = require("../util/db");


// 听力材料类
function Listen() {
  this.id;
  this.tId;
  this.dId;
  this.title;
  this.img;
  this.mp4;
  this.original;
  this.topicId;
  this.isMockexam;
}

module.exports = Listen;

// 教师操作
// 发布听力材料
Listen.TaddListenMaterial = function(tId,dId,title,img,mp4,original,topicId,isMockexam,callback){
  var sql = "insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId,isMockexam) value(?,?,?,?,?,?,?,?)";
  db.exec(sql, [tId, dId,title, img, mp4, original, topicId,isMockexam],function(err){
    if(err){
      return callback(err);
    }else{
      var sql = "select listeningMaterial.id as id,listeningMaterial.tId as tId,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,listeningMaterial.mp4 as mp4,listeningMaterial.original as original,listeningMaterial.isMockexam as isMockexam,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) where listeningMaterial.tId = ? order by id desc limit 1";
      db.exec(sql,[tId,dId],(err,rows)=>{
        if(err){
          return callback(err);
        }
        callback(err,rows);
      })
    }
  })
}

// 删除听力材料（先删除材料相关题目）
Listen.TdeleteListenMaterialById = function(id,callback){
  var sql = "delete from listeningMaterial where id = ? and isMockexam = '0'";
  db.exec(sql,[id],function(err){
    if(err){
      return callback(err);
    }
    callback(err,'success');
  })
}

// 删除某位老师的所有听力材料
Listen.TdeleteListenMaterialByTid = function(tId,callback){
  var sql = "delete from listeningMaterial where tId = ? and isMockexam = '0'";
  db.exec(sql,[tId],function(err){
    if(err){
      return callback(err);
    }
    callback(err, 'success');
  })
}

// 修改听力材料
Listen.TupdateListenMaterial = function(id,dId,title,img,mp4,original,topicId,callback){
  var sql = "update listeningMaterial set dId = ? , img = ? , title = ? , mp4 = ? , original = ? , topicId = ? where id = ?";
  db.exec(sql,[dId,img,title,mp4,original,topicId,id],function(err){
    if(err){
      return callback(err);
    }
    callback(err, 'success');
  })
}

// 查询单个听力材料
Listen.TfindListenMaterialById = function(id,callback){
  var sql = "select listeningMaterial.id as id,listeningMaterial.tId as tId,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,listeningMaterial.mp4 as mp4,listeningMaterial.original as original,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) where listeningMaterial.id = ?";
  db.exec(sql,[id],function(err,rows){
    if(err){
      return callback(err);
    }
    callback(err,rows);
  })
}

//查询该老师发布的所有听力材料
Listen.TfindListenMaterialByTid = function(tId,callback){
  var sql = "select listeningMaterial.id as id,listeningMaterial.tId as tId,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,listeningMaterial.mp4 as mp4,listeningMaterial.original as original,listeningMaterial.isMockexam as isMockexam,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) where listeningMaterial.tId = ?";
  db.exec(sql,[tId],function(err,rows){
    if(err){
      return callback(err);
    }
    callback(err,rows);
  })
}


// 前台操作
// 查询所有听力材料(结果：id，情景类型，难度等级)
Listen.findAllListenMaterial = function(callback){
  var sql = "select listeningMaterial.id as id,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) order by listeningMaterial.id desc";
  db.exec(sql,"",function(err,rows){
    if(err){
      return callback(err);
    }
    callback(err,rows);
  })
}

// 按照条数查询听力材料
Listen.findListenMaterial = function (startIndex, num, callback) {
  var sql = "select listeningMaterial.id as id,listeningMaterial.tId as tId,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,listeningMaterial.mp4 as mp4,listeningMaterial.original as original,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) limit ?,?";
  db.exec(sql, [startIndex, num], function (err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
}


// 按照条数查询听力材料
// Listen.findListenMaterial = function(startIndex,num,mId,callback){
//     var sql = "select t3.*,t4.myrighth as myrighth,t5.mytotal as mytotal from (select t1.righth as righth,t2.total as total, listeningMaterial.id as id,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title, topic.topicName as topic from listeningMaterial left join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) left join topic on(listeningMaterial.topicId = topic.id) left join (select materialId,count(materialId) as righth from allAnswerRecord where tyId =2 and isRight = '1' group by materialId) as t1 on(listeningMaterial.id = t1.materialId) left join (select materialId,count(materialId) as total from allAnswerRecord where tyId =2 group by materialId) as t2 on(listeningMaterial.id = t2.materialId) order by listeningMaterial.id asc limit ?,?) as t3 left join (select materialId,count(materialId) as myrighth from allAnswerRecord where tyId =2 and mId = ? and isRight = '1' group by materialId) as t4 on(t3.id = t4.materialId) left join (select materialId,count(materialId) as mytotal from allAnswerRecord where tyId =2 and mId =? group by materialId) as t5 on(t4.materialId = t5.materialId)";
//     db.exec(sql, [startIndex,num,mId,mId], function(err, rows) {
//       if (err) {
//         return callback(err);
//       }
//       callback(err, rows);
//     });
// }

// 查询听力材料MP4
Listen.findAllListenMaterialMp4 = function(id,callback){
  var sql = "select id,title,mp4 from listeningMaterial where id = ?";
  db.exec(sql,[id],function(err,rows){
    if(err){
      return callback(err);
    }
    callback(err,rows);
  })
}


// 查询材料总数
Listen.findListenMaterialNum = function(callback){
    var sql = "select count(*) as MaterialNum from listeningMaterial";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照难度查询某位老师的听力材料
Listen.findListenMaterialByDid = function(tId,dId,callback){
  var sql = "select listeningMaterial.id as id,listeningMaterial.tId as tId,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,listeningMaterial.mp4 as mp4,listeningMaterial.original as original,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) where listeningMaterial.tId = ? and listeningMaterial.dId = ?";
  db.exec(sql,[tId,dId],function(err,rows){
    if(err){
      return callback(err);
    }
    callback(err,rows);
  })
}

// 按照难度查询听力材料
Listen.findListeningMaterialByDid = function(dId,callback){
  var sql = "select listeningMaterial.id as id,listeningMaterial.tId as tId,listeningMaterial.dId as dId,listeningMaterial.topicId as topicId,difficultyLevel.level as level,listeningMaterial.title as title,listeningMaterial.img as img,listeningMaterial.mp4 as mp4,listeningMaterial.original as original,topic.topicName as topic from listeningMaterial join difficultyLevel on(listeningMaterial.dId = difficultyLevel.id) join topic on(listeningMaterial.topicId = topic.id) where listeningMaterial.dId = ?";
  db.exec(sql,[dId],function(err,rows){
    if(err){
      return callback(err);
    }
    callback(err,rows);
  })
}

// 查询分类下题目数量
Listen.findTopicNum = function(callback){
  var sql = "select topic.id as topicId,count(listeningMaterial.id) as num,topic.topicName as topicName from listeningMaterial right join  topic on(listeningMaterial.topicId = topic.id) group by topic.id";
  db.exec(sql,"",(err,rows)=>{
    if(err){
      return callback(err);
    }
    callback(err,rows)
  })
}

// 查询材料的title
Listen.findTitle = function(id,callback){

 var sql = "select id,title from listeningMaterial where id = ?";
  db.exec(sql,[id],(err,rows)=>{
    if(err){
      return callback(err);
    }
    callback(err,rows)
  })
}

// 听力预览(合并问题未解决)
Listen.preview = function(id,numForLM,callback){
  var sql = "(select t1.id as id,t1.title as title,t1.mp4 as mp4,t1.original as original,t2.numForLM as numForLM,t2.mp4 as mp4Q,t2.question as question,t2.mp4ForQ as mp4ForQ,t2.options as options,t2.rightAnswer as rightAnswer from listeningMaterial as t1 join listeningQuestion as t2 on (t1.id = t2.LMId) where t1.id = ? and t2.numForLM = ?) union all (select count(id) as num from listeningQuestion where LMId = ?)";
  db.exec(sql,[id,numForLM,id],(err,rows)=>{
    if(err){
      return callback(err);
    }
    callback(err,rows)
  })
}