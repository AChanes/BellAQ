$("#next").click(function () {
    window.location = $(this).attr("href");
})
var myVid = document.getElementById("playad");
var left, ding;

left = parseInt($('#proR').css('width')) / parseInt(myVid.duration);
ding = setInterval(function () {

    $('#speed').css('left', -(parseInt($('#proR').css('width'))) + (parseInt(myVid.currentTime) * left) + 'px');
}, 1000);

function end() {
    window.location = $("#next").attr("href");
}
