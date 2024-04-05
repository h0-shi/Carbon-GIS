<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통계페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<link href="<c:url value='/resources/'/>css/sidebar.css" rel="stylesheet" type="text/css" >
<script type="text/javascript">
	google.charts.load('current', {packages: ['corechart']});
	google.charts.setOnLoadCallback(drawChart);
	
	var count = 0;
	var data;
	var chart;
    var options;
    var count = 0;
      
	function drawChart(){
		data = google.visualization.arrayToDataTable([
	         ['loaction', '사용량', { role: 'style' }],
	        <c:forEach items="${sdTotal }" var="sd">
	 			['${sd.usage_nm}',${sd.usage}, "skyblue"],
	 		</c:forEach>
	      ]);
		options = {'title':'국가 전기 사용량'};
		chart = new google.visualization.BarChart(document.getElementById('chart_div'));
		chart.draw(data, options);
		window.addEventListener('resize',drawChart,false);
	}
	function addData(usage_nm, usage){
		data.addRow([usage_nm, usage, "skyblue"]);
		chart.draw(data, options);
	}
	function removeData(count){
		for (var i = 0; i < count; i++) {
			data.removeRow(0);
		}
		chart.draw(data, options);
	}
	
	
$(document).ready(function(){
	var sd;
	var sgg;
	var sdCD;
	var sggCD;
	count = ${fn:length(sdTotal)};
	
	$("#sd").on("change",function(){
		sd = $("#sd option:selected").text();
		sdCD = $("#sd option:selected").val();
		
		var sggDd = $("#sgg");
		var disabled = $("<option value='0' disabled selected >시/군/구 선택</option>");
		var all = $("<option value='1'>전체보기</option>");
		sggDd.empty();
		sggDd.append(disabled);
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
		sd = $("#sd option:selected").text();
		sdCD = $("#sd option:selected").val();
		sgg = $("#sgg option:selected").text();
		sggCD = $("#sgg option:selected").val();
		
		if(sdCD == 0){
			alert("시/도를 선택해주세요.");
			return false;
		} else if(sggCD == 0){
			alert("시군구를 선택해주세요.");
			return false;
		}
		
		
		var filter;
		var type;
		if(sggCD != 1){
			filter = sggCD;
			type = "bjd";
		} else if(sdCD != 1){
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
				var table = $("#usageTable");
				$("#usageTable tbody tr td").remove();
				$("#usageTable tbody tr").remove();
				removeData(count);
				count = 0;
				for (var i = 0; i < result.length; i++) {
					var td;
					td = '<tr><td>'+result[i].usage_nm+'</td>';
					td += '<td>'+result[i].usage.toLocaleString('kr-KR')+'</td></tr>';
					table.append(td);
					addData(result[i].usage_nm, result[i].usage);
					count++;
				}
			},
			error: function(request, status, error){
				console.log("실패");
			}
		});
		
	});
});
</script>
<style type="text/css">
.mainContent{
	height: calc(100vh - 70px);
	margin: 10px;
	padding: 10px;
	border: 1px solid grey;
	border-radius: 5px;
}
.chart{
	width: 100%;
	height: 100%;
	border-color: 10px soild black;
}
.graphDiv{
	padding: 10px;
	margin-right: 5px;
	width: calc(50% - 5px);
	height: 80%;
	float: left;
	border: 1px solid grey;
	border-radius: 5px;
}
.usageTable{
	width: 100%;
	height: 100%;
}
.total{
	height: auto;
	margin-bottom: 10px;
}
.table_div{
	width: calc(50% - 5px);
	height: 80%;
	margin-left: 5px;
	display: block;
	justify-content: center;
	text-align: center;
	overflow-y: auto;
	border: 1px solid grey;
	border-radius: 5px;
	float: left;
}
.aContainer{
	display: flex;
	height: calc(100vh - 50px);
	width: 100%;
}
.content{
	flex: 1 1 auto;
}
</style>
</head>
<body>
	<%@ include file="topNav.jsp" %>
	<div class="aContainer">
		 <div class="sidebar">
			<div class="sideCategory">
		        <ul>
		            <li>
		            	<a href="./hover.do">
		            	<img class="icon" alt="탄소공간지도" src="<c:url value='/resources/'/>/image/mapicon.png">
		           		<br>탄소공간지도
		           		</a>
		           	</li>
		            <li>
		           		 <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
		           		 <img class="icon" alt="탄소공간지도" src="<c:url value='/resources/'/>/image/uploadicon.png">
		           		 <br>데이터 업로드
		           		 </a>
		           	</li>
		            <li class="selectedCate">
			            <a href="./analysis.do">
			            <img class="icon" alt="탄소공간지도" src="<c:url value='/resources/'/>/image/graphicon.png">
			            <br>탄소 통계
			            </a>
			        </li>
		        </ul>
			</div>
			<div class="sideDetail">
				<form id="dropdowns">
					<select id="sd">
						<option value=0 selected disabled>시/도 선택</option>
						<option value=1>전체 선택</option>
						<c:forEach items="${sdnm }" var="sd">
							<option value="${sd.sd_nm }">${sd.sd_nm }</option>
						</c:forEach>
					</select>
					<select id="sgg">
						<option value=0 selected disabled>시/군/구 선택</option>
					</select>
					<button type="submit">선택</button>
				</form>
			</div>
	    </div>
		
		<div class="content">
			<div class="mainContent">
				<div class="total">
					<h2>탄소 배출(전기) 현황</h2>
					<hr>
					<h5>총 배출량 : <fmt:formatNumber value="${total }" pattern="#,###"/></h5>
				</div>
				<div class="graphDiv">
					<div id="chart_div" class="chart"></div>
				</div>
				<div class="table_div">
					<table id="usageTable" class="usageTable">
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
			</div>
		</div>
		<%@ include file="upload.jsp" %>
	</div>
</body>
</html>