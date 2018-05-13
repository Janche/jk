package cn.itcast.controller.stat;

import cn.itcast.dao.springdao.SqlDao;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author LR-PC
 * @version v1.0
 * @since 2018/05/12 15:13
 */
@Controller
@RequestMapping("/statChart")
public class StatChartController {

    @Resource
    private SqlDao sqlDao;// 注入sqlDao

    /**
     * 统计登录次数最多的10个人的图表
     * @return
     * @throws Exception
     */
    @RequestMapping("/loginCount")
    public String loginList(Model model) throws Exception {
        //发送查询语句获取到结果List
        String sql = "select * from (select login_name,count(*) lcount from login_log_p group by login_name order by lcount desc) where rownum <=10";
        List<String> dataList = sqlDao.executeSQL(sql);
        //通过list拼接出相对应格式的字符串当做xml文件里面的内容
        StringBuilder sb = new StringBuilder();

        String[] colors = { "#FF0F00", "#FF6600", "#FF9E01", "#FCD202", "#F8FF01", "#B0DE09", "#04D215", "#0D8ECF",
                "#0D52D1", "#2A0CD0", "#8A0CCF", "#CD0D74" };
        // 拼接json
        sb.append("[");
        int j = 0;
        for (int i = 0; i < dataList.size(); i++) {
            sb.append("{").append("\"loginName\":\"").append(dataList.get(i)).append("\"").append(",");
            sb.append("\"count\":").append(dataList.get(++i)).append("").append(",");
            sb.append("\"color\":\"").append(colors[j++]).append("\"").append("}").append(",");

            if (j >= colors.length) {
                j = 0;
            }

        }

        sb.delete(sb.length() - 1, sb.length());

        sb.append("]");
        model.addAttribute("loginlist", sb.toString());

        return "stat/chart/logincount";
    }

    /**
     * 厂家销量排序
     *
     * @return
     */
    @RequestMapping("/factorySale")
    public String factorysale(Model model) {
        String sql = "select factory_name,count(amount) c from contract_product_c group by factory_name order by c desc";
        List<String> list = sqlDao.executeSQL(sql);
        //手动拼接json字符串
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for(int i=0;i<list.size();i++){
            sb.append("{").append("\"factory\":\"").append(list.get(i)).append("\",")
                    .append("\"amount\":\"").append(list.get((++i))).append("\"")
                    .append("}").append(",");
        }
        sb.delete(sb.length()-1, sb.length());
        sb.append("]");
        System.out.println(sb.toString());
        model.addAttribute("result", sb.toString());
        return "stat/chart/pieSimple";
    }

    /**
     * 产品销量排行
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/productSale")
    public String productsale(Model model) throws Exception {
        //发送查询语句获取到结果List
        String sql = "select * from (select product_no,sum(amount) c from contract_product_c  group by product_no order by c desc) b where rownum <16";
        List<String> list = sqlDao.executeSQL(sql);

        //根据对应的list集合的结果来写回一个json字符串来展示对应的页面,手动拼接json
        StringBuilder sb= new StringBuilder();
        //颜色弄成一个字符串数组
        String[] colors={"#FF0F00","#FF6600","#FF9E01","#FCD202","#F8FF01","#B0DE09","#04D215","#0D52D1","#2A0CD0","#8A0CCF","#CD0D74","#754DEB"};
        int j=0;
        sb.append("[");
        //拼接
        for(int i=0;i<list.size();i++){
            sb.append("{").append("\"factory\":\"").append(list.get(i)).append("\",")
                    .append("\"amount\":\"").append(list.get((++i))).append("\",")
                    .append("\"color\":\"").append(colors[j++]).append("\"")
                    .append("}").append(",");
            if(j>=colors.length){
                j=0;
            }
        }
        sb.delete(sb.length()-1, sb.length());
        sb.append("]");

        //将json压栈
        model.addAttribute("result", sb.toString());
        //返回结果页面
        return "stat/chart/column3D";
    }

    /**
     *  产品按市场价的排名
     */
    @RequestMapping("/productPrice")
    public String productprice(Model model) throws Exception {
        //发送查询语句获取到结果List
        String sql = "select * from (select PRODUCT_NO,PRICE from CONTRACT_PRODUCT_C order by PRICE desc) p where rownum < 10 ";
        List<String> list = sqlDao.executeSQL(sql);

        //根据对应的list集合的结果来写回一个json字符串来展示对应的页面,手动拼接json
        StringBuilder sb= new StringBuilder();
        //颜色弄成一个字符串数组
        String[] colors={"#FF0F00","#FF6600","#FF9E01","#FCD202","#F8FF01","#B0DE09","#04D215","#0D52D1","#2A0CD0","#8A0CCF","#CD0D74","#754DEB"};
        int j=0;
        sb.append("[");
        //拼接
        for(int i=0;i<list.size();i++){
            System.err.println(list.get(i));
            sb.append("{").append("\"productno\":\"").append(list.get(i)).append("\",")
                    .append("\"price\":\"").append(list.get((++i))).append("\",")
                    .append("\"color\":\"").append(colors[j++]).append("\"")
                    .append("}").append(",");
            if(j>=colors.length){
                j=0;
            }
        }
        sb.delete(sb.length()-1, sb.length());
        sb.append("]");

        //将拼接好的字符串放到值栈中
        model.addAttribute("result", sb.toString());
        System.out.println("result: "+sb.toString());

        return "stat/chart/productCol";
    }

}
