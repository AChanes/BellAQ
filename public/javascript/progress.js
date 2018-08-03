var moveX;
var max;
var yuan = document.getElementById("yuan");
var jindu = document.getElementById("jindu");
var tiao = document.getElementById("tiao");
var tiaoW = tiao.offsetWidth;
var audio = document.getElementById("playad");
//点击显示进度条
$('#volume').click(function () {
    if ($('.tlvolumeWrapper').css('display') == 'none') {
        $('.tlvolumeWrapper').show();
    } else {
        $('.tlvolumeWrapper').hide();
    }
});
window.onload=function(){
    yuan.style.marginLeft =100 + "px";
    jindu.style.width = + "px";
   maxW= tiao.offsetWidth - yuan.offsetWidth;
    var num=audio.volume;
    yuan.style.marginLeft = maxW * num + "px";
    jindu.style.width =maxW*num + "px";
    
   
}
    var isfalse = false; //控制滑动
    yuan.onmousedown = function (e) {
        isfalse = true;
        var X = e.clientX; //获取当前元素相对于窗口的X左边
        var offleft = this.offsetLeft; //当前元素相对于父元素的左边距
         max = tiao.offsetWidth - this.offsetWidth; //宽度的差值
        document.body.onmousemove = function (e) {
            if (isfalse == false) {
                return;
            }
            var changeX = e.clientX; //在移动的时候获取X坐标
            moveX = Math.min(max, Math.max(-2, offleft + (changeX - X))); //超过总宽度取最大宽
            yuan.style.marginLeft = Math.max(0, moveX) + "px";
            jindu.style.width = moveX + "px";
        }
    }
function toDecimal(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return;
    }
    f = Math.round(x * 100) / 100;
    return f;
} 
    yuan.onmouseup = function () {

        audio.volume=toDecimal(moveX/max);
        
        isfalse = false;
    }

  
    

