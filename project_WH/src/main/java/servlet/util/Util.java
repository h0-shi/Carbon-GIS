package servlet.util;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class Util {
	
	public String getKey() {
		return "17254DD9-A574-399C-A5E5-781211777FFF";
	}
	
	public List<Long> getLegend(String strLegend) {
		strLegend = strLegend.substring(1,strLegend.length()-1);
		String[] temp = strLegend.split(",");
		
		List<Long> legend = new ArrayList<Long>();
		for (int i = 0; i < temp.length; i++) {
			legend.add(Long.parseLong(temp[i]));			
		}
		return legend; 
	}

}
