var recorder, intervalid, dao;
var i = 15;
recorder = new MP3Recorder({
    debug: true,
    funOk: function () {

    },
    funCancel: function (msg) {

        recorder = null;
    }
});

function mytime() {
    $('#luyin').css('display', 'block');
    intervalid = setInterval("fun()", 1000);
}

function fun() {
    if (i == 0) {
        clearInterval(intervalid);
        dao = setInterval('countDown()', 1000);

        funStart();
    } else {
        i--;
        $("#readyTime").text(i + 'Seconds');
    }
}

//设置倒计时时间为60秒  
var daotime = 45;     //倒计时的方法  
function countDown() {
    $('#stop').css('display', 'block');
    if (daotime > 0) {

        daotime--;
        console.log(daotime);
        $('#rsTime').text(daotime + 'Seconds');
    } else {
        funStop();
        clearInterval(set);
    }
}
var mp3Blob;
function funStart() {
    clearInterval(intervalid);
    clearInterval(dao);
    set = setInterval('countDown()', 1000);
    // log('录音开始...');
    recorder.start();
}

function funStop() {
    clearInterval(set);
    recorder.stop();
    // log('录音结束，MP3导出中...');
    recorder.getMp3Blob(function (blob) {
        // log('MP3导出成功');
        mp3Blob = blob;
        console.log(mp3Blob, blob);
        funUpload();
    });
}
function getValue() {
    /*获取请求信息*/
    var info = location.search;
    /*去除？*/
    info = info.length > 0 ? info.substring(1) : " ";
    /*以&分割字符串*/
    var result1 = info.split("&");
    /*存储key和value的数组*/
    var key, value;
    var data = [];
    for (var i = 0; i < result1.length; i++) {
        /*以=分割字符串*/
        var result2 = result1[i].split("=");
        key = result2[0];
        value = result2[1];
        data[key] = value;
    }
    return data;
}

//点击上传录音
function funUpload() {
    var arr=getValue()
    var fd = new FormData();
    $('#stop').attr('disabled', true);
    var mp3Name = encodeURIComponent('audio_recording_' + new Date().getTime() + '.mp3');
    fd.append('mp3Name', mp3Name);
    fd.append('mp4', mp3Blob);
    fd.append('startTime',sessionStorage.spokenTime);
    fd.append('isM', arr["mockRId"] ? arr["mockRId"] : 0,)
    fd.append("title", $('#title').val());
    fd.append("mId", $('#mid').val());
    fd.append('tyId', 1);
    fd.append('materialId', $('#materialId').val());
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            if (xhr.responseText == 'success') {

                window.location = $('#gorust').attr("href");

            };
        }
    };

    xhr.open('POST', '/api/answerRs/addAnswerR');
    xhr.send(fd);
}