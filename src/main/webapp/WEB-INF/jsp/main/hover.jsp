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
	.pop{
		background-color: white;
	}    

    
</style>
<script>
   $(document).ready(function() {
	   
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
		               'LAYERS' : 'Project:sd_c1', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997', 
		               </c:if>
		               
		               <c:if test="${size eq 'sgg'}">
		               'LAYERS' : 'Project:tl_sgg', // 3. 작업공간:레이어 명
		               'BBOX' : '1.386872E7,3906626.5,1.4428071E7,4670269.5', 
		               </c:if>
		               
		               <c:if test="${size eq 'bjd'}">
		               'LAYERS' : 'Project:tl_bjd', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3873946E7,3906626.5,1.4428045E7,4670269.5', 
		               </c:if>
		               
		               'SRS' : 'EPSG:3857', // SRID
		               'FORMAT' : "image/png" // 포맷
		            },
		            serverType : 'geoserver',
		         })
		});
		
		map.addLayer(wms); // 맵 객체에 레이어를 추가함
		var selectedLayer;
	
	// 지도 클릭시 정보 가져옴
		map.on('singleclick', function(evt) {
			//map.removeLayer(selectedLayer);
			
		    var view = map.getView();
		    var viewResolution = view.getResolution();
		    var source = wms.getSource();
		    var ele;
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
							ele = jsonObj.features[0].properties.sd_nm;
						</c:if>
						<c:if test="${size eq 'sgg'}">
							ele = jsonObj.features[0].properties.sgg_nm;
						</c:if>
						<c:if test="${size eq 'bjd'}">
							ele = jsonObj.features[0].properties.bjd_nm;
						</c:if>
						var usage = jsonObj.features[0].properties.usage;
						$("#selectedLoc").text("선택한 위치 : "+ele+" | "+"사용량 : "+usage);
						
						//오버레이 생성
						var coordinate = evt.coordinate;
						const div = $('.ol-overlay-container');
						if(div.length>0){
							div.remove();
						}
						
						let content = document.createElement("div");
						content.classList.add('ol-popup','pop');
						
						
						content.innerHTML = '<span> 사용량 : '+usage+'</span>';
						let overlay = new ol.Overlay({
						       element: content, // 생성한 DIV
						});
						//오버레이의 위치 저장
						overlay.setPosition(coordinate);
						//지도에 추가
						map.addOverlay(overlay);
						
						const div2 = $('.ol-overlay-container').text();
						
						
						/*
						싱글클릭
						var colorWms = new ol.layer.Tile({
							source : new ol.source.TileWMS({
								url :  'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
								params : {
						               'VERSION' : '1.1.0', // 2. 버전
						               'STYLES' : 'line ', // 2. 버전
						               'LAYERS' : 'Project:tl_sd', // 3. 작업공간:레이어 명
						               'BBOX' : '1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997',
						               'SRS' : 'EPSG:3857', // SRID
						               'FORMAT' : "image/png", // 포맷
						               'CQL_FILTER' : "sd_nm='"+ele+"'"
						            },
						            serverType : 'geoserver'
						         })
						});
						selectedLayer = colorWms;
						map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
						*/
		        	})
		        	
		        });
		    }
		    
		    
		    
		});
		
		$("#location").on('change',function(){
			//var param = "sd_nm='"+$(this).val()+"'";
			var sd = $(this).val();
			var sgg = $("#sgg");
			
			if(sd.length < 1){
				var center = ol.proj.fromLonLat([128.4, 35.7]);
				map.getView().setCenter(center);
				map.getView().setZoom(7)
				return false;
			}
			
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sd' : sd},
				dataType : 'json',
				success: function(result){
					sgg.empty();
					var all = $("<option value='all'>전체보기</option>");
					sgg.append(all);
					for (var i = 0; i < result.length; i++) {
						var option = $("<option value="+result[i].sgg_nm+">"+result[i].sgg_nm+"</option>");
						sgg.append(option);
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
			map.removeLayer(selectedLayer);
			
			//coloerd Border 레이어 생성
			var colorWms = new ol.layer.Tile({
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
			selectedLayer = colorWms;
			map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
			
		});
		
		//시군구 변경시 법정동 가져옴
		$("#sgg").on('change',function(){
			
			var sd = $(this).siblings('#location').val();
			var sgg = $(this).val();
			var bjd = $("#bjd");
			var filter;
			
			if(sgg.length > 0){
				filter = sd+' '+sgg;
			}
			
			//리스트 출력
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sggSel' : sgg },
				dataType : 'json',
				success: function(result){
					bjd.empty();
					var all = $("<option value=''>전체보기</option>");
					bjd.append(all);
					for (var i = 0; i < result.length; i++) {
						var option = $("<option>"+result[i].bjd_nm+"</option>");
						bjd.append(option);
					}
				},
				error: function(request, status, error){ //통신오류
					alert("에러 발생");
				}
			});
			
			// 지도 중심으로 이동
			
			$.ajax({
				url: "./getCenter.do",
				type: "post",
				data: {'filter' : filter , 'type':'sgg'},
				dataType : 'json',
				success: function(result){
					var center = [result.x, result.y];
					map.getView().setCenter(center);
					map.getView().setZoom(12);
				},
				error: function(request, status, error){ //통신오류
					alert("에러 발생");
				}
			});
		})
	
   });
</script>
</head>
<body>
   <div id="map" class="map">
      <!-- 실제 지도가 표출 될 영역 -->
   </div>
   <div id="selectedLoc">
   선택한 위치 : &ensp;&ensp;&ensp;&ensp;&ensp; | 사용량 :
   </div>
   	
   <div>
      <button type="button" id="addLayer" name="rpg_1">레이어추가하기</button>
      <button type="button" id="delLayer" name="rpg_1">레이어삭제하기</button>
      
      <form action="./hover.do" action="post">
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
	    
	    <select id="location" name="sd">
	    	<option value="">전체보기</option>
	    	<c:forEach items="${list}" var="row">
	    	<option value="${row.sd_nm}"
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
		 
	    <c:if test="${param.size eq 'bjd' }">
		    <select id="bjd">
		    	<option value="">전체보기</option>
		    <c:forEach items="${bjd }" var="row">
		    	<option value="${row.bjd_nm}">${row.bjd_nm}</option>
		    </c:forEach>
		    </select>
	    </c:if>
	    <button type="submit">선택</button>
      </form>
   </div>
</body>
</html>