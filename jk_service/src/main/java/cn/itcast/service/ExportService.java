package cn.itcast.service;

import cn.itcast.domain.Export;
import cn.itcast.util.Page;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface ExportService {
	
	//查询所有，带条件查询
	public List<Export> find(String hql, Class<Export> entityClass, Object[] params);
	//获取一条记录
	public Export get(Class<Export> entityClass, Serializable id);
	//分页查询，将数据封装到一个page分页工具类对象
	public Page<Export> findPage(String hql, Page<Export> page, Class<Export> entityClass, Object[] params);

	//新增和修改保存
	public void saveOrUpdate(Export entity);
	//批量新增和修改保存
	public void saveOrUpdateAll(Collection<Export> entitys);

	//单条删除，按id
	public void deleteById(Class<Export> entityClass, Serializable id);
	//批量删除
	public void delete(Class<Export> entityClass, Serializable[] ids);

	//修改状态的方法
	public void changeState(String[] ids, int state);

	//保存电子报运返回的对象的方法
	public void update(Export export);
}
