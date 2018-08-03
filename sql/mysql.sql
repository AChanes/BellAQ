drop database if exists BellAQ;
create database BellAQ;
use BellAQ;

SET GLOBAL event_scheduler = ON;
-- 会员表
create table member(
    id int primary key auto_increment,
    -- 学习计划状态
    isPlan enum('1','0') default '0',
    -- 图片直接存入(大小在1M以内)
    img mediumtext,
    nickname varchar(32) not null,
    account char(11) unique not null,
    password varchar(22) not null,
    phoneNum char(11) not null,
    age int,
    pay enum('1','0') default '0',
    paytime varchar(15),
    sex enum('1','2','0') default '0',
    -- 学号
    sno varchar(32),
    stage enum('1','2','3','4','5','6') default '6',
    -- 已获得分数成绩
    score int default 0,
    -- 已完成题数
    questionNum int default 0,
    -- 最近登陆时间
    ltime varchar(15),
    isUsed enum("1","0") default '1'
);

-- 管理员表
create table administrator(
    id int primary key auto_increment,
    nickname varchar(32) not null,
    account char(11) unique not null,
    phoneNum char(11) not null,
    password varchar(22) not null,
    age int,
    -- teacher admin sadmin 教师  会员管理  超级管理员
    role varchar(32),
    sex enum('1','2','0') default '0',
    isUsed enum("1","0") default '1'
);


-- 题目难度表
create table difficultyLevel(
    id int primary key auto_increment,
    level varchar(20)
);

-- 题目类型表(四个分类：口语 id =1、阅读 id=2、听力 id =3、写作 id =4、综合 id=5、其它 id=6)
create table types(
    id int primary key auto_increment,
    typeName varchar(32)
);

-- 情景分类表
create table topic(
    id int primary key auto_increment,
    topicName varchar(32)
);

-- 听力材料表
create table listeningMaterial(
    id int primary key auto_increment,
    -- 教师id
    tId int not null,
    -- 难度id
    dId int not null,
    title text not null,
    -- 情景相关图片
    img text not null,
    mp4 text not null,
    -- 原文
    original text not null,
    -- 情景分类
    topicId int not null,
    -- 是否为套题材料
    isMockexam varchar(128) default '0',
    foreign key fk1(tId) references administrator(id),
    foreign key fk2(dId) references difficultyLevel(id),
    foreign key fk3(topicId) references topic(id)
);

-- 听力题目
create table listeningQuestion(
    id int primary key auto_increment,
    LMId int not null,
    -- 材料下题目序号
    numForLM int,
    isD enum('1','0') default '0',
    -- 题目录音
    mp4 text not null,
    question text not null,
    -- 题目附加录音
    mp4ForQ text,
    -- 选项（json数组）[{num:0,content:"A.this is option A"}](MariaDB 下使用json会报错，无法建表)
    options text not null,
    -- 正确答案
    rightAnswer varchar(16) not null,
    -- 分数
    score int not null,
    foreign key fk4(LMId) references listeningMaterial(id)
);

-- 口语材料
create table speakingMaterial(
    id int primary key auto_increment,
    tId int not null,
    dId int not null,
    title text not null,
    -- 讨论类的题目无QUESTION显示使用img
    img text,
    -- 原文录音
    mp4ForO text,
    -- 要求的录音
    mp4ForA text not null,
    -- 问题的录音
    mp4ForQ text not null,
    question text not null,
    -- 限时
    timedown int,
    -- 阅读材料
    rMaterial text,
    -- 原文
    original text,
    -- 情景分类
    topicId int not null,
    -- 是否为套题材料
    isMockexam varchar(128) default '0',
    foreign key fk5(tId) references administrator(id),
    foreign key fk6(dId) references difficultyLevel(id),
    foreign key fk7(topicId) references topic(id)
);

-- 写作材料
create table writingMaterial(
    id int primary key auto_increment,
    tId int not null,
    dId int not null,
    title text not null,
    -- 倒计时
    timedown int,
    -- 原文
    original text,
    -- 材料
    material text,
    img text,
    -- 原文录音
    mp4 text,
    question text not null,
    -- 情景
    topicId int not null,
    -- 是否包含材料（不包含材料时，倒计时、原文、材料、录音均为空）
    includeMaterial enum('1','0'),
    score int not null,
    -- 是否为套题材料
    isMockexam varchar(128) default '0',
    foreign key fk8(tId) references administrator(id),
    foreign key fk9(dId) references difficultyLevel(id),
    foreign key fk10(topicId) references topic(id)
);

-- 阅读材料
create table readingMaterial(
    id int primary key auto_increment,
    tId int not null,
    dId int not null,
    englishTitle text not null,
    chineseTitle text not null,
    -- 英文版材料
    englishMaterial text not null,
    -- 中文版材料
    chineseMaterial text not null,
    -- 情景类型
    topicId int not null,
    -- 是否为套题材料
    isMockexam varchar(128) default '0',
    foreign key fk11(tId) references administrator(id),
    foreign key fk12(dId) references difficultyLevel(id),
    foreign key fk13(topicId) references topic(id)
);

-- 阅读问题
create table readingQuestion(
    id int primary key auto_increment,
    rId int not null,
    numForRM int,
    numF varchar(32),
    -- 是否为多选题  是为'1' 不是为'0'
    isD enum('1','0') default '0',
    question text not null,
    -- 选项
    options text not null,
    rightAnswer varchar(16) not null,
    score int not null,
    foreign key fk14(rId) references readingMaterial(id)
);

-- 全部答题记录
create table allAnswerRecord(
    id int primary key auto_increment,
    mId int not null,
    tyId int not null,
    isM int default 0,
    -- 材料id
    materialId int not null,
    -- 材料title
    materialTitle varchar(32),
    dId int default 1,
    -- 难度
    level varchar(32),
    -- 材料下的第几题
    numForM int,
    -- 口语录音
    mp4 text,
    -- 口语点赞数
    likeClick varchar(20000) default "0",
    -- 用户答案
    mAnswer varchar(32),
    -- 正确答案
    rightAnswer varchar(32),
    -- 用户答案是否正确（正确为1,错误为0,写作题为-1）
    isRight enum('1','0','-1') default '-1',
    -- 作文内容
    wContent text,
    -- 分数
    score int default 0,
    -- 用时
    startTime varchar(32),
    -- 答题日期
    endTime varchar(32),
    foreign key fk15(mId) references member(id),
    foreign key fk16(tyId) references types(id)
);

-- 会员推荐
create table memberRecommend(
    id int primary key auto_increment,
    aId int not null,
    img text not null,
    title varchar(32),
    digest text not null,
    pullTime varchar(32),
    pageView int default 0,
    content text,
    -- 文章分类
    tyId int not null,
    foreign key fk17(aId) references administrator(id),
    foreign key fk18(tyId) references types(id)
);

-- 目标
create table target(
    id int primary key auto_increment,
    mId int not null, 
    dId int not null,
    starts varchar(32) not null,
    complete varchar(32) not null,
    score int not null,
    -- 2为正在进行中
    targetStatus enum('1','0','2') default '2',
    foreign key fk19(mId) references member(id),
    foreign key fk20(dId) references difficultyLevel(id)
);

-- 模拟试题
create table mockExam(
     id int primary key auto_increment,
     tId int not null,
     dId int not null,
     -- 听力题id
     lId varchar(32) not null,
     -- 口语id
     sId varchar(32) not null,
     -- 阅读id
     rId varchar(32) not null,
     -- 写作 id
     wId varchar(32) not null,
     timedown int,
     foreign key fk21(tId) references administrator(id),
     foreign key fk22(dId) references difficultyLevel(id)
);

-- 做过模拟试题的学生记录
create table mockExamR(
    id int primary key auto_increment,
    mId int not null,
    mEId int not null,
    dId int not null,
    level varchar(32),
    spokenTotal int default 0,
    spokenRight int default 0,
    spokenScore int default 0,
    readTotal int default 0,
    readRight int default 0,
    readScore int default 0,
    listenTotal int default 0,
    listenRight int default 0,
    listenScore int default 0,
    writeTotal int default 0,
    writeRight int default 0,
    writeScore int default 0,
    totalScore int default 0,
    startTime varchar(32),
    endTime varchar(32),
    foreign key fk23(mId) references member(id),
    foreign key fk24(mEId) references mockExam(id),
    foreign key fk25(dId) references difficultyLevel(id)
);

-- 短信验证
create table checkCode(
    id int primary key auto_increment,
    phoneNum char(11),
    endTime varchar(32),
    time int default 0
);

-- 打卡
create table clockIn (
     id int primary key auto_increment,
     mId int not null, 
     record text,
     foreign key fk25(mId) references member(id)
);

delimiter |
create trigger mockExamR_insert before insert on mockExamR for each row
	begin
        set new.level =(select level from difficultyLevel where id = new.dId);
	end |
