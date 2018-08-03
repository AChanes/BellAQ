var mysql = require("mysql");
var config = require("../config");


var DB = {};

var pool = mysql.createPool({
  host: config.db_host,
  port: config.db_port,
  user: config.username,
  password: config.password,
  database: config.db_name,
  connectionLimit: 100 //最大连接数  
})

//sql语句执行
DB.exec = function (sqls, values, after) {
  pool.getConnection((err, connection) => {
    if(err){
      return;
    }
    connection.connect(function (err) {
      connection.query(sqls || "", values || [], function (err, rows) {
        after(err, rows);
        //释放连接  
        connection.release();
      });
    });
  });
};

//事务连接
DB.getConnection = function (callback) {
  pool.getConnection((err, connection) => {
    connection.connect(function (err) {
      if (err) {
        console.error("error connecting: " + err.stack);
        connection.release();
        return;
      }
      callback(err, connection);
    });
  });
}

module.exports = DB;