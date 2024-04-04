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
<link href="<c:url value='/resources/'/>css/ol.css" rel="stylesheet" type="text/css" > <!-- OpenLayer css -->
<script>
   $(document).ready(function() {
	   
      let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
          target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
          layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
            new ol.layer.Tile({
              source: new ol.source.OSM({
            	  url: 'http://api.vworld.kr/req/wmts/1.0.0/17254DD9-A574-399C-A5E5-781211777FFF/Base/{z}/{y}/{x}.png'   
                      // vworld의 지도를 가져온다.
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
            url : 'http://localhost:8080/geoserver/Project/wms?service=WMS', // 1. 레이어 URL
            params : {
               'VERSION' : '1.1.0', // 2. 버전
               'LAYERS' : 'Project:tl_sgg', // 3. 작업공간:레이어 명
               'BBOX' : '1.386872E7,3906626.5,1.4428071E7,4670269.5', 
               'SRS' : 'EPSG:3857', // SRID
               'FORMAT' : "image/png", // 포맷
           	   'CQL_FILTER' : "${zip}"
            },
            serverType : 'geoserver',
         })
      });
      map.addLayer(wms); // 맵 객체에 레이어를 추가함
      
      //드래거블
      $("#legend").draggable({containment:"#boxLine", scroll:false});
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
			<h1>탄소 배출(전기) 현황</h1>
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