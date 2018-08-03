var db = require("../util/db");
var sendSMS = require("../util/sendSMS");
// 会员类
function Member() {
    this.id;
    this.isPlan;
    this.img;
    this.nickname;
    this.account;
    this.password;
    this.phoneNum;
    this.age;
    this.pay;
    this.sex;
    this.sno;
    this.stage;
    this.score;
    this.questionNum;
    this.isL;
}

module.exports = Member;
// 退出登陆
Member.unLogin = function (account, callback) {
    var sql = "update member set isL = '0' where account = ?";
    db.exec(sql, [account], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 检测账号是否存在
Member.findAccount = function (account, callback) {
    var sql = "select count(id) as status from member where account = ?";
    db.exec(sql, [account], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}
// 会员登陆
Member.login = function (account, password, callback) {
    var sql = "select id,isPlan,pay,isUsed from member where account = ? and password = ?";
    db.exec(sql, [account, password], function (err, rows) {
        if (err) {
            return callback(err);
        } else if (rows[0] && rows[0].id && rows[0].isUsed == '1') {
            if (rows[0].isPlan == '1') {
                isP(rows[0].id, function (err, sta) {
                    if (err) {
                        return callback(err);
                    }
                })
            }
            if (rows[0].pay == '1') {
                isPa(rows[0].id, function (err, sta) {
                    if (err) {
                        return callback(err);
                    }
                })
            }
            var sql = "update member set ltime = current_date() where id=?";
            db.exec(sql, [rows[0].id], function (err) {
                if (err) {
                    return callback(err);
                } else {
                    var sql = "select id,isPlan,img,nickname,account,pay,score,questionNum from member where account = ? and password = ?";
                    db.exec(sql, [account, password], function (err, rows) {
                        if (err) {
                            return callback(err);
                        } else {
                            callback(err, rows);
                        }
                    })
                }
            })
        } else {
            callback(err, 'defeat');
        }
    })
}

// 会员注册
Member.reg = function ( nickname, account, password, phoneNum, callback) {
    var sql = "select id,isUsed from member where account = ?";
    db.exec(sql, [account], (err, rows) => {
        if (err) {
            return callback(err);
        }
        if (rows[0]) {
            callback(err, 'defeat')
        } else {
            var sql = "insert into member(nickname,account,password,phoneNum) value(?,?,?,?)";
            db.exec(sql, [ nickname, account, password, phoneNum], function (err) {
                if (err) {
                    return callback(err);
                }
                callback(err, "success");
            });
        }
    })

};

// 修改信息
Member.updateMasg = function (id, img, nickname, password, phoneNum, age, sex, sno, stage, callback) {
    var sql = "update member set img = ? , nickname = ? , password = ? , phoneNum = ? , age = ? , sex = ? , sno = ? , stage = ? where id = ?";
    db.exec(sql, [img, nickname, password, phoneNum, age, sex, sno, stage, id], function (err) {
        if (err) {
            return callback(err);
        } else {
            var sql = "select id,img,nickname,password,phoneNum,age,sex,sno,stage from member where id = ?";
            db.exec(sql, [id], (err, rows) => {
                if (err) {
                    return callback(err);
                }
                callback(err, rows);
            })
        }
    });
}

// 修改密码
Member.updatePassword = function (account, password, callback) {
    var sql = "update member set password = ? where account = ?";
    db.exec(sql, [password, account], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 添加成绩
Member.updateScore = function (id, score, callback) {
    var sql = "update member set score = score + ? where id =?";
    db.exec(sql, [score, id], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 添加答题数量
Member.updateQuestionNum = function (id, callback) {
    var sql = "update member set questionNum = questionNum + 1 where id = ?";
    db.exec(sql, [id], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

// 排行榜展示（分数前十）
Member.findScoreTop = function (callback) {
    var sql = "select img,nickname,ltime,score,questionNum from member order by score desc limit 10";
    db.exec(sql, "", function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 查询指定用户的信息
Member.findMemberById = function (id, callback) {
    var sql = "select id,isPlan,ltime,img,nickname,account,pay,score,questionNum from member where id = ?";
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}

// 修改计划状态
Member.updateIsPlan = function (id, isPlan, callback) {
    var sql = "update member set isPlan = ? where id =?";
    db.exec(sql, [isPlan, id], function (err) {
        if (err) {
            return callback(err);
        }
        callback(err, 'success');
    })
}

Member.findMsg = function (id, callback) {
    var sql = "select * from member where id = ?";
    db.exec(sql, [id], function (err, rows) {
        if (err) {
            return callback(err);
        }
        callback(err, rows);
    })
}


function isP(id, callback) {
    var sql ="select id from target where mId = ? and complete > current_date()";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        if(!rows[0] || !rows[0].id){
            sql = "update target set targetStatus = '0' where mId = ? and targetStatus ='2'";
            db.exec(sql,[id],(err)=>{
                if(err){
                    return callback(err);
                }
            })
        }
    })
}

function isPa(id, callback) {
    var sql = "select id from member where id = ? and paytime > current_date()";
    db.exec(sql,[id],(err,rows)=>{
        if(err){
            return callback(err);
        }
        if(!rows[0] ||　!rows[0].id){
            sql = "update member set pay ='0' where id = ?";
            db.exec(sql,[id],(err)=>{
                if(err){
                    return callback(err);
                }
            })
        }
    })
}

// 短信验证
Member.findCheckCode = function (phoneNum, callback) {
    var sql = "select id,time from checkCode where phoneNum = ? and endTime = current_date() ";
    db.exec(sql, [phoneNum], (err, rows) => {
        if (err) {
            return callback(err);
        } else if (rows[0] && rows[0].id) {
            if (rows[0].time < 2) {
                sql = "update checkCode set time = time + 1 where id = ?";
                db.exec(sql, [rows[0].id], (err) => {
                    if (err) {
                        return callback(err);
                    }
                    callback(err, "1")
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
                callback(err, "1");
            })
        } else {
            callback(err, "0");
        }
    })
}

// 查找手机号码
Member.findPhoneNum = function (account, callback) {
    var sql = "select id,phoneNum from member where account = ?";
    db.exec(sql, [account], (err, rows) => {
        if (err) {
            return callback(err);
        }
        
        if (rows[0] && rows[0].id) {
            var phoneNum = rows[0].phoneNum;
            var sql = "select id,time from checkCode where phoneNum = ? and endTime = current_date() ";
            db.exec(sql, [phoneNum], (err, rowss) => {
                if (err) {
                    return callback(err);
                } 
                if (rowss[0] && rowss[0].id) {
                    if (rowss[0].time < 5) {
                        sql = "update checkCode set time = time + 1 where id = ?";
                        db.exec(sql, [rowss[0].id], (err) => {
                            if (err) {
                                return callback(err);
                            } else {
                                callback(err, phoneNum);
                            }

                        })
                    } else {
                        callback(err, "0");
                    }
                } else if (rowss.length == 0) {
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
        } else {
            callback(err, '0');
        }
    })

}