package cn.itcast.service.impl;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.ExtEproduct;
import cn.itcast.service.ExtEproductService;
import cn.itcast.util.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
@Transactional
public class ExtEproductServiceImpl implements ExtEproductService {
	
	//注入dao
	@Resource
	private BaseDao baseDao;

	public void setBaseDao(BaseDao baseDao) {
		this.baseDao = baseDao;
	}

	@Override
	public List<ExtEproduct> find(String hql, Class<ExtEproduct> entityClass, Object[] params) {
		
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public ExtEproduct get(Class<ExtEproduct> entityClass, Serializable id) {
		
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<ExtEproduct> findPage(String hql, Page<ExtEproduct> page, Class<ExtEproduct> entityClass, Object[] params) {
		
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(ExtEproduct entity) {

		
		baseDao.saveOrUpdate(entity);
		
	}

	@Override
	public void saveOrUpdateAll(Collection<ExtEproduct> entitys) {
		baseDao.saveOrUpdateAll(entitys);
		
	}

	@Override
	public void deleteById(Class<ExtEproduct> entityClass, Serializable id) {
		
		baseDao.deleteById(entityClass, id);
	}

	@Override
	public void delete(Class<ExtEproduct> entityClass, Serializable[] ids) {
		//遍历ids数组,调用用过id删除用户的方法
		for (Serializable id : ids) {
			this.deleteById(ExtEproduct.class, id);
		}
	}

	//改变状态的方法
	@Override
	public void changeState( String[] ids, int state) {
		
		
		}
	
}
