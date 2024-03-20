package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import servlet.service.ServletService;
import servlet.vo.ServletVO;

@Controller
public class ServletController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model, @RequestParam(name="zip", defaultValue = "" ,required = false) String zip) throws Exception {
		List<ServletVO> sidonm = servletService.sidonm();
		
		if(zip.length()>1) {
			zip = "sd_nm='"+zip+"'";
		}
		model.addAttribute("zip",zip);
		model.addAttribute("list",sidonm);
		return "main/main";
	}
	
	@RequestMapping(value = "/hover.do")
	@CrossOrigin(origins = "*", allowedHeaders =  "*")
	public String hover(ModelMap model, @RequestParam(name="zip", defaultValue = "" ,required = false) String zip) throws Exception {
		List<ServletVO> sidonm = servletService.sidonm();
		
		if(zip.length()>1) {
			zip = "sd_nm='"+zip+"'";
		}
		model.addAttribute("zip",zip);
		model.addAttribute("list",sidonm);
		return "main/hover";
	}
	
	@RequestMapping(value="/mapTest.do")
	public String layer() {
		return "main/mapTest";
	}
}
