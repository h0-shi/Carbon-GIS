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
	
	var count = 0;
	var data;
	var chart;
    var options;
      
	function drawChart(){
		data = google.visualization.arrayToDataTable([
	         ['loaction', '사용량', { role: 'style' }],
	        <c:forEach items="${sdTotal }" var="sd">
	 			['${sd.usage_nm}',${sd.usage}, "skyblue"],
	 		</c:forEach>
	      ]);
		chart = new google.visualization.BarChart(document.getElementById('myPieChart'));
		chart.draw(data, null);
	}
	function addData(usage_nm, usage){
		data.addRow([usage_nm, usage, "skyblue"]);
		chart.draw(data, options);
	}
	function removeData(){
		data.removeRow(0);
		chart.draw(data, options);
	}
	
	
$(document).ready(function(){
	var sd;
	var sgg;
	var sdCD;
	var sggCD;
	
	$("#sd").on("change",function(){
		sd = $("#sd option:selected").text();
		sdCD = $("#sd option:selected").val();
		
		console.log(sd);
		
		var sggDd = $("#sgg");
		var all = $("<option value='0'>전체보기</option>");
		sggDd.empty();
		sggDd.append(all);
		
		$.ajax({
			url: './getDropdown.do',
			type: 'post',
			data: {'sd':sd, 'type':'sd'},
			dataType: 'json',
			success: function(result){
				for (var i = 0; i < result.length; i++) {
					var option = $("<option value='"+result[i].sgg_cd+"'>"+result[i].sgg_nm+"</option>");
					sggDd.append(option);
				}
			},
			error: function(request, status, error){
				console.log("실패");
			}
		});
	});
	
	$("#sgg").on("change",function(){
		sgg = $("#sgg option:selected").text();
		sggCD = $("#sgg option:selected").val();
	})
	
	$("#dropdowns").submit(event,function(){
		event.preventDefault();
		var chart = new google.visualization.BarChart(document.getElementById('myPieChart'));
		
		sd = $("#sd option:selected").text();
		sdCD = $("#sd option:selected").val();
		sgg = $("#sgg option:selected").text();
		sggCD = $("#sgg option:selected").val();
		
		var filter;
		var type;
		if(sggCD != 0){
			filter = sggCD;
			type = "bjd";
		} else if(sdCD != 0){
			filter = sd;
			type = "sgg";
		} else {
			filter = "";
			type= "sd";
		}
		
		$.ajax({
			url: "./getUsage.do",
			type: "post",
			data: {"filter":filter, "type":type},
			dataType: "json",
			success: function(result){
				console.log(result);
				console.log(result[0].usage_nm);
				console.log(result[0].usage);
				
				var table = $("#usageTable");
				$("#usageTable tbody tr td").remove();
				$("#usageTable tbody tr").remove();
				for (var i = 0; i < result.length; i++) {
					var td;
					td = '<tr><td>'+result[i].usage_nm+'</td>';
					td += '<td>'+result[i].usage.toLocaleString('kr-KR')+'</td></tr>';
					table.append(td);
					removeData();
					addData(result[i].usage_nm, result[i].usage);
				}
			},
			error: function(request, status, error){
				console.log("실패");
			}
		});
		
	});
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
			<table border="1" id="usageTable">
				<thead>
					<tr>
						<th>시도별</th>
						<th>사용량</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${sdTotal }" var="sd">
						<tr>
							<td>${sd.usage_nm }</td>
							<td><fmt:formatNumber value="${sd.usage }" pattern="#,###"/></td>
						</tr>
	 				</c:forEach>
				</tbody>
			</table>
		</div>
		<form id="dropdowns">
			<select id="sd">
				<option value=0>전체 선택</option>
				<c:forEach items="${sdnm }" var="sd">
					<option value="${sd.sd_nm }">${sd.sd_nm }</option>
				</c:forEach>
			</select>
			<select id="sgg">
				<option value=0>전체 선택</option>
			</select>
			<button type="submit">선택</button>
		</form>
	</div>
</body>
</html>