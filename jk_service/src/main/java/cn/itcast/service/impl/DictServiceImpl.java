package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.Dictionary;
import cn.itcast.service.DictService;
import cn.itcast.util.Page;
@Service
@Transactional
public class DictServiceImpl implements DictService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<Dictionary> find(String hql, Class<Dictionary> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public Dictionary get(Class<Dictionary> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<Dictionary> findPage(String hql, Page<Dictionary> page, Class<Dictionary> entityClass,
			Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(Dictionary entity) {
		/*
		 * if (UtilFuns.isEmpty(entity.getDid())) { // 新增
		 * //entity.setState(1);// 1是启用 0停用 默认为启用 }
		 */
		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<Dictionary> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<Dictionary> entityClass, Serializable id) {
		baseDao.deleteById(entityClass, id);
	}

	@Override
	public void delete(Class<Dictionary> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(Dictionary.class, id);
		}
	}

}
