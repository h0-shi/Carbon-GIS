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
	public String hover(ModelMap model,@RequestParam(name="sgg", defaultValue = "", required = false) String sgg_nm, @RequestParam(name="sd",defaultValue = "", required = false) String sd, @RequestParam(name="size",required = false, defaultValue = "sd") String size) throws Exception {
		List<ServletVO> sidonm = servletService.sidonm();
		String filter = "";
		if(sd.length()>0) {
			List<ServletVO> sgg = servletService.sgg(sd);
			model.addAttribute("sgg",sgg);
			if(sgg_nm.length()>0) {
				filter = "sgg_nm='"+sd+" "+sgg_nm+"'";
			} else {
				filter = "sd_nm='"+sd+"'";
			}
		}
		//지금은 시도만
		model.addAttribute("size",size);
		model.addAttribute("filter",filter);
		model.addAttribute("key",util.getKey());
		model.addAttribute("list",sidonm);
		return "main/hover";
	}
	
}