delimiter ;

-- 用户注册之后添加一个空的打卡记录
delimiter |
create trigger member_insert after insert on member for each row
	begin
        insert into clockIn(mId,record) value(new.id,'');
	end |
delimiter ;

-- -- 触发器（删除阅读材料）
delimiter |
create trigger readMaterial_delete before delete on readingMaterial for each row
	begin
        delete from readingQuestion where rId = old.id;
	end |
delimiter ;

-- -- 触发器（删除听力材料）
delimiter |
create trigger listenMaterial_delete before delete on listeningMaterial for each row
	begin
        delete from listeningQuestion where LMId = old.id;
	end |
delimiter ;

-- -- 添加听力题
delimiter |
create trigger listeningQuestion_insert before insert on listeningQuestion for each row
	begin
        declare i int;
        set i = (select count(numForLM) from listeningQuestion where LMId = new.LMId);
        set new.numForLM = i + 1;
	end |
delimiter ;

-- 添加阅读题
delimiter |
create trigger readingQuestion_insert before insert on readingQuestion for each row
	begin
        declare i int;
        set i = (select count(numForRM) from readingQuestion where rId = new.rId);
        set new.numForRM = i + 1;
	end |
delimiter ;

-- 修改会员付费到期时间
delimiter |
create trigger member_paytime_update before update on member for each row
    begin
        if date_format(new.paytime,'%Y-%m-%d') >= date_format(concat(year(now()),'-',month(now()),'-',day(now())),'%Y-%m-%d') then
        set new.pay = '1';
        end if;
    end |
delimiter ;

-- 确认付费是否到期
delimiter |
create trigger member_ltime_update before update on member for each row
    begin
        if date_format(new.paytime,'%Y-%m-%d') < date_format(concat(year(now()),'-',month(now()),'-',day(now())),'%Y-%m-%d') then
        set new.pay = '0';
        end if;
    end |
delimiter ;

-- 触发器（添加答题记录时添加答题数和成绩）
delimiter |
create trigger answerR_insert before insert on allAnswerRecord for each row
	begin
        if new.tyId = 1 then
            set new.level = (select level from difficultyLevel where id = (select dId from speakingMaterial where id = new.materialId));
            set new.materialTitle = (select title from speakingMaterial where id = new.materialId);
        end if;
        if new.tyId = 2 then
            set new.level = (select level from difficultyLevel where id = (select dId from readingMaterial where id = new.materialId));
            set new.materialTitle = (select englishTitle from readingMaterial where id = new.materialId);
        end if;
        if new.tyId = 3 then
            set new.level = (select level from difficultyLevel where id = (select dId from listeningMaterial where id = new.materialId));
            set new.materialTitle = (select title from listeningMaterial where id = new.materialId);
        end if;
        if new.tyId = 4 then
            set new.level = (select level from difficultyLevel where id = (select dId from writingMaterial where id = new.materialId));
            set new.materialTitle = (select title from writingMaterial where id = new.materialId);
        end if;
        update member set questionNum = questionNum + 1 where id = new.mId;
        if  new.isRight = '1' then 
            update member set score = score + new.score where id = new.mId;
        end if;
        if new.isM <> 0 then 
            if new.tyId = 1 then
                update mockExamR set spokenTotal = spokenTotal + 1 where id = new.isM;
            end if;
            if new.tyId = 2 then
                update mockExamR set readTotal = readTotal + 1 where id = new.isM;
                if new.isRight = "1" then 
                    update mockExamR set readScore = readScore + new.score where id = new.isM;
                    update mockExamR set readRight = readRight + 1 where id = new.isM;
                    update mockExamR set totalScore = totalScore + new.score where id = new.isM;
                end if;
            end if;
            if new.tyId = 3 then
                update mockExamR set listenTotal = listenTotal + 1 where id = new.isM;
                if new.isRight = "1" then 
                    update mockExamR set listenScore = listenScore + new.score where id = new.isM;
                    update mockExamR set listenRight = listenRight + 1 where id = new.isM;
                    update mockExamR set totalScore = totalScore + new.score where id = new.isM;
                end if;
            end if;
            if new.tyId = 4 then
                update mockExamR set writeTotal = writeTotal + 1 where id = new.isM;
            end if;
            update mockExamR set endTime =new.endTime where id = new.isM;
        end if;
	end |
delimiter ;

-- 触发器（作文打分）
delimiter |
create trigger allAnswerRecord_score_update after update on allAnswerRecord for each row
	begin
        update mockExamR set writeScore = new.score where id = old.isM;
        update mockExamR set totalScore = totalScore + new.score where id = old.isM;
		update member set score = score + new.score where id = old.mId;
	end |
delimiter ;

-- 添加目标
delimiter |
create trigger target_insert after insert on target for each row
	begin
        update member set isPlan = '1' where id = new.mId;
	end |
delimiter ;

-- 目标完成
delimiter |
create trigger mockExamR_score_update after update on mockExamR for each row
	begin
        declare sc int default 0;
        declare dif int default 0;
        set sc =(select score from target where mId = old.mId and targetStatus ='2');
        set dif =(select dId from target where mId = old.mId and targetStatus ='2');
		if new.totalScore >= sc and old.dId = dif then
		update target set targetStatus ='1' where mId = old.mId and targetStatus ='2';
        update member set isPlan = '0' where id = old.mId;
		end if;
	end |
delimiter ;

-- 添加套题
delimiter |
create trigger mockExam_insert after insert on mockExam for each row
	begin
        call isMockexam_to_yon(new.sId,",",1,new.id,1);
        call isMockexam_to_yon(new.rId,",",2,new.id,1);
        call isMockexam_to_yon(new.lId,",",3,new.id,1);
        call isMockexam_to_yon(new.wId,",",4,new.id,1);
	end |
delimiter ;

-- 修改套题
delimiter |
create trigger mockExam_update after update on mockExam for each row
	begin
        call isMockexam_to_yon(old.sId,",",1,old.id,0);
        call isMockexam_to_yon(old.rId,",",2,old.id,0);
        call isMockexam_to_yon(old.lId,",",3,old.id,0);
        call isMockexam_to_yon(old.wId,",",4,old.id,0);
        call isMockexam_to_yon(new.sId,",",1,old.id,1);
        call isMockexam_to_yon(new.rId,",",2,old.id,1);
        call isMockexam_to_yon(new.lId,",",3,old.id,1);
        call isMockexam_to_yon(new.wId,",",4,old.id,1);
	end |
delimiter ;

-- 删除套题
delimiter |
create trigger mockExam_delete before delete on mockExam for each row
	begin
        call isMockexam_to_yon(old.sId,",",1,old.id,0);
        call isMockexam_to_yon(old.rId,",",2,old.id,0);
        call isMockexam_to_yon(old.lId,",",3,old.id,0);
        call isMockexam_to_yon(old.wId,",",4,old.id,0);
	end |
delimiter ;

-- 修改材料是否在套题中  口语  阅读 听力  写作
delimiter |
create PROCEDURE isMockexam_to_yon(in s_str varchar(128),in s_split varchar(3),in tyId int,in thisId int,in isA int)  
    begin  
        declare i int;
		declare left_str varchar(128);
		declare sub_str varchar(128);
        declare n int;
        declare s varchar(32);
        set i = length(s_str) - length(replace(s_str,s_split,''));
        set left_str = s_str;  
        while i>0 do   
            set sub_str = substr(left_str,1,instr(left_str,s_split)-1);       
            set left_str = substr(left_str,length(sub_str)+length(s_split)+1);    
            set n = trim(sub_str);
            if tyId = 1 then 
                set s = (select isMockexam from speakingMaterial where id = n);
                if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
                update speakingMaterial set isMockexam = s where id = n;
            end if;
            if tyId = 2 then
                set s = (select isMockexam from readingMaterial where id = n);
                if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
                update readingMaterial set isMockexam = s  where id = n;
            end if;
            if tyId = 3 then
                set s = (select isMockexam from listeningMaterial where id = n);
                if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
                update listeningMaterial set isMockexam = s  where id = n;
            end if;
            if tyId = 4 then
                set s = (select isMockexam from writingMaterial where id = n);
                if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
                update writingMaterial set isMockexam = s  where id = n;
            end if;
            set i = i - 1;
        end while;
        set n = trim(left_str);  
        if tyId = 1 then 
            set s = (select isMockexam from speakingMaterial where id = n);
            if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
            update speakingMaterial set isMockexam = s where id = n;
        end if;
        if tyId = 2 then
            set s = (select isMockexam from readingMaterial where id = n);
            if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
            update readingMaterial set isMockexam = s  where id = n;
        end if;
        if tyId = 3 then
            set s = (select isMockexam from listeningMaterial where id = n);
            if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
            update listeningMaterial set isMockexam = s  where id = n;
        end if;
        if tyId = 4 then
            set s = (select isMockexam from writingMaterial where id = n);
            if isA = 1 then
                    set s = concat(s,',',thisId);
                end if;
                if isA = 0 then
                    set s = replace(s,concat(',',thisId),'');
                end if;
            update writingMaterial set isMockexam = s  where id = n;
        end if; 
	end |
