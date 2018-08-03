
var str = JSON.stringify(Date.parse(new Date()));
window.sessionStorage.setItem('spokenTime', str);


$("#next").click(function () {
    window.location = $(this).attr("href");
})