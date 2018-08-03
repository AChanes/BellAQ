$(function(){
    
    $("#signIn").hide();

    
    $(".login-font").delegate('.loginBtn', 'click', function(){
        $("#login").show();
        $("#signIn").hide();
        $('.myapp-login-logo-text span').text(" 登录 ");
        
        $(".login-font").html(`
            <i class="loginBtn"> 登录 </i>
                or
            <span class="signBtn"> 注册 </span>
        `);
        // window.sessionStorage.user=
    });


    

    $(".login-am-center").delegate('.signBtn', 'click', function () {
        $("#signIn").show();
        $("#login").hide();
        $('.myapp-login-logo-text span').text(" 注册 ");

        $(".login-font").html(`
            <span class="loginBtn"> 登录 </span>
                or
            <i class="signBtn"> 注册 </i>
        `);
    });

})