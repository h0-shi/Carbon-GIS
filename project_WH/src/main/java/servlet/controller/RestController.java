package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import servlet.service.AnalysisService;
import servlet.service.ServletService;
import servlet.util.Util;
import servlet.vo.ServletVO;

@Controller
@ResponseBody
public class RestController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	@Resource(name = "AnalysisService")
	private AnalysisService analysisService;
	@Autowired
	Util util;
	
	@PostMapping("/getDropdown.do")
	public List<ServletVO> hover(String sd, String sggSel) throws IOException {
		List<ServletVO> sgg = servletService.sgg(sd);
		if(sggSel != null) {
			List<ServletVO> bjd = servletService.bjd(sggSel);
			return bjd;
		}
		return sgg;
	}
	
	@PostMapping("/getCenter.do")
	public String getCenter(String filter, String type){
		Map<String, String> where = new HashMap<String, String>();
		where.put("type", type);
		where.put("filter", filter);
		
		Map<String, String> center = servletService.center(where);
		String bBox = center.get("st_asgeojson");
		return bBox;
	}
	
	@PostMapping("/dbInsert.do")
	public int test(MultipartHttpServletRequest request) throws IOException {
		MultipartFile mFile = request.getFile("file");
		InputStreamReader isr = new InputStreamReader(mFile.getInputStream(),"UTF-8");
		BufferedReader bf = new BufferedReader(isr);
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();

		String aLine = null;
		int count = 0;
		int pageSize = 10000;
		while((aLine = bf.readLine()) != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			String[] arr = aLine.split("\\|");
		    map.put("useDate", arr[0]);
		    map.put("sggCD", arr[3]);
		    map.put("bjd", arr[4]);
		    map.put("usage", Integer.parseInt(arr[13]));
		    list.add(map);
		    count++;
		    if(--pageSize <= 0 ) {
		    	//int result = servletService.dbInsert(list);
		    	list.clear();
		    	pageSize = 0;
		    }
		}
		
		bf.close();
		
		return count;//return result; 
	}
	
	@PostMapping("/legend.do")
	public List<Long> legend(String filter, String type){
		Map<String, String> where = new HashMap<String, String>();
		where.put("filter", filter);
		System.out.println(filter);
		where.put("type", type);
		String legendStr = servletService.legend(where);
		List<Long> legend = util.getLegend(legendStr);
		return legend;
	}

}
