package servlet.controller;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import servlet.service.AnalysisService;
import servlet.util.Util;

@Controller
public class analysisController {
	
	@Resource(name= "AnalysisService")
	private AnalysisService analysisService;
	
	@Autowired
	private Util util;
	
	@GetMapping("/analysis.do")
	public String analysis(Model model) {
		long total = analysisService.total();
		model.addAttribute("total",total);
		return "main/analysis";
	}
	
}
