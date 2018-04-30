package cn.itcast.service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import cn.itcast.domain.DictAndModule;
import cn.itcast.util.Page;

public interface DictAndModuleService {

	// 查询所有，带条件查询
	public List<DictAndModule> find(String hql, Class<DictAndModule> entityClass, Object[] params);

	// 获取一条记录
	public DictAndModule get(Class<DictAndModule> entityClass, Serializable id);

	// 分页查询，将数据封装到一个page分页工具类对象
	public Page<DictAndModule> findPage(String hql, Page<DictAndModule> page, Class<DictAndModule> entityClass, Object[] params);

	// 新增和修改保存
	public void saveOrUpdate(DictAndModule entity);

	// 批量新增和修改保存
	public void saveOrUpdateAll(Collection<DictAndModule> entitys);

	// 单条删除，按id
	public void deleteById(Class<DictAndModule> entityClass, Serializable id);

	// 批量删除
	public void delete(Class<DictAndModule> entityClass, Serializable[] ids);
}
