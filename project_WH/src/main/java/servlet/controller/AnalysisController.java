package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import servlet.service.AnalysisService;
import servlet.service.ServletService;
import servlet.util.Util;
import servlet.vo.ServletVO;

@Controller
public class AnalysisController {
	
	@Resource(name= "AnalysisService")
	private AnalysisService analysisService;
	@Resource(name= "ServletService")
	private ServletService servletService;
	
	@Autowired
	private Util util;
	
	@GetMapping("/analysis.do")
	public String analysis(Model model) {
		long total = analysisService.total();
		List<ServletVO> sdTotal = analysisService.sdTotal();
		List<ServletVO> sdnm = servletService.sidonm();
		model.addAttribute("sdnm",sdnm);
		model.addAttribute("total",total);
		model.addAttribute("sdTotal",sdTotal);
		return "main/analysis";
	}
	
}
