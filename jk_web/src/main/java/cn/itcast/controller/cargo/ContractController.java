package cn.itcast.controller.cargo;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.domain.Contract;
import cn.itcast.service.ContractService;
import cn.itcast.service.RoleService;
import cn.itcast.util.Page;

/**
 * 合同处理的controller
 * @author LR-PC
 */
@Controller
@RequestMapping("/contract")
public class ContractController {

	@Resource
	private ContractService contractService;

	/**
	 * 分页查询
	 */
	@RequestMapping("/list")
	public String list(Page<Contract> page, Model model, HttpServletRequest request) throws Exception {

		page = contractService.findPage("from Contract", page, Contract.class, null);
		// 设置分页的URL
		String path = request.getContextPath();
		page.setUrl(path+"/contract/list.action");

		model.addAttribute("page", page);
		return "cargo/contract/jContractList";
	}

	/**
	 * 查看
	 */
	@RequestMapping("/toview")
	public String toview(Contract contract, Model model) {
		// 1.调用业务方法，根据id,得到对象
		contract = contractService.get(Contract.class, contract.getId());
		// 放入栈顶
		model.addAttribute("contract", contract);
		return "cargo/contract/jContractView";
	}

	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate(Model model) {
		// 调用业务方法
		List<Contract> contractList = contractService.find("from Contract ", Contract.class, null);
		// 将查询结果放入值栈中 单个对象用push，集合用下面这个
		model.addAttribute("contractList", contractList);
		// 跳页面
		return "cargo/contract/jContractCreate";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/insert")
	public String insert(Contract contract) {
		// 调用业务方法，实现保存
		contractService.saveOrUpdate(contract);
		// 跳页面
		return "forward:list.action";
	}

	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(Contract contract, Model model) {
		// 根据id，得到一个对象
		Contract obj = contractService.get(Contract.class, contract.getId());
		// 将对象放入值栈中
		model.addAttribute("contract", obj);
		// 跳页面
		return "cargo/contract/jContractUpdate";
	}

	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(Contract contract) {
		// 根据id，得到一个数据库中保存的对象
		Contract obj = contractService.get(Contract.class, contract.getId());
		// 设置修改的属性
		obj.setCustomName(contract.getCustomName());
		obj.setPrintStyle(contract.getPrintStyle());
		obj.setContractNo(contract.getContractNo());
		obj.setOfferor(contract.getOfferor());
		obj.setInputBy(contract.getInputBy());
		obj.setCheckBy(contract.getCheckBy());
		obj.setInspector(contract.getInspector());
		obj.setSigningDate(contract.getSigningDate());
		obj.setImportNum(contract.getImportNum());
		obj.setShipTime(contract.getShipTime());
		obj.setTradeTerms(contract.getTradeTerms());
		obj.setDeliveryPeriod(contract.getDeliveryPeriod());
		obj.setCrequest(contract.getCrequest());
		obj.setRemark(contract.getRemark());
		
		contractService.saveOrUpdate(obj);
		return "forward:list.action";
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
	public String delete(Contract contract) throws Exception {
		String[] ids = contract.getId().split(",");
		contractService.delete(Contract.class, ids);
		return "forward:list.action";
	}
	
	/**
	 * 提交
	 */
	@RequestMapping("/submit")
	public String submit(Contract contract) throws Exception {
		String[] ids = contract.getId().split(",");
		contractService.changeState(1, ids);
		return "forward:list.action";
	}
	
	/**
	 * 取消
	 */
	@RequestMapping("/cancel")
	public String cancel(Contract contract) throws Exception {
		String[] ids = contract.getId().split(",");
		contractService.changeState(0, ids);
		return "forward:list.action";
	}

	/**
	 * 打印
	 */
	@RequestMapping("/print")
	public String print(String id, Contract contract, HttpServletResponse response, HttpServletRequest request) throws Exception {
		//1.根据购销合同的id,得到购销合同对象
		contract = contractService.get(Contract.class, contract.getId());
		System.out.println("id:"+id);
		//2.指定path
		String path = request.getRealPath("/");//应用程序的根路径

		ContractPrint cp = new ContractPrint();
		cp.print(contract, path, response);

		return null;
	}
}
