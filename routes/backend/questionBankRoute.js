var express = require("express");
var router = express.Router();
var Administrator = require("../../models/administrator");
var Listen = require("../../models/listen");
var ListenQ = require("../../models/listenq");
var Speak = require("../../models/speak");
var Read = require("../../models/read");
var ReadQ = require("../../models/readq");
var Write = require("../../models/write");
var MemberR = require("../../models/memberR");
var Mockexam = require("../../models/mockexam");
var upload = require("../../util/multerUtil");
var fs = require("fs");

// 跳转至题目管理页面
//上传听力材料
router.get("/listen", (req, res, next) => {
    res.render("backEnd/listen.html");
})
// 上传口语材料
router.get("/spoken", (req, res, next) => {
    res.render("backEnd/spoken.html");
})
// 上传阅读材料
router.get("/read", (req, res, next) => {
    res.render("backEnd/read.html");
})
// 上传写作材料
router.get("/write", (req, res, next) => {
    res.render("backEnd/writing.html");
})
// 跳转至材料列表页
router.get("/subject", (req, res, next) => {
    var tId = req.query.tId;
    var tyId = req.query.tyId;
    if (tyId == 1) {
        Speak.TfindSpeakMaterialByTid(tId, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row=>{
                row.tyId = 1;
            })
            res.render("backEnd/subject.html", {
                lists: unescape(JSON.stringify(rows))
            })
        })
    } else if (tyId == 2) {
        Read.TfindReadMaterialByTid(tId, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 2;
            })
            res.render("backEnd/subject.html", {
                lists: unescape(JSON.stringify(rows))
            })
        })
    } else if (tyId == 3) {
        Listen.TfindListenMaterialByTid(tId, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 3;
            })
            res.render("backEnd/subject.html", {
                lists: unescape(JSON.stringify(rows))
            })
        })
    } else if (tyId == 4) {
        Write.TfindWriteMaterialByTid(tId, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 4;
            })
            res.render("backEnd/subject.html", {
                lists: unescape(JSON.stringify(rows))
            })
        })
    }
})
// 跳转至修改页面
router.get("/detail", (req, res, next) => {
    var tyId = req.query.tyId * 1;
    var id = req.query.id * 1;
    if (tyId == 1) {
        Speak.TfindSpeakMaterialById(id, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 1
            })
            console.log(rows)
            res.render("backEnd/spoken1.html", {
                dataStr: unescape(JSON.stringify(rows)),
                data: rows
            })
        })
    } else if (tyId == 2) {
        Read.TfindReadMaterialById(id, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 2
            })
            res.render("backEnd/read1.html", {
                dataStr: unescape(JSON.stringify(rows)),
                data: rows
            });
        })
    } else if (tyId == 3) {
        Listen.TfindListenMaterialById(id, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 3
            })
            res.render("backEnd/listen1.html", {
                dataStr: unescape(JSON.stringify(rows)),
                data: rows
            });
        })
    } else if (tyId == 4) {
        Write.TfindWriteMaterialById(id, (err, rows) => {
            if (err) {
                res.send(err);
            }
            rows.forEach(row => {
                row.tyId = 4
            })
            res.render("backEnd/write1.html", {
                dataStr: unescape(JSON.stringify(rows)),
                data: rows
            });
        })
    }
})

// 跳转至发布会员推荐
router.get("/recommend", (req, res, next) => {
    res.render("backEnd/mRecommend.html");
})

// 跳转至发布套题页面
router.get("/mock", (req, res, next) => {
    res.render("backEnd/mock.html");
})

// 跳转至修改套题页面
router.get("/mockxiu", (req, res, next) => {
    var tId = req.query.tId;
    Mockexam.findMockexamByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.lId = int(row.lId.split(","));
            row.sId = int(row.sId.split(","));
            row.rId = int(row.rId.split(","));
            row.wId = int(row.wId.split(","));
        });
        res.render("backEnd/mockxiu.html", {
            data: unescape(JSON.stringify(rows))
        })
    })
})

