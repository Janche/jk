package cn.itcast.shiro;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import cn.itcast.service.RoleService;
import org.apache.log4j.Logger;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.domain.DictAndModule;
import cn.itcast.domain.Dictionary;
import cn.itcast.domain.Module;
import cn.itcast.domain.Role;
import cn.itcast.domain.User;
import cn.itcast.service.DictAndModuleService;
import cn.itcast.service.DictService;
import cn.itcast.service.UserService;
public class AuthRealm extends AuthorizingRealm{
	private static Logger log = Logger.getLogger(AuthRealm.class);
	@Autowired
	private UserService userService;
	
	@Autowired
	private DictAndModuleService dictModuleService;
	
	@Autowired
	private DictService dictService;

	//授权  当jsp页面出现shiro的标签时，才会加载授权这个方法
	@Transactional
	protected AuthorizationInfo doGetAuthorizationInfo(
			PrincipalCollection principals) {
		log.info("执行授权...");
		// 根据realm的名字去找对应的realm
		User user = (User) principals.fromRealm(this.getName()).iterator().next();
		List<String> list = new ArrayList<>();
		Set<Role> roles = user.getRoles();
		// System.out.println("roles:-----"+roles.toString());
		// 遍历每个角色
		for (Role role : roles) {
			Set<Module> modules = role.getModules();
			// System.out.println("modules:=========="+modules.toString());
			for (Module module : modules) {
				list.add(module.getName());
				// 把每个模块的操作权限一起赋权限给用户
				List<DictAndModule> rdms = dictModuleService.find("from DictAndModule where roleId = ? and moduleId = ?", DictAndModule.class, new String[]{role.getId(), module.getId()});
				for (DictAndModule rdm : rdms) {
					Dictionary dict = dictService.get(Dictionary.class, rdm.getDictId());
					list.add(module.getName()+"_"+dict.getName());
				}
			}
		}
		System.out.println(list);
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		info.addStringPermissions(list);
		
		return info;
	}

	//认证
	/*
	 * shiro规则，按用户名查找，如果没找到返回null，如果查找到返回密码，shiro自动和调用subject.login()中的密码值进行比较
	 * 密码一致，登录成功；密码不一致，密码错误。
	 */
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken token) throws AuthenticationException {
		log.info("执行认证...");
		// 向下转型
		UsernamePasswordToken uptoken = (UsernamePasswordToken) token;
		// 调用业务方法，实现根据用户名查询
		
		String hql = "from User where userName = ?";
		List<User> list = userService.find(hql, User.class, new String[]{uptoken.getUsername()});
		if (list!=null && list.size()>0) {
			User user = list.get(0);
			SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(user, user.getPassword(), this.getName());
			
			return info; //此处结果返回将立即进入到密码比较器
		}
		
			return null; //登录异常
//		}
	}

}