package servlet.DAO;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("AnalysisDAO")
public class AnalysisDAO {

	@Autowired
	private SqlSessionTemplate session;
	
	public long total() {
		return session.selectOne("servlet.total");
	}

}
