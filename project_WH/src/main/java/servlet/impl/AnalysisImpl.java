package servlet.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import servlet.DAO.AnalysisDAO;
import servlet.service.AnalysisService;
import servlet.vo.ServletVO;

@Service("AnalysisService")
public class AnalysisImpl implements AnalysisService {

	@Resource(name="AnalysisDAO")
	private AnalysisDAO analysisDAO;
	
	@Override
	public long total() {
		return analysisDAO.total();
	}

	@Override
	public List<ServletVO> sdTotal() {
		return analysisDAO.sdTotal();
	}

	@Override
	public List<ServletVO> getUsage(String filter, String type) {
		return analysisDAO.getUsage(filter, type);
	}

}
