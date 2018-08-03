var express = require("express");
var router = express.Router();
var Administrator = require("../../models/administrator");

// 跳转至个人信息页面
router.get("/:id",(req,res,next)=>{
    var id = req.params.id;
    Administrator.findAdministratorById(id,(err,rows)=>{
        if(err){
            res.send(err);
        }
        res.render("backEnd/personal.html",{data:rows});
    })
})

// 修改个人信息
router.post("/api/updataAdministrator",(req,res,next)=>{
    var account = req.body.account;
    var nickname = req.body.nickname;
    var phoneNum = req.body.phoneNum;
    var password = req.body.password;
    var age = req.body.age ? req.body.age : null;
    var sex = req.body.sex ? req.body.sex : "0";
    console.log(account,nickname, phoneNum, password, age, sex ,444)
    Administrator.updataAdministrator(account,nickname, phoneNum, password, age, sex,(err,sta)=>{
    	if(err){
    		res.send(err);
    	}
        res.send(sta,222);
        console.log(sta)
    })
})
module.exports = router;