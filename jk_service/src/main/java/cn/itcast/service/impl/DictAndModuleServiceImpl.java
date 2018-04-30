package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.DictAndModule;
import cn.itcast.service.DictAndModuleService;
import cn.itcast.util.Page;
@Service
@Transactional
public class DictAndModuleServiceImpl implements DictAndModuleService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<DictAndModule> find(String hql, Class<DictAndModule> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public DictAndModule get(Class<DictAndModule> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<DictAndModule> findPage(String hql, Page<DictAndModule> page, Class<DictAndModule> entityClass,
			Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(DictAndModule entity) {
		/*
		 * if (UtilFuns.isEmpty(entity.getDid())) { // 新增
		 * //entity.setState(1);// 1是启用 0停用 默认为启用 }
		 */
		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<DictAndModule> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<DictAndModule> entityClass, Serializable id) {
		baseDao.deleteById(entityClass, id);
	}

	@Override
	public void delete(Class<DictAndModule> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(DictAndModule.class, id);
		}
	}

}