delimiter ;

-- 删除会员
delimiter |
create trigger member_delete before delete on member for each row
	begin
        delete from allAnswerRecord where mId = old.id;
        delete from target where mId = old.id;
        delete from mockExamR where mId = old.id;
        delete from clockIn where mId = old.id;
	end |
delimiter ;

-- 定时修改计划状态
delimiter |
create event update_target_targetStatus_day on SCHEDULE every 1 day do
    begin
        update target set targetStatus = '0' where complete < current_date() and targetStatus = '2';
	end |
delimiter ;


insert into types(typeName) value("口语");
insert into types(typeName) value("阅读");
insert into types(typeName) value("听力");
insert into types(typeName) value("写作");
insert into types(typeName) value("综合");
insert into types(typeName) value("其它");

insert into difficultyLevel(level) value("高中");
insert into difficultyLevel(level) value("四级");
insert into difficultyLevel(level) value("六级");
insert into difficultyLevel(level) value("托福");
insert into difficultyLevel(level) value("托福TPO5");

insert into topic(topicName) value("生物");
insert into topic(topicName) value("历史");
insert into topic(topicName) value("地质");
insert into topic(topicName) value("艺术");
insert into topic(topicName) value("心理");
insert into topic(topicName) value("环境科学");
insert into topic(topicName) value("生态");
insert into topic(topicName) value("考古");
insert into topic(topicName) value("天文");
insert into topic(topicName) value("教育");
insert into topic(topicName) value("其它");

-- 会员未付费
-- insert into member(nickname,account,password,phoneNum) value("会员0","18180163780","123456","18180163780");
insert into member(nickname,account,password,phoneNum) value("会员1","18180163781","123456","18180163781");
insert into member(nickname,account,password,phoneNum) value("会员2","18180163782","123456","18180163782");
-- 会员已付费
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员3","18180163783","123456","18180163783","1","2018-05-26");
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员4","18180163784","123456","18180163784","1","2018-06-30");
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员5","18180163785","123456","18180163785","1","2018-06-30");
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员6","18180163786","123456","18180163786","1","2018-06-30");
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员7","18180163787","123456","18180163787","1","2018-05-31");
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员8","18180163788","123456","18180163788","1","2018-05-31");
insert into member(nickname,account,password,phoneNum,pay,paytime) value("会员9","18180163789","123456","18180163789","1","2018-05-31");
-- 管理员
insert into administrator(nickname,account,password,phoneNum,role) value("teacher","18180163791","123456","18180163791","teacher");
insert into administrator(nickname,account,password,phoneNum,role) value("teacher","18180163792","123456","18180163792","teacher");
insert into administrator(nickname,account,password,phoneNum,role) value("teacher","18180163793","123456","18180163793","teacher");
insert into administrator(nickname,account,password,phoneNum,role) value("teacher","18180163794","123456","18180163794","teacher");
insert into administrator(nickname,account,password,phoneNum,role) value("teacher","18180163785","123456","18180163795","teacher");
insert into administrator(nickname,account,password,phoneNum,role) value("teacher","18180163796","123456","18180163796","teacher");
insert into administrator(nickname,account,password,phoneNum,role) value("admin","18180163797","123456","18180163797","admin");
insert into administrator(nickname,account,password,phoneNum,role) value("admin","18180163798","123456","18180163798","admin");
insert into administrator(nickname,account,password,phoneNum,role) value("sadmin","18180163799","123456","18180163799","sadmin");

