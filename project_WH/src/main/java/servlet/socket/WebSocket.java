package servlet.socket;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.websocket.OnMessage;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import servlet.service.ServletService;

@ServerEndpoint("/webSocket")
public class WebSocket {

	@Resource(name = "ServletService")
	private ServletService servletService;

	@OnMessage
	public void onMessage(Session session, String message) throws IOException {
		System.out.println("받은거");
		String[] arr = message.split("\\n");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		int total = arr.length;
		int count = 0;
		int pageSize = 10000;
		
		while (total > 0) {
			Map<String, Object> map = new HashMap<String, Object>();
			String[] data = arr[count].split("\\|");
			map.put("useDate", data[0]);
			map.put("sggCD", data[3]);
			map.put("bjd", data[4]);
			map.put("usage", Integer.parseInt(data[13]));
			list.add(map);
			count++;
			if(--pageSize <0) {
				list.clear();
				pageSize = 10000;
				session.getBasicRemote().sendText(count+"줄");
			}
		}
	}
}
