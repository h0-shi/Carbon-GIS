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
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	google.charts.load('current', {packages: ['corechart']});
	google.charts.setOnLoadCallback(drawChart);
	function drawChart(){
		var data = google.visualization.arrayToDataTable([
	         ['Element', 'Density', { role: 'style' }],
	        <c:forEach items="${sdTotal }" var="sd">
	 			['${sd.sd_nm}',${sd.usage}, "skyblue"],
	 		</c:forEach>
	      ]);
		var chart = new google.visualization.BarChart(document.getElementById('myPieChart'));
		chart.draw(data, null);
	}
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
			<div id="myPieChart"></div>
		</div>
		<div>
			<table border="1">
				<thead>
					<tr>
						<th>시도별</th>
						<th>사용량</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${sdTotal }" var="sd">
						<tr>
							<td>${sd.sd_nm }</td>
							<td><fmt:formatNumber value="${sd.usage }" pattern="#,###"/></td>
						</tr>
	 				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>