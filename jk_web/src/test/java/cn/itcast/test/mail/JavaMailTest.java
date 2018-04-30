package cn.itcast.test.mail;

import java.util.Properties;

import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.junit.Test;

public class JavaMailTest {
	
	@Test
	public void testMail() throws Exception{
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.163.com"); //指定邮件的发送服务器地址
		props.put("mail.smtp.auth", "true"); // 服务器是否要验证用户身份信息
//		props.setProperty("mail.transport.protocol", "smtp");
//		props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
//		props.setProperty("mail.smtp.port", "465");
//		props.setProperty("mail.smtp.socketFactory.port", "465");
		
		Session session = Session.getInstance(props);
		session.setDebug(true);
		// 创建一个MimeMessage格式的邮件
		MimeMessage message = new MimeMessage(session);
		// 设置发送者
		InternetAddress fromAddress = new InternetAddress("13989182060@163.com");
		message.setFrom(fromAddress);
		// 设置接收者
		InternetAddress toAddress = new InternetAddress("957671816@qq.com");
		message.setRecipient(RecipientType.TO, toAddress);
		
		// 设置发送邮件主题
		message.setSubject("给你的一封信");
		// 设置发送邮件内容
		message.setText("两点半，老地方见");
		
		// 保存邮件
		message.saveChanges();
		
		// 得到发送邮件的火箭
		Transport transport = session.getTransport("smtp");
		// 火箭连接到服务器
		transport.connect("smtp.163.com","13989182060","lr201215");
/*		transport.connect("smtp.qq.com","2235372507","ylbwqwoiuszeecgg");*/	
	// 发送
		transport.sendMessage(message, message.getAllRecipients());
		// 关闭
		transport.close();
		
	}
}
