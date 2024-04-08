<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>브이월드 오픈API</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">

<script type="text/javascript" src="<c:url value='resources/js/ol.js' />"></script>
<link href="<c:url value='/resources/'/>css/ol.css" rel="stylesheet" type="text/css" > <!-- OpenLayer css -->
<link href="<c:url value='/resources/'/>css/sidebar.css" rel="stylesheet" type="text/css" >
<link href="<c:url value='/resources/'/>css/gisMap.css" rel="stylesheet" type="text/css" > <!-- OpenLayer css -->
<script>
   $(document).ready(function() {
	   //변수들 모음
	   //Colored Border 지우기 위한 변수
		let selectedLayer;
		let colorWms;
		let ele;
		//범례 레이어
		let legend;
		//오버레이
		let overLay;
		//지역 코드와 이름
		let sdCD;
		let sggCD;
		let bjdCD;
		let sd;
		let sgg;
		let bjd;
		
		
	   let map = new ol.Map({
		   target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
		    layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
		      new ol.layer.Tile({
		        source: new ol.source.OSM({
		          url: 'http://api.vworld.kr/req/wmts/1.0.0/${key}/Base/{z}/{y}/{x}.png' // vworld의 지도를 가져온다.
		        })
		      })
		    ],
		    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
		      center: ol.proj.fromLonLat([128.4, 35.7]),
		      zoom: 7
		    })
	   });
	   /*
		var wms = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
				
				params : {

		               'SRS' : 'EPSG:3857', // SRID
		               'FORMAT' : "image/png" // 포맷
		            },
		            serverType : 'geoserver',
		         })
		});
		*/
	//	map.addLayer(wms); // 맵 객체에 레이어를 추가함
		
	// 지도 클릭시 정보 가져옴
		map.on('singleclick', function(evt) {
			//var sgg = $('#sgg option:selected').text();
			sggCD = $('#sgg option:selected').val();
			sgg = $('#sgg option:selected').text();
			
			$(".pop").remove();
		    var view = map.getView();
		    var viewResolution = view.getResolution();
		    var source = legend.getSource();
		    var url =  source.getGetFeatureInfoUrl(
		    		 evt.coordinate, viewResolution, view.getProjection(), {
		    	            'INFO_FORMAT': 'application/json',
		    	            'FEATURE_COUNT': 50
		    	        });
		    if (url) {
		        fetch(url).then(function(response) {
		        	response.text().then(function(text){
						var jsonObj = JSON.parse(text);
						var usage = jsonObj.features[0].properties.usage;
						usage = usage.toLocaleString('ko-KR');
						//오버레이 생성
						var coordinate = evt.coordinate;
						const div = $('.ol-overlay-container');
						if(div.length>0){
							div.remove();
						}
						
						let content = document.createElement("div");
						content.classList.add('ol-popup','pop');
						
						if(sggCD == 1){
							ele = jsonObj.features[0].properties.sgg_nm;
							$("#selectedLoc").text("선택한 위치 : "+ele+" | "+"사용량 : "+usage);
							content.innerHTML = "<div class='overLay'><span> 선택 지역 : "+ele+'<br>사용량 : '+usage+'</span></div>';
						} else {
							ele = jsonObj.features[0].properties.bjd_nm;
							$("#selectedLoc").text("선택한 위치 : "+sgg+" "+ele+" | "+"사용량 : "+usage);
							content.innerHTML = "<div class='overLay'><span> 선택 지역 : "+sgg+" "+ele+'<br>사용량 : '+usage+'</span></div>';
						}
						
						overlay = new ol.Overlay({
						       element: content, // 생성한 DIV
						});
						
						//오버레이의 위치 저장
						overlay.setPosition(coordinate);
						//지도에 추가
						map.addOverlay(overlay);
						
		        	})
		        });
		    }
		});
		
		$("#sd").on('change',function(){
			//var param = "sd_nm='"+$(this).val()+"'";
			//map.removeLayer(legend);
			
			sd = $("#sd option:selected").text();
			sdCD = $("#sd option:selected").val();
			//sgg 드롭다운			
			var sggDd = $("#sgg");
			var bjdDd = $("#bjd");
			filter = "sd_nm='"+sd+"'";
			
			sggDd.empty();
			bjdDd.empty();
			var all = $("<option value='1'>전체보기</option>");
			bjdDd.append(all);
			var disabled = $("<option value='0' disabled selected >시/군/구 선택</option>");
			sggDd.append(all);
			sggDd.append(disabled);
			disabled = $("<option value='0' disabled selected >법정동 선택</option>");
			bjdDd.append(disabled);
			
			//전체 선택시 줌 아웃
			if(sdCD == 1){
				var center = ol.proj.fromLonLat([128.4, 35.7]);
				map.getView().setCenter(center);
				map.getView().setZoom(7)
				map.removeLayer(colorWms);
				return false;
			}
			
			//드롭다운 가져옴
			$.ajax({
				url: "./getDropdown.do",
				type: "post",
				data: {'sd' : sd},
				dataType : 'json',
				success: function(result){
					for (var i = 0; i < result.length; i++) {
						var option = $("<option value='"+result[i].sgg_cd+"'>"+result[i].sgg_nm+"</option>");
						sggDd.append(option);
					}
				},
				error: function(request, status, error){ //통신오류
					console.log('drop다운 에러');
				}
			});
			
			// 시,도 중심 좌표값 가져옴
			$.ajax({
				url: "./getCenter.do",
				type: "post",
				data: {'filter' : sd, 'type':'sd'},
				dataType : 'json',
				success: function(result){
					var bbox = result.bbox;
					map.getView().fit(bbox);
				},
				error: function(request, status, error){ //통신오류
					console.log('중심좌표 가져오기 에러');
				}
			});
			
			//coloerd Border 레이어 생성
			map.removeLayer(colorWms);
			colorWms = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
					params : {
			               'VERSION' : '1.1.0', // 2. 버전
			               'STYLES' : 'line ', // 2. 버전
			               'LAYERS' : 'Project:tl_sgg', // 3. 작업공간:레이어 명
			               'BBOX' : '1.386872E7,3906626.5,1.4428071E7,4670269.5', 
			               'SRS' : 'EPSG:3857', // SRID
			               'FORMAT' : "image/png", // 포맷
			               'CQL_FILTER' : "sd_nm='"+sd+"'"
			            },
			            serverType : 'geoserver'
			         })
			});
			map.addLayer(colorWms);
			
		});
		
		//시군구 변경시 법정동 가져옴
		$("#sgg").on('change',function(){
			sgg = $("#sgg option:selected").text();
			sggCD = $("#sgg option:selected").val();
			
			var bjdDd = $("#bjd");
			bjdDd.empty();
			var all = $("<option value='1'>전체보기</option>");
			bjdDd.append(all);
			var disabled = $("<option value='0' disabled selected >법정동 선택</option>");
			bjdDd.append(disabled);

			//법정동 리스트
			if(sggCD != 1){
				filter = sd+' '+sgg;
				type = 'sgg';
			} else {
				filter = sd;
				type = 'sd';
			}
			
			$.ajax({
				url: "./getDropdown.do",
				type: "post",
				data: {'sggSel' : sgg },
				dataType : 'json',
				success: function(result){
					for (var i = 0; i < result.length; i++) {
						var option = $("<option value="+result[i].bjd_cd+">"+result[i].bjd_nm+"</option>");
						bjdDd.append(option);
					}
				},
				error: function(request, status, error){ //통신오류
					console.log("법정동 리스트 에러 발생");
				}
			});
			
			
			// 지도 중심으로 이동
			$.ajax({
				url: "./getCenter.do",
				type: "post",
				data: {'filter' : filter , 'type':type},
				dataType : 'json',
				success: function(result){
					var bbox = result.bbox;
					map.getView().fit(bbox);
				},
				error: function(request, status, error){ //통신오류
					console.log("중심 이동 에러 발생");
				}
			});
			
			//coloerd Border 레이어 생성
			if(sggCD != 1){
				filter = "sgg_nm='"+sd+' '+sgg+"'";
			} else {
				filter = "sd_nm='"+sd+"'";
			}
			
			map.removeLayer(colorWms);
			colorWms = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
					params : {
			               'VERSION' : '1.1.0', // 2. 버전
			               'STYLES' : 'line ', // 2. 버전
			               'LAYERS' : 'Project:c1_sgg', // 3. 작업공간:레이어 명
			               'BBOX' : '1.386872E7,3906626.5,1.4428071E7,4670269.5', 
			               'SRS' : 'EPSG:3857', // SRID
			               'FORMAT' : "image/png", // 포맷
			               'CQL_FILTER' : filter
			            },
			            serverType : 'geoserver'
			         })
			});
			map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
			
		});
		
		$("#bjd").on('change', function(){
			bjd = $('#bjd option:selected').text();
			bjdCD = $("#bjd option:selected").val();
			sggCD = $("#sgg option:selected").val();
			if(sggCD == 1){
				return false;
			}
			
			var cql;
			var layer;
			var bbox;
			if(bjdCD != 1){
				filter = bjdCD;
				type = 'bjd';
				cql = "bjd_nm='"+bjd+"'";
				layer = 'Project:tl_bjd';
				bbox = '1.3873946E7,3906626.5,1.4428045E7,4670269.5';
			} else {
				filter = sd+' '+sgg;
				type = 'sgg';
				cql = "sgg_nm='"+filter+"'";
				layer = 'Project:c1_sgg';
				bbox = '1.386872E7,3906626.5,1.4428071E7,4670269.5';
			}
			
			//coloerd Border 레이어 생성
			map.removeLayer(colorWms);
			colorWms = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
					params : {
			               'VERSION' : '1.1.0', // 2. 버전
			               'STYLES' : 'line ', // 2. 버전
			               'LAYERS' : layer, // 3. 작업공간:레이어 명
			               'BBOX' : bbox, 
			               'SRS' : 'EPSG:3857', // SRID
			               'FORMAT' : "image/png", // 포맷
			               'CQL_FILTER' : cql
			            },
			            serverType : 'geoserver'
			         })
			});
			map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
			
			$.ajax({
				url: "./getCenter.do",
				type: "post",
				data: {'filter' : filter , 'type':type},
				dataType : 'json',
				success: function(result){
					var bbox = result.bbox;
					map.getView().fit(bbox);
				},
				error: function(request, status, error){ //통신오류
					console.log("중심 이동 에러 발생");
				}
			});
			
		});
		
		//드롭다운 선택
		$("#dropdowns").submit(function(event){
			event.preventDefault();
			map.removeLayer(legend);
			
			let sdCD = $("#sd option:selected").val();
			let sggCD = $("#sgg option:selected").val();
			let bjdCD = $("#bjd option:selected").val();
			
			let sd = $("#sd option:selected").text();
			let sgg = $("#sgg option:selected").text();
			let bjd = $("#bjd option:selected").text();
			if(sdCD == 0 || sdCD == 1){
				alert("시/도를 선택해주세요.");
				return false;
			} else if(sggCD == 0){
				alert("시/군/구를 선택해주세요.");
				return false;
			} else if(bjdCD == 0){
				alert("법정동을 선택해주세요.");
				return false;
			}
			
			var bBox;
			var params;
			var filter;
			var layer;
			var type;
			var legendType =  $("input[name='legendType']:checked").val();
			
			if(bjdCD != 1){
				if(legendType == 'na'){
					layer = 'Project:bjd_view';
				} else {
					layer = 'Project:bjd_eq';
				}
				bBox = '1.387148932991382E7,3910407.083927817,1.46800091844669E7%,666488.829376992';
				params = 'sgg_cd:'+sggCD;
				filter ="bjd_nm='"+bjd+"'";
			} else if (sggCD != 1) {
				if(legendType == 'na'){
					layer = 'Project:bjd_view';
				} else {
					layer = 'Project:bjd_eq';
				}				
				console.log(layer);
				bBox = '1.387148932991382E7,3910407.083927817,1.46800091844669E7%,666488.829376992';
				params = 'sgg_cd:'+sggCD;
				filter ="";
			} else if (sdCD != 1){
				if(legendType == 'na'){
					layer = 'Project:sgg_view';
				} else {
					layer = 'Project:sgg_eq';
				}	
				console.log(layer);
				bBox = '1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997';
				params = 'sgg_cd:'+sdCD;
				filter ="";
			}
			
			legend = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
					 params : {
			               'VERSION' : '1.1.0', // 2. 버전
			               'LAYERS' : layer, // 3. 작업공간:레이어 명
			               'BBOX' : bBox,
			               'SRS' : 'EPSG:3857', // SRID
			               'viewparams': params,
			               'CQL_FILTER' : filter,
			               'FORMAT' : "image/png" // 포맷
			            },
			            serverType : 'geoserver',
			         })
			});
			map.addLayer(legend);
			
			if(sggCD==1){
				//type = 사용 할 테이블
				type = "sgg";
				//filter = where 조건
				filter = sd;
			} else {
				type = "bjd";
				filter = sggCD;
			}
			var url;
			if(legendType=='na'){
				url = "./naLegend.do";
			} else {
				url = "./eqLegend.do";
			}
			$.ajax({
				url: url,
				type: "post",
				data: {'filter' : filter , 'type':type},
				dataType : 'json',
				success: function(result){
					//console.log(result);
					var table = $("#legendTable tbody");
					$('#legendTable tbody tr td').remove();
					$('#legendTable tbody tr').remove();
					
					for (var i = 0; i < result.length; i++) {
					var td = '<tr>'+
							"<td class='color fill"+[i]+"'></td>";
							if(i == 0){
								td += '<td> 0 ~ '+result[i].toLocaleString('ko-KR')+'</td>'+'</tr>';
							} else {
								td += '<td>'+result[i-1].toLocaleString('ko-KR')+'~'+result[i].toLocaleString('ko-KR')+'</td>'+'</tr>';
							}
							
					table.append(td);
					}
					
				},
				error: function(request, status, error){ //통신오류
					console.log("범례 오류 발생");
				}
			});
			
		});
		
		//draggable
		$("#legend").draggable({ containment: "#boxLine", scroll: false });
		
		$(".naturalBtn").on("click",function(){
			$("#radioNa").prop("checked", true);
			$(".naturalBtn").css("background-color","#2992D8");
			$(".naturalBtn").css("color","white");
			$(".equalBtn").css("background-color","white");
			$(".equalBtn").css("color","black");
		});
		$(".equalBtn").on("click",function(){
			$("#radioEq").prop("checked", true);
			$(".equalBtn").css("background-color","#2992D8");
			$(".equalBtn").css("color","white");
			$(".naturalBtn").css("background-color","white");
			$(".naturalBtn").css("color","black");
		});
   });
