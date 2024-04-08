package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.AnalysisService;
import servlet.util.Util;
import servlet.vo.ServletVO;

@Controller
@ResponseBody
public class AnalysisRestController {
	
	@Resource(name = "AnalysisService")
	private AnalysisService analysisService;
	@Autowired
	Util util;
	
	@PostMapping("/getUsage.do")
	public List<ServletVO> getUsage(String filter, String type){
		List<ServletVO> getUasge = analysisService.getUsage(filter,type);
		return getUasge;
	}
	
	
	

}
