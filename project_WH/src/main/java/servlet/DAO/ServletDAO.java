package servlet.DAO;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.impl.EgovComAbstractDAO;
import servlet.vo.ServletVO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	@Inject
	private SqlSessionTemplate webSession;
	
	public List<EgovMap> selectAll() {
		return session.selectList("servlet.serVletTest");
	}

	public List<ServletVO> sidonm() {
		return session.selectList("servlet.sidonm");
	}

	public List<ServletVO> sgg(String sd) {
		return session.selectList("servlet.sgg", sd);
	}

	public List<ServletVO> bjd(String sgg) {
		return session.selectList("servlet.bjd",sgg);
	}

	public Map<String, String> center(Map<String, String> where) {
		return session.selectOne("servlet.center",where);
	}

	public int dbInsert(List<Map<String, Object>> list) {
		return session.insert("servlet.dbInsert",list);
	}

	public String legend(Map<String, String> where) {
		return session.selectOne("servlet.legend",where);
	}

	public List<Object> test() {
		return webSession.selectList("servlet.sidonm");
	}

}
