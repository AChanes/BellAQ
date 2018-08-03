var express = require("express");
var router = express.Router();
var Topic = require("../../models/topic");

// 查询所有情景分类
router.get("/findAllTopic", (req, res, next) => {
    Topic.findAllTopic((err, rows) => {
        if(err){
            res.send(err);
        }
        res.send(rows);
    })
});

module.exports = router;