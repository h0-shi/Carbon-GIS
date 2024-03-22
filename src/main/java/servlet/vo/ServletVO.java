package servlet.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;

@Alias("servletVO")
public class ServletVO {

	private String sd_nm, sgg_nm, bjd_nm;

	public String getSd_nm() {
		return sd_nm;
	}

	public void setSd_nm(String sd_nm) {
		this.sd_nm = sd_nm;
	}

	public String getSgg_nm() {
		return sgg_nm;
	}

	public void setSgg_nm(String sgg_nm) {
		this.sgg_nm = sgg_nm;
	}

	public String getBjd_nm() {
		return bjd_nm;
	}

	public void setBjd_nm(String bjd_nm) {
		this.bjd_nm = bjd_nm;
	}

}
