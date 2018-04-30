package cn.itcast.test;


import cn.itcast.domain.Dept;
import cn.itcast.domain.DictAndModule;
import cn.itcast.service.DeptService;
import cn.itcast.service.DictAndModuleService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.List;

//第一种加载Spring容器的方式
@RunWith(SpringJUnit4ClassRunner.class) // 不能是PowerMock等别的class，否则无法识别spring的配置文件
@ContextConfiguration("classpath:bean-base.xml") // 读取spring配置文件
public class TestDao {
	@Resource
	private DeptService deptService;
	@Resource
	private DictAndModuleService dictAndModuleService;
	
    @Test
	public void test01(){
    	/*// 第二种加载Spring容器的方式
    	ApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:bean-base.xml");
		DeptService deptService = (DeptService) ctx.getBean("deptService");*/
		// todo 测试TODO标记
		List<Dept> list = deptService.find("from Dept", Dept.class, null);
		for (Dept dept : list) {
		//lrtodo 这是我即将要做的工作
			System.out.println(dept.getDeptName());
		}
	}


	
	@Test
	public void test02(){
      /*  ApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:bean-base.xml");
        DictAndModuleService dictAndModuleService = (DictAndModuleService) ctx.getBean("dictAndModuleService");*/
		List<DictAndModule> list = dictAndModuleService.find("from DictAndModule where moduleId = ?", DictAndModule.class, new String[]{"302"});
	
		for (DictAndModule d : list) {
			System.out.println(d.getDictId()+"  ---  "+d.getModuleId());
		}
	}
}
