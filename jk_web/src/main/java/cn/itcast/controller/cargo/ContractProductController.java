package cn.itcast.controller.cargo;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.domain.ContractProduct;
import cn.itcast.domain.Factory;
import cn.itcast.service.ContractProductService;
import cn.itcast.service.FactoryService;
import cn.itcast.service.RoleService;
import cn.itcast.util.Page;

/**
 * 货物处理的controller
 * 
 * @author LR-PC
 */
@Controller
@RequestMapping("/contractProduct")
public class ContractProductController {

	@Resource
	private ContractProductService contractProductService;

	@Resource
	private FactoryService factoryService;

	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate(Page<ContractProduct> page, Model model, ContractProduct contractProduct) {

		// 1.查询货物厂家
		List<Factory> factoryList = factoryService.find("from Factory where ctype='货物' and state = 1", Factory.class,
				null);
		model.addAttribute("factoryList", factoryList);

		// 2.查询当前合同下的货物
		page = contractProductService.findPage("from ContractProduct where contract.id = ?", page,
				ContractProduct.class, new String[] { contractProduct.getContract().getId() });
		model.addAttribute("page", page);
		// 跳页面
		return "cargo/contract/jContractProductCreate";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/insert")
	public String insert(ContractProduct contract) {
		// 调用业务方法，实现保存
		contractProductService.saveOrUpdate(contract);
		// 跳页面
		return "forward:tocreate.action";
	}

	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(ContractProduct contractProduct, Model model) {
		// 查询货物厂家
		List<Factory> factoryList = factoryService.find("from Factory where ctype='货物' and state = 1", Factory.class,
				null);
		model.addAttribute("factoryList", factoryList);
		// 根据id，得到一个对象
		contractProduct = contractProductService.get(ContractProduct.class, contractProduct.getId());
		// 将对象放入值栈中
		model.addAttribute("contractProduct", contractProduct);
		// 跳页面
		return "cargo/contract/jContractProductUpdate";
	}

	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(ContractProduct contract) {
		// 根据id，得到一个数据库中保存的对象
		ContractProduct obj = contractProductService.get(ContractProduct.class, contract.getId());
		// 设置修改的属性
		obj.setFactory(contract.getFactory());
		obj.setFactoryName(contract.getFactoryName());
		obj.setProductNo(contract.getProductNo());
		obj.setCnumber(contract.getCnumber());
		obj.setAmount(contract.getAmount());
		obj.setPackingUnit(contract.getPackingUnit());
		obj.setLoadingRate(contract.getLoadingRate());
		obj.setBoxNum(contract.getBoxNum());
		obj.setOrderNo(contract.getOrderNo());
		obj.setProductDesc(contract.getProductDesc());
		obj.setProductRequest(contract.getProductRequest());

		contractProductService.saveOrUpdate(obj);
		return "forward:tocreate.action";
	}

	/**
	 * 删除 contract id:String类型 具有同名框的一组值如何封装数据 如果服务器端是String类型： Struts2默认采用 , 分割
	 * id:Integer类型：100 200 300 将会导致数据丢失，Struts2默认只保存最后一个 Integer[]id;
	 * {100,200,300}服务器端用数组来接受没有问题
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete")
	public String delete(ContractProduct contractProduct) throws Exception {
		contractProductService.delete(ContractProduct.class, contractProduct);
		return "forward:tocreate.action";
	}

}
