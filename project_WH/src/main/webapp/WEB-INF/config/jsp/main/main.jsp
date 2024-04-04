<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>브이월드 오픈API</title>

<link href="<c:url value='/resources/'/>css/ol.css" rel="stylesheet" type="text/css" > <!-- OpenLayer css -->
<script>
	const websocket = new WebSocket("ws://localhost/project_WH/webSocket");
	
	websocket.onopen = function(event) {
	    console.log("WebSocket connection opened");
	};
	
	//여기서 받는구나
    websocket.onmessage = function(event) {
        console.log("Received message from server:", event.data);
    };
	
	function sendMessage() {
		  const fileInput = document.getElementById("fileInput");
          const file = fileInput.files[0];
          
          const reader = new FileReader();
          reader.onload = function(event) {
              const fileContent = event.target.result;
              const lines = fileContent.split('\n'); // 한 줄씩 분리
              let chunk = "";
              
              lines.forEach(line => {
                  chunk += line + '\n'; // 줄을 chunk에 추가
                  if (chunk.split('\n').length >= 10000) { // 10000줄마다 전송
                      websocket.send(chunk); // chunk 전송
                      chunk = ""; // chunk 초기화
                  }
              });

              if (chunk.length > 0) { // 마지막 chunk 전송
                  websocket.send(chunk);
              }
              
              
          };
          reader.readAsText(file);
	}

   $(document).ready(function() {
	   
   });
   
</script>

<style>
body, html{
	height: 100%;
	width: 100%;
	margin: 0;
}
    .map {
      height: 100%;
      width: 100% ;
    }
    
    .olControlAttribution {
        right: 20px;
    }

    .olControlLayerSwitcher {
        right: 20px;
        top: 20px;
    }
 .legend{
  width: auto;
  height: 125px;
  display: flex;
  justify-content: center;
  align-items: center;
  border: 1px solid black;
  border-radius: 2px;
  font-size: x-small;
  background-color: white;
  position: absolute;
  left: 50px;
  top: 50px;
  
  user-select: none;
  
  /*  drag cursor   */
  cursor: grab;
}

.legend:active {
  cursor: grabbing;
}

.color{
	width: 25px;
	height: 20px;
	background-color: red;
}
.boxLine{
	width: 100%;
	height: 70%;
}
.container{
	height: 100%;
	width: 100%;
	display: flex;
}
</style>
</head>
<body>
<div class="">
		<div class="">
			<input type="file" id="fileInput">
    		<button onclick="sendMessage()">Send</button>
			
			<hr>
			<div class="total">
				배출량 : <fmt:formatNumber value="${total }" pattern="#,###"/>
			</div>
			<div class="graph">
				<div id="chart" class="chart"></div>
			</div>
			<div class="table">
				<div>
					<table border="1" id="usageTable" class="usageTable">
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
	</div>
</body>
</html>