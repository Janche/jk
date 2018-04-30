package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import cn.itcast.util.Arith;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.Contract;
import cn.itcast.domain.ContractProduct;
import cn.itcast.domain.ExtCproduct;
import cn.itcast.service.ContractProductService;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;

@Service
@Transactional
public class ContractProductServiceImpl implements ContractProductService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<ContractProduct> find(String hql, Class<ContractProduct> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public ContractProduct get(Class<ContractProduct> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<ContractProduct> findPage(String hql, Page<ContractProduct> page, Class<ContractProduct> entityClass,
			Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(ContractProduct entity) {
		double amount = 0d;
		if (UtilFuns.isEmpty(entity.getId())) {
			// 新增
			if (UtilFuns.isNotEmpty(entity.getPrice())) {
				amount = Arith.mul(entity.getPrice(), entity.getCnumber());
				// amount = entity.getPrice() * entity.getCnumber();  // 货物总金额
				entity.setAmount(amount);
			}
			// 修改购销合同的总金额
			Contract contract = baseDao.get(Contract.class, entity.getContract().getId());
			contract.setTotalAmount(contract.getTotalAmount() + amount);
			// 保存购销合同的总金额
			baseDao.saveOrUpdate(contract);
		} else {
			// 取出货物原有总金额
			double oldAmount = entity.getAmount();
			if (UtilFuns.isNotEmpty(entity.getPrice())) {
				amount = Arith.mul(entity.getPrice(), entity.getCnumber()); // 货物总金额
				entity.setAmount(amount);
			}
			// 修改购销合同的总金额
			Contract contract = baseDao.get(Contract.class, entity.getContract().getId());
			contract.setTotalAmount(contract.getTotalAmount() - oldAmount + amount);
			// 保存购销合同的总金额
			baseDao.saveOrUpdate(contract);
		}

		baseDao.saveOrUpdate(entity);
	}

	@Override
	public void saveOrUpdateAll(Collection<ContractProduct> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<ContractProduct> entityClass, Serializable id) {

		baseDao.deleteById(entityClass, id); // 删除模块信息
	}

	@Override
	public void delete(Class<ContractProduct> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(ContractProduct.class, id);
		}
	}

	@Override
	public void delete(Class<ContractProduct> entityClass, ContractProduct contractProduct) {
		ContractProduct product = baseDao.get(ContractProduct.class, contractProduct.getId());
		Set<ExtCproduct> extCproducts = product.getExtCproducts();
		Contract contract = baseDao.get(Contract.class, product.getContract().getId());
		// 减去附件的金额
		for (ExtCproduct extCproduct : extCproducts) {
			contract.setTotalAmount(contract.getTotalAmount() - extCproduct.getAmount());
		}
		// 减去货物的金额
		contract.setTotalAmount(contract.getTotalAmount() - product.getAmount());
		// 保存购销合同的金额修改
		baseDao.saveOrUpdate(contract);
		// 级联删除附件 配置文件加了cascade
		baseDao.deleteById(ContractProduct.class, product.getId());
	}

}
