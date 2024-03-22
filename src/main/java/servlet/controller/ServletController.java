package servlet.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
	
	@GetMapping("/hover.do")
	@CrossOrigin(origins = "*", allowedHeaders =  "*")
	public String hover(ModelMap model, @RequestParam(name="sd",defaultValue = "", required = false) String sd, @RequestParam(name="size",required = false, defaultValue = "sd") String size) throws Exception {
		List<ServletVO> sidonm = servletService.sidonm();
		if(sd.length()>0) {
			System.out.println(sd);
			List<ServletVO> sgg = servletService.sgg(sd);
			model.addAttribute("sgg",sgg);
			sd = "sd_nm='"+sd+"'";
		}
		model.addAttribute("size",size);
		model.addAttribute("sd",sd);
		model.addAttribute("list",sidonm);
		return "main/hover";
	}
	
	@ResponseBody
	@PostMapping("/hover.do")
	public List<ServletVO> hover(String sd, HttpServletResponse res) throws IOException {
		List<ServletVO> sgg = servletService.sgg(sd);
		return sgg;
	}
	
	@RequestMapping(value="/mapTest.do")
	public String layer() {
		return "main/mapTest";
	}
}
