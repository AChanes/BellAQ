var myVid = document.getElementById("hearingAudio");
var curr, time, left, ding, maxW;
maxW = parseInt($('#progress').css('width')) - parseInt($('#audoRange').css('width'));

function playPause() {
    left = maxW / parseInt(myVid.duration);
    if (myVid.paused) {
        myVid.play();
        $('.dragPlay').css('background', "url(/images/play2.png) no-repeat");
        ding = setInterval(function () {
            $('.nzkTime').text('00:' + ((Math.round(myVid.currentTime) < 10) ? '0' + Math.round(myVid.currentTime) : parseInt(myVid.currentTime)));
            $('#audoRange').css('left', Math.round(myVid.currentTime) * left + 'px');
            $("#speed").css('width', Math.round(myVid.currentTime) * left + 'px')
        }, 1000);

    } else {
        myVid.pause();
        clearInterval(ding);
        $('.dragPlay').css('background', "url(/images/play.png) no-repeat");
    }
}
function mytime() {
    clearInterval(ding);
    curr = 0;
    $('.dragPlay').css('background', "url(/images/play.png) no-repeat");
    $('#audoRange').css('left', curr * left + 'px');
    $('.nzkTime').text('00:00');
    $("#speed").css('width', curr * left + 'px')
}
var audiomp4Q = $('#audiomp4Q')[0];
$('#qmp4').on('click', function () {
    if (audiomp4Q.paused) {
        audiomp4Q.play();
        $(this).css('background', 'url("/images/volumetwo.png") no-repeat');
    } else {
        audiomp4Q.pause();
        $(this).css('background', 'url("/images/volumeone.png") no-repeat');
    }
})
$(document).on('click', '#nzkSee a', function () {
    $("#article").css('display', 'block');
    $('.showaRticle').css('display', 'none');
})
$(document).on('click', '.showAnswer', function () {
    $(".nzkCorrect").toggle();


})
//点击材料显示
$(document).on('click', '#og', function () {
    $('.nzkShowPicture').css('display', 'none');
    $("#article").css('display', 'block');
    $('.showaRticle').css('display', 'none');
    $(this).css('background', '#4574de').siblings().css('background', '#FFF');
    $(this).css('color', '#FFF').siblings().css('color', '#4574de');
    $('#chineseMaterial').css('display', 'none');
    $('#imgs').css('display', 'none');
})
//点击img显示
$(document).on('click', '#im', function () {
    $('#chineseMaterial').css('display', 'block');
    $("#article").css('display', 'none');
    $('#imgs').css('display', 'block');
    $('.showaRticle').css('display', 'none');
    $(this).css('background', '#4574de').siblings().css('background', '#FFF');
    $(this).css('color', '#FFF').siblings().css('color', '#4574de');
})
$("#article").html($("#article").text());
$("#chineseMaterial").html($("#chineseMaterial").text())