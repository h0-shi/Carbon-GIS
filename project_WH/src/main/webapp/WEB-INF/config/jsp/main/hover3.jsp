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
	   
	   var vectorSource = new ol.source.Vector({
		    format: new ol.format.GeoJSON(),
		    url: 'http://localhost:8080/geoserver/Project/ows?service=WFS&' +
		        'version=1.0.0&request=GetFeature&typeName=Project:c1_sd&' +
		        'outputFormat=application/json&srsname=EPSG:3857',
		    strategy: ol.loadingstrategy.bbox
		});
	   
	   var vector = new ol.layer.Vector({
		    source: vectorSource,
		    style: function(feature, resolution){
		    	 var style1 = new ol.style.Style({
		 	        stroke: new ol.style.Stroke({
		 	            color: 'rgba(255, 255, 0, 1.0)',
		 	            width: 1
		 	        }),
		 	        fill: new ol.style.Fill({
		 	            color: 'rgba(246,205,205,0.7)'
		 	        })
		 	    });
		    	 var style2 = new ol.style.Style({
		 	        stroke: new ol.style.Stroke({
		 	            color: 'rgba(255, 255, 0, 1.0)',
		 	            width: 1
		 	        }),
		 	        fill: new ol.style.Fill({
		 	            color: 'rgba(242,159,159,0.7)'
		 	        })
		 	    });
		    	 var style3 = new ol.style.Style({
		 	        stroke: new ol.style.Stroke({
		 	            color: 'rgba(255, 255, 0, 1.0)',
		 	            width: 1
		 	        }),
		 	        fill: new ol.style.Fill({
		 	            color: 'rgba(238,114,114,0.7)'
		 	        })
		 	    });
		    	 var style4 = new ol.style.Style({
		 	        stroke: new ol.style.Stroke({
		 	            color: 'rgba(255, 255, 0, 1.0)',
		 	            width: 1
		 	        }),
		 	        fill: new ol.style.Fill({
		 	            color: 'rgba(234,68,68,0.7)'
		 	        })
		 	    });
		    	 var style5 = new ol.style.Style({
		 	        stroke: new ol.style.Stroke({
		 	            color: 'rgba(234, 217, 107, 1.0)',
		 	            width: 1
		 	        }),
		 	        fill: new ol.style.Fill({
		 	            color: 'rgba(230,23,23,0.7)'
		 	        })
		 	    });
			    	if(feature.values_.usage<4154486638)
		                return [style1];
		             else if(feature.values_.usage<6075125900)
		                return [style2]; 
		             else if(feature.values_.usage<7002737427)
		                return [style3]; 
		             else if(feature.values_.usage<12278544350)
		                return [style4]; 
		             else 
		                return [style5]; 
		    },
		    visible: true
		});
			map.addLayer(vector); // 맵 객체에 레이어를 추가함
		
		//Colored Border 지우기 위한 변수
		var selectedLayer;
	
	// 지도 클릭시 정보 가져옴
	
		map.on('singleclick', function(evt) {
			var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature) {
				return feature;
			});
			if(feature != null) {
	        	//feature의 값 중, name을 불러오기
			//	alert(feature.get('usage'));
			}
			//오버레이 생성
			var usage = feature.get('usage');
			console.log(usage);
			/*
			$("#selectedLoc").text("선택한 위치 : "+ele+" | "+"사용량 : "+usage);
			
			var coordinate = evt.coordinate;
			alert(coordinate);
			const div = $('.ol-overlay-container');
			if(div.length>0){
				div.remove();
			}
			
			let content = document.createElement("div");
			content.classList.add('ol-popup','pop');
			
			content.innerHTML = '<span> 선택 지역 : '+ele+'<br>사용량 : '+usage+'</span>';
			let overlay = new ol.Overlay({
			       element: content, // 생성한 DIV
			});
			//오버레이의 위치 저장
			overlay.setPosition(coordinate);
			//지도에 추가
			
			map.addOverlay(overlay);
			*/
		});
	
		
		$("#location").on('change',function(){
			//var param = "sd_nm='"+$(this).val()+"'";
			var sd = $(this).val();
			var sgg = $("#sgg");
			
			//전체 선택시 줌 아웃
			if(sd.length < 1){
				var center = ol.proj.fromLonLat([128.4, 35.7]);
				map.getView().setCenter(center);
				map.getView().setZoom(7)
				return false;
			}
			
			//드롭다운 가져옴
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sd' : sd},
				dataType : 'json',
				success: function(result){
					sgg.empty();
					var all = $("<option value=''>전체보기</option>");
					sgg.append(all);
					for (var i = 0; i < result.length; i++) {
						var option = $("<option value='"+result[i].sgg_nm+"'>"+result[i].sgg_nm+"</option>");
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
			
			//coloerd Border 레이어 생성
			map.removeLayer(selectedLayer);
			
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
			var sgg = $(this).val();
			var sd = $(this).siblings('#location').val();

			//전체선택 줌아웃
			if(sgg.length < 1){
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
				map.removeLayer(selectedLayer);
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
			}

			
			
			//법정동 리스트 출력
			var bjd = $("#bjd");
			var filter;
			if(sgg.length > 0){
				filter = sd+' '+sgg;
			}
			
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
					map.getView().setZoom(11);
				},
				error: function(request, status, error){ //통신오류
					alert("에러 발생");
				}
			});
			
			//coloerd Border 레이어 생성
			map.removeLayer(selectedLayer);
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
			               'CQL_FILTER' : "sgg_nm='"+sd+' '+sgg+"'"
			            },
			            serverType : 'geoserver'
			         })
			});
			selectedLayer = colorWms;
			map.addLayer(colorWms); // 맵 객체에 레이어를 추가함
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
      <form id="file" enctype="multipart/form-data">
      	<input type="file" name="file">
      	<button type="button" id="fileBtn">업로드</button>
      </form>
   </div>
</body>
</html>