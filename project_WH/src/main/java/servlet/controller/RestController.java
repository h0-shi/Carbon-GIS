package servlet.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
	public String dbInsert(MultipartHttpServletRequest request) throws IOException {
		MultipartFile mFile = request.getFile("file");
		String fileRealName = mFile.getOriginalFilename();
		String fileExtension = fileRealName.substring(fileRealName.lastIndexOf("."),fileRealName.length());
		if(!fileExtension.equals(".txt")) {
			System.out.println(fileExtension);
			return "";
		}
		InputStreamReader isr = new InputStreamReader(mFile.getInputStream(),"UTF-8");
		BufferedReader bf = new BufferedReader(isr);
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			String[] arr = bf.readLine().split("\\|");
			map.put("useDate", arr[0]);
			map.put("sggCD", arr[3]);
			map.put("bjd", arr[4]);
			map.put("usage", Integer.parseInt(arr[13]));
		} catch (Exception e) {
			return "";
		}
		
		int trunc = servletService.truncate();
		
		String upfile = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\Carbon-GIS\\project_WH\\src\\main\\webapp\\resources\\upload\\";
		UUID uuid = UUID.randomUUID();
		File saveFile = new File(upfile, uuid+fileRealName);
		mFile.transferTo(saveFile);
		
		return uuid+fileRealName;//return result; 
	}
	
	@PostMapping("/legend.do")
	public List<Long> legend(String filter, String type){
		Map<String, String> where = new HashMap<String, String>();
		where.put("filter", filter);
		where.put("type", type);
		String legendStr = servletService.legend(where);
		List<Long> legend = util.getLegend(legendStr);
		return legend;
	}
	
}
