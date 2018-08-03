var Express = require("express"),
    jwt = require("jsonwebtoken"),
    Faker = require("faker"),
    acl = require('./acl');

var Router = Express.Router();

var session = require("express-session");
var FileStore = require('session-file-store')(session);
// Routers required

var adminRoute = require("./adminRoute");
var memberRoute = require("./memberRoute");
var questionBankRoute = require("./questionBankRoute");
var Administrator = require("../../models/administrator");
var memberRRoute = require("./memberRRoute");
var selfManagerRoute = require("./selfManagerRoute");
var AnswerR = require("../../models/answerR");


var key = 'beierenglish';
var createToken = function (user) {
    var token = jwt.sign(user, key);
    return token;
};


// mock user data

var mockUser = {
    _id: Faker.random.uuid(),
    username: Faker.internet.userName(),
    email: Faker.internet.email(),
    password: Faker.internet.password(),
    role: ''
}

module.exports = function (App) {


    //登录页面跳转
    Router.route("/login")
        .get((req, res, next) => { //页面跳转部分
            if (req.session.userToken) {
                res.redirect("/backend");
            } else {
                res.render("backEnd/login.html", {
                    title: "登录",
                    message:""
                });
            }
        })
        .post((req, res, next) => { //登录表单提交部分
            var username = req.body.username;
            var userpass = req.body.userpass;
            Administrator.login(username, userpass, function (err, rows) {
                if (err) {
                    res.send(err);
                } else {
                    if (rows[0] && username == rows[0].account && userpass == rows[0].password && rows[0].isUsed == '1') {
                        var user = {
                            id: rows[0].id,
                            username: req.body.username,
                            role: rows[0].role
                        }
                        req.session.regenerate(function (err) {
                            if (!err) {
                                req.session.userToken = createToken(user);
                                req.session.role = user.role;
                            } else {
                                return res.json(500, err);
                            }
                            res.redirect("/backend");
                        });
                    } else {
                        res.render('backEnd/login.html', {
                            message: "账号或密码错误",
                        })
                    }
                }

            })


            //TODO 加入登录验证判断 并且 将登录后部分个人信息传递到前端  并 存储到session
        });


    //退出
    Router.route("/logout")
        .get((req, res, next) => { //页面跳转部分
            req.session.destroy(function (err) {
                if (!err) {
                    res.clearCookie('beier');
                }
                res.redirect('/backend'); //fix session-file-save bug
            })
        })



    // 加载ACL 权限控制中间件
    Router.use(acl.authorize.unless({
        path: ['backend/login']
    }));






    Router.use((req, res, next) => {
        var token = req.session.userToken; // 这部分目前模拟  与 数据库进行用户验证 TODO
        if (token) {
            req.headers['x-access-token'] = token || '';
            next();
        } else {
            return res.redirect('/backend/login');
        }
    });


    //后台headers加入token钩子
    Router.use((req, res, next) => {
        var token = req.headers['x-access-token'];
        jwt.verify(token, key, (err, decoded) => {
            if (err) {
                return res.json(500, err);
            } else {
                //如果没有登录 则无法获取到权限 则主动判定跳转到登录界面去获取权限
                if (!decoded || !decoded.role) {
                    return res.redirect('/backEnd/login');
                } else {
                    res.locals.userToken = decoded;
                    res.locals.location = req.path;
                }
                next();
            }
        });
    });






    //首页路由
    Router.route(["/", '/index'])
        .get((req, res, next) => {
            var readCorrectRate, listenCorrectRate, writeAverageScore,questionTop,scoreTop;
            AnswerR.read((err,rows)=>{
                if(err){
                    res.send(err);
                }
                readCorrectRate = rows[0].readCorrectRate;
                AnswerR.listen((err,rows_1)=>{
                    if(err){
                        res.send(err);
                    }
                    listenCorrectRate = rows_1[0].listenCorrectRate;
                    AnswerR.wirte((err,rows_2)=>{
                        if(err){
                            res.send(err);
                        }
                        writeAverageScore = rows_2[0].writeAverageScore;
                        AnswerR.findQuestionTop((err,rows_3)=>{
                            if(err){
                                res.send(err);
                            }
                            questionTop = rows_3;
                            AnswerR.findScoreTop((err,rows_4)=>{
                                if(err){
                                    res.send(err);
                                }
                                scoreTop = rows_4;
                                AnswerR.spoken((err,rows_5)=>{
                                    if(err){
                                        res.send(err);
                                    }
                                    res.render("backEnd/index.html",JSON.parse(JSON.stringify( {
                                        times:rows_5[0].times,
                                        readCorrectRate:readCorrectRate,
                                        listenCorrectRate:listenCorrectRate,
                                        writeAverageScore:writeAverageScore,
                                        questionTop:questionTop,
                                        scoreTop:scoreTop,
                                        title: "首页"
                                    })));
                                })
                                
                            })
                        })
                    })
                })
            })
        });


    Router.use("/sadmin", adminRoute);
    Router.use("/questionBank", questionBankRoute);
    Router.use("/members", memberRoute);
    Router.use("/memberRs", memberRRoute);
    Router.use("/selfManager",selfManagerRoute);
    
   
    App.use('/backend', Router);
}