</script>
</head>
<body>
	<%@ include file="topNav.jsp" %>
	<div class="gisContainer">
		<!-- 사이드바 -->
		 <div class="sidebar">
			<div class="sideCategory">
		        <ul>
		            <li class="selectedCate">
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
		            <li>
			            <a href="./analysis.do">
			            <img class="icon" alt="탄소공간지도" src="<c:url value='/resources/'/>/image/graphicon.png">
			            <br>탄소 통계
			            </a>
			        </li>
		        </ul>
			</div>
			<div class="sideDetail">
				<form class="dropdowns" id="dropdowns">
					<div class="radios">
						<button type="button" class="naturalBtn">Natural Brake</button>
						<button type="button" class="equalBtn">등간격</button>
						<input type="radio" name="legendType" value="na" id="radioNa" checked>
						<input type="radio" name="legendType" value="eq" id="radioEq">
					</div>
				    <select id="sd" name="sd">
				    	<option value="0" disabled selected>시/도 선택</option>
				    	<option value="1">전체보기</option>
				    	<c:forEach items="${list}" var="row">
				    		<option value="${row.sd_cd}"
				    	<c:if test="${row.sd_nm eq param.sd }">selected="selected"</c:if>
				    		>${row.sd_nm}</option>
				    	</c:forEach>
				    </select>
					    <select id="sgg" name="sgg">
					    	<option value="0" disabled selected>시/군/구 선택</option>
					    </select>
					    <select id="bjd">
					    	<option value="0" disabled selected>법정동 선택</option>
					    </select>
				    <button type="submit">선택</button>
		      	</form>
			</div>
	    </div>
		
		<div class="content">
		   <div class="boxLine" id="boxLine">
			   <div id="map" class="map">
			   </div>
			      <!-- 실제 지도가 표출 될 영역 -->
			      	<div class="draggable legend" id="legend">
				   		<table id="legendTable">
				   			<thead>
				   			<tr>
				   				<th colspan="2">범례입니다아</th>
				   			</tr>
				   			<tr>	
				   				<th>색상</th>
				   				<th>범위</th>
				   			</tr>
				   			</thead>
				   			<tbody>
					   			<tr>
					   				<td class="color"></td>
					   				<td>숫자~숫자</td>
					   			</tr>
				   			</tbody>
				   		</table>
				   	</div>
			  	 <div>
				</div>
				<%@ include file="upload.jsp" %>
		</div>
		   
		   <div>
		   
			</div>
		</div>
   </div>
</body>
</html>