package servlet.socket;

import java.io.IOException;

import javax.websocket.OnMessage;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/webSocket")
public class WebSocket {

	@OnMessage
	public void onMessage(Session session, String message) throws IOException {
		System.out.println(session+"이게 세션");
		System.out.println("Received message from client: " + message);
		session.getBasicRemote().sendText("Message received: " + message);
	}
}
