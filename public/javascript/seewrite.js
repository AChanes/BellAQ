$('#qbtn').on('click', function () {
    var qmp4 = $('#qmp4')[0];;
    if (qmp4.paused) {
        qmp4.play();
        $(this).css('background', 'url("/images/volumetwo.png") no-repeat');
    } else {
        $(this).css('background', 'url("/images/volumeone.png") no-repeat');
        qmp4.pause();
    }

    // $(this).css()
})

var myVid = document.getElementById("playad");
var curr, time, left, ding;
window.onload = function () {
    var maxW=parseInt($('#jin').css('width'))- parseInt($('.dragBar').css('width'));
    left = (maxW/(myVid.duration.toFixed(1)*1)).toFixed(1)*1;

}
//点击播放事件
function playPause() {
    if (myVid.paused) {
        myVid.play();
        ding = setInterval(function () {
            curr = myVid.currentTime.toFixed(1) * 1;
            $('.speedTime').text('00:' + (curr< 10? '0' + curr : curr));
            $('.dragBar').css('left', Math.ceil(curr * left) + 'px');
            $(".progressBar").css('width', Math.ceil(curr * left)+ 'px')
        }, 200);
        $('.nzkPlay').css('background', 'url(/images/bigplay2.png)no-repeat ');
    } else {
        clearInterval(ding);
        myVid.pause();
        $('.nzkPlay').css('background', 'url(/images/bigplay1.png) no-repeat ');
    }
}
function end() {
    clearInterval(ding);
    $('.dragBar').css('left','0px');
    $(".progressBar").css('width',"0px");
    $('.nzkPlay').css('background', 'url(/images/bigplay1.png) no-repeat ');

}
//点击材料显示
$(document).on('click', '#og', function () {
    $('.nzkShowPicture').css('display', 'none');
    $("#article").css('display', 'block');

    $(this).css('background', 'blue').siblings().css('background', '#FFF');
    $(this).css('color', '#FFF').siblings().css('color', 'blue');

})
//点击img显示
$(document).on('click', '#im', function () {
    $('.nzkShowPicture').css('display', 'block');
    $("#article").css('display', 'none');

    $(this).css('background', 'blue').siblings().css('background', '#FFF');
    $(this).css('color', '#FFF').siblings().css('color', 'blue');
})