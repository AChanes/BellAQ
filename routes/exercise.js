/**
 *  练习路由
 */

var express = require('express');
var router = express.Router();
var Listen = require("../models/listen");
var Speak = require("../models/speak");
var Read = require("../models/read");
var Write = require("../models/write")
var Member = require("../models/member")
var ListenQ = require("../models/listenq")
var ReadQ = require("../models/readq")
var AnswerR = require("../models/answerR")

// 进入练习页面
router.get(["/", "/listen"], (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var data = [],
        top = [];
    Listen.findAllListenMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        data = JSON.parse(JSON.stringify(rows));
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = JSON.parse(JSON.stringify(rows_1));
            
                AnswerR.findMessage(req.session.user.id, (err, rows_2) => {
                    if (err) {
                        res.send(err);
                    }
                    var days = findDays(rows_2[0].times);
                    res.render('exercise.html', JSON.parse(JSON.stringify({
                        data: data,
                        top: top,
                        questionNum: rows_2[0].num,
                        score: rows_2[0].score,
                        days: days
                    })));
                })
        })
    })
})
// 阅读
router.get("/read", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var data = [],
        top = [];
    Read.findAllReadMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        data = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;

            AnswerR.findMessage(req.session.user.id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                var days = findDays(rows_2[0].times);
                res.render('exercise.html', JSON.parse(JSON.stringify({
                    data: data,
                    top: top,
                    questionNum: rows_2[0].num,
                    score: rows_2[0].score,
                    days: days
                })));
            })
        })
    })
})
// 口语
router.get("/spoken", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var data = [],
        top = [];
    Speak.findAllSpeakMaterial((err, rows) => {
        if (err) {
            res.send(err);
        }
        data = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;

            AnswerR.findMessage(req.session.user.id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                var days = findDays(rows_2[0].times);
                res.render('exercise.html', JSON.parse(JSON.stringify({
                    data: data,
                    top: top,
                    questionNum: rows_2[0].num,
                    score: rows_2[0].score,
                    days: days
                })));
            })
        })
    })
})
// 写作
router.get("/write", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var data = [],
        top = [];
        
    Write.findWrite((err, rows) => {
        if (err) {
            res.send(err);
        }
        data = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            AnswerR.findMessage(req.session.user.id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                var days = findDays(rows_2[0].times);
                res.render('exercise.html', JSON.parse(JSON.stringify({
                    data: data,
                    top: top,
                    questionNum: rows_2[0].num,
                    score: rows_2[0].score,
                    days: days
                })));
            })
        })
    })
})

// 分段展示听力
router.get(["/listen/daun", "/daun"], (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var start = Math.floor((req.query.start * 1 - 1) / 5) * 5;
    var num = req.query.num * 1;
    
    Listen.findListenMaterial(start, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            Listen.findListenMaterialNum((err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                AnswerR.findMessage(req.session.user.id, (err, rows_4) => {
                    if (err) {
                        res.send(err);
                    }
                    var days = findDays(rows_4[0].times);
                    res.render("exList.html", JSON.parse(JSON.stringify({
                        data: rows,
                        top: top,
                        num: rows_2[0].MaterialNum,
                        questionNum: rows_4[0].num,
                        score: rows_4[0].score,
                        days: days
                    })))
                })
            })
        })
    })
})


