package servlet.socket;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.websocket.OnMessage;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.springframework.scheduling.annotation.EnableAsync;

import servlet.impl.ServletImpl;
import servlet.vo.ServletVO;

@ServerEndpoint("/webSocket")
@EnableAsync
public class WebSocket {

	@OnMessage
	public void onMessage(Session session, String fileName) throws IOException {
		ServletImpl servletService = new ServletImpl();
		String root = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\Carbon-GIS\\project_WH\\src\\main\\webapp\\resources\\upload\\";
		FileReader reader = new FileReader(root+fileName);
		BufferedReader bf = new BufferedReader(reader);
		File f = new File(root+fileName);
		long size = f.length();
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String aLine = null;
		long count = 0;
		int pageSize = 1;
		session.getBasicRemote().sendText("시작합니다");
		List<ServletVO> sdnm = servletService.sidonmTest();
		/*
		while((aLine = bf.readLine()) != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			count += aLine.getBytes().length;
			String[] arr = aLine.split("\\|");
		    map.put("useDate", arr[0]);
		    map.put("sggCD", arr[3]);
		    map.put("bjd", arr[4]);
		    map.put("usage", Integer.parseInt(arr[13]));
		    list.add(map);
		    if(--pageSize <= 0 ) {
		    	//int result = servletService.dbInsert(list);
//		    	int result = servletService.dbInsert(list);
//		    	list.clear();
//		    	pageSize = 1;
		    	session.getBasicRemote().sendText("Message received: "+(count/size)*100);
		    }
		}
		bf.close();
		 */
	}
}
