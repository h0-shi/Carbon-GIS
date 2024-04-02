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
<script type="text/javascript" src="<c:url value='resources/js/ol.js' />"></script>
<link href="<c:url value='/resources/'/>css/ol.css" rel="stylesheet" type="text/css" > <!-- OpenLayer css -->
<style>
.map {
	height: 600px;
	width: 100%;
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
	height: auto;
}
</style>
<script>
   $(document).ready(function() {
	   //변수들 모음
	   //Colored Border 지우기 위한 변수
		let selectedLayer;
		let colorWms;
		let ele;
		//범례 레이어
		let legend;
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
	   
		var wms = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
				
				params : {
		               'VERSION' : '1.1.0', // 2. 버전
		               <c:if test="${size eq 'sd'}">
		                'LAYERS' : 'Project:c1_sd', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997',
		               </c:if>
		               
		               <c:if test="${size eq 'sgg'}">
		               'LAYERS' : 'Project:c1_sgg', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3871489329746835E7,3910407.083927817,1.46800091844669E7,4666488.829376992',
		               </c:if>
		               
		               <c:if test="${size eq 'bjd'}">
		               'LAYERS' : 'Project:c1_bjd', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3873946E7,3906626.5,1.4428045E7,4670269.5', 
		               'STYLES' : 'line',
		               </c:if>
		               'SRS' : 'EPSG:3857', // SRID
		               'FORMAT' : "image/png" // 포맷
		            },
		            serverType : 'geoserver',
		         })
		});
		
	//	map.addLayer(wms); // 맵 객체에 레이어를 추가함
		
	// 지도 클릭시 정보 가져옴
		map.on('singleclick', function(evt) {

			//var sgg = $('#sgg option:selected').text();
		    var view = map.getView();
		    var viewResolution = view.getResolution();
		    var source = legend.getSource();
		    console.log(sgg);
		    var url =  source.getGetFeatureInfoUrl(
		    		 evt.coordinate, viewResolution, view.getProjection(), {
		    	            'INFO_FORMAT': 'application/json',
		    	            'FEATURE_COUNT': 50
		    	        });
		    if (url) {
		        fetch(url).then(function(response) {
		        	response.text().then(function(text){
						var jsonObj = JSON.parse(text);
						<c:if test="${size eq 'sd'}">
							ele = jsonObj.features[0].properties.bjd_nm;
						</c:if>
						<c:if test="${size eq 'sgg'}">
							ele = jsonObj.features[0].properties.bjd_nm;
						</c:if>
						<c:if test="${size eq 'bjd'}">
							ele = jsonObj.features[0].properties.bjd_nm;
						</c:if>
						var usage = jsonObj.features[0].properties.usage;
						$("#selectedLoc").text("선택한 위치 : "+sgg+" "+ele+" | "+"사용량 : "+usage);
						
						//오버레이 생성
						var coordinate = evt.coordinate;
						const div = $('.ol-overlay-container');
						if(div.length>0){
							div.remove();
						}
						
						let content = document.createElement("div");
						content.classList.add('ol-popup','pop');
						
						content.innerHTML = '<span> 선택 지역 : '+sgg+" "+ele+'<br>사용량 : '+usage+'</span>';
						let overlay = new ol.Overlay({
						       element: content, // 생성한 DIV
						});
						
						//오버레이의 위치 저장
						overlay.setPosition(coordinate);
						//지도에 추가
						map.addOverlay(overlay);
						
						/*
						//싱글클릭
						colorWms = new ol.layer.Tile({
							source : new ol.source.TileWMS({
								url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
								params : {
						               'VERSION' : '1.1.0', // 2. 버전
						               'STYLES' : 'simple_roads ', // 2. 버전
						               'LAYERS' : 'Project:tl_sd', // 3. 작업공간:레이어 명
						               'BBOX' : '1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997',
						               'SRS' : 'EPSG:3857', // SRID
						               'FORMAT' : "image/png", // 포맷
						               'CQL_FILTER' : "sd_nm='"+ele+"'"
						            },
						            serverType : 'geoserver'
						         })
						});
						map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
						*/
		        	})
		        });
		    }
		});
		
		$("#sd").on('change',function(){
			//var param = "sd_nm='"+$(this).val()+"'";
			//map.removeLayer(legend);
			
			sd = $("#sd option:selected").text();
			sdCd = $("#sd option:selected").val();
			//sgg 드롭다운			
			var sggDd = $("#sgg");
			filter = "sd_nm='"+sd+"'";
			
			//전체 선택시 줌 아웃
			if(sdCd.length < 1){
				var center = ol.proj.fromLonLat([128.4, 35.7]);
				map.getView().setCenter(center);
				map.getView().setZoom(7)
				map.removeLayer(colorWms);
				return false;
			}
			
			//드롭다운 가져옴
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sd' : sd},
				dataType : 'json',
				success: function(result){
					sggDd.empty();
					var all = $("<option value='0'>전체보기</option>");
					sggDd.append(all);
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
					var center = [result.x, result.y];
					map.getView().setCenter(center);
					if(sd.match('특별')||sd.match('광역')){
						map.getView().setZoom(11);
					} else {
						map.getView().setZoom(9);
					}
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
			sd = $("#sd option:selected").text();
			sgg = $("#sgg option:selected").text();
			sggCd = $("#sgg option:selected").val();

			//전체선택 줌아웃
			if(sggCd == 0){
				$.ajax({
					url: "./getCenter.do",
					type: "post",
					data: {'filter' : sd, 'type':'sd'},
					dataType : 'json',
					success: function(result){
						var center = [result.x, result.y];
						map.getView().setCenter(center);
						if(sd.match('특별')||sd.match('광역')){
							map.getView().setZoom(11);
						} else {
							map.getView().setZoom(9);
						}
					},
					error: function(request, status, error){ //통신오류
						console.log('중심좌표 가져오기 에러');
					}
					
				});
			}
			
			//법정동 리스트 출력
			if(sggCd != 0){
				filter = sd+' '+sgg;
			} else {
				filter = sd;
			}
			
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sggSel' : sgg },
				dataType : 'json',
				success: function(result){
					var bjdDd = $("#bjd");
					bjdDd.empty();
					var all = $("<option value='0'>전체보기</option>");
					bjdDd.append(all);
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
			if(sggCd != 0){
				$.ajax({
					url: "./getCenter.do",
					type: "post",
					data: {'filter' : filter , 'type':'sgg'},
					dataType : 'json',
					success: function(result){
						var center = [result.x, result.y];
						map.getView().setCenter(center);
						map.getView().setZoom(11);
					},
					error: function(request, status, error){ //통신오류
						console.log("중심 이동 에러 발생");
					}
				});
			}
			
			//coloerd Border 레이어 생성
			if(sggCd != 0){
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
			var bjd = $('#bjd option:selected').text();
			var sgg = $("#sgg option:selected").text();
			var sggCd = $("#sgg option:selected").val();
			console.log(bjd);
			
			/*
			$.ajax({
				url: "./getCenter.do",
				type: "post",
				data: {'filter' : bjd , 'type':'bjd'},
				dataType : 'json',
				success: function(result){
					var center = [result.x, result.y];
					map.getView().setCenter(center);
					map.getView().setZoom(15);
				},
				error: function(request, status, error){ //통신오류
					alert("에러 발생");
				}
			});
			*/
			
			//coloerd Border 레이어 생성
			map.removeLayer(colorWms);
			colorWms = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
					params : {
			               'VERSION' : '1.1.0', // 2. 버전
			               'STYLES' : 'line ', // 2. 버전
			               'LAYERS' : 'Project:tl_bjd', // 3. 작업공간:레이어 명
			               'BBOX' : '1.3873946E7,3906626.5,1.4428045E7,4670269.5', 
			               'SRS' : 'EPSG:3857', // SRID
			               'FORMAT' : "image/png", // 포맷
			               'CQL_FILTER' : "bjd_nm='"+bjd+"'"
			            },
			            serverType : 'geoserver'
			         })
			});
			map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
			
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
			
			if(sdCD.length<1){
				alert("시/도를 선택해주세요");
				return false;
				/*
			} else if(sggCD.length<1){
				alert("시/군/구를 선택해주세요");
				return false;
			} else if(bjdCD.length<1){
				alert("법정동을 선택해주세요");
				return false;
				*/
			}
			var bBox;
			var params;
			var filter;
			var layer;
			
			if(bjdCD != 0){
				layer = 'Project:bjd_view';
				bBox = '1.387148932991382E7,3910407.083927817,1.46800091844669E7%,666488.829376992';
				params = 'sgg_cd:'+sggCD;
				filter ="bjd_nm='"+bjd+"'";
			} else if (sggCD != 0) {
				layer = 'Project:bjd_view';
				bBox = '1.387148932991382E7,3910407.083927817,1.46800091844669E7%,666488.829376992';
				params = 'sgg_cd:'+sggCD;
				filter ="";
			} else if (sdCD != 0){
				console.log(sdCD);
				layer = 'Project:sgg_view';
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
			
			
		});
		
	
		$("#fileBtn").click(function(event){
			event.preventDefault();
			var form = $("#file");
			console.log(form[0]); 
			
			var formData = new FormData(form[0]);
			//console.log(formData); 
			
			$.ajax({
				url: './dbInsert.do',
				enctype: 'multipart/form-data',
				processData: false,
				contentType: false,
				data: formData,
				type: 'POST',
				success: function(result){
					console.log(result);
					alert(result);
				},
				error: function(request, status, error){ //통신오류
					alert("에러 발생");
				}
			});
		});
		
		//draggable
		$("#legend").draggable({containment:"#boxLine", scroll:false});
		
   });
