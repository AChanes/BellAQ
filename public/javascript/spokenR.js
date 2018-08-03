/**
 * Created by niezhenke on 2017/7/4.
 */
$(document).ready(function () {
    //暂停播放
    playTopause();
    //拖拽改变进度
    var oAudio = document.getElementById('hearingAudio');
    if (oAudio) {

        var maxLeft = $('.audioWrap').css('width').replace(/px/g, '') - $('.Tn-herdrag').css('width').replace(/px/g, '');

        oAudio.oncanplay = function () {
            var aTime = zerofill(Math.floor(this.duration / 60), 2) + ':' + zerofill(Math.floor(this.duration % 60), 2);
            $('.Tn-hertime').html(aTime);
        };

        $('.Tn-herdrag').mousedown(function (ev) {
            var oEvent = ev || event;
            var disX = oEvent.clientX - $('#drag').position().left;

            var left = 0;
            document.onmousemove = function (ev) {
                var oEvent = ev || event;
                left = oEvent.clientX - disX;
                if (left < 0) left = 0;
                if (left > maxLeft) left = maxLeft;
                $('#drag').css('left', left);
            };
            document.onmouseup = function () {

                var duration = oAudio.duration;
                var scale = left / maxLeft * duration;
                oAudio.currentTime = scale;

                //进度时间
                var sTime = zerofill(Math.floor(oAudio.currentTime / 60), 2) + ':' + zerofill(Math.floor(oAudio.currentTime % 60), 2);
                $('.Tn-hertime').html(sTime);
                $('.Tn-herdrag').get(0).releaseCapture && $('.Tn-herdrag').get(0).releaseCapture();
                document.onmousemove = null;
                document.onmouseup = null;
            };
            $('.Tn-herdrag').get(0).setCapture && $('.Tn-herdrag').get(0).setCapture();
            oEvent.cancelBubble = true;
            oEvent.stopPropagation();
            return false;
        });

        //监听改变播放时间
        oAudio.ontimeupdate = function () {
            $('#drag').css('left', oAudio.currentTime / oAudio.duration * maxLeft);
            var sTime = zerofill(Math.floor(oAudio.currentTime / 60), 2) + ':' + zerofill(Math.floor(oAudio.currentTime % 60), 2);
            $('.Tn-hertime').html(sTime);
        };
    }



    //点击变化播放速度
    var speedArr = ['1.0', '1.25', '1.5', '1.8', '0.5', '0.75'];
    var speedNum = 0;
    $('#rate').click(function () {
        speedNum++;
        if (speedNum == speedArr.length) speedNum = 0;
        oAudio.playbackRate = speedArr[speedNum];
        $(this).html('x' + speedArr[speedNum]);
    });
    //播放结束后
    oAudio.onended = function () {
        oAudio.currentTime = 0;
        $('#paly').css('background',"url('/images/Tn-bgpublic.png') no-repeat #fff -8px -85px");
       
    };

    //重听听力听完之后
    var repeatAudio = document.getElementById('doubleTl');
    if (repeatAudio) {
        repeatAudio.onended = function () {
            this.currentTime = 0;
            $('a[data-id="repeat"]').css('background', "url('/images/volumeone.png') no-repeat");
          
        };
    }

    //控制音量大小

    $('#volume').click(function () {
        if ($('.tlvolumeWrapper').css('display') == 'none') {
            $('.tlvolumeWrapper').show();
        } else {
            $('.tlvolumeWrapper').hide();
        }
    });

    var oDrag = document.getElementById('audoRange');
    var oSpeed = document.querySelector('#progress');
    var oLine = document.getElementById('speed');

    //设置默认音量大小
    (function () {
        var maxWidth = getStyle(oSpeed, 'width').replace(/px/g, '');
        var ballWidth = getStyle(oDrag, 'width').replace(/px/g, '');
        var maxLeftVo = maxWidth - ballWidth;
        oAudio.volume = 0.5;
        oLine.style.width = oAudio.volume * 100 + '%';
        oDrag.style.left = oAudio.volume * maxLeftVo + 'px';
        oDrag.onmousedown = function (ev) {
            var oEvent = ev || event;
            var disX = oEvent.clientX - this.offsetLeft;
            document.onmousemove = function (ev) {
                var oEvent = ev || event;
                var left = oEvent.clientX - disX;
                if (left < 0) left = 0;
                if (left > maxLeftVo) left = maxLeftVo;
                oDrag.style.left = left + 'px';
                oLine.style.width = left / maxLeftVo * 100 + '%';
                $("audio").each(function () {
                    this.volume = left / maxLeftVo;
                });
            };
            document.onmouseup = function () {
                document.onmousemove = null;
                document.onmouseup = null;
                oDrag.releaseCapture && oDrag.releaseCapture();
            };
            this.setCapture && this.setCapture();
            return false;
        };

        oSpeed.onclick = function (ev) {
            var oEvent = ev || event;
            var disX = oEvent.clientX - getDistance(this);
            var maxWidth = getStyle(this, 'width').replace(/px/g, '');
            var scale = disX / maxWidth;
            oDrag.style.left = disX + 'px';
            oLine.style.width = scale * 100 + '%';
            $("audio").each(function () {
                this.volume = scale;
            });
        };
    })();

    //参考信息音频播放器
    //循环拖拽改变进度。监听进度改变拖拽小球位置和时间
    recording();

    function recording() {
        var aAudio = document.querySelectorAll('#referenceAudioWrap audio');
        var aDrag = document.querySelectorAll('.Tn-min-bnt');
        var aSpeed = document.querySelectorAll('.Tn-min-bluline');
        var aNzkProgress = document.querySelectorAll('.Tn-min-linebig');
        var aTime = document.querySelectorAll('.Tn-min-wittime');
        var aPlayBtn = document.querySelectorAll('.Tn-min-witplay');
        var maxLeft = getStyle(aNzkProgress[0], 'width').replace(/[px]/g, '') - getStyle(aDrag[0], 'width').replace(/[px]/g, '');
        for (var i = 0; i < aDrag.length; i++) {
            aDrag[i].index = i;
            aAudio[i].index = i;
            aNzkProgress[i].index = i;

            aAudio[i].oncanplay = function () {
                var time = zerofill(Math.floor(this.duration / 60), 2) + ':' + zerofill(Math.floor(this.duration % 60), 2);
                aTime[this.index].innerHTML = time + '\'\'';
            };
            aDrag[i].onmousedown = function (ev) {
                var oEvent = ev || event;
                var disX = oEvent.clientX - this.offsetLeft;
                var _this = this;
                var left = 0;
                document.onmousemove = function (ev) {
                    var oEvent = ev || event;
                    left = oEvent.clientX - disX;
                    if (left < 0) left = 0;
                    if (left > maxLeft) left = maxLeft;
                    _this.style.left = left + 'px';
                };
                document.onmouseup = function () {
                    var scalc = left / maxLeft * aAudio[_this.index].duration;
                    aAudio[_this.index].currentTime = scalc;
                    aSpeed[_this.index].style.width = aAudio[_this.index].currentTime / aAudio[_this.index].duration * 100 + '%';
                    //进度时间
                    var sTime = zerofill(Math.floor(aAudio[_this.index].currentTime / 60), 2) + ':' + zerofill(Math.floor(aAudio[_this.index].currentTime % 60), 2);
                    aTime[_this.index].innerHTML = sTime + '\'\'';
                    document.onmousemove = null;
                    document.onmouseup = null;
                };
                oEvent.preventDefault();
                return false;
            };
            //播放完毕后换按钮重置时间为0
            aAudio[i].onended = function () {
                this.currentTime = 0;
                aPlayBtn[this.index].style.background = "url('/images/Tn-bgpublic.png') -17px -144px no-repeat rgb(255, 255, 255)";
            };
            //监听改变播放时间
            aAudio[i].ontimeupdate = function () {
                var left = this.currentTime / this.duration * maxLeft;
                aDrag[this.index].style.left = left + 'px';
                aSpeed[this.index].style.width = this.currentTime / this.duration * 100 + '%';
                var sTime = zerofill(Math.floor(this.currentTime / 60), 2) + ':' + zerofill(Math.floor(this.currentTime % 60), 2);
                aTime[this.index].innerHTML = sTime + '\'\'';
            };

            //点击进度条改变进度
            aNzkProgress[i].onclick = function (ev) {
                var oEvent = ev || event;
                var disX = oEvent.clientX - getDistance(this);
                var maxWidth = getStyle(this, 'width').replace(/px/g, '');
                var scale = disX / maxWidth;
                aDrag[this.index].style.left = disX + 'px';
                aSpeed[this.index].style.width = scale * 100 + '%';
                aAudio[this.index].currentTime = scale * aAudio[this.index].duration;
            };
        }
    }
});
//暂停播放
function playTopause() {
    var aAudio = document.querySelectorAll('audio');
    var aPlay = document.querySelectorAll('.playPau');
    for (var i = 0; i < aPlay.length; i++) {
        aPlay[i].index = i;
        aPlay[i].onclick = function () {
            for (var i = 0; i < aPlay.length; i++) {
                if (this.index !== i) {
                    aAudio[i].pause();
                    if (aPlay[i].getAttribute('data-id') == 'big') {
                        aPlay[i].style.background = "url('/images/Tn-bgpublic.png') no-repeat #fff -8px -85px";                    } else if (aPlay[i].getAttribute('data-id') == 'repeat') {
                        aPlay[i].style.background = "url('/images/volumeone.png') no-repeat";
                } else {
                        aPlay[i].style.background = "url('/images/Tn-bgpublic.png') no-repeat #fff -17px -144px";
                    }
                }
            }
            if (aAudio[this.index].paused) {
                aAudio[this.index].play();
                if (this.getAttribute('data-id') == 'big') {

                    this.style.background = "url('/images/Tn-bgpublic.png') no-repeat #fff -58px -133px";
                } else if (this.getAttribute('data-id') == 'repeat') {
                    this.style.background = "url('/images/volumetwo.png') no-repeat";
                }else {
                    this.style.background = "url('/images/Tn-bgpublic.png') no-repeat #fff -17px -177px";
                }
            } else {
                aAudio[this.index].pause();
                if (this.getAttribute('data-id') == 'big') {
                    this.style.background = "url('/images/Tn-bgpublic.png') no-repeat #fff -8px -85px"  ;    
                          } else if (this.getAttribute('data-id') == 'repeat') {
                    this.style.background = "url('/images/volumeone.png ')no-repeat";
                }else {
                    this.style.background = "url('/images/Tn-bgpublic.png') no-repeat #fff -17px -144px";
                }
            }

        };
    }
}

//获取元素到页面left距离
function getDistance(obj) {
    var left = 0;
    while (obj) {
        left += obj.offsetLeft;
        obj = obj.offsetParent;
    }
    return left;
}
//获取样式
function getStyle(obj, attr) {

    if (obj.currentStyle) {

        return obj.currentStyle[attr];

    }

    else {
        return getComputedStyle(obj, false)[attr];

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
