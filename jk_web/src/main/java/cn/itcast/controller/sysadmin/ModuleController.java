package cn.itcast.controller.sysadmin;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.domain.Module;
import cn.itcast.service.ModuleService;
import cn.itcast.service.RoleService;
import cn.itcast.util.Page;

/**
 * 部门管理的Action
 * 
 * @author LR-PC
 */
@Controller
@RequestMapping("/module")
public class ModuleController {


	@Resource
	private ModuleService moduleService;

	@Resource
	private RoleService roleService;

	/**
	 * 分页查询
	 */
	@RequestMapping("/list")
	public String list(Page<Module> page, Model model, HttpServletRequest request) throws Exception {
		// 此处的page = 可以写出来，也可不写，因为修改的引用 类型的
		page = moduleService.findPage("from Module", page, Module.class, null);
		// 设置分页的URL
		String path = request.getContextPath();
		page.setUrl(path+"/module/list.action");

		model.addAttribute("page", page);
		return "sysadmin/module/jModuleList";
	}

	/**
	 * 查看
	 */
	@RequestMapping("/toview")
	public String toview(Module module, Model model) {
		// 1.调用业务方法，根据id,得到对象
		module = moduleService.get(Module.class, module.getId());
		// 放入栈顶
		model.addAttribute("module", module);
		return "sysadmin/module/jModuleView";
	}

	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate(Model model) {
		// 调用业务方法
		List<Module> moduleList = moduleService.find("from Module ", Module.class, null);
		// 将查询结果放入值栈中 单个对象用push，集合用下面这个
		model.addAttribute("moduleList", moduleList);
		// 跳页面
		return "sysadmin/module/jModuleCreate";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/insert")
	public String insert(Module module) {
		// 调用业务方法，实现保存
		moduleService.saveOrUpdate(module);
		// 跳页面
		return "forward:list.action";
	}

	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(Module module, Model model) {
		// 根据id，得到一个对象
		Module obj = moduleService.get(Module.class, module.getId());
		// 将对象放入值栈中
		model.addAttribute("module", obj);
		// 跳页面
		return "sysadmin/module/jModuleUpdate";
	}

	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(Module module) {
		// 根据id，得到一个数据库中保存的对象
		Module obj = moduleService.get(Module.class, module.getId());
		// 设置修改的属性
		obj.setName(module.getName());
		obj.setLayerNum(module.getLayerNum());
		obj.setCpermission(module.getCpermission());
		obj.setCurl(module.getCurl());
		obj.setCtype(module.getCtype());
		obj.setState(module.getState());
		obj.setBelong(module.getBelong());
		obj.setCwhich(module.getCwhich());
		obj.setRemark(module.getRemark());
		obj.setOrderNo(module.getOrderNo());
		
		moduleService.saveOrUpdate(obj);
		return "forward:list.action";
	}

	/**
	 * 删除 module id:String类型 具有同名框的一组值如何封装数据 如果服务器端是String类型： Struts2默认采用 , 分割
	 * id:Integer类型：100 200 300 将会导致数据丢失，Struts2默认只保存最后一个 Integer[]id;
	 * {100,200,300}服务器端用数组来接受没有问题
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete")
	public String delete(Module module) throws Exception {
		String[] ids = module.getId().split(",");
		moduleService.delete(Module.class, ids);
		return "forward:list.action";
	}
}
