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
		  String root = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\Carbon-GIS\\project_WH\\src\\main\\webapp\\resources\\upload\\";
	      FileReader reader = new FileReader(root+fileName);
	      BufferedReader bf = new BufferedReader(reader);
	      File f = new File(root+fileName);
	      long size = f.length();
	      System.out.println(size);
	    //  System.out.println(size+"이게 사이즈");
	      List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
	      String aLine = null;
	      long count = 0;
	      int pageSize = 15000;
	      //session.getBasicRemote().sendText("시작합니다");
	      
	      while((aLine = bf.readLine()) != null) {
	         Map<String, Object> map = new HashMap<String, Object>();
	         count += aLine.getBytes("ks_c_5601-1987").length+2;
	         //System.out.println(count+"이게 카운트");
	         String[] arr = aLine.split("\\|");
	          map.put("useDate", arr[0]);
	          map.put("sggCD", arr[3]);
	          map.put("bjd", arr[4]);
	          map.put("usage", Integer.parseInt(arr[13]));
	          list.add(map);
	          if(--pageSize <= 0 ) {
	        	 //System.out.println("초기화");
	             int result = servletService.dbInsert(list);
	             list.clear();
	             long perc = (count*100)/size;
	             //System.out.println(perc+"이게 퍼센트");
	             session.getBasicRemote().sendText(perc+"");
	             //System.out.println(count+"/"+size);
	             //System.out.println(perc);
	             pageSize = 15000;
	          }
	      }
	     int refresh =  servletService.Refresh();
	     System.out.println(refresh);
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
