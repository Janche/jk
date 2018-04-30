package cn.itcast.springmail;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;

/**
 * @ClassName: SpringSimpleMailTest
 * 
 * @Description: TODO Spring 实现简单的邮件发送测试
 * 
 * @author LR
 * 
 */
public class SpringMailTest {

	public static void main(String[] args) {

		// 创建应用程序上下文
		ApplicationContext actx = new ClassPathXmlApplicationContext("mailMessage.xml");

		// Spring 封装MailSender，不再重复造轮子
		MailSender ms = (MailSender) actx.getBean("mailSender");

		// 简单邮件发送
		SimpleMailMessage smm = (SimpleMailMessage) actx.getBean("mailMessage");

		// 主题,内容
		smm.setSubject("你好");
		smm.setText("这个是一个通过Spring框架来发送邮件的小程序!!!");
		smm.setTo("957671816@qq.com");
		// 发送
		ms.send(smm);
	}
}
