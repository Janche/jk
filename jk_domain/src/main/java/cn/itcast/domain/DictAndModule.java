package cn.itcast.domain;

import java.io.Serializable;

public class DictAndModule implements Serializable{
	
	private static final long serialVersionUID = 1L;

	private String id;
	
	private String dictId;
	
	private String moduleId;
	
	private String roleId;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDictId() {
		return dictId;
	}

	public void setDictId(String dictId) {
		this.dictId = dictId;
	}

	public String getModuleId() {
		return moduleId;
	}

	public void setModuleId(String moduleId) {
		this.moduleId = moduleId;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	@Override
	public String toString() {
		return "DictAndModule [id=" + id + ", dictId=" + dictId + ", moduleId=" + moduleId + ", roleId=" + roleId + "]";
	}
	
	
}
