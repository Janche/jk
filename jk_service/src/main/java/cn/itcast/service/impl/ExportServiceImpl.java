package cn.itcast.service.impl;

import cn.itcast.dao.BaseDao;
import cn.itcast.domain.*;
import cn.itcast.service.ExportService;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;
import java.util.*;

@Service
@Transactional
public class ExportServiceImpl implements ExportService {

	// 注入dao
	@Autowired
	private BaseDao baseDao;

	public void setBaseDao(BaseDao baseDao) {
		this.baseDao = baseDao;
	}

	@Override
	public List<Export> find(String hql, Class<Export> entityClass, Object[] params) {

		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public Export get(Class<Export> entityClass, Serializable id) {

		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<Export> findPage(String hql, Page<Export> page, Class<Export> entityClass, Object[] params) {

		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate(Export entity) {

		// 判断
		if (UtilFuns.isEmpty(entity.getId())) {
			// 如果id为空,说明是新增报运单,则设置初始状态为0
			entity.setState(0);

			// 设置当前的日期为制单时间
			entity.setInputDate(new Date());

			// name="contractIds" value="4028817a33fc4e280133fd9f8b4e002f,
			// 4028a9bd515b3be301515b3d676f0000,
			// 4028817a33812ffd0133813f25940001" />
			// 将前台传来的多个合同的id号码切割成数组
			String[] ids = entity.getContractIds().split(", ");

			// 创建字符串拼接对象
			StringBuilder stringBuilder = new StringBuilder();

			// 遍历ids集合
			for (String id : ids) {

				// 通过id查到每个合同对象
				Contract contract = baseDao.get(Contract.class, id);
				// 将合同的状态设置成2,已报运
				contract.setState(2);
				// 将修改后的合同对象保存到数据库中
				baseDao.saveOrUpdate(contract);
				// 因为报运单中的多个合同号是这样的形式放到excel表格中的:11JK1084
				// C/3817/11,所以在数据库中就要把合同号盘皆成想要的形式
				stringBuilder.append(contract.getContractNo()).append(" ");
			}
			// 将拼接后的对象设置到报运单里面去
			entity.setCustomerContract(stringBuilder.toString());

			// 报运单里面的合同id字符串是id1,id2,...形式的
			entity.setContractIds(UtilFuns.joinStr(ids, ","));

			// 通过报运单中的合同id集合,跳跃查询查询报运单下的购销合同下的所有货物
			String hql = "from ContractProduct where contract.id in (" + UtilFuns.joinInStr(ids) + ")";

			// 查询出所有的货物
			List<ContractProduct> contractProductList = baseDao.find(hql, ContractProduct.class, null);

			// 新建一个set集合,盛放出口报运单下的货物
			HashSet<ExportProduct> exportProductList = new HashSet<>();

			// 货物的数据搬家
			// 遍历contractProductList集合
			for (ContractProduct contractProduct : contractProductList) {
				// 创建报运单下的商品对象
				ExportProduct exportProduct = new ExportProduct();

				// 数据搬家
				exportProduct.setBoxNum(contractProduct.getBoxNum());
				exportProduct.setCnumber(contractProduct.getCnumber());
				exportProduct.setFactory(contractProduct.getFactory());
				exportProduct.setOrderNo(contractProduct.getOrderNo());
				exportProduct.setPackingUnit(contractProduct.getPackingUnit());
				exportProduct.setPrice(contractProduct.getPrice());
				exportProduct.setProductNo(contractProduct.getProductNo());
				exportProduct.setExport(entity);// 设置商品与报运单 多对一

				// 将设置好的报运单下的货物保存到集合中
				exportProductList.add(exportProduct);

				// 获取货物下所有的附件集合
				Set<ExtCproduct> extCproductsList = contractProduct.getExtCproducts();

				// 新建一个set集合,盛放出口报运单下的附件
				HashSet<ExtEproduct> extExportProductList = new HashSet<>();

				// 遍历附件集合
				for (ExtCproduct extCproduct : extCproductsList) {
					// 创建报运单下的商品对象
					ExtEproduct extEproduct = new ExtEproduct();

					// 实用工具类数据搬家
					BeanUtils.copyProperties(extCproduct, extEproduct);
					extEproduct.setId(null);
					extEproduct.setExportProduct(exportProduct);
					// 将设置好的附件放到set集合中
					extExportProductList.add(extEproduct);
				}

				// 向报运单下的货物对象中添加附件集合exportProduct
				exportProduct.setExtEproducts(extExportProductList);
			}

			// 大循环结束时,所有的货物和商品都已经弄好,需要在报运单中设置一个货物的集合
			entity.setExportProducts(exportProductList);

		}

		// 将最终设置好的报运单保存到数据库中
		baseDao.saveOrUpdate(entity);

	}

	@Override
	public void saveOrUpdateAll(Collection<Export> entitys) {
		baseDao.saveOrUpdateAll(entitys);

	}

	@Override
	public void deleteById(Class<Export> entityClass, Serializable id) {

		baseDao.deleteById(entityClass, id);
	}

	@Override
	public void delete(Class<Export> entityClass, Serializable[] ids) {
		// 遍历ids数组,调用用过id删除用户的方法
		for (Serializable id : ids) {
			this.deleteById(Export.class, id);
		}
	}

	// 改变状态的方法
	@Override
	public void changeState(String[] ids, int state) {
		// 遍历ids
		for (String id : ids) {
			// 通过id获得一个合同对象
			Export export = baseDao.get(Export.class, id);

			export.setState(state);

			baseDao.saveOrUpdate(export);
		}

	}

	// 保存电子报运返回的对象的方法
	@Override
	public void update(Export entity) {
		// 从数据库获取完整的export对象
		Export export = baseDao.get(Export.class, entity.getId());

		// 将报运单里面的状态改为2
		export.setState(entity.getState());
		export.setRemark(entity.getRemark());

		// 获取页面上传来的货物
		Set<ExportProduct> epSet = entity.getExportProducts();

		for (ExportProduct ep : epSet) {

			// 遍历集合,通过id获取到每一个数据库中的货物
			ExportProduct exportProduct = baseDao.get(ExportProduct.class, ep.getId());

			// 将税金设置进去
			exportProduct.setTax(ep.getTax());

			// 将商品保存到数据库
			baseDao.saveOrUpdate(exportProduct);
		}

		// 将报运单保存到数据库
		baseDao.saveOrUpdate(export);

	}

}
