package cn.itcast.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.common.SysConstant;
import cn.itcast.domain.User;

/**
 * @Description:主页跳转
 * @Author:		LR
 */
@Controller
@RequestMapping("/home")
public class HomeController {
	
	@RequestMapping("/fmain")
	public String fmain(){
		return "home/fmain";
	}
	
	@RequestMapping("/title")
	public String title(HttpSession session, Model model){
		//获取session
		User curUser = (User)session.getAttribute(SysConstant.CURRENT_USER_INFO);
		model.addAttribute(curUser);
		return "home/title";
	}

	@RequestMapping("/tomain")
	public String tomain(String moduleName, Model model){
		model.addAttribute("moduleName", moduleName);
		return moduleName+"/main";
	}
	
	@RequestMapping("/toleft")
	public String toleft(String moduleName, Model model){
		model.addAttribute("moduleName", moduleName);
		return moduleName+"/left";
	}

}
