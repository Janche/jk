package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.Dept;
import cn.itcast.service.DeptService;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;

@Service
@Transactional
public class DeptServiceImpl implements DeptService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<Dept> find(String hql, Class<Dept> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public Dept get(Class<Dept> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<Dept> findPage(String hql, Page<Dept> page, Class<Dept> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(Dept entity) {
		if (UtilFuns.isEmpty(entity.getId())) {
			// 新增
			entity.setState(1);// 1是启用 0停用 默认为启用
		}
		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<Dept> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<Dept> entityClass, Serializable id) {
		// 有哪些子部门的父部门的编号为第二个参数：id
		String hql = "from Dept where parent.id = ?";
		// 查询当前父部门下的子部门列表
		List<Dept> list = baseDao.find(hql, Dept.class, new Object[]{id});
		if (list != null && list.size() > 0) {
			for (Dept dept : list) {
				baseDao.deleteById(Dept.class, dept.getId());
//				deleteById(Dept.class, dept.getId());	// 递归调用删除子部门的方法
			}
		}
		baseDao.deleteById(entityClass, id);	// 删除父部门
	}

	@Override
	public void delete(Class<Dept> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(Dept.class, id);
		}
	}

}
