var express = require("express");
var router = express.Router();
var Administrator = require("../../models/administrator");

// 跳转至管理员管理页面
router.get("/",(req,res,next)=>{
    Administrator.findAllAdministrator((err,rows)=>{
        if(err){
            res.send(err);
        }
        res.render("backEnd/administrators.html", {data:rows});
    });
})

// 跳转至教师管理页面
router.get("/teacher",(req,res,next)=>{
    Administrator.findAllTeacher(function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.render("backEnd/teacher.html", { data: unescape(JSON.stringify(rows))});
    })
})

// 跳转至会员管理员页面
router.get("/admin",(req,res,next)=>{
    Administrator.findAllAdministratorAd(function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.render("backEnd/admin.html",{data:unescape(JSON.stringify(rows))});
    })
})

// 后台添加管理员
router.post("/api/reg", function (req, res, next) {
    console.log(444);
    var nickname = req.body.nickname;
    var account = req.body.account;
    var password = req.body.password;
    var role = req.body.role;
    var phoneNum = account;
    Administrator.reg(nickname, account, phoneNum, password, role, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改自身信息
router.post("/api/updataAdministrator", function (req, res, next) {
    var nickname = req.body.nickname;
    var phoneNum = req.body.phoneNum;
    var password = req.body.password;
    var age = req.body.age;
    var sex = req.body.sex;
    Administrator.updateAdministrator(nickname, phoneNum, password, age, sex, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改管理员权限
router.post("/api/updateRole", function (req, res, next) {
    var account = req.body.account;
    var role = req.body.role;
    Administrator.updateRole(account, role, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 删除管理员
router.post("/api/deleteAdministrator", function (req, res, next) {
    var account = req.body.account;
    Administrator.deleteAdministrator(account, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
})

// 查询所有老师
router.get("/api/findAllTeacher", function (req, res, next) {
    Administrator.findAllTeacher(function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询会员管理员
router.get("/api/findAllAdministratorAd", function (req, res, next) {
    Administrator.findAllAdministratorAd(function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询所有管理员
router.post("/api/findAllAdministrator", function (req, res, next) {
    Administrator.findAllAdministrator(function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照账号查询管理员
router.post("/api/findAdministratorByAccount", function (req, res, next) {
    var account = req.body.account;
    Administrator.findAdministratorByAccount(account, function (err, rows) {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 修改管理员密码
router.post("/api/updatePassword", function (req, res, next) {
    var account = req.body.account;
    var password = req.body.password;
    Administrator.updatePassword(account, password, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})


// 删除会员
router.get("/api/deleteMember",(req,res,next)=>{
    var account = req.query.account;
    Administrator.deleteMember(account,(err,sta)=>{
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

// 会员找回账号
router.post("/api/findBackMember",(req,res,next)=>{
    var account = req.body.account;
    var password = req.body.password;
    Administrator.findBackMember(account,password,(err,sta)=>{
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})
module.exports = router;
