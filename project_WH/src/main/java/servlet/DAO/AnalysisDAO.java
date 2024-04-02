package servlet.DAO;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.vo.ServletVO;

@Repository("AnalysisDAO")
public class AnalysisDAO {

	@Autowired
	private SqlSessionTemplate session;
	
	public long total() {
		return session.selectOne("analysis.total");
	}

	public List<ServletVO> sdTotal() {
		return session.selectList("analysis.sdTotal");
	}

}
