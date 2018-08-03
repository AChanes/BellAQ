var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var session = require("express-session");
var FileStore = require('session-file-store')(session);
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var ejs = require('ejs');
var multer = require("multer");
var ueditor = require("ueditor");


//前端  客户端  入口
var index = require('./routes/index');



var Ausers = require('./routes/api/users');
var AanswerRs = require("./routes/api/answerRs");
var Aclockins = require("./routes/api/clockins");
var Alistens = require("./routes/api/listens");
var Alistenqs = require("./routes/api/listenqs");
var Amembers = require("./routes/api/members");
var AmemberRs = require("./routes/api/memberRs");
var Amockexams = require("./routes/api/mockexams");
var Aspeaks = require("./routes/api/speaks");
var Atargets = require("./routes/api/targets");
var Awrites = require("./routes/api/writes");
var Atopics = require("./routes/api/topics");
var Areads = require("./routes/api/reads");
var Areadqs = require("./routes/api/readqs");


var app = express();

var backEnd = require("./routes/backend/index");


// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json({
  limit: "50mb"
}));
app.use(bodyParser.urlencoded({
  limit: "50mb",
  extended: true
}));
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.json());

app.engine("html", ejs.__express);
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use("/ueditor/ue", ueditor(path.join(__dirname, "public"), function (req, res, next) {
  //客户端上传文件设置
  var ActionType = req.query.action;
  if (
    ActionType === "uploadimage" ||
    ActionType === "uploadfile" ||
    ActionType === "uploadvideo"
  ) {
    var file_url = "/images/ueditor/"; //默认图片上传地址
    /*其他上传格式的地址*/

    if (ActionType === "uploadfile") {
      file_url = "/file/ueditor/"; //附件
    }
    if (ActionType === "uploadvideo") {
      file_url = "/video/ueditor/"; //视频
    }
    res.ue_up(file_url); //你只要输入要保存的地址 。保存操作交给ueditor来做
    res.setHeader("Content-Type", "text/html");
  } else if (req.query.action === "listimage") {
    //  客户端发起图片列表请求
    var dir_url = "/images/ueditor/";
    res.ue_list(dir_url); // 客户端会列出 dir_url 目录下的所有图片
  } else {
    // 客户端发起其它请求
    res.setHeader("Content-Type", "application/json");
    res.redirect("/ueditor/nodejs/config.json");
  }
}));
// process.setgid(501)

// ueditor配置
app.use(
  bodyParser.urlencoded({
    extended: true
  })
);


app.use(cookieParser());
app.use(session({
  secret: 'beier_session',
  name: 'beier',
  resave: false,
  store: new FileStore(),
  saveUninitialized: false,
  cookie: {
    maxAge: 1000 * 60 * 60 * 6
  }
}))


//界面跳转部分
app.use('/', index);


//api部分
app.use('/api/users', Ausers);
app.use("/api/answerRs", AanswerRs);
app.use("/api/clockins", Aclockins);
app.use("/api/listens", Alistens);
app.use("/api/listens", Alistens);
app.use("/api/listenqs", Alistenqs);
app.use("/api/members", Amembers);
app.use("/api/memberRs", AmemberRs);
app.use("/api/mockexams", Amockexams);
app.use("/api/reads", Areads);
app.use("/api/readqs", Areadqs);
app.use("/api/speaks", Aspeaks);
app.use("/api/targets", Atargets);
app.use("/api/writes", Awrites);
app.use("/api/topics", Atopics);

backEnd(app);
// catch 404 and forward to error handler
// app.use(function(req, res, next) {
//   next(createError(404));
// });

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  // res.locals.message = err.message;
  // res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  console.log(err)
  // res.render("error.html")
});


module.exports = app;