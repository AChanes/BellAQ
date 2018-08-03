var axios = require("axios");
var qs = require("qs");
var SendMsg={}
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8';
SendMsg.send =  function (phoneNum, callback) {
    var url = "https://mb345.com/ws/LinkWS.asmx/Send";
    var code ='';
    for(var i  = 0;i<6;i++){
        code += Math.floor(Math.random() * 10);
    }
    var obj = {
        CorpID: 'LKSDK0004000',
        Pwd:'123456@',
        Mobile:phoneNum,
        Content:"验证码是"+code+"【知行软件学院】",
        Cell:'',
        SendTime:''
    }
    axios.post(url, qs.stringify(obj))
        .then(function (response) {
            callback({status:response.status,code:code})
         }).catch(function (error) {
                if (error) {
                    // 请求已发出，但服务器响应的状态码不在 2xx 范围内
                    console.log(error.response.data);
                    console.log(error.response.status);
                    console.log(error.response.headers);
                } else {
                        // Something happened in setting up the request that triggered an Error
                        console.log('Error', error.message);
                    }
                    console.log(error.config);
                });

    }
module.exports = SendMsg;