</script>
</head>
<body>
	<div class="container">
	   <div class="boxLine" id="boxLine">
		   <div id="map" class="map">
		   </div>
		      <!-- 실제 지도가 표출 될 영역 -->
		      	<div class="draggable legend" id="legend">
			   		<table>
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
	</div>
	   
	   <div id="selectedLoc">
	   선택한 위치 : &ensp;&ensp;&ensp;&ensp;&ensp; | 사용량 :
	   </div>
	   	
	   <div>
	      <button type="button" id="addLayer" name="rpg_1">레이어추가하기</button>
	      <button type="button" id="delLayer" name="rpg_1">레이어삭제하기</button>
	      
	      <form class="dropdowns" id="dropdowns">
	      	<select name="size" id="size"  onchange="getSgg();">
		      	<option value="sd"
		      	<c:if test="${param.size eq 'sd' }">selected="selected"</c:if>
		      	>시/도</option>
		      	<option value="sgg"
		      	<c:if test="${param.size eq 'sgg' }">selected="selected"</c:if>
		      	>시군구</option>
		      	<option value="bjd"
		      	<c:if test="${param.size eq 'bjd' }">selected="selected"</c:if>
		      	>법정동</option>
		    </select>
		    
		    <select id="sd" name="sd">
		    	<option value="">전체보기</option>
		    	<c:forEach items="${list}" var="row">
		    	<option value="${row.sd_cd}"
		    	<c:if test="${row.sd_nm eq param.sd }">selected="selected"</c:if>
		    	>${row.sd_nm}</option>
		    	</c:forEach>
		    </select>
		    
			    <select id="sgg" name="sgg">
			    	<option value="">전체보기</option>
			    <c:forEach items="${sgg }" var="row">
			    	<option value="${row.sgg_nm}">${row.sgg_nm}</option>
			    </c:forEach>
			    </select>
			 
			    <select id="bjd">
			    	<option value="">전체보기</option>
			    <c:forEach items="${bjd }" var="row">
			    	<option value="${row.bjd_nm}">${row.bjd_nm}</option>
			    </c:forEach>
			    </select>
		    <button type="submit">선택</button>
	      </form>
	      
	      <form id="file" enctype="multipart/form-data">
	      	<input type="file" name="file">
	      	<button type="button" id="fileBtn">업로드</button>
	      </form>
		</div>
   </div>
</body>
</html>