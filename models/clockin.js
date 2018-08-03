var db = require("../util/db");

function ClockIn() {
  this.id;
  this.mId;
  this.record;
}




//用户添加打卡
ClockIn.addRecord = function (mId, record, callback) {
  console.log(mId, record)
  var sql = "update clockIn set record = ? where mId = ?";
  db.exec(sql, [record, mId], (err) => {
    if (err) {
      return callback(err);
    }
    callback(err, "success");

  })
}




ClockIn.findRecord = function (mId, callback) {
  var sql = "select record from clockIn where mId = ?";

  db.exec(sql, [mId], (err, rows) => {
    if (err) {
      return callback(err);
    }
    callback(err, rows);

  });
}
module.exports = ClockIn;
