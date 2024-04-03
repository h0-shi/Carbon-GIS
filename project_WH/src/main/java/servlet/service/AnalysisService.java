package servlet.service;

import java.util.List;

import servlet.vo.ServletVO;

public interface AnalysisService {

	long total();

	List<ServletVO> sdTotal();

	List<ServletVO> getUsage(String filter, String type);

}
