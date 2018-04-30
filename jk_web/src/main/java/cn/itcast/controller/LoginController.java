package cn.itcast.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.itcast.common.SysConstant;
import cn.itcast.domain.User;
import cn.itcast.util.UtilFuns;

/**
 * @Description: 登录和退出类
 * @Author:		LR
 */
@Controller
@RequestMapping("/")
public class LoginController {
	
	//SSH传统登录方式
	@RequestMapping("/login")
	public String login(HttpSession session, HttpServletRequest request, String username, String password) throws Exception {
		if (UtilFuns.isEmpty(username)) {
			return "sysadmin/login/login";
		}
		
		try {
			//1.得到subject
			Subject subject = SecurityUtils.getSubject();
			
			//2.调用登录方法
			UsernamePasswordToken token = new UsernamePasswordToken(username, password);
			subject.login(token);  	// 当调用这行代码就会自动跳入到AuthRealm中认证的方法
			
			//3.登陆成功时，就从Shiro中取出用户的登录信息
			User user = (User) subject.getPrincipal();
			
			//4.将用户放入session中
			session.setAttribute(SysConstant.CURRENT_USER_INFO, user);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorInfo", "对不起，你登录的用户名或密码错误！");
			return "sysadmin/login/login";
		}
		
		return "home/fmain";
	}
	
	//退出
	@RequestMapping("/logout")
	public String logout(HttpSession session){
		session.removeAttribute(SysConstant.CURRENT_USER_INFO);		//删除session
		
		return "sysadmin/login/logout";
	}

}

