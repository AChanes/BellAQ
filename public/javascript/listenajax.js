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
function show() {
    obj = $("input[name='chkId']:checked");
    check_val = '';
    for (k in obj) {
        if (obj[k].checked)
            check_val += obj[k].value;
    }
    console.log(check_val);
    return check_val;
}

$("#next").click(function () {
    var self =$(this);
    var arr = getValue();
    var isRight = $("#isRight").val();
    var rightAnswer = $("#rightAnswer").val();
   var isD = $("#isD").val();
   var mAnswer = isD == '0' ? $("input[name='optionsRadios']:checked").val() : show()
    if (rightAnswer == mAnswer) {
        isRight = '1';
    }
    if (mAnswer) {
        console.log(mAnswer);
        
        $.ajax({
            type: 'post',
            url: '/api/answerRs/addAnswerR',
            data: {
                mId: arr["mId"],
                tyId: 3,
                materialId: arr["id"],
                isM: arr["mockRId"] ?arr["mockRId"]:0,
                numForM: arr["numForLM"]?arr["numForLM"]:1,
                mAnswer: mAnswer,
                startTime: sessionStorage.listenTime,
                title: $('.nav-tf p').text(),
                rightAnswer: $("#rightAnswer").val(),
                isRight: isRight,
                score: $('#score').val()
            },
            success: function (data) {
                console.log(data);
                if (data == 'success') {
                    window.location =self.attr("href");

                }
            }

        })

    }
})
$(document).on('click', '#backBtnHide', function () {
    window.location = $(this).attr("href");
})