// 跳转至修改套题详情页面
router.get("/mockdetial", (req, res, next) => {
    var id = req.query.id;
    Mockexam.findMockexamById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.lId = int(row.lId.split(","));
            row.sId = int(row.sId.split(","));
            row.rId = int(row.rId.split(","));
            row.wId = int(row.wId.split(","));
        });
        res.render("backEnd/mockdetial.html", {
            data: unescape(JSON.stringify(rows))
        })
    })
})

// 跳转至会员推荐修改页面
router.get("/recom",(req,res,next)=>{
    var id = req.query.id;
    MemberR.findMemberR(id,(err,rows)=>{
        if(err){
            res.send(err);
        }
        res.render("backEnd/recom.html", {
            data: rows,
            dataStr: unescape(JSON.stringify(rows))
        });
    })
})

// 跳转至会员列表页面
router.get("/recomList",(req,res,next)=>{
    var aId = req.query.aId;
    MemberR.findAllMemberRByAid(aId,(err,rows)=>{
        if(err){
            res.send(err);
        }
        res.render("backEnd/recomList.html", {data:unescape(JSON.stringify(rows))});
    })
})

// 跳转至作文列表页
router.get("/findAllWriteNoScore", (req, res, next) => {
    Write.findAllWriteNoScore((err, rows) => {
        if (err) {
            res.send(err);
        }
    res.render("backEnd/grade.html",{data:unescape(JSON.stringify(rows))});
    });
});

// 跳转至作文详情
router.get("/findWriteDetail",(req,res,next)=>{
    var id = req.query.id;
    Write.findWriteDetail(id,(err,rows)=>{
        if(err){
            res.send(err);
        }
        res.render("backEnd/gradedetial.html", { data: JSON.parse(JSON.stringify(rows))})
    })
})

