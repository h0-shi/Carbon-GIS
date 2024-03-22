package servlet.service;

import java.util.List;

import servlet.vo.ServletVO;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<ServletVO> sidonm();

	List<ServletVO> sgg(String sd);
}
