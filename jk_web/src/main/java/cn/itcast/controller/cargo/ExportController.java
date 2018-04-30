package cn.itcast.controller.cargo;

import cn.itcast.common.SysConstant;
import cn.itcast.domain.*;
import cn.itcast.service.ContractService;
import cn.itcast.service.ExportProductService;
import cn.itcast.service.ExportService;
import cn.itcast.util.Page;
import cn.itcast.util.UtilFuns;
import org.apache.cxf.transport.http.HTTPSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashSet;
import java.util.Set;

/**
 * @author LR-PC
 * @version v1.0
 * @since 2018/04/16 20:58
 */
@Controller
@RequestMapping("/export")
public class ExportController {
    @Resource
    private ExportService exportService;
    @Resource
    private ContractService contractService; //因为要有一个购销合同的查询因此需要注入一个合同的service
    @Resource
    private ExportProductService exportProductService;
    /**
     * 点击合同管理的时候调用的方法,返回的是一个page对象
     * @return
     * @throws Exception
     */
    @RequestMapping("/contractList")
    public String contractList(Page<Contract> page, Model model, HttpServletRequest request) throws Exception {
        //购销合同本身应该就有粗粒度权限的控制,所以可以不加细粒度也可以加
        String hql = "from Contract where state = 1";
        contractService.findPage(hql, page, Contract.class, null);
        //给page设置url
        String path = request.getContextPath();
        page.setUrl(path+"/export/contractList.action");
        model.addAttribute("page", page);
        return "cargo/export/jContractList";
    }
    /**
     * 报运单的分页查询
     * @return
     * @throws Exception
     */
    @RequestMapping("/list")
    public String list(Page<Export> page, Model model, HttpSession session, HttpServletRequest request) throws Exception{
        //细粒度控制,根据不同的登录用户的级别来发送不同的hql语句
        User user = (User) session.getAttribute(SysConstant.CURRENT_USER_INFO);
        String hql = "from Export  where 1=1 ";
        Integer degree = user.getUserinfo().getDegree();
        if (4 == degree) {
            hql+="and createBy = '"+user.getId()+"'";
        }else if (3 == degree) {
            hql+="and createDept = '"+user.getDept().getId()+"'";
        }else if (2 == degree) {
            //本部门和子部门修改数据库中的数据,父子关系要明确,数据要有规律,100-100100,100101-100100100,100100101这种数据规律
            hql+="and createDept like '"+user.getDept().getId()+"%'";
        }else if (1 == degree) {
            //副总??思考
        }else if (0 == degree) {
            //总经理就是能查看所有人的因此可以不用写啥条件
        }
//        System.out.println("hql:"+ hql);
        //方法中会动态的改变page
        exportService.findPage(hql, page, Export.class,null);
        //设置分页的url
        String path = request.getContextPath();
        page.setUrl(path+"/export/list.action");
        // page.setUrl("contract/list");
        model.addAttribute("page", page);
        return "cargo/export/jExportList";
    }
    /**
     * 查看某个报运单
     */
    @RequestMapping("/toview")
    public String toview(Export export, Model model) throws Exception{
        export = exportService.get(Export.class, export.getId());
        model.addAttribute("export", export);
        return "cargo/export/jExportView";
    }
    /**
     * 新增报运单的跳转页面
     */
    @RequestMapping("/tocreate")
    public String tocreate(String id, Model model) throws Exception{
    	model.addAttribute("id", id);
        //直接跳转到页面
        return "cargo/export/jExportCreate";
    }
    /**
     * 新增报运单,加入了细粒度权限控制
     * 页面有一个隐藏域hidden目的是为了传递export对象中的购销合同ids,因此要在页面将属性修改一下
     */
    @RequestMapping("/insert")
    public String insert(HttpSession session, Export export) throws Exception{
        //通过session来获取到当前的登录的用户
        User user = (User) session.getAttribute(SysConstant.CURRENT_USER_INFO);
        //获取当前用户的id和部门id分别设置进入新建的报运单中
        export.setCreateBy(user.getId());
        export.setCreateDept(user.getDept().getId());
        //调用service的方法来保存报运单
        exportService.saveOrUpdate(export);
        //增加完了之后应该继续跳转到这个页面
        return "forward:contractList.action";
    }
    /**
     * 修改报运单的跳转页面
     * 使用了DHTML技术来动态的更新页面,因此再往页面写数据的时候也要注意这点
     * addTRRecord("mRecordTable", 'id', 'productNo', 'cnumber', 'grossWeight', 'netWeight', 'sizeLength', 'sizeWidth', 'sizeHeight', 'exPrice', 'tax');
     */
    @RequestMapping("/toupdate")
    public String toupdate(Export export, Model model) throws Exception{
        //获取到当前的对象
        Export obj = exportService.get(Export.class, export.getId());
        model.addAttribute("export", obj);

        //对动态的数据进行设置和编写
        Set<ExportProduct> exportProducts = obj.getExportProducts();
        //遍历这个商品列表,拼接出TRRecord中的数据
        StringBuilder sb = new StringBuilder();
        for (ExportProduct ep : exportProducts) {
            //拼接出数中的数据
            sb.append("addTRRecord(\"mRecordTable\", \"").append(ep.getId());
            sb.append("\", \"").append(ep.getProductNo());
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getCnumber()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getGrossWeight()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getNetWeight()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getSizeLength()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getSizeWidth()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getSizeHeight()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getExPrice()));
            sb.append("\", \"").append(UtilFuns.convertNull(ep.getTax())).append("\");");
        }
        //将拼接好的数据放入值栈中
        model.addAttribute("mRecordData", sb.toString());;
        return "cargo/export/jExportUpdate";
    }
    /**
     * 修改报运单
     * 同时要修改报运单下的商品的信息,对于数字来说应该用数组或者集合封装数据
     */
    @RequestMapping("/update")
    public String update(Export export) throws Exception{
        Export obj = exportService.get(Export.class, export.getId());
        //设置obj
        obj.setInputDate(export.getInputDate());
        obj.setLcno(export.getLcno());
        obj.setConsignee(export.getConsignee());
        obj.setShipmentPort(export.getShipmentPort());
        obj.setDestinationPort(export.getDestinationPort());
        obj.setTransportMode(export.getTransportMode());
        obj.setPriceCondition(export.getPriceCondition());
        obj.setMarks(export.getMarks());	//唛头是具有一定格式的备注信息
        obj.setRemark(export.getRemark());

        //修改完了报运单对象后修改报运单下面的货物的详细信息
        Set<ExportProduct> epSet = new HashSet<>();
        //根据页面的一个mr_id来循环
        for (int i = 0; i < mr_id.length; i++) {
            //遍历商品的id来获取商品对象
            ExportProduct ep = exportProductService.get(ExportProduct.class, mr_id[i]);
            //根据mr_changed的值来判断是否进行了修改
            if ("1".equals(mr_changed[i])) {
                //如果是1,则证明有修改的属性
                ep.setCnumber(mr_cnumber[i]);
                ep.setGrossWeight(mr_grossWeight[i]);
                ep.setNetWeight(mr_netWeight[i]);
                ep.setSizeLength(mr_sizeLength[i]);
                ep.setSizeWidth(mr_sizeWidth[i]);
                ep.setSizeHeight(mr_sizeHeight[i]);
                ep.setExPrice(mr_exPrice[i]);
                ep.setTax(mr_tax[i]);
            }
            epSet.add(ep);
        }
        //修改完了报运单下面的商品之后应该即时对报运单进行修改
        obj.setExportProducts(epSet);
        //调用更新方法!
        exportService.saveOrUpdate(obj);//有级联更新存在因此可以直接保存
        return "forward:list.action";
    }
    private String[] mr_id;
    private String[] mr_changed;//检查当行是否有变化
    private Integer []mr_cnumber;//商品数量
    private Double []mr_grossWeight;//毛重
    private Double []mr_netWeight;//净重
    private Double []mr_sizeLength;//尺寸长
    private Double []mr_sizeWidth;//尺寸宽
    private Double []mr_sizeHeight;//尺寸高
    private Double []mr_exPrice;//出口单价
    private Double []mr_tax;	//收购单价,含税
    public void setMr_id(String[] mr_id) {
        this.mr_id = mr_id;
    }
    public void setMr_changed(String[] mr_changed) {
        this.mr_changed = mr_changed;
    }
    public void setMr_cnumber(Integer[] mr_cnumber) {
        this.mr_cnumber = mr_cnumber;
    }
    public void setMr_grossWeight(Double[] mr_grossWeight) {
        this.mr_grossWeight = mr_grossWeight;
    }
    public void setMr_netWeight(Double[] mr_netWeight) {
        this.mr_netWeight = mr_netWeight;
    }
    public void setMr_sizeLength(Double[] mr_sizeLength) {
        this.mr_sizeLength = mr_sizeLength;
    }
    public void setMr_sizeWidth(Double[] mr_sizeWidth) {
        this.mr_sizeWidth = mr_sizeWidth;
    }
    public void setMr_sizeHeight(Double[] mr_sizeHeight) {
        this.mr_sizeHeight = mr_sizeHeight;
    }
    public void setMr_exPrice(Double[] mr_exPrice) {
        this.mr_exPrice = mr_exPrice;
    }
    public void setMr_tax(Double[] mr_tax) {
        this.mr_tax = mr_tax;
    }
    /**
     * 批量删除报运单,
     */
    @RequestMapping("/delete")
    public String delete(Export export) throws Exception{
        //获得model 中用,拼接起来的id值转换成字符串数组
        String[] ids = export.getId().split(", ");
        //调用方法直接批量删除
        exportService.delete(Export.class, ids);
        return "forward:list.action";
    }

    /**
     * 批量提交
     * @return
     * @throws Exception
     */
    @RequestMapping("/submit")
    public String submit(Export export) throws Exception{
        //获得model 中用,拼接起来的id值转换成字符串数组
        String[] ids = export.getId().split(", ");
        //调用方法直接批量删除
        exportService.changeState(ids,1);
        return "forward:list.action";
    }

    /**
     * 批量取消
     * @return
     * @throws Exception
     */
    @RequestMapping("/cancel")
    public String cancel(Export export) throws Exception{
        //获得model 中用,拼接起来的id值转换成字符串数组
        String[] ids = export.getId().split(", ");
        //调用方法直接批量删除
        exportService.changeState(ids,0);
        return "forward:list.action";
    }

    //注入一个客户端,用来接收远程Webservice的对象调用方法
    // @Resource
    // private EpService epService;

    /**
     * 海关保运的方法!
     * @return
     * @throws Exception
     */
    // public String export() throws Exception{
    //     //获取到当前的报运单
    //     Export export = exportService.get(Export.class, model.getId());
    //     //利用fastjson来处理这个报运单(处理之前先用fastjson去处理domain中的属性)
    //     String jsonString = JSON.toJSONString(export);
    //     System.out.println(jsonString);
    //     //用客户端来调用远程方法,传入json字符串,获取返回结果
    //     String result = epService.exportE(jsonString);
    //     //利用fastjason来解析这个由海关返回回来的json串
    //     Export resultExport = JSON.parseObject(result,Export.class);
    //     //根据传过来的数据来更新报运单然后保存
    //     exportService.updateE(resultExport);
    //     //再次查询出口报运单,跳回页面
    //     return "alist";
    // }
}
