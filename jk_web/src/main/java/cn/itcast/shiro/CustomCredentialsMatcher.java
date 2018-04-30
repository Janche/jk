package cn.itcast.shiro;

import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authc.credential.SimpleCredentialsMatcher;

import cn.itcast.util.Encrypt;

public class CustomCredentialsMatcher extends SimpleCredentialsMatcher{
	
	@Override
	public boolean doCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) {
		UsernamePasswordToken usertoken = (UsernamePasswordToken) token;
		
		//注意token.getPassword()拿到的是一个char[]，不能直接用toString()，它底层实现不是我们想的直接字符串，只能强转
		Object pwd = Encrypt.md5(String.valueOf(usertoken.getPassword()),usertoken.getUsername());  
		Object dbPwd = getCredentials(info);  

		//将密码加密与系统加密后的密码校验，内容一致就返回true,不一致就返回false  
		return equals(pwd, dbPwd);  
	}
}
