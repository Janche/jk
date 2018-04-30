package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.Contract;
import cn.itcast.domain.ExtCproduct;
import cn.itcast.service.ExtCproductService;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;
@Service
@Transactional
public class ExtCproductServiceImpl implements ExtCproductService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<ExtCproduct> find(String hql, Class<ExtCproduct> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public ExtCproduct get(Class<ExtCproduct> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<ExtCproduct> findPage(String hql, Page<ExtCproduct> page, Class<ExtCproduct> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(ExtCproduct entity) {
		double amount = 0d;
		if (UtilFuns.isEmpty(entity.getId())) {
			// 新增
			if (UtilFuns.isNotEmpty(entity.getPrice())) {
				amount = entity.getPrice() * entity.getCnumber();  // 货物总金额
				entity.setAmount(amount);
			}
			// 修改购销合同的总金额
			Contract contract = baseDao.get(Contract.class, entity.getContractProduct().getContract().getId());
			contract.setTotalAmount(contract.getTotalAmount() + amount);
			// 保存购销合同的总金额
			baseDao.saveOrUpdate(contract);
		} else {
			// 取出货物原有总金额
			double oldAmount = entity.getAmount();
			if (UtilFuns.isNotEmpty(entity.getPrice())) {
				amount = entity.getPrice() * entity.getCnumber(); // 货物总金额
				entity.setAmount(amount);
			}
			// 修改购销合同的总金额
			Contract contract = baseDao.get(Contract.class, entity.getContractProduct().getContract().getId());
			contract.setTotalAmount(contract.getTotalAmount() - oldAmount + amount);
			// 保存购销合同的总金额
			baseDao.saveOrUpdate(contract);
		}

		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<ExtCproduct> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<ExtCproduct> entityClass, Serializable id) {
		
		baseDao.deleteById(entityClass, id);	// 删除模块信息
	}

	@Override
	public void delete(Class<ExtCproduct> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(ExtCproduct.class, id);
		}
	}


}
