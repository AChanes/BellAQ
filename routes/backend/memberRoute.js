var express = require("express");
var router = express.Router();
var Administrator = require("../../models/administrator");

// 跳转至会员管理页面
router.get("/",(req,res,next) => {
    Administrator.findAllMember((err,rows)=>{
        if(err){
            res.send(err);
        }
        res.render("backEnd/members.html", {data:unescape(JSON.stringify(rows))});
    })
})

// 删除会员
router.post("/api/deleteMember", function (req, res, next) {
    var account = req.body.account;
    Administrator.deleteMember(account, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 修改会员付费到期时间
router.post("/api/updatePayTime", function (req, res, next) {
    var account = req.body.account;
    var paytime = req.body.paytime;
    Administrator.updatePay(account, paytime, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 修改会员密码
router.post("/api/updateMemberPsw",(req,res,next)=>{
    var account = req.body.account;
    var password = req.body.password;
    Administrator.updateMemberPsw(account,password,(er,sta)=>{
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})
module.exports = router;