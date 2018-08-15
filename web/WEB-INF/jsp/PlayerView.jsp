<%--
  Created by IntelliJ IDEA.
  User: 11084919
  Date: 2018/8/10
  Time: 9:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <meta charset="utf-8" name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>airan播放器</title>
    <link rel="stylesheet" href="../css/layout.css" />
    <script src="../js/less.min.js"></script>
    <script src="../js/jquery.js"></script>
    <script src="../js/song.js"></script>
</head>

<body>
<div id="qqMain">
    <!--音乐-->
    <c:set var="cFlag" scope="session" value="${0}"/>
    <c:if test="${cFlag == 0}">
        <audio src="../music/qianbaidu.mp3" id="my_audio"></audio>
        <!--cd播放机-->
        <div class="img">
            <img src="../img/timg.jpg"/>
            <span class="centerCircle"></span>
        </div>
        <!--音频名字-->
        <div class="musicName">
            <!--<span>慌しく年</span>-->
            <span>千百度</span>
            <!--<span>Kiroro-好きな人</span>-->
        </div>
    </c:if>
    <c:if test="${cFlag == 1}">
        <audio src="../music/suzhouchengwaideweixiao.flac" id="my_audio"></audio>
        <!--cd播放机-->
        <div class="img">
            <img src="../img/timg.jpg"/>
            <span class="centerCircle"></span>
        </div>
        <div class="musicName">
            <!--<span>慌しく年</span>-->
            <span>苏州城外的微笑</span>
            <!--<span>Kiroro-好きな人</span>-->
        </div>
    </c:if>


    <!--歌词-->
    <!-- <div id="musicContent"> -->
    <!-- <span class="musicContent01"></span> -->
    <!-- <span class="musicContent02"></span> -->
    <!-- <span class="musicContent03"></span> -->
    <!-- </div> -->
    <div class="time">
        <!--当前时间-->
        <span class="now_time" id="now_time">00:00</span>
        <!--总的时间-->
        <span class="all_time" id="all_time">00:00</span>
    </div>
    <!--时间轴-->
    <div class="time_progress">
        <div class="progress">
            <p class="bar" id="bar"></p>
            <div class="btn" id="btn"></div>
        </div>
    </div>
    <!--暂停或播放-->
    <div class="btnpic" item="0"></div>
