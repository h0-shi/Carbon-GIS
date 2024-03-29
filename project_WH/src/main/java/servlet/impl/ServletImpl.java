package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.ServletService;
import servlet.vo.ServletVO;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}

	@Override
	public List<ServletVO> sidonm() {
		return dao.sidonm();
	}

	@Override
	public List<ServletVO> sgg(String sd) {
		return dao.sgg(sd);
	}

	@Override
	public List<ServletVO> bjd(String sggSel) {
		return dao.bjd(sggSel);
	}

	@Override
	public Map<String, Double> center(Map<String, String> where) {
		return dao.center(where);
	}

	@Override
	public int dbInsert(List<Map<String, Object>> list) {
		return dao.dbInsert(list);
	}

	@Override
	public String legend() {
		return dao.legend();
	}

}
