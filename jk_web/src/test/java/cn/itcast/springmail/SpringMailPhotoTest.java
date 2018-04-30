package cn.itcast.springmail;

import java.io.File;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

/**
 * @ClassName: SpringSimpleMailTest
 * 
 * @Description: TODO Spring 实现简单的邮件发送测试
 * 
 * @author LR
 * 
 */
public class SpringMailPhotoTest {

	public static void main(String[] args) throws MessagingException {

		// 创建应用程序上下文
		ApplicationContext actx = new ClassPathXmlApplicationContext("mailMessage.xml");

		// Spring 封装MailSender，不再重复造轮子
		JavaMailSender sender = (JavaMailSender) actx.getBean("mailSender");
		MimeMessage message = sender.createMimeMessage();
		// 通过工具类来更好的操作MimeMessage对象
		MimeMessageHelper helper = new MimeMessageHelper(message, true);
		
		// 工具类可设置主题,内容，图片，附件
		helper.setFrom("2235372507@qq.com");
		helper.setSubject("你好");
		helper.setText("<html><head></head><body><h1>hello!!baby</h1>"
				+ "<a href=http://www.itheima.com>黑马程序员</a>"
				+ "<img src=cid:image/></body></html>", true);
		helper.setTo("957671816@qq.com");
		
		// 添加图片
		FileSystemResource resource = new FileSystemResource(new File("C:\\Users\\LR-PC\\Pictures\\a.png"));
		helper.addInline("image", resource);
		// 发送
		sender.send(message);
	}
}
