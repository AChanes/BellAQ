var db = require("../util/db");

// 情景分类
function Topic() {
  this.id;
  this.topicName;
}
module.exports = Topic;

// 查询所有情景分类
Topic.findAllTopic = (callback) => {
    var sql = "select id,topicName from topic";
    db.exec(sql, "", (err, rows) => {
        if(err){
            return callback(err);
        }
        callback(err,rows);
    })
}

// 添加情景分类
Topic.addTopic = (topicName, callback) => {
    var sql = "insert into topic(topicName) value(?)";
    db.exec(sql, [topicName], (err, sta) => {
        if(err){
            return callback(err);
        }
        callback(err,sta);
    })
}