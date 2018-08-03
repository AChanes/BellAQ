function getDistance(obj) {
    var left = 0;
    while (obj) {
        left += obj.offsetLeft;
        obj = obj.offsetParent;
    }
    return left;
}
//获取样式
function getStyle(obj, sName) {
    if (obj.currentStyle) {
        return obj.currentStyle[sName];
    } else {
        return getComputedStyle(obj, false)[sName]
    }
}




//补零
function zerofill(num, n) {
    var len = num.toString().length;
    while (len < n) {
        num = "0" + num;
        len++;
    }
    return num;
}
$('#qbtn').on('click', function () {
    var qmp4 = $('#qmp4')[0];
    if (qmp4.paused) {
        qmp4.play();
        $(this).css('background', 'url("/images/volumetwo.png") no-repeat');
    } else {
        $(this).css('background', 'url("/images/volumeone.png") no-repeat');
        qmp4.pause();
    }



})
function sec_to_time(s) {
    var t;
    if (s > -1) {
        var hour = Math.floor(s / 3600);
        var min = Math.floor(s / 60) % 60;
        var sec = s % 60;
        if (hour < 10) {
            t = '0' + hour + ":";
        } else {
            t = hour + ":";
        }
        if (min < 10) { t += "0"; }
        t += min + ":";
        if (sec < 10) { t += "0"; }
        t += sec.toFixed(2);
    }
    return t.split('.')[0];
}

var myVid = document.getElementById("playad");
var curr, time, left, ding;
    //点击播放事件
    function playPause() {
        left = parseInt($('#jin').css('width')) /parseInt(myVid.duration);

   
    if (myVid.paused) {
        myVid.play();
        ding = setInterval(function () {
          
            $('.speedTime').text(sec_to_time(Math.round(myVid.currentTime)));
            $('.dragBar').css('left', Math.round(myVid.currentTime) * left + 'px');
            $(".progressBar").css('width', Math.round(myVid.currentTime) * left + 'px')
        }, 100);
        $('#nzkPlay').css('background', 'url(/images/bigplay2.png)no-repeat ');
    } else {
        clearInterval(ding);
        myVid.pause();
        $('#nzkPlay').css('background', 'url(/images/bigplay1.png) no-repeat ');
    }
}
function mytime() {
    clearInterval(ding);
    curr = 0;
    $('#nzkPlay').css('background', 'url(/images/bigplay1.png)no-repeat ');
    $('.dragBar').css('left','0px');
    $(".progressBar").css('width','0px');
    $('.Tn-hertime').text('00:00');
}

function speakingAudio() {
    //显示隐藏控制音量大小
    (function () {
        var aShowVolume = document.querySelectorAll('.volume');
        var aTlvolumeWrapper = document.querySelectorAll('.tlvolumeWrapper');
        for (var i = 0; i < aShowVolume.length; i++) {
            aShowVolume[i].index = i;
            aShowVolume[i].onclick = function () {
                for (var i = 0; i < aShowVolume.length; i++) {
                    if (this.index != i) {
                        aTlvolumeWrapper[i].style.display = 'none';
                    }
                }
                if (aTlvolumeWrapper[this.index].style.display == 'block') {
                    aTlvolumeWrapper[this.index].style.display = 'none';
                } else {
                    aTlvolumeWrapper[this.index].style.display = 'block';
                }
            };
        }
    })();
}

//点击材料显示
$(document).on('click', '#Ma', function () {
    $('#pM').css('display', 'block');
    $('#po').css('display', 'none');
    $(this).css('background', 'blue').siblings().css('background', '#FFF');
    $(this).css('color', '#FFF').siblings().css('color', 'blue');

})
//点击原文内容显示
$(document).on('click', '#or', function () {
    $('#po').css('display', 'block');
    $('#pM').css('display', 'none');
    $(".strong").css("color", "rgb(51, 51, 51)");
    $(this).css('background', 'blue').siblings().css('background', '#FFF');
    $(this).css('color', '#FFF').siblings().css('color', 'blue');
})
