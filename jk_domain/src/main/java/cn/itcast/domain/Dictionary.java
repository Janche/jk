package cn.itcast.domain;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

/**
 * @author LR-PC
 *	数据字典
 */
public class Dictionary implements Serializable {

	private static final long serialVersionUID = 1L;
	private String did;  //字典 id
	private String description;//描述
	private String dictype;//类型
	private String name;//名称
	private String val;//取值
	private Set<Module> modules = new HashSet<Module>(0); // 操作资源和模块  多对多
	private Set<Role> roles = new HashSet<Role>(0);// 操作资源和角色  多对多
	public String getDid() {
		return did;
	}
	public void setDid(String did) {
		this.did = did;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDictype() {
		return dictype;
	}
	public void setDictype(String dictype) {
		this.dictype = dictype;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getVal() {
		return val;
	}
	public void setVal(String val) {
		this.val = val;
	}
	public Set<Module> getModules() {
		return modules;
	}
	public void setModules(Set<Module> modules) {
		this.modules = modules;
	}
	public Set<Role> getRoles() {
		return roles;
	}
	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}
	
}