// 分段展示阅读
router.get("/read/daun", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var start = Math.floor((req.query.start * 1 - 1) * 1 / 5) * 5;
    var num = req.query.num * 1;
    
    Read.findReadMaterial(start, num,(err, rows) => {
        if (err) {
            res.send(err);
        }
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            Read.findReadMaterialNum((err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                AnswerR.findMessage(req.session.user.id, (err, rows_4) => {
                    if (err) {
                        res.send(err);
                    }
                    var days = findDays(rows_4[0].times);
                    res.render("exList.html", JSON.parse(JSON.stringify({
                        data: rows,
                        top: top,
                        num: rows_2[0].MaterialNum,
                        questionNum: rows_4[0].num,
                        score: rows_4[0].score,
                        days: days
                    })))
                })
            })
        })
    })
})
// 分段展示口语
router.get("/spoken/daun", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var start = Math.floor((req.query.start * 1 - 1) * 1 / 5) * 5;
    var num = req.query.num * 1;
    
    Speak.findSpeakMaterial(start, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            Speak.findSpeakMaterialNum((err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                AnswerR.findMessage(req.session.user.id, (err, rows_4) => {
                    if (err) {
                        res.send(err);
                    }
                    var days = findDays(rows_4[0].times);
                    res.render("exList.html", JSON.parse(JSON.stringify({
                        data: rows,
                        top: top,
                        num: rows_2[0].MaterialNum,
                        questionNum: rows_4[0].num,
                        score: rows_4[0].score,
                        days: days
                    })))
                })
            })
        })
    })
})
// 分段展示写作
router.get("/write/daun", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var start = Math.floor((req.query.start * 1 - 1) / 5) * 5;
    var num = req.query.num * 1;
    
    Write.findWriteMaterial(start, num, (err, rows) => {
        if (err) {
            res.send(err);
        }
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;

            Write.findWriteMaterialNum((err, rows_2) => {
                if (err) {
                    res.send(err);
                }

                AnswerR.findMessage(req.session.user.id, (err, rows_4) => {
                    if (err) {
                        res.send(err);
                    }
                    var days = findDays(rows_4[0].times);
                    res.render("exList.html", JSON.parse(JSON.stringify({
                        data: rows,
                        top: top,
                        num: rows_2[0].MaterialNum,
                        questionNum: rows_4[0].num,
                        score: rows_4[0].score,
                        days: days
                    })))
                })
            })
        })
    })
})

// 展示听力全部分类
router.get("/listen/topic", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var topic = [],
        top = [];
        
    Listen.findTopicNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        topic = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;

            res.render("topic.html", JSON.parse(JSON.stringify({
                data: topic,
                top: top
            })));
        })
    })
})

// 展示阅读全部分类
router.get("/read/topic", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var topic = [],
        top = [];
        
    Read.findTopicNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        topic = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            res.render("topic.html", JSON.parse(JSON.stringify({
                data: topic,
                top: top
            })));
        })
    })
})

// 展示阅读全部分类
router.get("/spoken/topic", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var topic = [],
        top = [];
        
    Speak.findTopicNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        topic = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            res.render("topic.html", JSON.parse(JSON.stringify({
                data: topic,
                top: top
            })));
        })
    })
})

// 展示阅读全部分类
router.get("/write/topic", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var topic = [],
        top = [];
        
    Write.findTopicNum((err, rows) => {
        if (err) {
            res.send(err);
        }
        topic = rows;
        Member.findScoreTop((err, rows_1) => {
            if (err) {
                res.send(err);
            }
            top = rows_1;
            res.render("topic.html", JSON.parse(JSON.stringify({
                data: topic,
                top: top
            })));
        })
    })
})

// 进入听力预览
router.get("/listen/preview", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id * 1;
    var numForLM = req.query.numForLM ? req.query.numForLM : 1;
    var material = [],
        question = [],
        num = 0;
        
    Listen.TfindListenMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        material = rows;
        ListenQ.findListenQuestionByLMId(id, numForLM, (err, rows_1) => {
            if (err) {
                res.send(err)
            }
            question = rows_1;
            question[0].options = JSON.parse(question[0].options)
            ListenQ.findMaxNumForLM(id, (err, rows) => {
                if (err) {
                    res.send(err);
                }
                num = rows[0].num;

                res.render("exercise/seeExe.html", JSON.parse(JSON.stringify({
                    material: material,
                    question: question,
                    num: num
                })));
            })
        })
    })
})

