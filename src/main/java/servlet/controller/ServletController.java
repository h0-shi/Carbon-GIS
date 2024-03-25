package servlet.controller;

import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.ServletService;
import servlet.util.Key;
import servlet.vo.ServletVO;

@Controller
public class ServletController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@Autowired
	private Key util;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model, @RequestParam(name="zip", defaultValue = "" ,required = false) String zip) throws Exception {
		List<ServletVO> sidonm = servletService.sidonm();
		
		if(zip.length()>1) {
			zip = "sd_nm='"+zip+"'";
		}
		model.addAttribute("zip",zip);
		//model.addAttribute("key",util.getKey());
		model.addAttribute("list",sidonm);
		return "main/main";
	}
	
	@GetMapping("/hover.do")
	@CrossOrigin(origins = "*", allowedHeaders =  "*")
	public String hover(ModelMap model,@RequestParam(name="sgg", defaultValue = "", required = false) String sgg_nm, @RequestParam(name="sd",defaultValue = "", required = false) String sd, @RequestParam(name="size",required = false, defaultValue = "sd") String size) throws Exception {
		List<ServletVO> sidonm = servletService.sidonm();
		if(sd.length()>0) {
			List<ServletVO> sgg = servletService.sgg(sd);
			model.addAttribute("sgg",sgg);
			if(sgg_nm.length()>0) {
				sd = "sgg_nm='"+sd+" "+sgg_nm+"'";
			} else {
				sd = "sd_nm='"+sd+"'";
			}
		}
		System.out.println(util.getKey());
		model.addAttribute("size",size);
		model.addAttribute("sd",sd);
		model.addAttribute("key",util.getKey());
		model.addAttribute("list",sidonm);
		return "main/hover";
	}
	
	@ResponseBody
	@PostMapping("/hover.do")
	public List<ServletVO> hover(String sd, String sggSel, HttpServletResponse res) throws IOException {
		List<ServletVO> sgg = servletService.sgg(sd);
		if(sggSel != null) {
			List<ServletVO> bjd = servletService.bjd(sggSel);
			return bjd;
		}
		return sgg;
	}
	
	@RequestMapping(value="/mapTest.do")
	public String layer() {
		return "main/mapTest";
	}
}
