package cn.itcast.service;

import cn.itcast.domain.ExportProduct;
import cn.itcast.util.Page;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface ExportProductService {

	//查询所有，带条件查询
	public List<ExportProduct> find(String hql, Class<ExportProduct> entityClass, Object[] params);
	//获取一条记录
	public ExportProduct get(Class<ExportProduct> entityClass, Serializable id);
	//分页查询，将数据封装到一个page分页工具类对象
	public Page<ExportProduct> findPage(String hql, Page<ExportProduct> page, Class<ExportProduct> entityClass, Object[] params);

	//新增和修改保存
	public void saveOrUpdate(ExportProduct entity);
	//批量新增和修改保存
	public void saveOrUpdateAll(Collection<ExportProduct> entitys);

	//单条删除，按id
	public void deleteById(Class<ExportProduct> entityClass, Serializable id);
	//批量删除
	public void delete(Class<ExportProduct> entityClass, Serializable[] ids);

	//修改状态的方法
	public void changeState(String[] ids, int state);
}
