<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta charset="UTF-8">
<script type="text/javascript">
$(document).ready(function(){
	$(".progressDiv").hide();
	$(".spinner").hide();
	
	$("#fileBtn").click(function(event){
		event.preventDefault();
		var form = $("#file");
		console.log(form[0]); 
		
		var formData = new FormData(form[0]);
		//console.log(formData); 
		$("#file").hide();
		$(".spinner").show();
		
		$.ajax({
			url: './dbInsert.do',
			enctype: 'multipart/form-data',
			processData: false,
			contentType: false,
			data: formData,
			type: 'POST',
			success: function(result){
				$(".spinner").hide();
				$(".progressDiv").show();
				
				var i = 0;
				setInterval(function(){
					if(i==0){
						$(".nowLoading").text("진행중 .");
						i++;
					} else if(i==1){
						$(".nowLoading").text("진행중 . .");
						i++;
					}else {
						$(".nowLoading").text("진행중 . . .");
						i=0;
					}
				}, 1000);
				//소켓 서버 생성
				const websocket = new WebSocket("ws://localhost/project_WH/webSocket");
				websocket.onopen = function(){
					websocket.send(result);
				}
				websocket.onmessage = function(event) {	
				    //console.log("진행률", event.data);
				    $(".progress-bar").css("width",event.data+"%");
				    $(".progress-bar").text(event.data+"%");
				    if(event.data>99){
				    	alert("성공");
				    	location.reload(true);
				    }
				};
			},
			error: function(request, status, error){ //통신오류
				alert("에러 발생");
				$("#file").show();
			}
		});
	});
})
</script>
<style type="text/css">
.progress{
	width: 80%;
	margin: auto;
}
.progressDiv{
	text-align: center;
}
</style>
</head>
<body>
	<!-- Modal -->
	<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="staticBackdropLabel">데이터 업로드</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
		  <div class="progressDiv">
	      	<div class="progress">
			  <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 0%">0%</div>
			</div>
			  <span class="nowLoading">진행중 .</span>
		  </div>
	      <div class="modal-body modalMain">
	      	<div class="text-center spinner">
				<div class="spinner-border" role="status">
				  <span class="visually-hidden">Loading...</span>
				</div>
				<br>
				<span>로딩중 . . .</span>
			</div>
			<form id="file" enctype="multipart/form-data">
	      		<input type="file" name="file">
	      		<button type="button" id="fileBtn">업로드</button>
	      	</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
</body>
</html>