package servlet.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import servlet.DAO.AnalysisDAO;
import servlet.service.AnalysisService;

@Service("AnalysisService")
public class AnalysisImpl implements AnalysisService {

	@Resource(name="AnalysisDAO")
	private AnalysisDAO analysisDAO;
	
	@Override
	public long total() {
		return analysisDAO.total();
	}

}
