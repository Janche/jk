package cn.itcast.controller.job;

import cn.itcast.domain.Contract;
import cn.itcast.service.ContractService;
import cn.itcast.util.MailUtil;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @author LR-PC
 * @version v1.0
 * @since 2018/05/06 21:40
 */

public class MailJob {

    @Resource
    private ContractService contractService;

    /*.购销合同中交货日期
        DeliveryPeriod字段
		以当前今天的时间为标准，如果有到期的购销合同，今天要交货，可以在早上8:30发出邮件
			邮件内容 ：
				主人您好，今天有您的交期，请您提前做好准备！购销合同号：——————
				如果一天中有多个购销合同的交期到了，分时间段发送邮件（Thread.sleep(3000)）;
	*/
    public void send () throws Exception{
        //获取当前时间
        String currentTime = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        //查询交期是当前日期的合同对象集合
        List<Contract> list = contractService.find("from Contract where to_char(deliveryPeriod,'yyyy-MM-dd') = ?", Contract.class, new String[]{currentTime});
        //判断集合
        if (list != null && list.size() > 0 ) {
            //如果集合里面有值,说明今天有到期的合同
            //遍历集合
            for (final Contract contract : list) {
                //线程睡30秒
                Thread.sleep(3000);
                //新开启一个线程
                Thread thread = new Thread(new Runnable() {

                    @Override
                    public void run() {
                        try {
                            MailUtil.sendMail("957671816@qq.com", "提醒,交期到了", "主人您好，您有一个购销合同的交货日期于"+new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(contract.getDeliveryPeriod())+"到期");
                        } catch (Exception e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                    }
                });
                //开启线程
                thread.start();
            }
        }else{
            System.out.println("您没有合同到期");
        }
    }
}
