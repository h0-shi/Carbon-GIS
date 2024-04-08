<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Diphylleia&family=Gowun+Dodum&family=Nanum+Gothic&family=Nanum+Myeongjo&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR:wght@500&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>브이월드 오픈API</title>
<link href="<c:url value='/resources/'/>css/ol.css" rel="stylesheet" type="text/css" > <!-- OpenLayer css -->
<script type="text/javascript">
$(document).ready(function(){
	console.log("시작");
	$('.bg-inner').on("mousemove", function(e) {
		  const width = $(window).width();
		  const height = $(window).height();

		  const moveX = (e.pageX - width / 2) / width;
		  const moveY = (e.pageY - height / 2) / height;

		  const backMoveX = -moveX * 30;
		  const backMoveY = -moveY * 10;
		  $('.temp-bg-back').css({
		    'transform': 'translate('+backMoveX+'px, '+backMoveY+'px)'
		  });
		});
});
</script>
<style>

* { 
	margin: 0; 
	padding: 0;
	font-family: "Noto Serif KR", serif;
  	font-weight: 750;
  	font-style: normal; 
}
.bg-inner {
	 width: 100%; 
	 height: 100vh; 
	 overflow: hidden;
	 position: relative;
}
.wrap { 
	transform: scale(1.2);
}
.temp-bg-back { 
	transition: .1s ease-out; 
	filter: brightness(60%);
}
.backBg { 
	width: 100%; 
}
.content{
	color: white;
	position: absolute;
	top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
	z-index: 5;
	text-align: center;
}
.logo > img{
	width: 100%;
	height: auto;
   	display: block;
	margin: 0 auto; /* 가로 중앙 정렬 */
	filter: drop-shadow(1px 1px white);
}
.content > button{
	width: 50%;
	height: 60px;
	margin-top: 30px;
	background-color: rgba(255,255,255,0.04);
	color: white;
	border-color: white;
	border-width: 1px;
	font-size: x-large;
}
.content > button:hover{
	background-color: rgba(255,255,255,0.2);
}
.title{
	margin-top: 15px;
}
.logo{
	max-width: 100%;	
	height: auto;
}
</style>
</head>
    <div class="content">
	    <div class="logo" >
	    	<img alt="logo" src="<c:url value='/resources/'/>/image/logo.png">
	    </div>
    	<h1 class="title">C조 탄소 지도 프로젝트</h1>
    	<span>- 백건하, 박시호, 이문희, 이진선, 신동일 -</span>
    	<br>
    	<button onclick="location.href='./gisMap.do'">시작하기</button>
    </div>
	<div class="bg-inner">
	  <div class="wrap">
	    <div class="temp-bg-back">
	      <img src="<c:url value='/resources/'/>image/background.jpg" class="backBg">
	    </div>
	  </div>
	</div>
</body>
</html>