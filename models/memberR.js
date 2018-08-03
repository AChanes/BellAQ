var db = require("../util/db");

// 会员推荐
function MemberR() {
    this.id;
    this.img;
    this.aId;
    this.title;
    this.digest;
    this.pullTime;
    this.pageView;
    this.content;
    this.tyId;
}

module.exports = MemberR;

// 添加会员推荐
MemberR.addMemberR = function(img,aId,title,digest,pullTime,content,tyId,callback){
    var sql = "insert into memberRecommend(img,aId,title,digest,pullTime,content,tyId) value(?,?,?,?,?,?,?)";
    db.exec(sql,[img,aId,title,digest,pullTime,content,tyId],function(err){
        if(err){
            return callback(err);
        }
        callback(err,"success");
    })
}

// 添加点击量
MemberR.addPageView = function(id,callback){
    var sql = "update memberRecommend set pageView = pageView + 1 where id = ?";
    db.exec(sql,[id],function(err){
        if(err){
            return callback(err);
        }
        callback(err,'success');
    })
}

// 删除会员推荐
MemberR.deleteMemberR = function(id,callback){
    var sql = "delete from memberRecommend where id = ?";
    db.exec(sql, [id], function(err) {
      if (err) {
        return callback(err);
      }
      callback(err,"success");
    });
}

// 删除某位管理员的所有会员推荐
MemberR.deleteMemberRByAid = function(aId,callback){
    var sql = "delete from memberRecommend where aId = ?";
    db.exec(sql,[aId],function(err){
        if(err){
            return callback(err);
        }
        callback(err,'success');
    })
}

// 查询所有会员推荐
MemberR.findAllMemberR = function(callback){
    var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) order by memberRecommend.pageView desc";
    db.exec(sql,"",function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照条数查询会员推荐
MemberR.findMemberRTop = function(num,callback){
    var sql = "select memberRecommend.id as id,memberRecommend.img as img, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) order by memberRecommend.pageView desc limit ?";
    db.exec(sql,[num],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询某位管理员的所有会员推荐
MemberR.findAllMemberRByAid = function(aId,callback){
    var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.aId as aId, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,memberRecommend.content as content,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) where memberRecommend.aId = ?";
    db.exec(sql,[aId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 展示会员推荐详情
MemberR.findMemberR = function(id,callback){
    var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.aId as aId, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,memberRecommend.content as content,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) where memberRecommend.id = ?";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 修改会员推荐
MemberR.updateMemberR = function(id,img,title,digest,content,tyId,callback){
    var sql = "update memberRecommend set img =? , title = ? , digest = ? , content = ? , tyId = ? where id = ?";
    db.exec(sql,[img,title,digest,content,tyId,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err,'success');
    })
}

// 按照推荐分类查询会员推荐
MemberR.findMemberRByTyId = function(tyId,callback){
    if (tyId == "0") {
        var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.aId as aId, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,memberRecommend.content as content,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) order by memberRecommend.pageView desc";
        db.exec(sql,'', function (err, rows) {
            if (err) {
                return callback(err);
            }
            callback(err, rows);
        })
    } else {
        var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.aId as aId, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,memberRecommend.content as content,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id)where memberRecommend.tyId=? order by memberRecommend.pageView desc";
        db.exec(sql, [tyId], function (err, rows) {
            if (err) {
                return callback(err);
            }
            callback(err, rows);
        });
    }
}

// 修改点击量
MemberR.updatePageView = function(id,pageView,callback){
    var sql = "update memberRecommend set pageView = ? where id = ?";
    db.exec(sql,[pageview,id],function(err){
        if(err){
            return callback(err);
        }
        callback(err,'success');
    })
}

// 按照条数查询会员推荐
MemberR.findMemberRByNum = function(tyId,startIndex,num,callback){
    if(tyId == "0"){
        var sql = "select memberRecommend.id as id,memberRecommend.img as img, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) order by memberRecommend.pullTime desc limit ?,?";
        db.exec(sql,[startIndex,num],function(err,rows){
            if(err){
                return callback(err);
            }
            callback(err,rows);
        })
    }else{
        var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.aId as aId, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,memberRecommend.content as content,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id)where memberRecommend.tyId=? order by memberRecommend.pullTime desc limit ?,?";
        db.exec(sql, [tyId,startIndex, num], function(err, rows) {
          if (err) {
            return callback(err);
          }
          callback(err, rows);
        });
    }
    
}

// 按照分类查询总数
MemberR.findNumByTyId = function(tyId,callback){
    if(tyId != "0"){
        var sql = "select count(id) as num from memberRecommend where tyId = ?";
        db.exec(sql,[tyId],function(err,rows){
            if(err){
                return callback(err);
            }
            callback(err,rows);
        })
    }else{
        var sql = "select count(id) as num from memberRecommend";
        db.exec(sql, "", function(err, rows) {
          if (err) {
            return callback(err);
          }
          callback(err, rows);
        });
    }   
}

// 查询下一个会员推荐
MemberR.findNext = function(id,callback){
    var sql = "select id,title from memberRecommend where id > ? order by id limit 0,1";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 查询上一个会员推荐
MemberR.findLast = function(id,callback){
    var sql = "select id,title from memberRecommend where id < ? order by id desc limit 0,1";
    db.exec(sql,[id],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 按照分类查询老师的会员推荐
MemberR.findMemberRByTyidAndAid = function (aId, tyId,callback){
    var sql = "select memberRecommend.id as id,memberRecommend.img as img,memberRecommend.aId as aId, memberRecommend.title as title,memberRecommend.digest as digest,memberRecommend.pullTime as pullTime,memberRecommend.pageView as pageView,memberRecommend.content as content,types.typeName as typeName,memberRecommend.tyId as tyId from memberRecommend join types on(memberRecommend.tyId = types.id) where memberRecommend.aId = ? and memberRecommend.tyId = ?";
    db.exec(sql,[aId,tyId],function(err,rows){
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}
