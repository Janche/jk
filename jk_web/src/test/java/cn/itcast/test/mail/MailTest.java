package cn.itcast.test.mail;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.junit.Test;

public class MailTest {
		@Test
		public void testSendMail() throws MessagingException{
			
			Properties props=new Properties();
			props.put("mail.smtp.host","smtp.qq.com");
			props.put("mail.smtp.auth","true");
			props.put("mail.smtp.ssl.enable","true");
			Session session=Session.getInstance(props);
			//构造信息体 
			MimeMessage message =new MimeMessage(session);
			 //发件地址 
			Address address = new InternetAddress("2235372507@qq.com"); 
			message.setFrom(address);
			//收件地址 
			Address toAddress = new InternetAddress("957671816@qq.com"); 
			message.setRecipient(MimeMessage.RecipientType.TO, toAddress);
			//主题 
			message.setSubject("Hello world");
			//正文 
			message.setText("Hello world");
			message.saveChanges();
			Transport transport = session.getTransport("smtp"); 
//			transport.connect("smtp.qq.com", "2235372507@qq.com", "201215+*"); //发送
//			transport.sendMessage(message, message.getAllRecipients());
			transport.close();

		}
	
}
