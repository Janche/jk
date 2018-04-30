package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.Factory;
import cn.itcast.service.FactoryService;
import cn.itcast.util.Page;
@Service
@Transactional
public class FactoryServiceImpl implements FactoryService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<Factory> find(String hql, Class<Factory> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public Factory get(Class<Factory> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<Factory> findPage(String hql, Page<Factory> page, Class<Factory> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(Factory entity) {
		// 新增
		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<Factory> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<Factory> entityClass, Serializable id) {
		
		baseDao.deleteById(entityClass, id);	// 删除模块信息
	}

	@Override
	public void delete(Class<Factory> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(Factory.class, id);
		}
	}


}
