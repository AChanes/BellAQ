var db = require("../util/db");

// 阅读材料类
function Read(){
    this.id;
    this.tId;
    this.dId;
    this.englishTitle;
    this.chineseTitle;
    this.englishMaterial;
    this.chineseMaterial;
    this.topicId;
    this.isMockexam;
}

module.exports = Read;

// 教师操作
// 添加阅读材料
Read.TaddReadMaterial = function(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId,isMockexam,callback){
    var sql = "insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId,isMockexam) value(?,?,?,?,?,?,?,?)";
    db.exec(sql, [tId, dId, englishTitle, chineseTitle, englishMaterial, chineseMaterial, topicId, isMockexam], function (err) {
        if(err){
            return callback(err);
        }else{
            sql = "select readingMaterial.id as id,readingMaterial.tId as tId,readingMaterial.dId as dId,readingMaterial.topicId as topicId,readingMaterial.isMockexam as isMockexam,difficultyLevel.level as level,readingMaterial.englishTitle as englishTitle,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) where readingMaterial.tId = ? order by id desc limit 1";
            db.exec(sql,[tId],(err,rows)=>{
                if(err){
                    return callback(err);
                }
                callback(err,rows);
            })
        }
    });
}

// 删除材料
Read.TdeleteReadMaterialById = function(id,callback){
    var sql = "delete from readingMaterial where id = ? and isMockexam = '0'";
    db.exec(sql,[id],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 删除某位老师的所有材料
Read.TdeleteReadMaterialByTid = function(tId,callback){
    var sql = "delete from readingMaterial where tId = ? and isMockexam = '0'";
    db.exec(sql,[tId],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查询单个阅读材料
Read.TfindReadMaterialById = function(id,callback){
    var sql = "select readingMaterial.id as id,readingMaterial.tId as tId,readingMaterial.dId as dId,readingMaterial.topicId as topicId,difficultyLevel.level as level,readingMaterial.englishTitle as englishTitle,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) where readingMaterial.id = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询某个老师所有的材料
Read.TfindReadMaterialByTid = function(tId, callback) {
  var sql = "select readingMaterial.id as id,readingMaterial.tId as tId,readingMaterial.dId as dId,readingMaterial.topicId as topicId,readingMaterial.isMockexam as isMockexam,difficultyLevel.level as level,readingMaterial.englishTitle as englishTitle,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) where readingMaterial.tId = ?";
  db.exec(sql, [tId], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};

// 修改高亮
Read.change = function(id,englishMaterial,callback){
    var sql = "update readingMaterial set englishMaterial = ? where id = ?";
    db.exec(sql,[englishMaterial,id],(err)=>{
        if(err){
            return callback(err);
        }
        callback(err,'success');
    })
}

// 修改阅读材料
Read.TupdateReadMaterial = function (id, dId, englishTitle, chineseTitle, englishMaterial, chineseMaterial, topicId, callback) {
    var sql = "update readingMaterial set dId = ? , englishTitle = ? , chineseTitle = ? , englishMaterial = ? , chineseMaterial = ? , topicId = ? where id = ?";
    db.exec(sql, [dId, englishTitle, chineseTitle, englishMaterial, chineseMaterial, topicId, id], function (err) {
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    });
}

// 前台操作
// 查询所有阅读材料(结果：id，情景类型，难度等级)
Read.findAllReadMaterial = function(callback){
    var sql = "select readingMaterial.id as id,readingMaterial.dId as dId,readingMaterial.topicId as topicId,difficultyLevel.level as level,readingMaterial.englishTitle as title, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) order by readingMaterial.id desc";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照条数查询阅读材料
Read.findReadMaterial = function (startIndex, num, callback) {
    var sql = "select readingMaterial.id as id,readingMaterial.tId as tId,readingMaterial.dId as dId,readingMaterial.topicId as topicId,difficultyLevel.level as level,readingMaterial.englishTitle as title,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) limit ?,?";
    db.exec(sql, [startIndex, num], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    });
};


// 按照条数查询阅读材料
// Read.findReadMaterial = function(startIndex, num,mId, callback) {
//   var sql = "select t3.*,t4.myrighth as myrighth,t5.mytotal as mytotal from (select t1.righth as righth,t2.total as total, readingMaterial.id as id,readingMaterial.dId as dId,readingMaterial.topicId as topicId,difficultyLevel.level as level,readingMaterial.englishTitle as title,readingMaterial.chineseTitle as chineseTitle, topic.topicName as topic from readingMaterial left join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) left join topic on(readingMaterial.topicId = topic.id) join (select materialId,count(materialId) as righth from allAnswerRecord where tyId =2 and isRight = '1' group by materialId) as t1 on(readingMaterial.id = t1.materialId) join (select materialId,count(materialId) as total from allAnswerRecord where tyId =2 group by materialId) as t2 on(readingMaterial.id = t2.materialId) order by readingMaterial.id asc limit ?,?) as t3 left join (select materialId,count(materialId) as myrighth from allAnswerRecord where tyId =2 and mId = ? and isRight = '1' group by materialId) as t4 on(t3.id = t4.materialId) left join (select materialId,count(materialId) as mytotal from allAnswerRecord where tyId =2 and mId =? group by materialId) as t5 on(t4.materialId = t5.materialId)";
//   db.exec(sql, [startIndex, num,mId,mId], function(err, rows) {
//     if (err) {
//       return callback(err);
//     }
//     callback(err, rows);
//   });
// };

// 查询材料总数
Read.findReadMaterialNum = function(callback){
    var sql = "select count(id) as MaterialNum from readingMaterial";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照难度查询某位老师的材料
Read.findReadMaterialByDid = function(tId, dId, callback) {
  var sql =
    "select readingMaterial.id as id,readingMaterial.tId as tId,readingMaterial.dId as dId,readingMaterial.topicId as topicId,difficultyLevel.level as level,readingMaterial.englishTitle as englishTitle,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) where readingMaterial.tId = ? and readingMaterial.dId = ?";
  db.exec(sql, [tId, dId], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};

// 按照难度查询材料
Read.findReadingMaterialByDid = function(dId, callback) {
  var sql =
    "select readingMaterial.id as id,readingMaterial.tId as tId,readingMaterial.dId as dId,readingMaterial.topicId as topicId,difficultyLevel.level as level,readingMaterial.englishTitle as englishTitle,readingMaterial.chineseTitle as chineseTitle,readingMaterial.englishMaterial as englishMaterial,readingMaterial.chineseMaterial as chineseMaterial, topic.topicName as topic from readingMaterial join difficultyLevel on(readingMaterial.dId = difficultyLevel.id) join topic on(readingMaterial.topicId = topic.id) where readingMaterial.dId = ?";
  db.exec(sql, [dId], function(err, rows) {
    if (err) {
      return callback(err);
    }
    callback(err, rows);
  });
};


// 查询分类下题目数量
Read.findTopicNum = function (callback) {
    var sql = "select topic.id as topicId,count(readingMaterial.id) as num,topic.topicName as topicName from readingMaterial a join  topic on(readingMaterial.topicId = topic.id) group by topic.id";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows)
    })
}

/** 推荐任务 最新的任务 **/

Read.findNewTask = function (callback) {
    var sql = "(select id,title,1 as tyid from speakingMaterial order by id desc limit 2) union all (select id,englishTitle as title , 2 as tyid from readingMaterial order by id desc limit 2) union all (select id,title , 3 as tyid from listeningMaterial order by id desc limit 2) union all (select id,title, 4 as tyid  from writingMaterial order by id desc limit 2)";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows) // 1 2 3 4
    })
}