 function myfunc(data) {  //自己的函数   可以对data 这个数据对象进行操作或遍历数据  
    console.log(data);
} 

function ajaxs(modth, url, data,func) {
    $.ajax({
        type: modth,
        url: 'http://localhost:3000/api'+url,
        data: data,
        error: function (data) {
            //请求失败时被调用的函数   
            // alert("传输失败:" + data);
            console.log(data);
        },
        success: function (data) {
            //成功后的调用方法
            func(data);
        }
    });
}
function ajaxn(modth, url, data) {
    
    $.ajax({
        type: modth,
        url: 'http://localhost:3000/api'+url,
        data: data
    });
}
function ajaxa(modth, url, data) {

    $.ajax({
        type: modth,
        url: url,
        data: data
    });
}