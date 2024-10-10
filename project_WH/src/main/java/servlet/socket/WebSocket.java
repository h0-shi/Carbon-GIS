package servlet.socket;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.websocket.OnMessage;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.springframework.stereotype.Component;

import servlet.impl.ServletImpl;

@Component
@ServerEndpoint(value="/webSocket", configurator = ServerEndpointConfigurator.class)
public class WebSocket {

	@Inject
	private ServletImpl servletService;
	
	@OnMessage
	public void onMessage(Session session, String fileName) throws IOException {		
		  String root = "C:\\temp\\GisDBUp\\";
		  //txt파일 불러옴
	      FileReader reader = new FileReader(root+fileName);
	      BufferedReader bf = new BufferedReader(rader);
	      File f = new File(root+fileName);
	      long size = f.length();
		  //사이즈 확인
	      //System.out.println(size);
	      List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
	      String aLine = null;
	      long count = 0;
	      int pageSize = 15000;	    
	      
		  //DB 업로드 시작
	      while((aLine = bf.readLine()) != null) {
	         Map<String, Object> map = new HashMap<String, Object>();
			 //읽어들인 byte의 총 합
	         count += aLine.getBytes("ks_c_5601-1987").length+8;	         
	         String[] arr = aLine.split("\\|");
	          map.put("useDate", arr[0]);
	          map.put("sggCD", arr[3]);
	          map.put("bjd", arr[4]);
	          map.put("usage", Integer.parseInt(arr[13]));
			  //map list에 저장
	          list.add(map);
	          if(--pageSize <= 0 ) {
				 //DB Insert				
	             int result = servletService.dbInsert(list);
				 // list 초기화
	             list.clear();
				 //진행률 업데이트
	             long perc = (count*100)/size;
				 //프론트로 진행률 전송
	             session.getBasicRemote().sendText(perc+"");	             
	             //페이지 사이즈 재설정
	             pageSize = 15000;
	          }
	      }
		  //Materialized view Refresh
	      servletService.Refresh();
	      session.getBasicRemote().sendText(100+"");
	      if(f.exists()) {
	    	  if(f.delete()) {
	    		  System.out.println("파일 삭제");
	    	  }else {
	    		  System.out.println("삭제 실패");
	    	  }
	      } else {
	    	  System.out.println("파일 없음");
	      }
	      
	      bf.close();
		
	}
	
}
