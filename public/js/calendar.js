(function () {
    var Calendar = function (calendarObj) {
        this.currentId = calendarObj.currentId;
        this.currentYear = calendarObj.currentYear || (new Date()).getFullYear();
        this.currentMonth = calendarObj.currentMonth || (new Date()).getMonth() + 1;
        this.highlightArr = this.getHighlightArr() || [];
        this.TueDayCount = this.is_leap();
        this.month_days = [31, 28 + this.TueDayCount, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        this.weekSign = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
        this.monthSign = ['Jan.', 'Feb.', 'Mar.', 'Apr.', 'May.', 'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.'];
        this.firstDay = (new Date(this.currentYear, this.currentMonth - 1, 1)).getDay();//0-6 0周日
        this.isNext = false,
            this.isPrev = true;
        this.init();
    };
    Calendar.prototype = {
        init: function () {
            $('#' + this.currentId).html(
                '<div class="calendarTitle">' +
                '<div class="prevMouth"></div>' +
                '<span class="currentDate"><i>' + this.monthSign[this.currentMonth - 1] + '</i>' + this.currentYear + '</span>' +
                '<div class="nextMouth"></div>' +
                '</div>' +
                '<div class="calendarBody">' +
                '<ul class="week"></ul>' +
                '<ul class="day"></ul>' +
                '</div>'
            );
            //添加事件
            var _that = this;
            $('#' + this.currentId + ' .prevMouth').on('click', function () {
                _that.prevMonth();
            });
            $('#' + this.currentId + ' .nextMouth').on('click', function () {
                _that.nextMonth();
            });
            //初始化星期
            var weekStr = '';
            for (var w = 0; w < this.weekSign.length; w++) {
                weekStr += '<li>' + this.weekSign[w] + '</li>';
            }
            $('#' + this.currentId + ' .week').html(weekStr);

            this.dateFill();
        },
        dateFill: function () {
            $('#' + this.currentId + ' .currentDate').html('<i>' + this.monthSign[this.currentMonth - 1] + '</i>' + this.currentYear);
            //填充day
            var str = '';
            var tempArr = this.highlightArr;
            for (var i = 0; i < this.month_days[this.currentMonth - 1]; i++) {
                if (this.highlightArr[0] == (i + 1)) {
                    if (i + 1 <= 9) {
                        str += '<li class="center"><i>' + (i + 1) + '</i></li>';
                    } else {
                        str += '<li class="right"><i>' + (i + 1) + '</i></li>';
                    }
                    tempArr.shift();
                } else {
                    str += "<li><i>" + (i + 1) + "</i></li>"
                }
            }
            //补充前边位置
            var frontStr = '';
            if (this.firstDay > 0) {
                for (var j = 0; j < this.firstDay; j++) {
                    frontStr += '<li></li>';
                }
            }
            str = frontStr + str;
            //补充后边位置
            var endStr = "";
            // console.log((this.month_days[this.currentMonth-1]+this.firstDay) %7 ==0);
            if (!((this.month_days[this.currentMonth - 1] + this.firstDay) % 7 == 0)) {
                var mod = (this.month_days[this.currentMonth - 1] + this.firstDay) % 7;
                var int = (this.month_days[this.currentMonth - 1] + this.firstDay) / 7
                mod = 7 - mod;
                for (var i = 0; i < mod; i++) {
                    endStr += '<li></li>';
                }
            }
            str = str + endStr;
            $('#' + this.currentId + ' .day').html(str);
        },
        is_leap: function (year) {
            return (year % 100 == 0 ? (year % 400 == 0 ? 1 : 0) : (year % 4 == 0 ? 1 : 0));
        },
        nextMonth: function () {
            if (this.isNext) {
                if (this.currentMonth == 12) {
                    this.currentYear = this.currentYear + 1;
                    this.currentMonth = 1;
                    this.TueDayCount = this.is_leap();
                    this.month_days = [31, 28 + this.TueDayCount, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                    this.firstDay = (new Date(this.currentYear, this.currentMonth - 1, 1)).getDay();
                } else {
                    this.currentMonth = this.currentMonth + 1;
                    this.firstDay = (new Date(this.currentYear, this.currentMonth - 1, 1)).getDay();
                }
                //获取当前月的签到数据
                this.highlightArr = this.getHighlightArr() ? this.getHighlightArr() : [];
                this.dateFill();
            }
            this.isNextFun();
        },
        prevMonth: function () {
            if (this.isPrev) {
                if (this.currentMonth == 1) {
                    this.currentYear = this.currentYear - 1;
                    this.currentMonth = 12;
                    this.TueDayCount = this.is_leap();
                    this.month_days = [31, 28 + this.TueDayCount, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                    this.firstDay = (new Date(this.currentYear, this.currentMonth - 1, 1)).getDay();
                } else {
                    this.currentMonth = this.currentMonth - 1;
                    this.firstDay = (new Date(this.currentYear, this.currentMonth - 1, 1)).getDay();
                }
                //获取当前月的签到数据
                this.highlightArr = this.getHighlightArr() ? this.getHighlightArr() : [];
                this.dateFill();
            }
            this.isPrevFun();
        },
        isNextFun: function () {
            if (this.currentYear >= new Date().getFullYear()) {
                if (this.currentMonth - 1 == new Date().getMonth()) {
                    this.isNext = false;
                    this.isPrev = true;
                }
            } else {
                this.isNext = true;
                this.isPrev = true;
            }
            this.changeActiveFun();
        },
        isPrevFun: function () {
            if (this.currentYear == 2017 && this.currentMonth == 8) {
                this.isPrev = false;
                this.isNext = true;
            } else {
                this.isPrev = true;
                this.isNext = true;
            }
            this.changeActiveFun();
        },
        changeActiveFun: function () {
            if (this.isPrev) {
                $('#' + this.currentId + ' .prevMouth').css('background', 'url(/images/calendar/left_arrow_active.png) no-repeat 14px 7px');
            } else {
                $('#' + this.currentId + ' .prevMouth').css('background', 'url(/images/calendar/left_arrow.png) no-repeat 14px 7px');
            }
            if (this.isNext) {
                $('#' + this.currentId + ' .nextMouth').css('background', 'url(/images/calendar/right_arrow_active.png) no-repeat 0px 7px');
            } else {
                $('#' + this.currentId + ' .nextMouth').css('background', 'url(/images/calendar/right_arrow.png) no-repeat 0px 7px');
            }
        },
        getHighlightArr: function () {
            //获取到返回一个数组，没有获取到返回 false
            //根据当前年，当前月获取本月签到日
            //this.currentYear
            //this.currentMonth
            var signedDays = isMark(this.currentYear, this.currentMonth);
            if (signedDays) return signedDays.split(",");
        }
    }
    window.Calendar = Calendar
})();

$(function () {
    var calendarObj = new Calendar({
        currentId: 'calendar'
    });
    $('#sign').on('click', function () {
        //发送签到参数
        mark();
        //重绘日历
        calendarObj.highlightArr= calendarObj.getHighlightArr();
        calendarObj.dateFill();
        $(this).addClass('hide');
        $('#signed').removeClass('hide');
    });
});

function refresh(signedDays) {
    var calendarObj = new Calendar({
        currentId: 'calendar'
    });
    //重绘日历
    calendarObj.highlightArr = signedDays;
}


function isMark(signedYear, signedMonth) {
    var userId = $('#userId').val();
    var signedDays = null;
    $.ajax({
        type: 'get',
        url: `/api/clockins/doClock`,
        data: {
            type: 0,
            mId: userId,
            signedYear: signedYear,
            signedMonth: signedMonth
        },
        dataType: 'json',
        async: false,
        error: function (XMLHttpRequest, textStatus, errorThrown) {
        },
        success: function (data, textStatus) {
            if (!data.result) {
                $('.signed').addClass("hide");
                $('.sign').removeClass("hide");
            }
            if (data.result) {
                $('.sign').addClass("hide");
                $('.signed').removeClass("hide");
            }
            $('.punchClockBtnIsMark').html('本月已打卡<i>' + data.respObject.totalCount + '</i>天&nbsp;&nbsp;&nbsp;连续<i>' + data.respObject.continuityCount + '</i>天');
            signedDays = data.respObject.signedDays.split(',').sort().join(",");
        }
    });
    return signedDays;
}


function mark() {
    var userId = $('#userId').val();
    $.ajax({
        type: 'get',
        url: `/api/clockins/doClock`,
        data: {
            type: 1,
            mId: userId
        },
        dataType: 'json',
        error: function (XMLHttpRequest, textStatus, errorThrown) {
        },
        success: function (data, textStatus) {
            if (data.result) {
                $('.punchClockBtnIsMark').html('本月已打卡<i>' + data.respObject.totalCount + '</i>天&nbsp;&nbsp;&nbsp;连续<i>' + data.respObject.continuityCount + '</i>天');
                var signedDays = data.respObject.signedDays.split(',').sort().join(",");
                refresh(signedDays);
            }
        }
    });
}