package cn.itcast.controller.sysadmin;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.domain.Dept;
import cn.itcast.service.DeptService;
import cn.itcast.util.Page;
/**
 * 部门管理的Action
 * @author LR-PC
 */
@Controller
@RequestMapping("/dept")
public class DeptController {
	
	// 注入DeptService
	@Resource
	private DeptService deptService;
	
	/**
	 * 分页查询
	 */
	@RequestMapping("/list")
	public String list(Dept dept,Page<Dept> page, Model model, HttpServletRequest request) throws Exception {
		// 此处的page = 可以写出来，也可不写，因为修改的引用 类型的
		page = deptService.findPage("from Dept", page, Dept.class, null);
		//设置分页的URL
		String path = request.getContextPath();
		page.setUrl(path+"/dept/list.action");
		// 将page对象压入model域
		model.addAttribute("page", page);
		return "sysadmin/dept/jDeptList";
	}
	
	/**
	 * 查看
	 */
	@RequestMapping("/toview")
	public String toview(Dept dept, Model model){
		//1.调用业务方法，根据id,得到对象
		dept = deptService.get(Dept.class, dept.getId());
		// 放入model域
		model.addAttribute("dept", dept);
		return "sysadmin/dept/jDeptView";
	}
	
	/**
	 * 新增
	 */
	@RequestMapping("/tocreate")
	public String tocreate(Model model){
		// 调用业务方法
		List<Dept> deptList = deptService.find("from Dept where state=1", Dept.class, null);
		// 将查询结果放入值栈中 单个对象用push，集合用下面这个
		model.addAttribute("deptList", deptList);
		//跳页面
		
		return "sysadmin/dept/jDeptCreate";
	}
	
	/**
	 * 保存
	 * <input type="text" name="deptName" value=""/>
	 */
	@RequestMapping("/insert")
	public String insert(Dept dept){
		//调用业务方法，实现保存
		deptService.saveOrUpdate(dept);
		// 跳页面
		return "forward:list.action";
	}
	
	/**
	 * 进入修改页面
	 */
	@RequestMapping("/toupdate")
	public String toupdate(Dept dept, Model model){
		// 根据id，得到一个对象
		Dept obj = deptService.get(Dept.class, dept.getId());
		// 将对象放入值栈中
		model.addAttribute("dept", obj); 
		// 查询父部门
		List<Dept> deptList = deptService.find("from Dept where state=1", Dept.class, null);
		deptList.remove(obj);
		model.addAttribute("deptList", deptList);
		// 跳页面
		return "sysadmin/dept/jDeptUpdate";
	}
	
	/**
	 * 修改
	 */
	@RequestMapping("/update")
	public String update(Dept dept, Model model){
		// 根据id，得到一个数据库中保存的对象
		Dept obj = deptService.get(Dept.class, dept.getId());
		// 设置修改的属性
		obj.setParent(dept.getParent());
		obj.setDeptName(dept.getDeptName());
		deptService.saveOrUpdate(obj);
		// 跳页面
		return "forward:list.action";
	}
	
	/**
	 * 删除
	 * dept
	 * 	id:String类型
	 * 	具有同名框的一组值如何封装数据
	 * 	如果服务器端是String类型：
	 * 		Struts2默认采用 , 分割
	 * 	id:Integer类型：100  200  300
	 * 		将会导致数据丢失，Struts2默认只保存最后一个
	 * 	Integer[]id;	{100,200,300}服务器端用数组来接受没有问题
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete")
	public String delete(Dept dept) throws Exception {
		String[] ids = dept.getId().split(",");
		System.out.println(ids);
		deptService.delete(Dept.class, ids);
		return "forward:list.action";
	}
}
