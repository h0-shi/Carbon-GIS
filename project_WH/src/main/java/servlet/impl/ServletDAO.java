package servlet.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.vo.ServletVO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<ServletVO> sidonm() {
		return selectList("servlet.sidonm");
	}

	public List<ServletVO> sgg(String sd) {
		return selectList("servlet.sgg", sd);
	}

	public List<ServletVO> bjd(String sgg) {
		return selectList("servlet.bjd",sgg);
	}

	public Map<String, Double> center(Map<String, String> where) {
		return session.selectOne("servlet.center",where);
	}

	public int dbInsert(List<Map<String, Object>> list) {
		return session.insert("dbInsert",list);
	}

	public String legend(Map<String, String> where) {
		return session.selectOne("legend",where);
	}

}
