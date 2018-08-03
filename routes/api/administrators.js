var express = require("express");
var router = express.Router();
var Administrator = require("../../models/administrator");
// 管理员登陆
router.post("/login", (req, res, next) => {
    var account = req.body.account;
    var password = req.body.password;
    Administrator.login(account, password, (err, rows) => {
        if(err){
            res.send(err);
        }
        res.send(rows);
    })
});

// 后台添加管理员
router.post("/reg", (req, res, next) => {
    var nickname = req.body.nickname;
    var account = req.body.account;
    var password = req.body.password;
    var position = req.body.position;
    var phoneNum = account;
    Administrator.reg(nickname, account, phoneNum, password, position, (err, sta) => {
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改自身信息
router.post("/updataAdministrator", (req, res, next) => {
    var nickname = req.body.nickname;
    var phoneNum = req.body.phoneNum;
    var password = req.body.password;
    var age = req.body.age;
    var sex = req.body.sex;
    Administrator.updateAdministrator(nickname, phoneNum, password, age, sex, (err, sta) => {
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改管理员权限
router.post("/updateRole", (req, res, next) => {
    var account = req.body.account;
    var role = req.body.role;
    Administrator.updateRole(account, role, (err, sta) => {
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

// 删除管理员
router.post("/deleteAdministrator", (req, res, next) => {
    var account = req.body.account;
    Administrator.deleteAdministrator(account, (err, sta) => {
      if (err) {
        res.send(err);
      }
      res.send(sta);
    });
})

// 查询所有老师
router.get("/findAllTeacher", (req, res, next) => {
    Administrator.findAllTeacher((err, rows) => {
        if (err) {
          res.send(err);
        }
        res.send(rows);
    })
})

// 查询会员管理员
router.get("/findAllAdministratorAd", (req, res, next) => {
    Administrator.findAllAdministratorAd((err, rows) => {
        if (err) {
          res.send(err);
        }
        res.send(rows);
    })
})
// 查询所有管理员
router.post("/findAllAdministrator", (req, res, next) => {
    Administrator.findAllAdministrator((err, rows) => {
        if(err){
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照账号查询管理员
router.post("/findAdministratorByAccount", (req, res, next) => {
    var account = req.body.account;
    Administrator.findAdministratorByAccount(account, (err, rows) => {
        if(err){
            res.send(err);
        }
        res.send(rows);
    })
})

// 修改管理员密码
router.post('/updatePassword', (req, res, next) => {
    var account = req.body.account;
    var password = req.body.password;
    Administrator.updatePassword(account, password, (err, sta) => {
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

// 删除会员
router.post("/deleteMember", (req, res, next) => {
    var id = req.body.id;
    Administrator.deleteMember(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 修改会员付费到期时间
router.post("/updatePayTime", (req, res, next) => {
    var account = req.body.account;
    var paytime = req.body.paytime;
    Administrator.updatePay(account, paytime, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});
module.exports = router;
