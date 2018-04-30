package cn.itcast.controller.sysadmin;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.domain.Dept;
import cn.itcast.domain.Role;
import cn.itcast.domain.User;
import cn.itcast.service.DeptService;
import cn.itcast.service.RoleService;
import cn.itcast.service.UserService;
import cn.itcast.util.Page;

/**
 * 部门管理的Action
 * 
 * @author LR-PC
 */
@Controller
@RequestMapping("/user")
public class UserController {

	@Resource
	private UserService userService;

	@Resource
	private DeptService deptService;

	@Resource
	private RoleService roleService;
	
	/**
	 * 分页查询
	 */
	@RequestMapping("/list")
	public String list(Page<User> page, Model model, HttpServletRequest request) throws Exception {
		// 此处的page = 可以写出来，也可不写，因为修改的引用 类型的
		page = userService.findPage("from User", page, User.class, null);
		// 设置分页的URL
		String path = request.getContextPath();
		page.setUrl(path+"/user/list.action");
		// 将page对象压入栈顶
		model.addAttribute("page", page);
		return "sysadmin/user/jUserList";
	}

	/**
	 * 查看
	 */
	@RequestMapping("/toview")
	public String toview(User user, Model model) {
		// 1.调用业务方法，根据id,得到对象
		user = userService.get(User.class, user.getId());
		// 放入栈顶
		model.addAttribute("user", user);
		return "sysadmin/user/jUserView";
	}

	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate(Model model) {
		// 调用业务方法
		List<Dept> deptList = deptService.find("from Dept where state=1", Dept.class, null);
		List<User> userList = userService.find("from User where state=1", User.class, null);
		// 将查询结果放入值栈中 单个对象用push，集合用下面这个
		model.addAttribute("userList", userList);
		model.addAttribute("deptList", deptList);
		// 跳页面
		return "sysadmin/user/jUserCreate";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/insert")
	public String insert(User user) {
		System.out.println(user);
		// 调用业务方法，实现保存
		userService.saveOrUpdate(user);
		// 跳页面
		return "forward:list.action";
	}

	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(User user, Model model) {
		// 根据id，得到一个对象
		User obj = userService.get(User.class, user.getId());
		// 将对象放入值栈中
		model.addAttribute("user", obj);
		// 查询父部门
		List<Dept> deptList = deptService.find("from Dept where state=1", Dept.class, null);
		model.addAttribute("deptList", deptList);
		// 跳页面
		return "sysadmin/user/jUserUpdate";
	}

	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(User user) {
		// 根据id，得到一个数据库中保存的对象
		User obj = userService.get(User.class, user.getId());
		// 设置修改的属性
		obj.setDept(user.getDept());
		obj.setUserName(user.getUserName());
		obj.setState(user.getState());
		userService.saveOrUpdate(obj);
		// 跳页面
		return "forward:list.action";
	}

	/**
	 * 删除 user id:String类型 具有同名框的一组值如何封装数据 如果服务器端是String类型： Struts2默认采用 , 分割
	 * id:Integer类型：100 200 300 将会导致数据丢失，Struts2默认只保存最后一个 Integer[]id;
	 * {100,200,300}服务器端用数组来接受没有问题
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete")
	public String delete(User user) throws Exception {
		String[] ids = user.getId().split(",");
		userService.delete(User.class, ids);
		return "forward:list.action";
	}

	/**
	 * 为用户添加角色
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/torole")
	public String torole(User user, Model model) throws Exception {
		// 查询用户
		User obj = userService.get(User.class, user.getId());
		model.addAttribute("user", obj);
		// 获取所有角色列表
		List<Role> roleList = roleService.find("from Role", Role.class, null);
		model.addAttribute("roleList", roleList);
		// 获取用户所拥有的角色
		Set<Role> roles = obj.getRoles();
		StringBuffer sb = new StringBuffer();
		for (Role role : roles) {
			sb.append(role.getName()).append(",");
		}
		model.addAttribute("roleStr", sb);
		return "sysadmin/user/jUserRole";
	}
	
	/**
	 * 保存用户的角色
	 * @param user
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/role")
	public String role(User user, Model model, String[] roleIds) throws Exception {
		// 获取用户
		user = userService.get(User.class, user.getId());
		// 获取选中的角色
		Set<Role> roles = new HashSet<>();
		for (String roleId : roleIds) {
			Role role = roleService.get(Role.class, roleId);
			roles.add(role);
		}
		user.setRoles(roles);
		// 保存用户
		userService.saveOrUpdate(user);
		return "forward:list.action";
	}
}