// 进入阅读预览
router.get("/read/preview", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var numForRM = req.query.numForRM ? req.query.numForRM : 1;
    var material = [],
        question = [],
        num = 0;
        
    Read.TfindReadMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err)
        }
        material = rows;
        ReadQ.findReadQuestionByRid(id, numForRM, (err, rows_1) => {
            if (err) {
                res.send(err)
            }
            question = rows_1;
            question[0].options = JSON.parse(question[0].options)
            ReadQ.findMaxNumForRM(id, (err, rows) => {
                if (err) {
                    res.send(err);
                }
                num = rows[0].num;
                res.render("exercise/seeExe.html", {
                    material: JSON.parse(JSON.stringify(material)),
                    question: JSON.parse(JSON.stringify(question)),
                    num: num
                })
            })
        })
    })
})

// 写作预览
router.get("/write/preview", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    
    Write.TfindWriteMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err)
        }
        res.render("exercise/Seewrite.html", JSON.parse(JSON.stringify({
            material: rows
        })))
    })
})

// 口语预览
router.get("/spoken/preview", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.session.user.id;;
    var material = [],
        allMp4 = [],
        myMp4 = [];
        
    Speak.TfindSpeakMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        material = rows;
        AnswerR.findExample(id, (err, rows_1) => {
            if (err) {
                res.send(err);
            }
            allMp4 = rows_1;
            AnswerR.findMyMp4(mId, id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                myMp4 = rows_2;
                AnswerR.findMessage(req.session.user.id, (err, rows_3) => {
                    if (err) {
                        res.send(err);
                    }
                    var days = findDays(rows_3[0].times);
                    res.render("exercise/Seespoken.html", JSON.parse(JSON.stringify({
                        material: material,
                        allMp4: allMp4,
                        myMp4: myMp4,
                        questionNum: rows_3[0].num,
                        score: rows_3[0].score,
                        days: days
                    })))
                })
            })
        })
    })
})


