package cn.itcast.service.impl;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.MessagingException;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.common.SysConstant;
import cn.itcast.dao.BaseDao;
import cn.itcast.domain.User;
import cn.itcast.service.UserService;
import cn.itcast.util.Encrypt;
import cn.itcast.util.MailUtil;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;
@Service
@Transactional
public class UserServiceImpl implements UserService {
	@Resource
	private BaseDao baseDao;

	@Override
	public List<User> find(String hql, Class<User> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.find(hql, entityClass, params);
	}

	@Override
	public User get(Class<User> entityClass, Serializable id) {
		// TODO Auto-generated method stub
		return baseDao.get(entityClass, id);
	}

	@Override
	public Page<User> findPage(String hql, Page<User> page, Class<User> entityClass, Object[] params) {
		// TODO Auto-generated method stub
		return baseDao.findPage(hql, page, entityClass, params);
	}

	@Override
	public void saveOrUpdate (User entity) {
		// 新增
		if (UtilFuns.isEmpty(entity.getId())) {
			String id = UUID.randomUUID().toString();
			entity.setId(id);
			entity.getUserinfo().setId(id);
			// 补充shiro添加后的bug
			entity.setPassword(Encrypt.md5(SysConstant.DEFAULT_PASS, entity.getUserName()));
			
			baseDao.saveOrUpdate(entity);  // 记录保存
			
			// 在开启一个新的线程完成邮件发送功能
			Thread th = new Thread(new Runnable() {
				
				@Override
				public void run() {
					try {
						MailUtil.sendMail(entity.getUserinfo().getEmail(), "新员工入职系统账户通知", "欢迎您加入本公司，您的用户名："+entity.getUserName()+",初始密码："+SysConstant.DEFAULT_PASS);
					} catch (MessagingException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
			});
			
			th.start();
		}else {
			// 修改
			baseDao.saveOrUpdate(entity);
		}
		
	}

	@Override
	public void saveOrUpdateAll(Collection<User> entitys) {
		// TODO Auto-generated method stub
		baseDao.saveOrUpdateAll(entitys);
	}

	@Override
	public void deleteById(Class<User> entityClass, Serializable id) {
		
		baseDao.deleteById(entityClass, id);	// 删除用户信息
	}

	@Override
	public void delete(Class<User> entityClass, Serializable[] ids) {
		for (Serializable id : ids) {
			this.deleteById(User.class, id);
		}
	}


}