//删除单一材料
router.get("/api/deleteMaterial", (req, res, next) => {
    var id = req.query.id;
    var tyId = req.query.tyId * 1;
    if (tyId == 1) {
        Speak.TdeleteSpeakMaterialById(id, (err, sta) => {
            if (err) {
                res.send(err);
            }
            res.send(sta);
        })
    } else if (tyId == 2) {
        Read.TdeleteReadMaterialById(id, (err, sta) => {
            if (err) {
                res.send(err);
            }
            res.send(sta);
        })
    } else if (tyId == 3) {
        Listen.TdeleteListenMaterialById(id, (err, sta) => {
            if (err) {
                res.send(err);
            }
            res.send(sta);
        })
    } else if (tyId == 4) {
        Write.TdeleteWriteMaterialById(id, (err, sta) => {
            if (err) {
                res.send(err);
            }
            res.send(sta);
        })
    }
})
/** 以下为口语材料接口 **/
// 添加口语材料
router.post("/api/TaddSpeakMaterial", upload.fields([{
    name: "mp4ForA",
    maxCount: 1
}, {
    name: "mp4ForQ",
    maxCount: 1
}, {
    name: "mp4ForO",
    maxCount: 1
}, {
    name: "img",
    maxCount: 1
}]), (req, res, next) => {
    var tId = req.body.tId;
    var dId = req.body.dId;
    var title = req.body.title;
    var mp4ForA = "/video/" + req.files.mp4ForA[0].filename;
    var mp4ForQ = "/video/" + req.files.mp4ForQ[0].filename;
    var question = req.body.question;
    var topicId = req.body.topicId;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : null : null;
    var mp4ForO = req.files ? req.files.mp4ForO ? "/video/" + req.files.mp4ForO[0].filename : null : null;
    var timedown = req.body.timedown ? req.body.timedown : null;
    var rMaterial = req.body.rMaterial ? req.body.rMaterial : null;
    var original = req.body.original ? req.body.original : null;
    var isMockexam = req.body.isMockexam ? req.body.isMockexam : "0";
    Speak.TaddSpeakMaterial(tId, dId, title, img, mp4ForO, mp4ForA, mp4ForQ, question, timedown, rMaterial, original, topicId, isMockexam, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 删除某位老师的所有口语材料
router.get("/api/TdeleteSpeakMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Speak.TdeleteSpeakMaterialByTid(tId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 修改口语材料
router.post("/api/TupdateSpeakMaterial", upload.fields([{
    name: "mp4ForA",
    maxCount: 1
}, {
    name: "mp4ForQ",
    maxCount: 1
}, {
    name: "mp4ForO",
    maxCount: 1
}, {
    name: "img",
    maxCount: 1
}]), (req, res, next) => {
    var id = req.body.id;
    var dId = req.body.dId;
    var title = req.body.title;
    var mp4ForA = req.files ? req.files.mp4ForA ? "/video/" + req.files.mp4ForA[0].filename : req.body.mp4ForAs : req.body.mp4ForAs;
    var mp4ForQ = req.files ? req.files.mp4ForQ ? "/video/" + req.files.mp4ForQ[0].filename : req.body.mp4ForQs : req.body.mp4ForQs;
    var question = req.body.question;
    var topicId = req.body.topicId;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : req.body.imgs ? req.body.imgs : null : req.body.imgs ? req.body.imgs : null;
    var mp4ForO = req.files ? req.files.mp4ForO ? "/video/" + req.files.mp4ForO[0].filename : req.body.mp4ForOs ? req.body.mp4ForOs : null : req.body.mp4ForOs ? req.body.mp4ForOs : null;
    var timedown = req.body.timedown ? req.body.timedown : null;
    var rMaterial = req.body.rMaterial ? req.body.rMaterial : null;
    var original = req.body.original ? req.body.original : null;
    if (req.files && req.files.img && req.body.imgs) {
        fs.exists("public" + req.body.imgs, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.imgs, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })

    }
    if (req.files && req.files.mp4ForO && req.body.mp4ForOs) {
        fs.exists("public" + req.body.mp4ForOs, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.mp4ForOs, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })

    }
    if (req.files && req.files.mp4ForA && req.body.mp4ForAs) {
        fs.exists("public" + req.body.mp4ForAs, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.mp4ForAs, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })

    }
    if (req.files && req.files.mp4ForQ && req.body.mp4ForQs) {
        fs.exists("public" + req.body.mp4ForQs, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.mp4ForQs, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })
    }
    Speak.TupdateSpeakMaterial(id, dId, title, img, mp4ForO, mp4ForA, mp4ForQ, question, timedown, rMaterial, original, topicId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询所有的口语材料(结果：id，情景类型，难度等级)
router.get("/api/findAllSpeakMaterial", (req, res, next) => {
    Speak.findAllSpeakMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询某位老师所有口语材料
router.get("/api/TfindSpeakMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Speak.TfindSpeakMaterialByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询某位老师任意难度的材料
router.get("/api/TfindSpeakMaterialByTidAndDid", (req, res, next) => {
    var tId = req.query.tId;
    var dId = req.query.dId;
    Speak.TfindSpeakMaterialByTidAndDid(tId, dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 按照材料id查询口语材料
router.get("/api/TfindSpeakMaterialById", (req, res, next) => {
    var id = req.query.id;
    Speak.TfindSpeakMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 按照id查询口语材料（id，问题，问题录音，原文，原文录音，阅读材料,情景类型）
router.get("/api/findSpeakMaterialById", (req, res, next) => {
    var id = req.query.id;
    Speak.findSpeakMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

/**以下为阅读材料和题目 */
/**阅读材料 */

// 添加阅读材料
router.post("/api/TaddReadMaterial", (req, res, next) => {
    var tId = req.body.tId;
    var dId = req.body.dId;
    var englishTitle = req.body.englishTitle;
    var chineseTitle = req.body.chineseTitle;
    var englishMaterial = req.body.englishMaterial;
    var chineseMaterial = req.body.chineseMaterial;
    var topicId = req.body.topicId;
    var isMockexam = req.body.isMockexam ? req.body.isMockexam : "0";
    Read.TaddReadMaterial(tId, dId, englishTitle, chineseTitle, englishMaterial, chineseMaterial, topicId, isMockexam, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 删除某位老师的所有材料
router.get("/api/TdeleteReadMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Read.TdeleteReadMaterialByTid(tId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询某位老师所有材料
router.get("/api/TfindReadMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Read.TfindReadMaterialByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 修改高亮
router.post("/api/change",(req,res,next)=>{
    var id = req.body.id;
    var englishMaterial = req.body.englishMaterial;
    Read.change(id,englishMaterial,(err,sta)=>{
        if(err){
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改阅读材料
router.post("/api/TupdateReadMaterial", (req, res, next) => {
    var id = req.body.id;
    var dId = req.body.dId;
    var englishTitle = req.body.englishTitle;
    var chineseTitle = req.body.chineseTitle;
    var englishMaterial = req.body.englishMaterial;
    var chineseMaterial = req.body.chineseMaterial;
    var topicId = req.body.topicId;
    Read.TupdateReadMaterial(id, dId, englishTitle, chineseTitle, englishMaterial, chineseMaterial, topicId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询所有阅读材料
router.get("/api/findAllReadMaterial", (req, res, next) => {
    Read.findAllReadMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 按照难度查询某位老师的材料
router.get("/api/findReadMaterialByDid", (req, res, next) => {
    var tId = req.query.tId;
    var dId = req.query.dId;
    Read.findReadMaterialByDid(tId, dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询单个阅读材料
router.get("/api/TfindReadMaterialById", (req, res, next) => {
    var id = req.query.id;
    Read.TfindReadMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 添加题目
router.post("/api/TaddReadQuestion", (req, res, next) => {
    var rId = req.body.rId;
    var isD = req.body.isD;
    var question = req.body.question;
    var options = JSON.stringify({
        A: req.body.optionsA,
        B: req.body.optionsB,
        C: req.body.optionsB,
        D: req.body.optionsD
    });
    var numF = req.body.numF;
    var rightAnswer = req.body.rightAnswer;
    var score = req.body.score;
    ReadQ.TaddReadMaterial(rId, isD, question, options, rightAnswer, score,numF, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除单个题目
router.get("/api/TdeleteReadQuestionById", (req, res, next) => {
    var id = req.query.id;
    ReadQ.TdeleteReadQuestionById(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 删除一个材料下所有题目
router.get("/api/TdeleteReadQuestionByRid", (req, res, next) => {
    var rId = req.query.rId;
    ReadQ.TdeleteReadQuestionByRid(rId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
});

// 修改题目
router.post("/api/TupdateReadQuestion", (req, res, next) => {
    var id = req.body.id;
    var question = req.body.question;
    var options = JSON.stringify({
        A: req.body.optionsA,
        B: req.body.optionsB,
        C: req.body.optionsB,
        D: req.body.optionsD
    });
    var isD = req.body.isD;
    var numF = req.body.numF;
    var rightAnswer = req.body.rightAnswer;
    var score = req.body.score;
    console.log(isD)
    ReadQ.TupdateReadQuestion(id, question, isD,options, rightAnswer, score,numF, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询一个材料下所有题目
router.get("/api/TfindReadQuestionByRid", (req, res, next) => {
    var rId = req.query.rId;
    ReadQ.TfindReadQuestionByRid(rId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
});

// 查询单个题目
router.get("/api/findReadQuestionByRid", (req, res, next) => {
    var rId = req.query.rId;
    var numForRM = req.query.numForRM;
    ReadQ.findReadQuestionByRid(rId, numForRM, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    });
});

// 查询单个题目
router.get("/api/TfindReadQuestionById", (req, res, next) => {
    var id = req.query.id;
    ReadQ.TfindReadQuestionById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
});

/**以下为听力材料和题目 */

// 发布听力材料
router.post("/api/TaddListenMaterial", upload.fields([{
    name: "mp4",
    maxCount: 1
}, {
    name: "img",
    maxCount: 1
}]), (req, res, next) => {
    var tId = req.body.tId;
    var dId = req.body.dId;
    var title = req.body.title;
    var img = "/picture/" + req.files.img[0].filename;
    var mp4 = "/video/" + req.files.mp4[0].filename;
    var original = req.body.original;
    var topicId = req.body.topicId;
    var isMockexam = req.body.isMockexam ? req.body.isMockexam : "0";
    Listen.TaddListenMaterial(tId, dId, title, img, mp4, original, topicId, isMockexam, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 删除听力材料
router.get("/api/TdeleteListenMaterialById", (req, res, next) => {
    var id = req.body.id;
    Listen.TdeleteListenMaterialById(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 删除某位老师的所有听力材料
router.post("/api/TdeleteListenMaterialByTid", (req, res, next) => {
    var tId = req.body.tId;
    Listen.TdeleteListenMaterialByTid(tId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 修改听力材料
router.post("/api/TupdateListenMaterial", upload.fields([{
    name: "mp4",
    maxCount: 1
}, {
    name: "img",
    maxCount: 1
}]), (req, res, next) => {
    var id = req.body.id;
    var dId = req.body.dId;
    var title = req.body.title;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : req.body.img1 : req.body.img1;
    var mp4 = req.files ? req.files.mp4 ? "/video/" + req.files.mp4[0].filename : req.body.mp41 : req.body.mp41;
    var original = req.body.original;
    var topicId = req.body.topicId;
    if (req.files && req.files.img && req.body.img1) {
        fs.exists("public" + req.body.img1, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.img1, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })
    }
    if (req.files && req.files.mp4 && req.body.mp41) {
        fs.exists("public" + req.body.mp41, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.mp41, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })
    }
    Listen.TupdateListenMaterial(id, dId, title, img, mp4, original, topicId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询所有听力材料
router.get("/api/findAllListenMaterial", (req, res, next) => {
    Listen.findAllListenMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询单个听力材料
router.get("/api/TfindListenMaterialById", (req, res, next) => {
    var id = req.query.id;
    Listen.TfindListenMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 按照难度查询某位老师的听力材料
router.get("/api/findListenMaterialByDid", (req, res, next) => {
    var tId = req.query.tId;
    var dId = req.query.dId;
    Listen.findListenMaterialByDid(tId, dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 查询某位老师所有材料
router.get("/api/TfindListenMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Listen.TfindListenMaterialByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
})

// 添加题目
router.post("/api/TaddListenQuestion", upload.fields([{
    name: "mp4",
    maxCount: 1
}, {
    name: "mp4ForQ",
    maxCount: 1
}]), (req, res, next) => {
    var LMId = req.body.LMId;
    var isD = req.body.isD;
    var mp4 = "/video/" + req.files.mp4[0].filename;
    var question = req.body.question;
    var options = JSON.stringify({
        A: req.body.optionsA,
        B: req.body.optionsB,
        C: req.body.optionsB,
        D: req.body.optionsD
    });
    var rightAnswer = req.body.rightAnswer;
    var score = req.body.score;
    var mp4ForQ = req.files ? req.files.mp4ForQ ? "/video/" + req.files.mp4ForQ[0].filename : null : null;
    ListenQ.TaddListenQuestion(LMId, isD, mp4, question, options, rightAnswer, score, mp4ForQ, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除单个题目
router.get("/api/TdeleteListenQuestionById", (req, res, next) => {
    var id = req.query.id;
    ListenQ.TdeleteListenQuestionById(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 删除一个材料下所有题目
router.get("/api/TdeleteListenQuestionByLMId", (req, res, next) => {
    var LMId = req.query.LMId;
    ListenQ.TdeleteListenQuestionByLMId(LMId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 查询单个题目
router.get("/api/TfindListenQuestionById", (req, res, next) => {
    var id = req.query.id;
    ListenQ.TfindListenQuestionById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
})

// 修改题目
router.post("/api/TupdateListenQuestion", upload.fields([{
    name: "mp4",
    maxCount: 1
}, {
    name: "mp4ForQ",
    maxCount: 1
}]), (req, res, next) => {
    var id = req.body.id;
    var isD = req.body.isD;
    var mp4 = req.files ? req.files.mp4 ? "/video/" + req.files.mp4[0].filename : req.body.mp42 : req.body.mp42;
    var question = req.body.question;
    var options = JSON.stringify({
        A: req.body.optionsA,
        B: req.body.optionsB,
        C: req.body.optionsB,
        D: req.body.optionsD
    });
    var rightAnswer = req.body.rightAnswer;
    var score = req.body.score;
    var mp4ForQ = req.files ? req.files.mp4ForQ ? "/video/" + req.files.mp4ForQ[0].filename : req.body.mp43 ? req.body.mp43 : null : req.body.mp43 ? req.body.mp43 : null;
    if (req.files && req.files.mp4 && req.body.mp42) {
        fs.exists("public" + req.body.mp42, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.mp42, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })

    }
    if (req.files && req.files.mp4ForQ && req.body.mp43) {
        fs.exists("public" + req.body.mp43, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.mp43, (err) => {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })

    }
    console.log(id, isD, mp4, question, options, rightAnswer, score, mp4ForQ)
    ListenQ.TupdateListenQuestion(id, isD, mp4, question, options, rightAnswer, score, mp4ForQ, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询一个材料下所有题目
router.get("/api/TfindListenQuestionByLMId", (req, res, next) => {
    var LMId = req.query.LMId;
    ListenQ.TfindListenQuestionByLMId(LMId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
})

// 按照听力材料ID查询单个题目
router.get("/api/findListenQuestionByLMId", (req, res, next) => {
    var LMId = req.query.LMId;
    var numForLM = req.query.numForLM;
    ListenQ.findListenQuestionByLMId(LMId, numForLM, (err, rows) => {
        if (err) {
            res.send(err);
        }
        rows.forEach(row => {
            row.options = JSON.parse(row.options);
        });
        res.send(rows);
    })
})

/**以下为写作材料 */
// 发布写作材料
router.post("/api/TaddWriteMaterial", upload.fields([{
    name: "img",
    maxCount: 1
}, {
    name: "mp4",
    maxCount: 1
}]), (req, res, next) => {
    var tId = req.body.tId;
    var dId = req.body.dId;
    var title = req.body.title;
    var question = req.body.question;
    var topicId = req.body.topicId;
    var includeMaterial = req.body.material ? '1' : '0';
    var score = req.body.score;
    var timedown = req.body.timedown ? req.body.timedown : 0;
    var original = req.body.original ? req.body.original : null;
    var material = req.body.material ? req.body.material : null;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : null : null;
    var mp4 = req.files ? req.files.mp4 ? "/video/" + req.files.mp4[0].filename : null : null;
    var isMockexam = req.body.isMockexam ? "0" + req.body.isMockexam : "0";
    Write.TaddWriteMaterial(tId, dId, title, timedown, original, material, img, mp4, question, topicId, includeMaterial, score, isMockexam, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 删除单个写作材料
router.get("/api/TdeleteWriteMaterialById", (req, res, next) => {
    var id = req.query.id;
    Write.TdeleteWriteMaterialById(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除某位老师所有的写作材料
router.get("/api/TdeleteWriteMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Write.TdeleteWriteMaterialByTid(tId, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 修改写作材料
router.post("/api/TupdateWriteMaterial", upload.fields([{
    name: "img",
    maxCount: 1
}, {
    name: "mp4",
    maxCount: 1
}]), (req, res, next) => {
    var id = req.body.id;
    var dId = req.body.dId;
    var title = req.body.title;
    var question = req.body.question;
    var topicId = req.body.topicId;
    var includeMaterial = req.body.includeMaterial;
    var score = req.body.score;
    var timedown = req.body.timedown ? req.body.timedown : null;
    var original = req.body.original ? req.body.original : null;
    var material = req.body.material ? req.body.material : null;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : req.body.imgw ? req.body.imgw : null : req.body.imgw ? req.body.imgw : null;
    var mp4 = req.files ? req.files.mp4 ? "/video/" + req.files.mp4[0].filename : req.body.mp4w ? req.body.mp4w : null : req.body.mp4w ? req.body.mp4w : null;
    if (req.files && req.files.img && req.body.imgw) {
        fs.exists("public" + req.body.imgw, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.imgw, function (err) {
                    if (err) {
                        res.send(err);
                    }
                })
            }
        })

    }
    if (req.files && req.files.mp4 && req.body.mp4w) {
        fs.exists("public" + req.body.mp4w, (exists) => {
            if (exists) {
                fs.unlink(req.body.mp4w, function (err) {
                    if (err) {
                        res.send(err);
                    }
                });
            }
        })
    }
    Write.TupdateWriteMaterial(id, dId, title, timedown, original, material, img, mp4, question, topicId, includeMaterial, score, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send("success");
    });
});

//查询所有写作题
router.get("/api/findWrite", (req, res, next) => {
    Write.findWrite((err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 查询某一个写作材料
router.get("/api/TfindWriteMaterialById", (req, res, next) => {
    var id = req.query.id;
    Write.TfindWriteMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 查询某位老师所有的写作材料
router.get("/api/TfindWriteMaterialByTid", (req, res, next) => {
    var tId = req.query.tId;
    Write.TfindWriteMaterialByTid(tId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 老师打分
router.post("/api/addScore", (req, res, next) => {
    var id = req.body.id;
    var score = req.body.score;
    Write.addScore(id, score, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 按照难度查询某位老师的材料
router.get("/api/findWriteMaterialByDid", (req, res, next) => {
    var tId = req.query.tId;
    var dId = req.query.dId;
    Write.findWriteMateralByDid(tId, dId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    })
});

// 查询某一个写作材料
router.get("/api/TfindWriteMaterialById", (req, res, next) => {
    var id = req.query.id;
    Write.TfindWriteMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});


// 添加会员推荐
router.post("/api/addMemberR", upload.fields([{
    name: "img",
    maxCount: 1
}]), function (req, res, next) {
    var img = "/picture/" + req.files.img[0].filename;
    var aId = req.body.aId;
    var title = req.body.title;
    var digest = req.body.digest;
    var pullTime = new Date();
    pullTime = pullTime.getFullYear() + "-" + (pullTime.getMonth() + 1) + "-" + pullTime.getDate();
    var content = req.body.content;
    var tyId = req.body.tyId;
    MemberR.addMemberR(img, aId, title, digest, pullTime, content, tyId, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 修改会员推荐
router.post("/api/updateMemberR", upload.fields([{
    name: "img",
    maxCount: 1
}]), (req, res, next) => {
    var id = req.body.id;
    var img = req.files ? req.files.img ? "/picture/" + req.files.img[0].filename : req.body.imgm : req.body.imgm;
    var title = req.body.title;
    var digest = req.body.digest;
    var content = req.body.content;
    var tyId = req.body.tyId;
    if (req.files && req.files.img && req.body.imgm) {
        fs.exists("public" + req.body.imgm, (exists) => {
            if (exists) {
                fs.unlink("public" + req.body.imgm, (err) => {
                    if (err) {
                        res.send(err);
                    }

                })
            }
        })
    }
    MemberR.updateMemberR(id, img, title, digest, content, tyId, function (err, sta) {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 查询某位会员管理的所有会员推荐
router.get("/api/findAllMemberRByAid", (req, res, next) => {
    var aId = req.query.aId;
    MemberR.findAllMemberRByAid(aId, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 会员推荐详情
router.get("/api/findMemberR", (req, res, next) => {
    var id = req.query.id;
    MemberR.findMemberR(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.send(rows);
    });
});

// 删除会员推荐
router.get("/api/deleteMemberR", (req, res, next) => {
    var id = req.query.id;
    MemberR.deleteMemberR(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 修改点击量
router.post("/api/addPageViews", (req, res, next) => {
    var id = req.body.id;
    var pageView = req.body.pageView;
    MemberR.addPageViews(id, pageView, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    })
})

// 添加套题
router.post("/api/addMockexam", (req, res, next) => {
    var tId = req.body.tId;
    var lId = req.body.lId.join(",");
    var sId = req.body.sId.join(",");
    var rId = req.body.rId.join(",");
    var wId = req.body.rId.join(",");
    var dId = req.body.dId;
    var timedown = req.body.timedown ? req.body.timedown : null;
    Mockexam.addMockexam(tId, lId, sId, rId, wId, dId, timedown, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 删除套题（id）
router.get("/api/deleteMockexamById", (req, res, next) => {
    var id = req.query.id;
    Mockexam.deleteMockexamById(id, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
});

// 修改套题
router.post("/api/updateMockexam", (req, res, next) => {
    var id = req.body.id;
    var lId = req.body.lId.join(",");
    var sId = req.body.sId.join(",");
    var rId = req.body.rId.join(",");
    var wId = req.body.wId.join(",");
    var dId = req.body.dId;
    var timedown = req.body.timedown ? req.body.timedown : null;
    console.log(id, lId, sId, rId, wId, dId, timedown)
    Mockexam.updateMockexam(id, lId, sId, rId, wId, dId, timedown, (err, sta) => {
        if (err) {
            res.send(err);
        }
        res.send(sta);
    });
})

function int(arr) {
    for (var i = 0, len = arr.length; i < len; i++) {
        arr[i] = arr[i] * 1;
    }
    return arr;
}
module.exports = router;