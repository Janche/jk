package cn.itcast.controller.factory;

import cn.itcast.common.SysConstant;
import cn.itcast.domain.Factory;
import cn.itcast.domain.User;
import cn.itcast.service.FactoryService;
import cn.itcast.service.UserService;
import cn.itcast.util.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * 合同处理的controller
 * @author LR-PC
 */
@Controller
@RequestMapping("/factory")
public class FactoryController {

	@Resource
	private FactoryService factoryService;

	@Resource
	private UserService userService;
	/**
	 * 分页查询
	 */
	@RequestMapping("/list")
	public String list(Page<Factory> page, Model model, HttpServletRequest request) throws Exception {
		page = factoryService.findPage("from Factory", page, Factory.class, null);
		// 设置分页的URL
		String path = request.getContextPath();
		page.setUrl(path+"/factory/list.action");

		model.addAttribute("page", page);
		return "baseinfo/factory/jFactoryList";
	}

	/**
	 * 查看
	 */
	@RequestMapping("/toview")
	public String toview(Factory factory, Model model) {
		// 1.调用业务方法，根据id,得到对象
		factory = factoryService.get(Factory.class, factory.getId());
		if (factory.getCreateBy()!=null){
			User user = userService.get(User.class, factory.getCreateBy());
			model.addAttribute("createName", user.getUserName());
		}
		if (factory.getUpdateBy()!=null){
			User user = userService.get(User.class, factory.getUpdateBy());
			model.addAttribute("updateName", user.getUserName());
		}
		// 放入栈顶
		model.addAttribute("factory", factory);
		return "baseinfo/factory/jFactoryView";
	}

	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate() {

		// 跳页面
		return "baseinfo/factory/jFactoryCreate";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/insert")
	public String insert(Factory factory, HttpSession session) {
		User user = (User) session.getAttribute(SysConstant.CURRENT_USER_INFO);
		factory.setCreateBy(user.getId());
		factory.setCreateDept(user.getDept().getId());
		// 调用业务方法，实现保存
		factoryService.saveOrUpdate(factory);
		// 跳页面
		return "forward:list.action";
	}

	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(Factory factory, Model model) {
		// 根据id，得到一个对象
		Factory obj = factoryService.get(Factory.class, factory.getId());
		// 将对象放入值栈中
		model.addAttribute("factory", obj);
		// 跳页面
		return "baseinfo/factory/jFactoryUpdate";
	}

	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(Factory factory, HttpSession session) {
		// 根据id，得到一个数据库中保存的对象
		Factory obj = factoryService.get(Factory.class, factory.getId());
		// 设置修改的属性
		obj.setCtype(factory.getCtype());
		obj.setFactoryName(factory.getFactoryName());
		obj.setFullName(factory.getFullName());
		obj.setContacts(factory.getContacts());
		obj.setPhone(factory.getPhone());
		obj.setMobile(factory.getMobile());
		obj.setFax(factory.getFax());
		obj.setAddress(factory.getAddress());
		obj.setInspector(factory.getInspector());
		obj.setOrderNo(factory.getOrderNo());
		obj.setState(factory.getState());
		obj.setRemark(factory.getRemark());

		User user = (User) session.getAttribute(SysConstant.CURRENT_USER_INFO);
		obj.setUpdateBy(user.getId());
		obj.setUpdateTime(new Date());
		factoryService.saveOrUpdate(obj);
		return "forward:list.action";
	}

	/**
	 * 删除
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete")
	public String delete(Factory factory) throws Exception {
		String[] ids = factory.getId().split(",");
		factoryService.delete(Factory.class, ids);
		return "forward:list.action";
	}
	

}
