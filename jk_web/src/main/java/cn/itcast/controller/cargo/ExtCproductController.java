package cn.itcast.controller.cargo;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.domain.ContractProduct;
import cn.itcast.domain.ExtCproduct;
import cn.itcast.domain.Factory;
import cn.itcast.service.ExtCproductService;
import cn.itcast.service.FactoryService;
import cn.itcast.service.RoleService;
import cn.itcast.util.Page;

/**
 * 附件处理的controller
 * 
 * @author LR-PC
 */
@Controller
@RequestMapping("/extCproduct")
public class ExtCproductController {

	@Resource
	private ExtCproductService extCproductService;
	
	@Resource
	private FactoryService factoryService;

	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate(Page<ExtCproduct>page, ExtCproduct extCproduct, Model model) {
		// 1.查询货物厂家
		List<Factory> factoryList = factoryService.find("from Factory where ctype='附件' and state = 1", Factory.class,
				null);
		model.addAttribute("factoryList", factoryList);

		// 2.查询当前货物下的附件列表
		page = extCproductService.findPage("from ExtCproduct where contractProduct.id = ?", page,
				ExtCproduct.class, new String[] { extCproduct.getContractProduct().getId() });
		model.addAttribute("page", page);
		// 跳页面
		return "cargo/contract/jExtCproductCreate";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/insert")
	public String insert(ExtCproduct extCproduct) {
		// 调用业务方法，实现保存
		extCproductService.saveOrUpdate(extCproduct);
		// 跳页面
		return "forward:tocreate.action";
	}

	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(ExtCproduct extCproduct, Model model) {
		// 1.查询货物厂家
		List<Factory> factoryList = factoryService.find("from Factory where ctype='附件' and state = 1", Factory.class, null);
		model.addAttribute("factoryList", factoryList);
		// 根据id，得到一个对象
		ExtCproduct obj = extCproductService.get(ExtCproduct.class, extCproduct.getId());
		// 将对象放入值栈中
		model.addAttribute("extCproduct", obj);
		// 跳页面
		return "cargo/contract/jExtCproductUpdate";
	}

	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(ExtCproduct extCproduct) {
		// 根据id，得到一个数据库中保存的对象
		ExtCproduct obj = extCproductService.get(ExtCproduct.class, extCproduct.getId());
		// 设置修改的属性
		obj.setFactory(extCproduct.getFactory());
		obj.setFactoryName(extCproduct.getFactoryName());
		obj.setProductNo(extCproduct.getProductNo());
		obj.setCnumber(extCproduct.getCnumber());
		obj.setAmount(extCproduct.getAmount());
		obj.setPackingUnit(extCproduct.getPackingUnit());
		obj.setOrderNo(extCproduct.getOrderNo());
		obj.setProductDesc(extCproduct.getProductDesc());
		obj.setProductRequest(extCproduct.getProductRequest());

		extCproductService.saveOrUpdate(obj);
		return "forward:tocreate.action";
	}

	/**
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete")
	public String delete(ExtCproduct extCproduct) throws Exception {
		String[] ids = extCproduct.getId().split(",");
		extCproductService.delete(ExtCproduct.class, ids);
		return "forward:tocreate.action";
	}

}
