package servlet.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;

@Alias("servletVO")
public class ServletVO {

	private String sd_nm, sgg_nm, bjd_nm;
	private int sd_cd,sgg_cd,bjd_cd;
	private long usage;

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

	public int getSgg_cd() {
		return sgg_cd;
	}

	public void setSgg_cd(int sgg_cd) {
		this.sgg_cd = sgg_cd;
	}

	public int getSd_cd() {
		return sd_cd;
	}

	public void setSd_cd(int sd_cd) {
		this.sd_cd = sd_cd;
	}

	public int getBjd_cd() {
		return bjd_cd;
	}

	public void setBjd_cd(int bjd_cd) {
		this.bjd_cd = bjd_cd;
	}

	public long getUsage() {
		return usage;
	}

	public void setUsage(long usage) {
		this.usage = usage;
	}

}
