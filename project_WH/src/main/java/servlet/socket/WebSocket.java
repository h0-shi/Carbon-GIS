package servlet.socket;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import javax.websocket.OnMessage;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/webSocket")
public class WebSocket {

	@OnMessage
	public void onMessage(Session session, String fileName) throws IOException {
		String root = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\Carbon-GIS\\project_WH\\src\\main\\webapp\\resources\\upload\\";
		FileReader reader = new FileReader(root+fileName);
		BufferedReader bf = new BufferedReader(reader);
		String aLine = "";
		while((aLine = bf.readLine())!=null) {
			session.getBasicRemote().sendText("Message received: " + aLine);
		}
		
	}
}
