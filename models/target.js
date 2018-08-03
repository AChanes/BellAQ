var db = require("../util/db");
function Target() {
  this.id;
  this.mId;
  this.dId;
  this.starts;
  this.complete;
  this.score;
  this.targetStatus;
}
module.exports=Target;
//用户添加学习计划
Target.addTarget=function (mId,dId,starts,complete,score,callback){
    var sql ='insert into target(mId,dId,starts,complete,score) values(?,?,?,?,?)';
    db.exec(sql,[mId, dId, starts, complete, score],function(err){
        if(err){
            return callback(err);
        }
        callback(err, "success");
    })
}

//更改计划状态
Target.updateTargetStatus = function (mId,targetStatus,callback){
    var sql ='update  target set  targetStatus=? where mId=? and stargetStatus = 2';
    db.exec(sql,[targetStatus,mId],function(err){
        if(err){
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查询学习计划
Target.findTarget = function(mId , callback){
    var sql = `select 
                    target.id as id,difficultyLevel.level as level,target.starts as starts,
                    target.targetStatus as targetStatus,
                    target.complete as complete,target.score as score 
                from 
                    target join difficultyLevel on(target.dId = difficultyLevel.id) 
                where 
                    target.mId = ? and target.targetStatus != '0' order by id desc limit 1
                `;
    db.exec(sql,[mId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

