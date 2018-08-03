var express = require('express');
var router = express.Router();

var guideRoute = require("./guide");
var exerciseRoute = require("./exercise");
var mockRoute = require("./mock");
var userCenter = require("./userCenter");
var userRecord = require("./userRecord");
var Member = require("../models/member");
var sendSMS = require("../util/sendSMS");
var URLUtils = require("../util/URLUtils");

var interceptPath = require("./interceptPath");



//客户端全局拦截器
router.use(function(req, res, next){
	
	
	//需要拦截的路径
	 
	var realURL = URLUtils.getUrlLevelArray(req.originalUrl);
	
	
	//全局ejs添加session 全局ejs添加request
	res.locals.request = req;
	res.locals.request.session = req.session;
	res.locals.URLUtils = URLUtils; //全局路径处理类

	
	
	//如果在拦截数组中则进行验证
	if (interceptPath.indexOf(realURL.path) > -1) {
		if (!req.session.user) {
			res.redirect('/login');
			return;
		}
	}
	next();
});



/* 注册 */
router.post('/register', (req, res, next) => {
	var account = req.body.username;
	var nickname = req.body.nickname;
	var password = req.body.password;
	var phoneNum = account;
	// 注册
	Member.reg(nickname, account, password, phoneNum, (err, sta) => {
		if (err) {
			res.render('register.html', {
				errMsg: '注册失败,请联系网站管理员'
			});
			return;
		}
		res.render('login.html');
	});
});



//发送短信验证码

router.get('/index/sendSms/:phoneNum', (req, res, next) => {
	var phoneNum = req.params.phoneNum;
	if (phoneNum) {
		sendSMS.send(phoneNum, (resCode) => {
			res.send({
				code: resCode.code
			});
		});
	} else {
		res.send({
			code: 000,
			err: '电话号码错误'
		})
	}
});

/* 登录 */
router.post('/login', (req, res, next) => {
	var account = req.body.username;
	var password = req.body.password;
	Member.login(account, password, (err, rows) => {
		if (err) {
			res.send(err);
			res.render('login.html', {
				errMsg: '登录过程发生错误'
			});
		}
		if (rows == "defeat") {
			//写入session
			res.render('login.html', {
				errMsg: '账号或密码错误'
			});
		} else {
			req.session.user = rows[0];
			res.redirect('/');
		}
	});
});


/* 退出登录 */
router.get('/logout', (req, res, next) => {
	req.session.destroy(function(err){
		if(err){
			console.log("清除cookie错误");
		}
		res.clearCookie();
		res.redirect('/');
	})
});






/* GET home page. */
router.get('/', (req, res, next) => {
	res.render('index.html');
});

/* Get Login page */
router.get('/login', (req,res,next)=>{
	res.render('login.html');
});




/* Get Login page */
router.get('/register', (req, res, next) => {
	res.render('register.html');
});




router.use('/guide', guideRoute);
router.use('/exercise', exerciseRoute);
router.use('/mock', mockRoute);
router.use('/user/userRecord', userRecord);
router.use('/user', userCenter);




module.exports = router;