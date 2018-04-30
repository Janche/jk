package cn.itcast.service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import cn.itcast.domain.Dictionary;
import cn.itcast.util.Page;

public interface DictService {

	// 查询所有，带条件查询
	public List<Dictionary> find(String hql, Class<Dictionary> entityClass, Object[] params);

	// 获取一条记录
	public Dictionary get(Class<Dictionary> entityClass, Serializable id);

	// 分页查询，将数据封装到一个page分页工具类对象
	public Page<Dictionary> findPage(String hql, Page<Dictionary> page, Class<Dictionary> entityClass, Object[] params);

	// 新增和修改保存
	public void saveOrUpdate(Dictionary entity);

	// 批量新增和修改保存
	public void saveOrUpdateAll(Collection<Dictionary> entitys);

	// 单条删除，按id
	public void deleteById(Class<Dictionary> entityClass, Serializable id);

	// 批量删除
	public void delete(Class<Dictionary> entityClass, Serializable[] ids);
}
