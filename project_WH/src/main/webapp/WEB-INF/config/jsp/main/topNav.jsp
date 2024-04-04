<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
.head{
	width: 5000px;
    height: 50px;
    text-align: center;
    max-width: 100%;
    background-position: center;
    background-size: cover;
    background-color: #333333;
    z-index: 1;
    display: flex;
    justify-content: center;
}
.head img{
	width: 300px;
	margin: auto;
	padding: 0; 
	text-align: left;
}
</style>
</head>
<body>
	<div class="head">
        <img class="icon" alt="로고" class="logo" onclick="location.href='./main.do'" src="<c:url value='/resources/'/>/image/logo.png">
   	</div>
</body>
</html>