// 口语练习页面一
router.get("/spoken/translate/first", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    if (mock * 1) {
        var arrS = sId.split(",");
        id = arrS.shift();
        sId = arrS.join(",");
    }
    Speak.findMp4ForA(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render("exercise/spokenfirst.html", JSON.parse(JSON.stringify({
            material: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})


// 口语练习页面二
router.get("/spoken/translate/second", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Speak.findMp4ForQ(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render("exercise/spokentype.html", JSON.parse(JSON.stringify({
            material: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})

// 口语练习页面四(结果页面)
router.get("/spoken/translate/fourth", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    if (mock * 1) {
        id = sId.split(",")[0];
        if (id) {
            res.redirect("/exercise/spoken/translate/first?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId);
        } else {
            var arrS = rId.split(",");
            id = arrS.shift();
            rId = arrS.join(",");
            res.redirect("/exercise/read/translate?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId);
        }
    }
    var material = [],
        myMp4 = [],
        example = [];
    Speak.findMp4ForQ(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        material = rows;
        AnswerR.findAnswerRByNumForM(mId, 1, id, 0, (err, rows_1) => {
            if (err) {
                res.send(err);
            }
            myMp4 = rows_1;
            AnswerR.findExample(id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                example = rows_2;
                res.render("exercise/spokenResult.html", JSON.parse(JSON.stringify({
                    material: material,
                    mp4: myMp4,
                    example: example
                })))
            })
        })
    })
})

// 口语练习页面二(含材料)
router.get("/spoken/translate/fifth", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Speak.findRMaterial(id, (err, rows) => {
        if (err) {
            res.send(err)
        }
        res.render("exercise/spokensecond.html", JSON.parse(JSON.stringify({
            rMaterial: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})

// 口语练习页面三（含材料）
router.get("/spoken/translate/sixth", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Speak.findMp4ForO(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render("exercise/spokenthird.html", JSON.parse(JSON.stringify({
            mp4: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})


// 听力练习页面一
router.get("/listen/translate/first", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Listen.findTitle(id, (err, rows) => {
        if (err) {
            res.send(err);
        }

        res.render("exercise/listenfirst.html", JSON.parse(JSON.stringify({
            material: rows,
            mock: mock,

            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})
// 听力练习页面二
router.get("/listen/translate/second", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Listen.findAllListenMaterialMp4(id, (err, rows) => {
        if (err) {
            res.render(err);
        }
        res.render("exercise/listensecond.html", {
            material: JSON.parse(JSON.stringify(rows)),
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })
    })
})

// 听力练习页面三
router.get("/listen/translate/third", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var numForLM = req.query.numForLM ? req.query.numForLM : 1;
    var question = [],
        num = 0,
        title = [];
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";

    ListenQ.findMaxNumForLM(id, (err, rows_1) => {
        if (err) {
            res.send(err);
        }
        num = rows_1[0].num;
        if (num < numForLM) {
            if (mock * 1) {
                var arrS = lId.split(",");
                id = arrS.shift();
                lId = arrS.join(",");
                if (id) {
                    res.redirect("/exercise/listen/translate/first?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
                } else {
                    id = wId.split(",")[0];
                    res.redirect("/exercise/write/translate/test?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
                }
            } else {
                res.redirect("/exercise/listen/translate/fourth?id=" + id + "&mId=" + mId)
            }
        } else {
            ListenQ.findListenQuestionByLMId(id, numForLM, (err, rows) => {
                if (err) {
                    res.send(err);
                }
                question = rows;
                question.forEach(ques => {
                    ques.options = JSON.parse(ques.options)
                })
                Listen.findTitle(id, (err, rows_2) => {
                    if (err) {
                        res.send(err);
                    }
                    title = rows_2;
                    res.render("exercise/listenthird.html", JSON.parse(JSON.stringify({
                        question: question,
                        num: num,
                        title: title,
                        mock: mock,
                        mockRId: mockRId,
                        lId: lId,
                        sId: sId,
                        rId: rId,
                        wId: wId
                    })))
                })
            })
        }
    })
})

// 听力练习页面四（结果页面）
router.get("/listen/translate/fourth", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var numForLM = req.query.numForLM ? req.query.numForLM : 1;
    var material = [],
        question = [],
        num = 0,
        result = [];
    Listen.TfindListenMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        material = rows;
        ListenQ.findListenQuestionByLMId(id, numForLM, (err, rows_1) => {
            if (err) {
                res.send(err)
            }
            question = rows_1;
            question[0].options = JSON.parse(question[0].options)
            ListenQ.findMaxNumForLM(id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                num = rows_2[0].num;
                AnswerR.findAnswerRByNumForM(mId, 3, id, numForLM, (err, rows_3) => {
                    if (err) {
                        res.send(err);
                    }
                    result = rows_3;

                    res.render("exercise/listenR.html", {
                        material: JSON.parse(JSON.stringify(material)),
                        question: JSON.parse(JSON.stringify(question)),
                        num: num,
                        result: result
                    });
                })
            })
        })
    })
})

// 阅读练习页面一
router.get("/read/translate", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var numForRM = req.query.numForRM ? req.query.numForRM : 1;
    var material = [],
        question = [],
        num = 0;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    ReadQ.findMaxNumForRM(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        num = rows[0].num;
        if (num < numForRM) {
            if (mock * 1) {
                var arrS = rId.split(",");
                id = arrS.shift();
                rId = arrS.join(",");
                if (id) {
                    res.redirect("/exercise/read/translate?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
                } else {
                    var arrS = lId.split(",");
                    id = arrS.shift();
                    lId = arrS.join(",");
                    res.redirect("/exercise/listen/translate/first?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
                }
            } else {
                res.redirect("/exercise/read/result?id=" + id + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId);
            }
        } else {

            ReadQ.findReadQuestionByRid(id, numForRM, (err, rows_1) => {
                if (err) {
                    res.send(err);
                }
                question = JSON.parse(JSON.stringify(rows_1));
                question[0].options = JSON.parse(question[0].options)
                Read.TfindReadMaterialById(id, (err, rows_2) => {
                    if (err) {
                        res.send(err);
                    }
                    material = rows_2;
                    res.render("exercise/readOp.html", JSON.parse(JSON.stringify({
                        material: material,
                        question: question,
                        num: num,
                        mock: mock,
                        mockRId: mockRId,
                        mId: mId,
                        lId: lId,
                        sId: sId,
                        rId: rId,
                        wId: wId
                    })))
                })
            })
        }
    })
})

// 阅读结果页面
router.get("/read/result", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var mId = req.query.mId;
    var id = req.query.id;
    var numForRM = req.query.numForRM ? req.query.numForRM : 1;
    var num = 0;
    AnswerR.findReadResult(mId, id, numForRM, (err, rows) => {
        if (err) {
            res.send(err);
        }
        ReadQ.findReadQuestionByRid(id, numForRM, (err, rows_1) => {
            if (err) {
                res.send(err);
            }
            rows_1.forEach(row => {
                row.options = JSON.parse(row.options)
            })
            question = rows_1;
            ReadQ.findMaxNumForRM(id, (err, rows_2) => {
                if (err) {
                    res.send(err);
                }
                num = rows_2[0].num;
                res.render("exercise/readR.html", {
                    result: JSON.parse(JSON.stringify(rows)),
                    question: JSON.parse(JSON.stringify(question)),
                    mId: mId,
                    num: num
                })
            })
        })
    })
})


router.get("/write/translate/test", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Write.TfindWriteMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        if (mock * 1) {
            var arrS = wId.split(",");
            id = arrS.shift();
            wId = arrS.join(",");
        }
        if (rows[0] && rows[0].material) {
            res.redirect("/exercise/write/translate/second?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
        } else {
            res.redirect("/exercise/write/translate/first?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
        }
    })
})


// 写作练习页面一
router.get("/write/translate/first", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Write.TfindWriteMaterialById(id, (err, rows) => {
        if (err) {
            res.send(err);
        }

        res.render("exercise/writeNo.html", JSON.parse(JSON.stringify({
            material: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})

// 写作练习页面二(含材料)
router.get("/write/translate/second", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Write.findWriteR2(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render("exercise/orginalWrite.html", JSON.parse(JSON.stringify({
            material: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })))
    })
})

// 写作练习页面三（含材料）
router.get("/write/translate/third", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var id = req.query.id;
    var mId = req.query.mId;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    Write.findWriteR3(id, (err, rows) => {
        if (err) {
            res.send(err);
        }
        res.render(".html", {
            material: rows,
            mock: mock,
            mockRId: mockRId,
            lId: lId,
            sId: sId,
            rId: rId,
            wId: wId
        })
    })
})

// 写作结果页面
router.get("/write/translate/fourth", (req, res, next) => {
    if (!req.session.user) {
        res.redirect("/login");
        return;
    }
    var mId = req.query.mId;
    var id = req.query.id;
    var mock = req.query.mock ? req.query.mock : 0,
        mockRId = req.query.mockRId ? req.query.mockRId : 0,
        sId = req.query.sId ? req.query.sId : ",",
        rId = req.query.rId ? req.query.rId : ",",
        lId = req.query.lId ? req.query.lId : ",",
        wId = req.query.wId ? req.query.wId : ",";
    if (mock * 1) {
        id = wId.split(",")[0];
        if (id) {
            res.redirect("/exercise/write/translate/test?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId);
        } else {
            res.redirect("/mock/result?id=" + id + "&mock=" + mock + "&mockRId=" + mockRId + "&mId=" + mId + "&sId=" + sId + "&rId=" + rId + "&lId=" + lId + "&wId=" + wId)
        }
    } else {
        Write.findAnswerRecord(mId, id, (err, rows) => {
            if (err) {
                res.send(err);
            }
            res.render("exercise/writeR.html", JSON.parse(JSON.stringify({
                data: rows
            })))
        })
    }
})

function findDays(arr) {
    var day = [];
    arr.forEach((time, index) => {
        arr[index] = new Date(time.startTime * 1000).toLocaleDateString();
    })
    arr.forEach((time) => {
        if (day.indexOf(time) == -1) {
            day.push(time)
        }
    })
    return day.length;
}
module.exports = router;