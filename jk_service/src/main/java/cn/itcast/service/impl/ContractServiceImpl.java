package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.Contract;
import cn.itcast.service.ContractService;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;
@Service
@Transactional
public class ContractServiceImpl implements ContractService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<Contract> find(String hql, Class<Contract> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public Contract get(Class<Contract> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<Contract> findPage(String hql, Page<Contract> page, Class<Contract> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(Contract entity) {
		// 新增
		if (UtilFuns.isEmpty(entity.getId())) {
			entity.setTotalAmount(0d);
			entity.setState(0); // 0代表草稿  1已上报  2已报运
		}
		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<Contract> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<Contract> entityClass, Serializable id) {
		
		baseDao.deleteById(entityClass, id);	// 删除模块信息
	}

	@Override
	public void delete(Class<Contract> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(Contract.class, id);
		}
	}

	@Override
	public void changeState(Integer state, String[] ids) {
		for (String id : ids) {
			Contract contract = baseDao.get(Contract.class, id);
			contract.setState(state);
			baseDao.saveOrUpdate(contract);  //可以不写，hibernate持久太会自动保存（hibernate的一级缓存）
		}
	}


}
