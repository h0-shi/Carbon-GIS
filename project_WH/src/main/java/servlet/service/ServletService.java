package servlet.service;

import java.util.List;
import java.util.Map;

import servlet.vo.ServletVO;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<ServletVO> sidonm();

	List<ServletVO> sgg(String sd);

	List<ServletVO> bjd(String sggSel);

	Map<String, Double> center(Map<String, String> where);

	int dbInsert(List<Map<String, Object>> list);
}