-- 听力材料
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(1,1,"listenM1","/images/0.2619449282509203.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(1,1,"listenM2","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(1,1,"listenM3","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(2,1,"listenM4","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(2,1,"listenM5","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(3,1,"listenM6","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(4,1,"listenM7","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(5,1,"listenM8","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);
insert into listeningMaterial(tId,dId,title,img,mp4,original,topicId) value(1,1,"listenM9","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",1);


-- 听力题目
-- 第一题
insert into listeningQuestion(LMId,mp4,question,options,rightAnswer,score) value(1,"/video/20170713105921293034753.mp3","Do oyou konw answer111?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,isD,mp4,question,options,rightAnswer,score) value(1,'1',"/video/20170713105921293034753.mp3","Do oyou konw answer1222?",'{"A":"I am ok1.","B":"I am ok1?","C":"I am ok1!","D":"I am ok1..."}',"AB","5");
insert into listeningQuestion(LMId,mp4,question,options,rightAnswer,score) value(1,"/video/20170713105921293034753.mp3","Do oyou konw answer1333?",'{"A":"I am ok1.","B":"I am ok1?","C":"I am ok1!","D":"I am ok1..."}',"A","5");
insert into listeningQuestion(LMId,isD,mp4,question,options,rightAnswer,score) value(1,'1',"/video/20170713105921293034753.mp3","Do oyou konw answer1444?",'{"A":"I am ok1.","B":"I am ok1?","C":"I am ok1!","D":"I am ok1..."}',"AB","5");
insert into listeningQuestion(LMId,mp4,question,options,rightAnswer,score) value(1,"/video/20170713105921293034753.mp3","Do oyou konw answer1555?",'{"A":"I am ok1.","B":"I am ok1?","C":"I am ok1!","D":"I am ok1..."}',"A","5");
insert into listeningQuestion(LMId,isD,mp4,question,options,rightAnswer,score) value(1,'1',"/video/20170713105921293034753.mp3","Do oyou konw answer1666?",'{"A":"I am ok1.","B":"I am ok1?","C":"I am ok1!","D":"I am ok1..."}',"AB","5");
insert into listeningQuestion(LMId,mp4,question,options,rightAnswer,score) value(1,"/video/20170713105921293034753.mp3","Do oyou konw answer1777?",'{"A":"I am ok1.","B":"I am ok1?","C":"I am ok1!","D":"I am ok1..."}',"A","5");
-- 第二题
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(2,1,"/video/20170713105921293034753.mp3","Do you know answer2111?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(2,2,'1',"/video/20170713105921293034753.mp3","Do you know answer12222?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(2,3,"/video/20170713105921293034753.mp3","Do you know answer123333?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(2,4,'1',"/video/20170713105921293034753.mp3","Do you know answer124444?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(2,5,"/video/20170713105921293034753.mp3","Do you know answer125555?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(2,6,'1',"/video/20170713105921293034753.mp3","Do you know answer126666?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(2,7,"/video/20170713105921293034753.mp3","Do you know answer127777?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(3,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(3,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(3,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(3,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(3,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(3,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(3,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(4,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(4,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(4,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(4,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(4,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(4,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(4,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(5,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(5,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(5,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(5,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(5,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(5,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(5,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(6,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(6,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(6,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(6,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(6,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(6,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(6,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(7,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(7,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(7,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(7,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(7,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(7,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(7,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(8,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(8,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(8,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(8,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(8,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(8,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(8,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(9,1,"/video/20170713105921293034753.mp3","Do you know answers?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(9,2,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(9,3,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(9,4,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(9,5,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");
insert into listeningQuestion(LMId,numForLM,isD,mp4,question,options,rightAnswer,score) value(9,6,'1',"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"AB","5");
insert into listeningQuestion(LMId,numForLM,mp4,question,options,rightAnswer,score) value(9,7,"/video/20170713105921293034753.mp3","Do you know answers1?",'{"A":"option a","B":" option b","C":"option c","D":"option d"}',"A","5");

-- -- 口语材料
insert into speakingMaterial(tId,dId,title,mp4ForA,mp4ForQ,question,topicId) value(1,1,"speakM1","/video/20170713105921293034753.mp3","/video/20170713105921293034753.mp3","Do you know answers4?",2);
insert into speakingMaterial(tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId) value(1,1,"speakM2","/images/0.7057596386216727.jpg","/video/1507702536441151.mp3","/video/1507702536441151.mp3","/video/1507702536441151.mp3","Do you know answers5?",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",2);
insert into speakingMaterial(tId,dId,title,mp4ForA,mp4ForQ,question,topicId) value(1,1,"speakM3","/video/20170713105921293034753.mp3","/video/20170713105921293034753.mp3","Do you know answers4?",2);
insert into speakingMaterial(tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId) value(1,1,"speakM4","/images/0.7057596386216727.jpg","/video/1507702536441151.mp3","/video/1507702536441151.mp3","/video/1507702536441151.mp3","Do you know answers5?",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",2);
insert into speakingMaterial(tId,dId,title,mp4ForA,mp4ForQ,question,topicId) value(2,1,"speakM5","/video/20170713105921293034753.mp3","/video/20170713105921293034753.mp3","Do you know answers4?",2);
insert into speakingMaterial(tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId) value(3,1,"speakM6","/images/0.7057596386216727.jpg","/video/20170713105921293034753.mp3","/video/20170713105921293034753.mp3","/video/20170713105921293034753.mp3","Do you know answers5?",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",2);
insert into speakingMaterial(tId,dId,title,mp4ForA,mp4ForQ,question,topicId) value(3,1,"speakM7","/video/20170713105921293034753.mp3","/video/listeningStart1.mp3","Do you know answers4?",2);
insert into speakingMaterial(tId,dId,title,img,mp4ForO,mp4ForA,mp4ForQ,question,timedown,rMaterial,original,topicId) value(4,1,"speakM8","/images/0.7057596386216727.jpg","/video/listeningStart1.mp3","/video/listeningStart1.mp3","/video/listeningStart1.mp3","Do you know answers5?",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.",2);

-- -- 写作材料
insert into writingMaterial(tId,dId,title,question,topicId,includeMaterial,score) value(1,1,"wirteM1","Do you know this answer one?",3,"0","25");
insert into writingMaterial(tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score) value(1,1,"wirteM22222",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","are you ok7?",3,"1","25");
insert into writingMaterial(tId,dId,title,question,topicId,includeMaterial,score) value(2,1,"wirteM3","Do you know this answer two?",3,"0","25");
insert into writingMaterial(tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score) value(2,1,"wirteM4",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","are you ok7?",3,"1","25");
insert into writingMaterial(tId,dId,title,question,topicId,includeMaterial,score) value(3,1,"wirteM5","Do you know this answer tree?",3,"0","25");
insert into writingMaterial(tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score) value(4,1,"wirteM6",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","are you ok7?",3,"1","25");
insert into writingMaterial(tId,dId,title,question,topicId,includeMaterial,score) value(5,1,"wirteM7","Do you know this answer four?",3,"0","25");
insert into writingMaterial(tId,dId,title,timedown,original,material,img,mp4,question,topicId,includeMaterial,score) value(5,1,"wirteM8",30,"The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","The necessary space is there, however, in many forms. The commonest spaces are those among the particles—sand grains andtiny pebbles—of loose, unconsolidated sand and gravel. Beds of this material, out of sight beneaththe soil, are common. They are found wherever fast rivers carrying loads of coarse sediment onceflowed. For example, as the great ice sheets that covered North America during the last ice age steadilymelted away, huge volumes of water flowed from them. The water was always laden with pebbles, gravel,and sand, known as glacial outwash, that was deposited as the flow slowed down.","/images/0.5084792792971453.jpg","/video/20170713105921293034753.mp3","are you ok7?",3,"1","25");

-- -- 阅读材料
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(1,1,"testing title one","测试文章一","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",4);
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(1,1,"testing title two","测试文章二","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",1);
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(2,1,"testing title three","测试文章三","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",4);
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(2,1,"testing title four","测试文章四","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",2);
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(3,1,"testing title five","测试文章五","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",3);
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(3,1,"testing title six","测试文章六","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",2);
insert into readingMaterial(tId,dId,englishTitle,chineseTitle,englishMaterial,chineseMaterial,topicId) value(4,1,"testing title seven","测试文章七","<p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></p><p><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'><span style='color: rgb(51, 51, 51); font-family: Verdana, 宋体; font-size: 14px;'>&nbsp;&nbsp;&nbsp;&nbsp;Most people know the word &#39;avatar&#39;. Perhaps we all saw the movie with the same name. Avatars are becoming a normal part of our life. Well... I should say our online life. Almosteverywhere you go on the Internet you see avatars. Sometimes it&#39;s awebsite asking you to make an avatar, and other times it&#39;s people&#39;s real avatars. Do you have one? Or two, or three? I see a lot of avatars that are kind of cute and look likeJapanese anime. One of the most popular things is to choose an animal as an avatar. I always take a long time to choose my avatar. It&#39;s important to make one I really like. It has to be funny. I also like avatars that move. All of the best avatars I&#39;ve seen move. They are usually very funny, and clever.</span></span></p>","<p>大多数人都知道“化身”这个词。也许我们都看过同名电影。化身成了我们生活中正常的一部分。好。。。我应该说我们的在线生活。在互联网上你可以看到化身。有时它是一个网站，要求你制作一个化身，而其他时候它是人们真正的化身。你有吗？或者两个，还是三个？我看到很多化身可爱，看起来像日本动漫。最受欢迎的事情之一是选择动物作为化身。我总是花很长时间来选择我的化身。重要的是制作一个我真正喜欢的。这一定很有趣。我也喜欢移动的化身。所有我见过的最好的化身。它们通常很有趣，而且很聪明。</p>",3);

-- -- 阅读题目
insert into readingQuestion(rId,question,options,rightAnswer,score) value(1,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(1,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(1,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(1,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(1,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(1,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(1,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(1,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

insert into readingQuestion(rId,question,options,rightAnswer,score) value(2,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(2,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(2,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(2,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(2,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(2,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(2,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(2,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

insert into readingQuestion(rId,question,options,rightAnswer,score) value(3,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(3,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(3,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(3,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(3,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(3,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(3,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(3,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

insert into readingQuestion(rId,question,options,rightAnswer,score) value(4,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(4,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(4,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(4,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(4,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(4,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(4,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(4,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

insert into readingQuestion(rId,question,options,rightAnswer,score) value(5,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(5,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(5,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(5,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(5,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(5,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(5,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(5,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

insert into readingQuestion(rId,question,options,rightAnswer,score) value(6,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(6,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(6,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(6,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(6,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(6,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(6,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(6,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

insert into readingQuestion(rId,question,options,rightAnswer,score) value(7,"Do you konw this answer one?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(7,'1',"Do you konw this answer two?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(7,"Do you konw this answer three?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(7,'1',"Do you konw this answer four?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(7,"Do you konw this answer five?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(7,'1',"Do you konw this answer six?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");
insert into readingQuestion(rId,question,options,rightAnswer,score) value(7,"Do you konw this answer seven?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"A","5");
insert into readingQuestion(rId,isD,question,options,rightAnswer,score) value(7,'1',"Do you konw this answer eight?",'{"A":"option a","B":"option b","C":"option c","D":"option d"}',"AB","5");

-- 会员推荐
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(7,"/images/0.2619449282509203.jpg","tesing title one","this is digest one one","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>我是一个在感到</span><a href='http://yuedu.mipang.com/hchj/jimo/' title='寂寞' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>寂寞</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的时候就会仰望天空的小孩，望着那个大太阳，望着那个大月亮，望到脖子酸痛，望到眼中噙满泪水。这是真的，好</span><a href='http://yuedu.mipang.com/fanwen/pingjia/haizi/' title='孩子' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孩子</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>不说假话。而我笔下的那些东西，那些看上去像是开放在水中的幻觉一样的东西，它们也是真的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　音乐</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　一直以来我就是个爱音乐的人，爱得排山倒海，骨子里的</span><a href='http://yuedu.mipang.com/lizhi/mingyan/jianchi/' title='坚持' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>坚持</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>在别人看来往往是不可理喻的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在天空清澈的夜晚，我总会在CD机中放进一张民谣。我总是</span><a href='http://yuedu.mipang.com/hchj/xihuan/' title='喜欢' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>喜欢</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>扬琴丁丁冬冬的声音，像是一个满腹心事的宋朝女词人的浅吟轻唱。红了樱桃，绿了芭蕉，雨打窗台湿绫绡。而我在沙发</span><a href='http://yuedu.mipang.com/hchj/wennuan/yijuhua/' title='温暖' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>温暖</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的包围中，在雀巢咖啡低调而飞扬的香味中，清清楚楚地知道，窗外的风无比的清凉，白云镶着月光如水的银边，一切完美，明日一定阳光明媚，我可以放肆得无法无天。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　然而大多数夜晚我的</span><a href='http://yuedu.mipang.com/hchj/shanggan/xinqing/' title='心情' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>心情</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>是不好的。寂寞。苍凉。和一点点呼之欲出的恐惧。而这个时候我会</span><a href='http://yuedu.mipang.com/zuowen/xiangxiang/xuanze/' title='选择' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>选择</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>张楚，或者窦唯。我总是以一种抗拒的姿态坐在客厅墙角的蓝白色沙发里，像个寂寞但倔强的小孩子。满脸的抗拒和愤怒，却睁着发亮的眼睛听着张楚唱“上苍保佑吃饱了饭的人民”以及窦唯的无字哼唱。我是个不按时吃饭的人，所以上苍并不保佑我，我常常胃疼，并且疼得掉下眼泪。我心爱的那个蓝白色沙发的对面是堵白色的墙，很大的一片白色，蔓延出泰山压顶般的空虚感。我曾经试图在上面挂上几幅我心爱的油画，可最终我把它们全部取了下来。空白，还是空白。那堵白色的墙让我想到</span>",1);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(7,"/images/0.2619449282509203.jpg","tesing title two","this is digest one two","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>折叠 昨日的心扉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　却不经意间洒落了一地</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　湿漉漉的痕迹</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　初夏的雨 缠满悱恻</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　有芬芳的花事悄悄来临 植在枝端</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　洒入梦境</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　游走一生的</span><a href='http://yuedu.mipang.com/hchj/gudu/' title='孤独' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孤独</a><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　剪辑成诗 用一枚悠悠明月盖了</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　</span><a href='http://yuedu.mipang.com/shici/yuguangzhong/xiangchou/' title='乡愁' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>乡愁</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的印戳</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　等待着飘雪尘埃落定</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　躲进</span><a href='http://yuedu.mipang.com/gushi/' title='故事' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>故事</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的臂弯 涟漪雨蝶花的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　晶莹剔透</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　研煮香墨 顺着紫藤萝的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　蔓节伸向远方 你我他不曾回眸亦</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　不会止步</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　也许 在未来的岁月</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　日记将与信鸽挥手告别 留下一抹清凉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在风里</span></p>",1);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(7,"/images/0.2619449282509203.jpg","tesing title three","this is digest one three","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>我是一个在感到</span><a href='http://yuedu.mipang.com/hchj/jimo/' title='寂寞' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>寂寞</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的时候就会仰望天空的小孩，望着那个大太阳，望着那个大月亮，望到脖子酸痛，望到眼中噙满泪水。这是真的，好</span><a href='http://yuedu.mipang.com/fanwen/pingjia/haizi/' title='孩子' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孩子</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>不说假话。而我笔下的那些东西，那些看上去像是开放在水中的幻觉一样的东西，它们也是真的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　音乐</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　一直以来我就是个爱音乐的人，爱得排山倒海，骨子里的</span><a href='http://yuedu.mipang.com/lizhi/mingyan/jianchi/' title='坚持' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>坚持</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>在别人看来往往是不可理喻的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在天空清澈的夜晚，我总会在CD机中放进一张民谣。我总是</span><a href='http://yuedu.mipang.com/hchj/xihuan/' title='喜欢' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>喜欢</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>扬琴丁丁冬冬的声音，像是一个满腹心事的宋朝女词人的浅吟轻唱。红了樱桃，绿了芭蕉，雨打窗台湿绫绡。而我在沙发</span><a href='http://yuedu.mipang.com/hchj/wennuan/yijuhua/' title='温暖' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>温暖</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的包围中，在雀巢咖啡低调而飞扬的香味中，清清楚楚地知道，窗外的风无比的清凉，白云镶着月光如水的银边，一切完美，明日一定阳光明媚，我可以放肆得无法无天。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　然而大多数夜晚我的</span><a href='http://yuedu.mipang.com/hchj/shanggan/xinqing/' title='心情' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>心情</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>是不好的。寂寞。苍凉。和一点点呼之欲出的恐惧。而这个时候我会</span><a href='http://yuedu.mipang.com/zuowen/xiangxiang/xuanze/' title='选择' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>选择</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>张楚，或者窦唯。我总是以一种抗拒的姿态坐在客厅墙角的蓝白色沙发里，像个寂寞但倔强的小孩子。满脸的抗拒和愤怒，却睁着发亮的眼睛听着张楚唱“上苍保佑吃饱了饭的人民”以及窦唯的无字哼唱。我是个不按时吃饭的人，所以上苍并不保佑我，我常常胃疼，并且疼得掉下眼泪。我心爱的那个蓝白色沙发的对面是堵白色的墙，很大的一片白色，蔓延出泰山压顶般的空虚感。我曾经试图在上面挂上几幅我心爱的油画，可最终我把它们全部取了下来。空白，还是空白。那堵白色的墙让我想到</span>",1);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(8,"/images/0.2619449282509203.jpg","tesing title four","this is digest one four","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>折叠 昨日的心扉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　却不经意间洒落了一地</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　湿漉漉的痕迹</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　初夏的雨 缠满悱恻</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　有芬芳的花事悄悄来临 植在枝端</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　洒入梦境</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　游走一生的</span><a href='http://yuedu.mipang.com/hchj/gudu/' title='孤独' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孤独</a><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　剪辑成诗 用一枚悠悠明月盖了</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　</span><a href='http://yuedu.mipang.com/shici/yuguangzhong/xiangchou/' title='乡愁' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>乡愁</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的印戳</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　等待着飘雪尘埃落定</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　躲进</span><a href='http://yuedu.mipang.com/gushi/' title='故事' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>故事</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的臂弯 涟漪雨蝶花的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　晶莹剔透</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　研煮香墨 顺着紫藤萝的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　蔓节伸向远方 你我他不曾回眸亦</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　不会止步</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　也许 在未来的岁月</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　日记将与信鸽挥手告别 留下一抹清凉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在风里</span></p>",2);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(8,"/images/0.2619449282509203.jpg","tesing title five","this is digest one five","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>我是一个在感到</span><a href='http://yuedu.mipang.com/hchj/jimo/' title='寂寞' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>寂寞</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的时候就会仰望天空的小孩，望着那个大太阳，望着那个大月亮，望到脖子酸痛，望到眼中噙满泪水。这是真的，好</span><a href='http://yuedu.mipang.com/fanwen/pingjia/haizi/' title='孩子' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孩子</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>不说假话。而我笔下的那些东西，那些看上去像是开放在水中的幻觉一样的东西，它们也是真的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　音乐</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　一直以来我就是个爱音乐的人，爱得排山倒海，骨子里的</span><a href='http://yuedu.mipang.com/lizhi/mingyan/jianchi/' title='坚持' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>坚持</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>在别人看来往往是不可理喻的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在天空清澈的夜晚，我总会在CD机中放进一张民谣。我总是</span><a href='http://yuedu.mipang.com/hchj/xihuan/' title='喜欢' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>喜欢</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>扬琴丁丁冬冬的声音，像是一个满腹心事的宋朝女词人的浅吟轻唱。红了樱桃，绿了芭蕉，雨打窗台湿绫绡。而我在沙发</span><a href='http://yuedu.mipang.com/hchj/wennuan/yijuhua/' title='温暖' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>温暖</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的包围中，在雀巢咖啡低调而飞扬的香味中，清清楚楚地知道，窗外的风无比的清凉，白云镶着月光如水的银边，一切完美，明日一定阳光明媚，我可以放肆得无法无天。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　然而大多数夜晚我的</span><a href='http://yuedu.mipang.com/hchj/shanggan/xinqing/' title='心情' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>心情</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>是不好的。寂寞。苍凉。和一点点呼之欲出的恐惧。而这个时候我会</span><a href='http://yuedu.mipang.com/zuowen/xiangxiang/xuanze/' title='选择' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>选择</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>张楚，或者窦唯。我总是以一种抗拒的姿态坐在客厅墙角的蓝白色沙发里，像个寂寞但倔强的小孩子。满脸的抗拒和愤怒，却睁着发亮的眼睛听着张楚唱“上苍保佑吃饱了饭的人民”以及窦唯的无字哼唱。我是个不按时吃饭的人，所以上苍并不保佑我，我常常胃疼，并且疼得掉下眼泪。我心爱的那个蓝白色沙发的对面是堵白色的墙，很大的一片白色，蔓延出泰山压顶般的空虚感。我曾经试图在上面挂上几幅我心爱的油画，可最终我把它们全部取了下来。空白，还是空白。那堵白色的墙让我想到</span>",2);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(8,"/images/0.2619449282509203.jpg","tesing title siex","this is digest one six","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>折叠 昨日的心扉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　却不经意间洒落了一地</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　湿漉漉的痕迹</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　初夏的雨 缠满悱恻</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　有芬芳的花事悄悄来临 植在枝端</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　洒入梦境</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　游走一生的</span><a href='http://yuedu.mipang.com/hchj/gudu/' title='孤独' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孤独</a><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　剪辑成诗 用一枚悠悠明月盖了</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　</span><a href='http://yuedu.mipang.com/shici/yuguangzhong/xiangchou/' title='乡愁' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>乡愁</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的印戳</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　等待着飘雪尘埃落定</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　躲进</span><a href='http://yuedu.mipang.com/gushi/' title='故事' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>故事</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的臂弯 涟漪雨蝶花的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　晶莹剔透</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　研煮香墨 顺着紫藤萝的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　蔓节伸向远方 你我他不曾回眸亦</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　不会止步</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　也许 在未来的岁月</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　日记将与信鸽挥手告别 留下一抹清凉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在风里</span></p>",3);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(9,"/images/0.2619449282509203.jpg","tesing title seven","this is digest one seven","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>我是一个在感到</span><a href='http://yuedu.mipang.com/hchj/jimo/' title='寂寞' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>寂寞</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的时候就会仰望天空的小孩，望着那个大太阳，望着那个大月亮，望到脖子酸痛，望到眼中噙满泪水。这是真的，好</span><a href='http://yuedu.mipang.com/fanwen/pingjia/haizi/' title='孩子' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孩子</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>不说假话。而我笔下的那些东西，那些看上去像是开放在水中的幻觉一样的东西，它们也是真的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　音乐</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　一直以来我就是个爱音乐的人，爱得排山倒海，骨子里的</span><a href='http://yuedu.mipang.com/lizhi/mingyan/jianchi/' title='坚持' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>坚持</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>在别人看来往往是不可理喻的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在天空清澈的夜晚，我总会在CD机中放进一张民谣。我总是</span><a href='http://yuedu.mipang.com/hchj/xihuan/' title='喜欢' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>喜欢</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>扬琴丁丁冬冬的声音，像是一个满腹心事的宋朝女词人的浅吟轻唱。红了樱桃，绿了芭蕉，雨打窗台湿绫绡。而我在沙发</span><a href='http://yuedu.mipang.com/hchj/wennuan/yijuhua/' title='温暖' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>温暖</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的包围中，在雀巢咖啡低调而飞扬的香味中，清清楚楚地知道，窗外的风无比的清凉，白云镶着月光如水的银边，一切完美，明日一定阳光明媚，我可以放肆得无法无天。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　然而大多数夜晚我的</span><a href='http://yuedu.mipang.com/hchj/shanggan/xinqing/' title='心情' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>心情</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>是不好的。寂寞。苍凉。和一点点呼之欲出的恐惧。而这个时候我会</span><a href='http://yuedu.mipang.com/zuowen/xiangxiang/xuanze/' title='选择' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>选择</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>张楚，或者窦唯。我总是以一种抗拒的姿态坐在客厅墙角的蓝白色沙发里，像个寂寞但倔强的小孩子。满脸的抗拒和愤怒，却睁着发亮的眼睛听着张楚唱“上苍保佑吃饱了饭的人民”以及窦唯的无字哼唱。我是个不按时吃饭的人，所以上苍并不保佑我，我常常胃疼，并且疼得掉下眼泪。我心爱的那个蓝白色沙发的对面是堵白色的墙，很大的一片白色，蔓延出泰山压顶般的空虚感。我曾经试图在上面挂上几幅我心爱的油画，可最终我把它们全部取了下来。空白，还是空白。那堵白色的墙让我想到</span>",3);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(9,"/images/0.2619449282509203.jpg","tesing title eight","this is digest one eight","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>折叠 昨日的心扉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　却不经意间洒落了一地</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　湿漉漉的痕迹</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　初夏的雨 缠满悱恻</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　有芬芳的花事悄悄来临 植在枝端</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　洒入梦境</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　游走一生的</span><a href='http://yuedu.mipang.com/hchj/gudu/' title='孤独' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孤独</a><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　剪辑成诗 用一枚悠悠明月盖了</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　</span><a href='http://yuedu.mipang.com/shici/yuguangzhong/xiangchou/' title='乡愁' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>乡愁</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的印戳</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　等待着飘雪尘埃落定</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　躲进</span><a href='http://yuedu.mipang.com/gushi/' title='故事' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>故事</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的臂弯 涟漪雨蝶花的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　晶莹剔透</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　研煮香墨 顺着紫藤萝的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　蔓节伸向远方 你我他不曾回眸亦</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　不会止步</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　也许 在未来的岁月</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　日记将与信鸽挥手告别 留下一抹清凉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在风里</span></p>",3);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(9,"/images/0.2619449282509203.jpg","tesing title nine","this is digest one nine","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>我是一个在感到</span><a href='http://yuedu.mipang.com/hchj/jimo/' title='寂寞' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>寂寞</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的时候就会仰望天空的小孩，望着那个大太阳，望着那个大月亮，望到脖子酸痛，望到眼中噙满泪水。这是真的，好</span><a href='http://yuedu.mipang.com/fanwen/pingjia/haizi/' title='孩子' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孩子</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>不说假话。而我笔下的那些东西，那些看上去像是开放在水中的幻觉一样的东西，它们也是真的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　音乐</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　一直以来我就是个爱音乐的人，爱得排山倒海，骨子里的</span><a href='http://yuedu.mipang.com/lizhi/mingyan/jianchi/' title='坚持' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>坚持</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>在别人看来往往是不可理喻的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在天空清澈的夜晚，我总会在CD机中放进一张民谣。我总是</span><a href='http://yuedu.mipang.com/hchj/xihuan/' title='喜欢' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>喜欢</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>扬琴丁丁冬冬的声音，像是一个满腹心事的宋朝女词人的浅吟轻唱。红了樱桃，绿了芭蕉，雨打窗台湿绫绡。而我在沙发</span><a href='http://yuedu.mipang.com/hchj/wennuan/yijuhua/' title='温暖' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>温暖</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的包围中，在雀巢咖啡低调而飞扬的香味中，清清楚楚地知道，窗外的风无比的清凉，白云镶着月光如水的银边，一切完美，明日一定阳光明媚，我可以放肆得无法无天。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　然而大多数夜晚我的</span><a href='http://yuedu.mipang.com/hchj/shanggan/xinqing/' title='心情' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>心情</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>是不好的。寂寞。苍凉。和一点点呼之欲出的恐惧。而这个时候我会</span><a href='http://yuedu.mipang.com/zuowen/xiangxiang/xuanze/' title='选择' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>选择</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>张楚，或者窦唯。我总是以一种抗拒的姿态坐在客厅墙角的蓝白色沙发里，像个寂寞但倔强的小孩子。满脸的抗拒和愤怒，却睁着发亮的眼睛听着张楚唱“上苍保佑吃饱了饭的人民”以及窦唯的无字哼唱。我是个不按时吃饭的人，所以上苍并不保佑我，我常常胃疼，并且疼得掉下眼泪。我心爱的那个蓝白色沙发的对面是堵白色的墙，很大的一片白色，蔓延出泰山压顶般的空虚感。我曾经试图在上面挂上几幅我心爱的油画，可最终我把它们全部取了下来。空白，还是空白。那堵白色的墙让我想到</span>",4);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(7,"/images/0.2619449282509203.jpg","tesing title ten","this is digest one tent","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>折叠 昨日的心扉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　却不经意间洒落了一地</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　湿漉漉的痕迹</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　初夏的雨 缠满悱恻</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　有芬芳的花事悄悄来临 植在枝端</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　洒入梦境</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　游走一生的</span><a href='http://yuedu.mipang.com/hchj/gudu/' title='孤独' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孤独</a><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　剪辑成诗 用一枚悠悠明月盖了</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　</span><a href='http://yuedu.mipang.com/shici/yuguangzhong/xiangchou/' title='乡愁' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>乡愁</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的印戳</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　等待着飘雪尘埃落定</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　躲进</span><a href='http://yuedu.mipang.com/gushi/' title='故事' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>故事</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的臂弯 涟漪雨蝶花的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　晶莹剔透</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　研煮香墨 顺着紫藤萝的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　蔓节伸向远方 你我他不曾回眸亦</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　不会止步</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　也许 在未来的岁月</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　日记将与信鸽挥手告别 留下一抹清凉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在风里</span></p>",4);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(8,"/images/0.2619449282509203.jpg","tesing title eletng","this is digest one elignio","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>我是一个在感到</span><a href='http://yuedu.mipang.com/hchj/jimo/' title='寂寞' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>寂寞</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的时候就会仰望天空的小孩，望着那个大太阳，望着那个大月亮，望到脖子酸痛，望到眼中噙满泪水。这是真的，好</span><a href='http://yuedu.mipang.com/fanwen/pingjia/haizi/' title='孩子' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孩子</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>不说假话。而我笔下的那些东西，那些看上去像是开放在水中的幻觉一样的东西，它们也是真的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　音乐</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　一直以来我就是个爱音乐的人，爱得排山倒海，骨子里的</span><a href='http://yuedu.mipang.com/lizhi/mingyan/jianchi/' title='坚持' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>坚持</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>在别人看来往往是不可理喻的。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在天空清澈的夜晚，我总会在CD机中放进一张民谣。我总是</span><a href='http://yuedu.mipang.com/hchj/xihuan/' title='喜欢' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>喜欢</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>扬琴丁丁冬冬的声音，像是一个满腹心事的宋朝女词人的浅吟轻唱。红了樱桃，绿了芭蕉，雨打窗台湿绫绡。而我在沙发</span><a href='http://yuedu.mipang.com/hchj/wennuan/yijuhua/' title='温暖' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>温暖</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的包围中，在雀巢咖啡低调而飞扬的香味中，清清楚楚地知道，窗外的风无比的清凉，白云镶着月光如水的银边，一切完美，明日一定阳光明媚，我可以放肆得无法无天。</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　然而大多数夜晚我的</span><a href='http://yuedu.mipang.com/hchj/shanggan/xinqing/' title='心情' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>心情</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>是不好的。寂寞。苍凉。和一点点呼之欲出的恐惧。而这个时候我会</span><a href='http://yuedu.mipang.com/zuowen/xiangxiang/xuanze/' title='选择' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>选择</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>张楚，或者窦唯。我总是以一种抗拒的姿态坐在客厅墙角的蓝白色沙发里，像个寂寞但倔强的小孩子。满脸的抗拒和愤怒，却睁着发亮的眼睛听着张楚唱“上苍保佑吃饱了饭的人民”以及窦唯的无字哼唱。我是个不按时吃饭的人，所以上苍并不保佑我，我常常胃疼，并且疼得掉下眼泪。我心爱的那个蓝白色沙发的对面是堵白色的墙，很大的一片白色，蔓延出泰山压顶般的空虚感。我曾经试图在上面挂上几幅我心爱的油画，可最终我把它们全部取了下来。空白，还是空白。那堵白色的墙让我想到</span>",4);
insert into memberRecommend(aId,img,title,digest,pullTime,content,tyId) value(9,"/images/0.2619449282509203.jpg","tesing title twions","this is digest onewriwo","2018-5-1","<p><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>折叠 昨日的心扉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　却不经意间洒落了一地</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　湿漉漉的痕迹</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　初夏的雨 缠满悱恻</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　有芬芳的花事悄悄来临 植在枝端</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　洒入梦境</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　游走一生的</span><a href='http://yuedu.mipang.com/hchj/gudu/' title='孤独' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>孤独</a><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　剪辑成诗 用一枚悠悠明月盖了</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　</span><a href='http://yuedu.mipang.com/shici/yuguangzhong/xiangchou/' title='乡愁' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>乡愁</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的印戳</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　等待着飘雪尘埃落定</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　躲进</span><a href='http://yuedu.mipang.com/gushi/' title='故事' target='_blank' style='color: rgb(6, 1, 16); text-decoration-line: none; font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'>故事</a><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>的臂弯 涟漪雨蝶花的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　晶莹剔透</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　研煮香墨 顺着紫藤萝的</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　蔓节伸向远方 你我他不曾回眸亦</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　不会止步</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　也许 在未来的岁月</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　日记将与信鸽挥手告别 留下一抹清凉</span><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><br style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; white-space: normal; background-color: rgb(250, 251, 252);'/><span style='color: rgb(51, 51, 51); font-family: 微软雅黑; font-size: 18px; background-color: rgb(250, 251, 252);'>　　在风里</span></p>",4);



-- 模拟试题
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1','1','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1,2','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1,2','1,2',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1','1,2','1','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1','1,2','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1','1','1,2',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1,2','1,2',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1','1','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1,2','1',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1,2','1,2','1,2','1,2',1);
insert into mockExam(tId,sId,rId,lId,wId,dId) value(1,'1','1,2','1','1',1);


insert into mockExamR(mId,mEId,dId) values(1,2,1),(1,3,1),(1,5,1),(2,2,1),(2,4,1),(2,7,1),(3,1,1),(3,3,1),(3,6,1),(4,3,1),(4,4,1),(4,5,1),(5,1,1),(5,2,1),(5,5,1),(6,1,1),(6,5,1),(6,7,1),(7,4,1),(7,6,1),(7,7,1),(8,3,1),(8,5,1),(8,6,1),(9,1,1),(9,5,1),(9,7,1);

insert into allAnswerRecord(mId,tyId,isM,materialId,numForM,mp4,mAnswer,rightAnswer,isRight,wContent,score,startTime,endTime)
values(1,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(2,1,0,1,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,2,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,3,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,4,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,5,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,6,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,7,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,0,8,0,"/video/120170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(3,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(4,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(5,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),


(6,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(7,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(8,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(9,1,0,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,3,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,4,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,5,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,6,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,7,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,0,8,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),

(1,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(1,2,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,0,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(1,2,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,0,4,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,0,4,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(2,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(2,2,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,0,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(2,2,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,0,4,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,0,4,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(3,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(3,2,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,0,3,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,0,3,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,0,3,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,0,3,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(3,2,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,0,4,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,0,4,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),


(4,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,0,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,0,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,0,3,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,0,3,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,0,3,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,0,3,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),


(5,2,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,0,3,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,0,3,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,0,3,7,null,"D","A","0",null,5,"1528780320","1528780325"),
(5,2,0,3,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(5,2,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,0,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(5,2,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,0,4,3,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,0,4,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(6,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(6,2,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,0,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(6,2,0,6,1,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,0,6,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,0,6,4,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(6,2,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,0,6,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(7,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(7,2,0,5,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,0,5,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,0,5,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,0,5,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,0,5,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,0,5,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,0,5,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,0,5,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(7,2,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,0,4,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,0,4,4,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,0,4,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(8,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(8,2,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,0,2,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,0,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(8,2,0,5,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,0,5,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,0,5,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,0,5,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,0,5,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,0,5,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,0,5,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,0,5,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(9,2,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,0,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(9,2,0,2,1,null,"D","A","0",null,5,"1528780320","1528780325"),
(9,2,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,0,2,3,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,0,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,0,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(9,2,0,6,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,0,6,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,0,6,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,0,6,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),

(1,3,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,3,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,0,4,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,3,0,6,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,0,6,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,0,6,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(2,3,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,0,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,3,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,0,4,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,3,0,6,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,0,6,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,0,6,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(3,3,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,0,3,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,0,3,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,0,3,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,3,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,0,4,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,3,0,6,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,0,6,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,0,6,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(4,3,0,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,0,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,0,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,0,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,0,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,0,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,0,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,3,0,8,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,0,8,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,0,8,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,0,8,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,0,8,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,0,8,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,0,8,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,3,0,6,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,0,6,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,0,6,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(5,3,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,0,3,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,3,0,3,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,0,3,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,3,0,5,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,0,5,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,0,5,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,0,5,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,0,5,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,3,0,5,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,0,5,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,3,0,7,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,0,7,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,0,7,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,0,7,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,0,7,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,3,0,7,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,0,7,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(6,3,0,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,0,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,0,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,0,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,0,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,3,0,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,0,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,3,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,0,4,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,3,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,3,0,8,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,0,8,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,0,8,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,0,8,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,0,8,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,3,0,8,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,0,8,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(7,3,0,5,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,0,5,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,0,5,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,0,5,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,0,5,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,0,5,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,0,5,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,3,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,0,4,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,3,0,6,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,0,6,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,0,6,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,0,6,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,0,6,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,0,6,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,0,6,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(8,3,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,0,3,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,0,3,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,0,3,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,3,0,4,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,0,4,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,0,4,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,0,4,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,0,4,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,0,4,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,0,4,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,3,0,5,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,0,5,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,0,5,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,0,5,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,0,5,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,0,5,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,0,5,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(9,3,0,3,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,0,3,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,0,3,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,0,3,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,0,3,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,3,0,3,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,0,3,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,3,0,7,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,0,7,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,0,7,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,0,7,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,0,7,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,3,0,7,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,0,7,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,3,0,9,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,0,9,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,0,9,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,0,9,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,0,9,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,3,0,9,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,0,9,7,null,"C","A","0",null,5,"1528780320","1528780325"),

(1,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(1,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(1,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(1,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(1,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(1,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(2,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(3,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(3,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(3,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(3,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(3,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(3,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(4,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(4,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(4,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(4,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(4,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(4,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(5,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(5,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(5,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(5,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(5,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(5,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(6,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(6,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(6,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(6,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(6,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(6,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(7,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(8,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(8,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(8,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(8,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(8,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(8,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(9,4,0,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(9,4,0,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(9,4,0,3,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(9,4,0,4,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(9,4,0,5,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(9,4,0,6,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325");






insert into allAnswerRecord(mId,tyId,isM,materialId,numForM,mp4,mAnswer,rightAnswer,isRight,wContent,score,startTime,endTime)
values(1,1,1,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,1,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,2,1,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,1,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,1,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,1,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,1,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,1,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,1,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,1,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(1,3,1,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,1,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,1,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,1,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,1,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,1,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,1,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,4,1,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(1,1,2,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,1,2,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,2,2,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,2,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,2,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,2,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,2,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,2,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,2,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,2,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(1,2,2,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,2,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,2,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,2,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,2,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,2,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,2,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,2,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(1,3,2,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,2,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,2,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,2,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,2,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,2,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,2,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,3,2,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,2,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,2,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,2,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,2,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,2,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,2,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,4,2,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(1,1,3,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(1,2,3,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,3,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,3,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,3,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,3,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,3,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,3,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,3,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(1,2,3,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,3,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,2,3,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,2,3,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,3,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,2,3,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,2,3,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,2,3,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(1,3,3,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,3,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,3,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(1,3,3,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(1,3,3,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(1,3,3,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(1,3,3,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(1,4,3,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(2,1,4,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,4,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,2,4,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,4,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,4,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,4,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,4,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,4,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,4,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,4,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(2,2,4,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,4,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,4,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,4,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,4,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,4,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,4,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,4,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(2,3,4,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,4,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,4,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,4,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,4,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,4,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,4,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,4,4,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(2,1,5,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,5,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,2,5,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,5,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,5,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,5,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,5,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,5,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,5,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,5,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(2,2,5,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,5,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,5,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,5,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,5,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,5,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,5,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,5,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(2,3,5,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,5,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,5,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,5,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,5,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,5,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,5,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,3,5,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,5,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,5,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,5,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,5,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,5,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,5,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,4,5,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,5,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(2,1,6,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,1,6,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(2,2,6,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,6,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,6,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,2,6,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,2,6,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,2,6,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,2,6,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,2,6,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(2,3,6,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,6,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,6,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(2,3,6,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(2,3,6,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(2,3,6,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(2,3,6,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(2,4,6,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(2,4,6,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(3,1,7,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,7,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,2,7,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,7,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,7,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,7,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,7,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,7,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,7,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,7,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(3,3,7,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,7,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,7,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,7,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,7,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,7,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,7,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,4,7,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(3,1,8,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,8,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,2,8,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,8,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,8,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,8,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,8,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,8,1,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,8,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,8,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(3,2,8,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,8,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,8,2,3,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,8,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,8,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,8,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,8,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,8,2,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(3,3,8,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,8,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,8,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,8,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,8,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,8,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,8,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,3,8,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,8,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,8,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,8,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,8,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,8,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,8,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,4,8,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(3,1,9,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,1,9,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(3,2,9,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,9,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,2,9,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,2,9,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,9,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,2,9,1,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,2,9,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,2,9,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(3,3,9,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,9,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,9,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,9,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,9,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,9,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,9,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,3,9,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,9,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,9,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(3,3,9,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(3,3,9,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(3,3,9,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(3,3,9,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(3,4,9,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(4,1,10,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,10,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,2,10,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,10,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,10,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,10,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,10,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,10,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,10,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,10,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(4,2,10,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,10,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,10,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,10,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,10,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,10,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,10,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,10,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,10,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,10,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,10,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,10,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,10,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,10,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,10,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,3,10,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,10,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,10,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,10,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,10,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,10,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,10,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,4,10,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(4,1,11,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,1,11,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,2,11,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,11,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,11,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,11,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,11,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,11,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,11,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,11,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(4,2,11,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,11,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,11,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,11,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,11,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,11,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,11,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,11,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,11,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,11,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,11,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,11,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,11,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,11,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,11,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,3,11,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,11,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,11,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,11,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,11,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,11,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,11,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,4,11,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(4,4,11,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(4,1,12,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(4,2,12,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,12,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,12,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,12,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,12,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,12,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,2,12,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,12,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(4,2,12,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,12,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,12,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,2,12,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,12,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,2,12,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,2,12,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,2,12,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,12,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,12,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,12,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(4,3,12,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(4,3,12,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(4,3,12,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(4,3,12,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(4,4,12,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(5,1,13,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,13,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,2,13,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,13,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,13,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,13,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,13,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,13,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,13,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,13,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(5,3,13,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,13,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,13,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,13,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,13,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,3,13,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,13,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,4,13,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(5,1,14,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,1,14,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,2,14,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,14,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,14,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,14,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,14,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,14,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,14,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,14,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(5,2,14,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,14,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,14,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,14,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,14,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,14,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,14,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,14,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,14,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,14,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,14,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,14,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,14,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,3,14,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,14,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,4,14,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(5,1,15,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(5,2,15,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,15,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,15,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,15,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,15,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,15,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,2,15,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,15,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(5,2,15,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,15,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,15,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,2,15,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,15,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,2,15,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,2,15,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,2,15,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,15,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,15,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,15,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(5,3,15,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(5,3,15,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(5,3,15,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(5,3,15,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(5,4,15,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(6,1,16,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,16,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,2,16,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,16,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,16,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,16,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,16,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,16,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,16,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,16,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(6,3,16,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,16,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,16,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,16,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,16,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,3,16,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,16,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,4,16,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(6,1,17,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,2,17,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,17,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,17,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,17,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,17,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,17,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,17,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,17,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(6,2,17,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,17,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,17,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,17,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,17,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,17,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,17,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,17,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,17,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,17,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,17,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,17,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,17,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,3,17,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,17,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,4,17,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(6,1,18,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,1,18,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(6,2,18,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,18,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,18,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,2,18,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,2,18,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,2,18,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,2,18,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,2,18,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(6,3,18,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,18,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,18,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(6,3,18,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(6,3,18,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(6,3,18,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(6,3,18,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(6,4,18,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(6,4,18,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(7,1,19,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,19,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,2,19,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,19,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,19,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,19,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,19,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,19,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,19,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,19,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(7,2,19,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,19,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,19,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,19,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,19,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,19,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,19,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,19,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,19,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,19,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,19,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,19,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,19,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,19,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,19,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,3,19,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,19,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,19,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,19,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,19,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,19,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,19,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,4,19,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,19,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(7,1,20,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,20,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,2,20,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,20,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,20,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,20,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,20,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,20,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,20,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,20,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(7,3,20,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,20,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,20,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,20,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,20,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,20,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,20,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,3,20,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,20,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,20,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,20,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,20,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,20,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,20,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,4,20,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(7,1,21,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,1,21,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(7,2,21,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,21,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,21,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,2,21,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,2,21,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,2,21,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,2,21,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,2,21,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(7,3,21,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,21,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,21,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(7,3,21,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(7,3,21,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(7,3,21,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(7,3,21,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(7,4,21,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(7,4,21,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(8,1,22,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,22,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,2,22,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,22,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,22,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,22,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,22,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,22,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,22,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,22,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(8,2,22,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,22,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,22,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,22,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,22,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,22,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,22,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,22,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,22,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,22,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,22,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,22,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,22,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,22,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,22,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,3,22,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,22,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,22,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,22,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,22,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,22,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,22,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,4,22,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(8,1,23,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,2,23,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,23,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,23,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,23,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,23,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,23,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,23,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,23,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(8,2,23,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,23,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,23,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,23,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,23,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,23,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,23,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,23,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,23,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,23,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,23,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,23,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,23,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,23,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,23,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,4,23,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(8,1,24,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,1,24,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(8,2,24,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,24,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,24,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,2,24,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,2,24,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,2,24,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,2,24,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,2,24,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(8,3,24,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,24,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,24,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,24,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,24,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,24,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,24,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,3,24,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,24,2,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,24,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(8,3,24,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(8,3,24,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(8,3,24,2,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(8,3,24,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(8,4,24,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(9,1,25,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,25,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,2,25,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,25,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,25,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,25,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,25,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,25,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,25,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,25,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(9,3,25,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,25,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,25,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,25,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,25,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,3,25,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,25,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,4,25,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(9,1,26,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,2,26,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,26,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,26,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,26,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,26,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,26,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,26,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,26,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(9,2,26,2,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,26,2,2,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,26,2,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,26,2,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,26,2,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,26,2,6,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,26,2,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,26,2,8,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,26,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,26,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,26,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,26,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,26,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,3,26,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,26,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,4,26,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),

(9,1,27,1,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,1,27,2,0,"/video/20170713105921293034753.mp3",null,null,"-1",null,0,"1528780320","1528780325"),
(9,2,27,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,27,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,27,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,2,27,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,2,27,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,2,27,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,2,27,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,2,27,1,8,null,"AD","AB","0",null,5,"1528780320","1528780325"),
(9,3,27,1,1,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,27,1,2,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,27,1,3,null,"A","A","1",null,5,"1528780320","1528780325"),
(9,3,27,1,4,null,"AC","AB","0",null,5,"1528780320","1528780325"),
(9,3,27,1,5,null,"B","A","0",null,5,"1528780320","1528780325"),
(9,3,27,1,6,null,"AB","AB","1",null,5,"1528780320","1528780325"),
(9,3,27,1,7,null,"C","A","0",null,5,"1528780320","1528780325"),
(9,4,27,1,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325"),
(9,4,27,2,0,null,null,null,"-1","<p>Aren’t airports strange places? There’s so much happening in them. People coming, people going; people crying with sadness because they’re going away, people crying with joy because they’ve arrived. Big airports are almost like small towns. It seems like you walk across a town by the time you check in and get to your departure1 gate. The thing I like most about airports is people watching. There are people from all over the world. I also like how everything fits and works2 together. You check your luggage in and then it disappears, before you see it again at the next airport. I still think airports need improving. There’s not a lot to do there. Airports really need to have an entertainment area so people can kill time.</P>",0,"1528780320","1528780325");
