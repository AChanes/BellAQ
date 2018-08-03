$(() =>{

    
    
    var smsCode = ''; //验证码变量
    
    
    //短信发送
    var sendSms = (callback) => {
        $.get('/index/sendSms/' + $("#phoneNum").val() , (res,err) =>{
            console.log(res);
            callback(res);
        });
    } 


    
    
    
    //获取短信验证码
    $("#getSmsBtn").click((e)=>{
        if($("#register #phoneNum").valid()){
            
            var countdown = $(e.target).data('countdown');
            if(!countdown || countdown == 0){
                console.log("可以发送");
                sendSms( num => {
                    smsCode = num.code;
                    countdown = 180; // 倒数时间
                    $(e.target).attr("disabled", "disabled");
                    $(e.target).val(`${countdown} 秒重新发送`);
                    var countSid = setInterval(() => {
                        if (countdown == 0) {
                            $(e.target).data('countdown', 0);
                            $(e.target).val("发送短信验证码");
                            $(e.target).removeAttr("disabled");
                            clearInterval(countSid);
                        } else {
                            --countdown;
                            $(e.target).data('countdown', countdown);
                            $(e.target).val(`${countdown} 秒重新发送`);
                        }
                    }, 1000);
                });
            }
        }
    });


    $.validator.addMethod("smsCode",(num)=>{
        return smsCode != '' && num == smsCode;
    },'验证码不正确');
    //登录验证
    $("#login").validate({
        rules: {
            username: {
                required: true,
                minlength:6,
                maxlength:12,
                normalizer: function (value) {
                    return $.trim(value);
                }
            },
            password: {
                required: true,
                minlength: 6,
                maxlength: 12,
                normalizer: function (value) {
                    return $.trim(value);
                }
            }
        },
        messages : {
            username: {
                required: "请输入用户名"
            },
            password: {
                required: "请输入密码"
            },
        }
    });


    //注册表单验证
    $("#register").validate({
        rules: {
            username: {
                required: true,
                minlength:6,
                maxlength:12,
                normalizer: function (value) {
                    return $.trim(value);
                }
            },
            nickname: {
                required: true,
                rangelength:[1,6],
                normalizer: function (value) {
                    return $.trim(value);
                }
            },
            password: {
                required: true,
                minlength: 6,
                maxlength: 12,
                normalizer: function (value) {
                    return $.trim(value);
                }
            },
            repassword: {
                required: true,
                minlength: 6,
                maxlength: 12,
                equalTo : "#password",
                normalizer: function (value) {
                    return $.trim(value);
                }
            },
            sms : {
                required : true,
                rangelength: [6,6],
                smsCode : "#sms"
            },
            phoneNum : {
                required : true,
                number : true,
                rangelength : [11,11]
            }
        },
        messages : {
            username: {
                required: "请输入用户名"
            },
            nickname: {
                required: "请输入昵称"
            },
            password: {
                required: "请输入密码"
            },
            repassword:{
                required: "请确认重复密码",
                equalTo : "请确保两次密码输入一致"
            },
            sms : {
                required: "请输入短信验证码",
                rangelength: "请输入正确的验证码",
            },
            phoneNum : {
                required: "请输入手机号",
                rangelength: "请输入11位手机号",
                number : "请输入正确的手机号"
            }
        }
    });
});

