package servlet.util;

import org.springframework.stereotype.Service;

@Service
public class Util {
	
	public String getKey() {
		return "17254DD9-A574-399C-A5E5-781211777FFF";
	}
	
	public Long[] getLegend(String strLegend) {
		strLegend = strLegend.substring(1,strLegend.length()-1);
		String[] temp = strLegend.split(",");
		Long[] legend = new Long[5];
		
		for (int i = 0; i < temp.length; i++) {
			legend[i] = Long.parseLong(temp[i]);			
		}
		return legend; 
	}

}
