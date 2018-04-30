package cn.itcast.service.impl;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.ExportProduct;
import cn.itcast.service.ExportProductService;
import cn.itcast.util.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
@Transactional
public class ExportProductServiceImpl implements ExportProductService {
	
	//注入dao
	@Resource
	private BaseDao baseDao;

	public void setBaseDao(BaseDao baseDao) {
		this.baseDao = baseDao;
	}

	@Override
	public List<ExportProduct> find(String hql, Class<ExportProduct> entityClass, Object[] params) {
		
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public ExportProduct get(Class<ExportProduct> entityClass, Serializable id) {
		
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<ExportProduct> findPage(String hql, Page<ExportProduct> page, Class<ExportProduct> entityClass, Object[] params) {
		
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(ExportProduct entity) {

		
		baseDao.saveOrUpdate(entity);
		
	}

	@Override
	public void saveOrUpdateAll(Collection<ExportProduct> entitys) {
		baseDao.saveOrUpdateAll(entitys);
		
	}

	@Override
	public void deleteById(Class<ExportProduct> entityClass, Serializable id) {
		
		baseDao.deleteById(entityClass, id);
	}

	@Override
	public void delete(Class<ExportProduct> entityClass, Serializable[] ids) {
		//遍历ids数组,调用用过id删除用户的方法
		for (Serializable id : ids) {
			this.deleteById(ExportProduct.class, id);
		}
	}

	//改变状态的方法
	@Override
	public void changeState( String[] ids, int state) {
		
	}
	
}
