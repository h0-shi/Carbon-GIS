package servlet.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import servlet.service.ServletService;
import servlet.vo.ServletVO;

@Controller
@ResponseBody
public class RestController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@PostMapping("/hover.do")
	public List<ServletVO> hover(String sd, String sggSel) throws IOException {
		List<ServletVO> sgg = servletService.sgg(sd);
		
		if(sggSel != null) {
			List<ServletVO> bjd = servletService.bjd(sggSel);
			return bjd;
		}
		return sgg;
	}
	
	@PostMapping("/getCenter.do")
	public Map<String, Double> getCenter(String filter, String type){
		Map<String, String> where = new HashMap<String, String>();
		where.put("type", type);
		where.put("filter", filter);
		Map<String, Double> center = servletService.center(where);
		return center;
	}
	
	@PostMapping("/dbInsert.do")
	public int test(MultipartHttpServletRequest request) throws IOException {
		MultipartFile mFile = request.getFile("file");
		InputStreamReader isr = new InputStreamReader(mFile.getInputStream(),"UTF-8");
		BufferedReader bf = new BufferedReader(isr);
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();

		String aLine = null;
		int pageSize = 1;
		int count = 1;
		
		while((aLine = bf.readLine()) != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			String[] arr = aLine.split("\\|");
		    map.put("useDate", arr[0]);
//		    map.put("mtLoc", arr[1]);
//		    map.put("rdLoc", arr[2]);
		    map.put("sggCD", arr[3]);
		    map.put("bjd", arr[4]);
//		    map.put("mtYn", arr[5]);
//		    map.put("bun", arr[6]);
//		    map.put("ji", arr[7]);
//		    map.put("newNum", arr[8]);
//		    map.put("newRdCd", arr[9]);
//		    map.put("udrtYn", arr[10]);
//		    map.put("bonbeon", arr[11]);
//		    map.put("boobeon", arr[12]);
		    map.put("usage", Integer.parseInt(arr[13]));
		  
		    list.add(map);
		    if(--pageSize <= 0 ) {
		    	//int result = servletService.dbInsert(list);
		    	System.out.println("클리어"+count++);
		    	list.clear();
		    	pageSize = 1;
		    }
		    
		}
		
		bf.close();
		
		//int result = servletService.dbInsert(list);
		return 1;//return result; 
	}
	

}
