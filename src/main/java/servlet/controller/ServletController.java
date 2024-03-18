package servlet.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model) throws Exception {
		System.out.println("sevController.java - mainTest()");
		String str = servletService.addStringTest("START! ");
		System.out.println("메인");
		model.addAttribute("resultStr", str);
		return "main/main";
	}
	
	@RequestMapping(value="/mapTest.do")
	public String layer() {
		System.out.println("레이어");
		return "main/mapTest";
	}
}
