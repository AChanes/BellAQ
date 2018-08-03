var db = require("../util/db");

// 管理员类
function Administrator() {
    this.id;
    this.nickname;
    this.account;
    this.phoneNum;
    this.password;
    this.age;
    this.role;
    this.sex;
}

module.exports = Administrator;


// 管理员登陆
Administrator.login = (account, password, callback) => {
    var sql = "select id,nickname,account,password,role,isUsed from administrator where account = ? and password = ?";
    db.exec(sql, [account, password], (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 添加后台管理员
Administrator.reg = (nickname, account, phoneNum, password, role, callback) => {
    var sql = "select id,isUsed from administrator where account = ?";
    db.exec(sql, [account], (err, rows) => {
        if (err) {
            return callback(err);
        }
        if (rows[0] && rows[0].isUsed == '1') {
            callback(err, "defeat");
        } else if (rows[0] && rows[0].isUsed == '0') {
            var sql = "update administrator set nickname = ?,phoneNum = ?,password = ?,role=?,isUsed='1' where account = ?";
            db.exec(sql, [nickname, phoneNum, password, role, account], (err) => {
                if (err) {
                    return callback(err);
                }
                callback(err, "success");
            })
        } else {
            var sql = "insert into administrator(nickname,account,phoneNum,password,role) value(?,?,?,?,?)";
            db.exec(sql, [nickname, account, phoneNum, password, role], (err) => {
                if (err) {
                    return callback(err);
                }
                callback(err, "success");
            });
        }
    });
};

// 修改职位
Administrator.updateRole = (account, role, callback) => {
    var sql = "update administrator set role = ? where account = ?";
    db.exec(sql, [role, account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 修改个人信息
Administrator.updataAdministrator = (account,nickname, phoneNum, password, age, sex, callback) => {
    var sql = "update administrator set nickname = ? , phoneNum = ? , password = ? , age = ? , sex = ? where account = ?";
    db.exec(sql, [nickname, phoneNum, password, age, sex, account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err,'success');
    })
}

// 删除管理员
Administrator.deleteAdministrator = (account, callback) => {
    var sql = "update administrator set isUsed = '0' where account = ?";
    db.exec(sql, [account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}
// 查询所有教师
Administrator.findAllTeacher = (callback) => {
    var sql = "select id,nickname,account,role from administrator where role = 'teacher' and isUsed ='1'";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    });
}

// 查询所有会员管理员
Administrator.findAllAdministratorAd = (callback) => {
    var sql = "select id,nickname,account,role from administrator where role ='admin' and isUsed ='1'";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    });
}
// 查询所有管理员
Administrator.findAllAdministrator = (callback) => {
    var sql = "select id,nickname,account,role from administrator where isUsed ='1' ";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 按照账号查询管理员
Administrator.findAdministratorById = (id, callback) => {
    var sql = "select id,nickname,password,sex,age,phoneNum,account,role from administrator where id = ? and isUsed ='1'";
    db.exec(sql, [id], (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 修改管理员密码
Administrator.updatePassword = (account, password, callback) => {
    var sql = "update administrator set password = ? where account = ?";
    db.exec(sql, [password, account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 删除会员
Administrator.deleteMember = (account, callback) => {
    var sql = "update member set isUsed='0' where account = ?";
    db.exec(sql, [account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 会员找回账号
Administrator.findBackMember = function(account,password,callback){
    var sql = "update member set password = ?,isUsed = '1' where account = ?";
    db.exec(sql,[password,account],(err)=>{
        if(err){
            return callback(err);
        }
        callback(err,"success");
    })
}

// 查询所有会员
Administrator.findAllMember = (callback) => {
    var sql = "select img,nickname,account,phoneNum,pay,paytime from member where isUsed = '1'";
    db.exec(sql, "", (err, rows) => {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 修改会员付费到期时间
Administrator.updatePay = (account, paytime, callback) => {
    var sql = "update member set paytime = ?,pay = '1' where account = ?";
    db.exec(sql, [paytime, account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err, "success");
    })
}

// 修改会员密码
Administrator.updateMemberPsw = (account, password, callback) => {
    var sql = "update member set password = ? where account = ?";
    db.exec(sql, [password, account], (err) => {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 查找手机号码
Administrator.findPhoneNum = function(account,callback){
    var sql = "select id,phoneNum from member where account = ?";
    db.exec(sql,[account],(err,rows)=>{
        if(err){
            return callback(err);
        }
        if(rows[0] && rows[0].id){
            var phoneNum = rows[0].phoneNum;
            var sql = "select id,time from checkCode where phoneNum = ? and endTime = current_date() ";
            db.exec(sql, [phoneNum], (err, rows) => {
                if (err) {
                    return callback(err);
                } else if (rows[0] && rows[0].id) {
                    if (rows[0].time < 5) {
                        sql = "update checkCode set time = time + 1 where id = ?";
                        db.exec(sql, [rows[0].id], (err) => {
                            if (err) {
                                return callback(err);
                            } else {
                                callback(err,phoneNum);
                            }

                        })
                    } else {
                        callback(err, "0");
                    }
                } else if (rows.length == 0) {
                    sql = "insert into checkCode(phoneNum,endTime) value(?,current_date());"
                    db.exec(sql, [phoneNum], (err) => {
                        if (err) {
                            return callback(err);
                        }
                        callback(err, phoneNum);
                    })
                } else {
                    callback(err, "0");
                }
            })
        }else{
            callback(err,'0');
        }
    })
    
}