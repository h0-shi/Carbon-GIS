package servlet.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.ServletService;
import servlet.vo.ServletVO;

@Controller
@ResponseBody
public class RestController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@PostMapping("/hover.do")
	public List<ServletVO> hover(String sd, String sggSel) throws IOException {
		List<ServletVO> sgg = servletService.sgg(sd);
		
		if(sggSel != null) {
			List<ServletVO> bjd = servletService.bjd(sggSel);
			return bjd;
		}
		return sgg;
	}
	
	@PostMapping("/getCenter.do")
	public Map<String, Double> getCenter(String filter, String type){
		Map<String, String> where = new HashMap<String, String>();
		where.put("type", type);
		where.put("filter", filter);
		Map<String, Double> center = servletService.center(where);
		return center;
	}
	
	@PostMapping("/color.do")
	public String color(String filter) {
		
		return null;
	}
	

}
