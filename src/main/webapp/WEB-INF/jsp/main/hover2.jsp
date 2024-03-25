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
</style>
<script>
   $(document).ready(function() {
	   
	   var temp;
		   
	   var source = new ol.source.XYZ({
		    url: 'http://api.vworld.kr/req/wmts/1.0.0/${key}/Base/{z}/{y}/{x}.png'
		});
		var viewLayer = new ol.layer.Tile({
		    source: source
		});
		var wms = new ol.layer.Tile({
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
		               
		               <c:if test="${size eq 'bjd'}">
		               'LAYERS' : 'Project:tl_bjd', // 3. 작업공간:레이어 명
		               'BBOX' : '1.3873946E7,3906626.5,1.4428045E7,4670269.5', 
		               </c:if>
		               
		               'SRS' : 'EPSG:3857', // SRID
		               'FORMAT' : "image/png", // 포맷
		           		'CQL_FILTER' : temp
		            },
		            serverType : 'geoserver',
		         })
		});
		
		var view = new ol.View({
			center: ol.proj.fromLonLat([128.4, 35.7]),
            zoom: 7
		});
		var mapView = new ol.Map({
		            target: "map",
		            layers: [viewLayer, wms],
		            view: view
		});
		
		mapView.on('singleclick', function(evt) {
		    var view = mapView.getView();
		    var viewResolution = view.getResolution();
		    var source = wms.getSource();
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
						<c:if test="${size eq 'bjd'}">
						var ele = jsonObj.features[0].properties.bjd_nm;
						</c:if>
						$("#selectedLoc").text("선택한 위치 : "+ele);
		        	})
		        });
		    }
		});
		
		$("#size").on('change',function(){
			var size = $("#size").val();
			//나중에 범례 지정에 따라 드롭다운 뜨게 하자
		});
		
		$("#location").on('change',function(){
			
			var sd = $("#location option:selected");
			var sgg = $("#sgg");
			
			//mapView.removeLayer(wms);

			temp = "sd_nm='"+$(this).val()+"'";
			alert(temp);
			
			wms.mergeNewParams({            
				CQL_FILTER: "sd_nm='"+$(this).val()+"'"
			});
			wms.redraw(true);
			//mapView.addLayer(wms);
			
			
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sd' : sd.val()},
				dataType : 'json',
				success: function(result){
					sgg.empty();
					var all = $("<option value=''>전체보기</option>");
					sgg.append(all);
					for (var i = 0; i < result.length; i++) {
						var option = $("<option>"+result[i].sgg_nm+"</option>");
						sgg.append(option);
					}
				},
				error: function(request, status, error){ //통신오류
					alert("에러 발생");
				}
			});
		});
		
		$("#sgg").on('change',function(){
			
			var sgg = $("#sgg option:selected");
			var bjd = $("#bjd");
			
			$.ajax({
				url: "./hover.do",
				type: "post",
				data: {'sggSel' : sgg.val()},
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
		});
		$("#delLayer").click(function(){
			mapView.removeLayer(wms);
		});
		$("#addLayer").click(function(){
			mapView.addLayer(wms);
		});
   });
</script>
</head>
<body>
   <div id="map" class="map">
      <!-- 실제 지도가 표출 될 영역 -->
   </div>
   <div id="selectedLoc">
   선택한 위치 : 
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