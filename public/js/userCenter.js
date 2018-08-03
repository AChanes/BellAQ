var tar, time, score;
$(function(){
    $('.Tn-bnt-public.punchClockBtn').click(function(e){
        $('.popupWindowBg').removeClass('popupDisplay');
          $('.popupWindowContainer').removeClass('popupDisplay');

    })
})
$(function () {
    $('.closeBtn').click(function (e) {
        $('.popupWindowBg').addClass('popupDisplay');
        $('.popupWindowContainer').addClass('popupDisplay');

    })
})
  $('.grade').click(function (e) {
     $(this).addClass('btnOn').siblings().removeClass('btnOn');
        score=$(this).attr('grade');
});

  $('#sel').on('change', function () {
   tar= $(this).val();

  })
    $('#time').on('change', function () {
        var time2 = formatDate(new Date()) ;
        if ($(this).val() > time2) {
            time=$(this).val();
      }else{
          alert('时间有误')
      }
    })
    
    function formatDate(now) {
        var year = now.getFullYear();
        console.log(now.getFullYear());
        var month = now.getMonth() + 1;
        var date = now.getDate();
        return year + "-" + (month>10?month:'0'+month) + "-" + date;
    }
    $('.onBegin').click(function () {
        console.log(888);
    if (tar && time && score){
       $.ajax({
           type: 'post',
           url: '/api/targets/addTarget',
           data: {
               mId: $('#mid').val(),
               dId: parseInt(tar),
               complete: time,
               score: parseInt(score)

           },
           success: function (data) {
            console.log(data);
               window.location ='/user';

           },
           complete: function () {
             $('.popupWindowBg').addClass('popupDisplay');
             $('.popupWindowContainer').addClass('popupDisplay');
           }
       })
    }else{
        alert('请选择内容');
    }
  
  });