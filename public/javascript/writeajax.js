
if (!sessionStorage.writeTime){
    var str = JSON.stringify(Date.parse(new Date()));
    window.sessionStorage.setItem('writeTime', str);
}

function getValue() {

    var info = location.search;

    info = info.length > 0 ? info.substring(1) : " ";

    var result1 = info.split("&");
  
    var key, value;
    var data = [];
    for (var i = 0; i < result1.length; i++) {

        var result2 = result1[i].split("=");
        key = result2[0];
        value = result2[1];
        data[key] = value;
    }
    return data;
}
$("#next").click(function () {
    var text = $('#wtTextArea').text();
    var self = $(this);
    var arr=getValue();
    
    if (text) {
        $.ajax({
            type: 'post',
            url: '/api/answerRs/addAnswerR',
            data: {
                mId: $('#mid').val(),
                materialId: $('#id').val(),
                tyId:4,
                startTime: sessionStorage.writeTime,
                title: $('.nav-tf p').text(),
                isM: arr["mockRId"] ? arr["mockRId"] : 0,
                wContent: $('#wtTextArea').text()
            },
            success: function (data) {
                if (data == 'success') {

                    window.location = self.attr("href");
                }
            }

        })

    }
})