</div>
</body>
<script type="text/javascript">
    var my_audio = document.getElementById("my_audio");
    var p_all=$(".progress").width();
    var startX = startY = endX = endY = 0;
    //暂停或播放
    function playPause()
    {
        if(my_audio.paused)
        {
            my_audio.play();
            $(".img img").addClass("rainbow");
        }
        else
        {
            my_audio.pause();
            $(".img img").removeClass("rainbow");
        }
    }
    $(".btnpic").click(function(){
        if($(this).attr("item")=="0"){
            $(this).css("background-position","280px 0");
            $(this).attr("item","1");
        }else{
            $(this).css("background-position","0 0");
            $(this).attr("item","0");
        }

        playPause();
    });
    var lyric = parseLyric(songContent);
    //显示歌词的元素
    lyricContainer = document.getElementById('musicContent');
    //audio播放的时候实时获取当前播放时间
    my_audio.ontimeupdate = function()
    {
        //获取当前播放时间
        document.getElementById("now_time").innerHTML = timeFormat(my_audio.currentTime);
        //当前的长度
        now_long=my_audio.currentTime/my_audio.duration*p_all;
        $(".bar").css({width:now_long});
        var btn_l=now_long-10+'px';
        $(".btn").css({left:btn_l});
        //遍历所有歌词，看哪句歌词的时间与当然时间吻合
        for (var i = 0, l = lyric.length; i < l; i++) {
            if (this.currentTime /*当前播放的时间*/ > lyric[i][0]) {
                //显示到页面
//		            lyricContainer.textContent = lyric[i][1];
                if(i>=1){
                    $(".musicContent01").html(lyric[i-1][1]);
                    $(".musicContent02").html(lyric[i][1]);
                    $(".musicContent03").html(lyric[i+1][1]);
                }else{
                    $(".musicContent02").html(lyric[i][1]);
                    $(".musicContent03").html(lyric[i+1][1]);
                }
            };
            addListenTouch();
        };
    };

    //页面一旦加入就获取audio的总时间
    my_audio.onprogress = function()
    {
        document.getElementById("all_time").innerHTML = timeFormat(my_audio.duration);
        //总的长度
    };
    // Time format converter - 00:00//时间格式转换器- 00:00
    var timeFormat = function(seconds){
        var m = Math.floor(seconds/60)<10 ? "0"+Math.floor(seconds/60) : Math.floor(seconds/60);
        var s = Math.floor(seconds-(m*60))<10 ? "0"+Math.floor(seconds-(m*60)) : Math.floor(seconds-(m*60));
        return m+":"+s;
    };
    //手动拉拽进度条的部分
    function addListenTouch(){
        //var speed=$('.had-play');
        var btn=document.getElementById("btn");
        document.getElementById("btn").addEventListener("touchstart", touchStart, false);
        document.getElementById("btn").addEventListener("touchmove", touchMove, false);
        document.getElementById("btn").addEventListener("touchend", touchEnd, false);
        document.getElementById("musicContent").addEventListener("touchstart", touchStart, false);
        document.getElementById("musicContent").addEventListener("touchmove", touchMove, false);
        document.getElementById("musicContent").addEventListener("touchend", touchEnd, false);
    }
    function touchStart(e){
        e.preventDefault();
        var touch=e.touches[0];
        startX=touch.pageX;
        my_audio.pause();
        document.getElementById("all_time").innerHTML = timeFormat(my_audio.duration);
        //歌词区域touch移动距离
        var touchSong = e.targetTouches[0];
        startSongX = touchSong.pageX;
        startSongY = touchSong.pageY;
    }
    function touchMove(e){//滑动
        e.preventDefault();
        var touch=e.touches[0];
        x=touch.pageX-startX//滑动的距离
        //btn.style.webkitTransform='translate('+0+'px,'+y+'px)';
        var widthBar=now_long+x;
        //
        $(".bar").css({width:widthBar});
        if(widthBar<p_all)
        {
            //
            $("#btn").css({left:widthBar-10+'px'});
            $("#bar").css({width:widthBar});
        }//不让进度条超出页面
        //歌词区域touch移动距离
        var touchSong = e.targetTouches[0];
        endSongX = touchSong.pageX;
        endSongY = touchSong.pageY;

        var yu=widthBar/p_all*my_audio.duration;
        document.getElementById("now_time").innerHTML = timeFormat(yu);
    }
    function touchEnd(e){//手指离开屏幕
        e.preventDefault();//取消事件的默认动作
        now_long=parseInt(btn.style.left);
        var touch=e.touches[0];
        var dragPaddingLeft=btn.style.left;
        var change=dragPaddingLeft.replace("px","");
        numDragpaddingLeft=parseInt(change);
        //console.log(numDragpaddingLeft);
        var currentTimeNew=(numDragpaddingLeft/(p_all-20)*my_audio.duration);
//		if(endSongX&&startSongX){
//			if((endSongY-startSongY)<0){
//
//				currentTimeNew = currentTimeNew - (parseInt(endSongY-startSongY))/80*my_audio.duration;
//			}
//			currentTimeNew = (endSongY-startSongY)/80*my_audio.duration;
//		}

        my_audio.currentTime = currentTimeNew;
        //console.log(currentTimeNew);
        //console.log(timeFormat(currentTimeNew));
        document.getElementById("now_time").innerHTML = timeFormat(currentTimeNew);
        my_audio.play();
        document.getElementById("all_time").innerHTML = timeFormat(my_audio.duration);
        console.log("垂直移动距离=    "+(endSongY-startSongY));
    }
</script>

</html>
