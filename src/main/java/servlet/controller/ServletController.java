package servlet.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model, @RequestParam(name="zip", defaultValue = "" ,required = false) String zip) throws Exception {
		if(zip.length()>1) {
			zip = "SIG_CD IN ("+zip+")";
		}
		model.addAttribute("zip",zip);
		return "main/main";
	}
	
	@RequestMapping(value="/mapTest.do")
	public String layer() {
		System.out.println("레이어");
		return "main/mapTest";
	}
}
