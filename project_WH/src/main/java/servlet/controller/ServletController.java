package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import servlet.service.ServletService;
import servlet.util.Util;
import servlet.vo.ServletVO;

@Controller
public class ServletController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@Autowired
	private Util util;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model, @RequestParam(name="zip", defaultValue = "" ,required = false) String zip) throws Exception {
		return "main/main";
	}
	
	@GetMapping("/hover.do")
	@CrossOrigin(origins = "*", allowedHeaders =  "*")
	public String hover(ModelMap model) {
		List<ServletVO> sidonm = servletService.sidonm();
		model.addAttribute("key",util.getKey());
		model.addAttribute("list",sidonm);
		return "main/hover";
	}
	
}
