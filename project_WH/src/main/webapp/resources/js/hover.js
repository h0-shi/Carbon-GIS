      let map = new ol.Map({ 
          target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
          layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
            new ol.layer.Tile({
              source: new ol.source.OSM({
            	  url: 'http://api.vworld.kr/req/wmts/1.0.0/key/Base/{z}/{y}/{x}.png'   
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
