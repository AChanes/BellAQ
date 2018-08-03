$("#nextContinue").click(function () {
    window.location = $(this).attr("href");
})
var myVid = document.getElementById("hear2");

var left, ding;

left = parseInt($('#proR').css('width')) / parseInt(myVid.duration);
ding = setInterval(function () {

    $('#speed').css('left', -(parseInt($('#proR').css('width'))) + (parseInt(myVid.currentTime) * left) + 'px');
}, 1000);

function end() {
    window.location.href = $("#nextContinue").attr("href");
}