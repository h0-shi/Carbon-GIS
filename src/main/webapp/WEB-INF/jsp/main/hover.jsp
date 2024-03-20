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

<script>
   $(document).ready(function() {
	   
	   var source = new ol.source.XYZ({
		    url: 'http://api.vworld.kr/req/wmts/1.0.0/key/Base/{z}/{y}/{x}.png'
		});
		var viewLayer = new ol.layer.Tile({
		    source: source
		});
		var tileImg = new ol.layer.Tile({
		    visible: true,
		   source : new ol.source.TileWMS({
		            url : 'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
		            params : {
		               'VERSION' : '1.1.0', // 2. 버전
		               <c:if test="${size eq 'sd'}">
		               'LAYERS' : 'Project:tl_sd', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997', 
		               </c:if>
		               <c:if test="${size eq 'sgg'}">
		               'LAYERS' : 'Project:tl_sgg', // 3. 작업공간:레이어 명
		               'BBOX' : '1.386872E7,3906626.5,1.4428071E7,4670269.5', 
		               </c:if>
		               'SRS' : 'EPSG:3857', // SRID
		               'FORMAT' : "image/png", // 포맷
		           		'CQL_FILTER' : "${zip}"
		            },
		            serverType : 'geoserver',
		         })
		});
		var view = new ol.View({
		    center: [14377556.389982047, 4186024.063626864],
		    zoom: 14,
		});
		var mapView = new ol.Map({
		            target: "map",
		            layers: [viewLayer, tileImg],
		            view: view
		});
		
		mapView.on('singleclick', function(evt) {
		    var view = mapView.getView();
		    var viewResolution = view.getResolution();
		    var source = tileImg.getSource();
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
						var ele = jsonObj.features[0].properties.sd_nm;
						</c:if>
						<c:if test="${size eq 'sgg'}">
						var ele = jsonObj.features[0].properties.sgg_nm;
						</c:if>
						$("#selectedLoc").text("선택한 위치 : "+ele);
		        	})
		        });
		    }
		});
		//포인터 무브 도전중
		 var selectPointerMove = new ol.interaction.Select({
	            condition: ol.events.condition.pointerMove,
	            style: new ol.style.Style({
	                stroke: new ol.style.Stroke({
	                    color: 'white',
	                    width: 2
	                }),
	                fill: new ol.style.Fill({
	                    color: 'rgba(0,0,255,0.6)'
	                })
	            })
	        });
	        // interaction 추가
	        map.addInteraction(selectPointerMove);
		
   });
</script>

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
</style>
</head>
<body>
   <div id="map" class="map">
      <!-- 실제 지도가 표출 될 영역 -->
   </div>
   <div id="selectedLoc">
   선택한 위치 : 
   </div>
   	
   <div>
      <button type="button" onclick="javascript:deleteLayerByName('VHYBRID');" name="rpg_1">레이어삭제하기</button>
      
      <form action="./hover.do" action="get">
      <select name="size">
      	<option value="sd">시/도</option>
      	<option value="sgg">시군구</option>
      </select>
      <button type="submit">범례변경</button>
      </form>
      
      <form action="./hover.do" method="get">
	      <select id="location" name="zip">
	      	<option value="">기본</option>
	      	<c:forEach items="${list}" var="row">
	      	<option value="${row.sidonm}">${row.sidonm}</option>
	      	</c:forEach>
	      </select>
	      <button type="submit">선택</button>
      </form>
   </div>
</body>
</html>