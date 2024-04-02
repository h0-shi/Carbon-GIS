<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통계페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
});
</script>
</head>
<body>
	<div class="container">
		<h1>탄소 배출(전기) 현황</h1>
		<hr>
		<div class="total">
			배출량 : <fmt:formatNumber value="${total }" pattern="#,###"/>
		</div>
		<div class="graph">
		
		</div>
	</div>
</body>
</html>