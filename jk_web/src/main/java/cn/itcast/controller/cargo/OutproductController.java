package cn.itcast.controller.cargo;

import cn.itcast.domain.ContractProduct;
import cn.itcast.domain.ExtCproduct;
import cn.itcast.service.ContractProductService;
import cn.itcast.util.DownloadUtil;
import cn.itcast.util.UtilFuns;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.List;

/**
 * 出货表
 *
 * @author LR-PC
 * @create 2018-04-01-17:05
 */
@Controller
@RequestMapping("/outProduct")
public class OutproductController {
    @Autowired
    private ContractProductService contractProductService;

    //转向出货表页面
    @RequestMapping("/toedit")
    public String toedit(){
        return "cargo/outproduct/jOutProduct";
    }


    //打印
    @RequestMapping("/print")
    public void print(String inputDate, HttpServletRequest request, HttpServletResponse response) throws Exception {
        /*
         * 操作步骤：
         * 1、取inputDate月的货物信息
         * 2、循环输出
         * 3、从模板中读取样式，设置单元格的样式
         *
         */
        System.out.println("inputDate:====="+inputDate);
        String path =request.getRealPath("/") + "make/xlsprint/";		//服务器的路径
        System.out.println(inputDate);
        List<ContractProduct> cpList = contractProductService.find("from ContractProduct o where to_char (o.contract.shipTime,'yyyy-MM') like '"+inputDate+"%'", ContractProduct.class, null);


        int rowNo = 2;				//行号
        short colNo = 1;			//列号

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(new File(path + "txOutProduct.xls")));	//打开模板文件
        HSSFSheet sheet = wb.getSheetAt(0);			//得到第一个工作表
        HSSFRow nRow = null;
        HSSFCell nCell = null;


        //从模板中获取的样式
        nRow = sheet.getRow(2);				//获得一个行对象

        nCell = nRow.getCell((short)1);	//获得一个单元格对象
        HSSFCellStyle customNameStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)2);	//获得一个单元格对象
        HSSFCellStyle contractNoStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)3);	//获得一个单元格对象
        HSSFCellStyle productNoStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)4);	//获得一个单元格对象
        HSSFCellStyle cnumberStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)5);	//获得一个单元格对象
        HSSFCellStyle factoryStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)6);	//获得一个单元格对象
        HSSFCellStyle extStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)7);	//获得一个单元格对象
        HSSFCellStyle deliveryStyle = nCell.getCellStyle();		//获得指定单元格的样式

        nCell = nRow.getCell((short)9);	//获得一个单元格对象
        HSSFCellStyle tradeStyle = nCell.getCellStyle();		//获得指定单元格的样式

        //设置标题
        nRow = sheet.getRow(0);
        nCell = nRow.getCell((short)1);
        nCell.setCellValue(inputDate.replaceFirst("-0", "-").replaceFirst("-", "年") + "月份出货表");		//2011-12,2011-09

        String _extName = "";

        for(ContractProduct cp : cpList){
            colNo = 1;					//初始化

            nRow = sheet.createRow(rowNo++);
            nRow.setHeightInPoints(24);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(cp.getContract().getCustomName());
            nCell.setCellStyle(customNameStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(cp.getContract().getContractNo());
            nCell.setCellStyle(contractNoStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(cp.getProductNo());
            nCell.setCellStyle(productNoStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(cp.getCnumber()+cp.getPackingUnit());
            nCell.setCellStyle(cnumberStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(cp.getFactory().getFactoryName());
            nCell.setCellStyle(factoryStyle);

            nCell = nRow.createCell(colNo++);
            _extName = "";
            for(ExtCproduct ep : cp.getExtCproducts()){
                _extName += ep.getPackingUnit() + "\n";
            }
            _extName = UtilFuns.delLastChar(_extName);
            if(_extName.equals("")){
                _extName = "无";
            }
            nCell.setCellValue(_extName);				//附件
            nCell.setCellStyle(extStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(UtilFuns.dateTimeFormat(cp.getContract().getDeliveryPeriod())); 	//将日期转换为字符串，格式为：YYYY-MM-DD
            nCell.setCellStyle(deliveryStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(UtilFuns.dateTimeFormat(cp.getContract().getShipTime()));
            nCell.setCellStyle(deliveryStyle);

            nCell = nRow.createCell(colNo++);
            nCell.setCellValue(cp.getContract().getTradeTerms());
            nCell.setCellStyle(tradeStyle);
        }


        //7.生成excel文件
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();			//生成流对象
        wb.write(byteArrayOutputStream);								//将excel写入流

        //工具类，封装弹出下载框：
        String outFile = "出货表.xls";
        DownloadUtil down = new DownloadUtil();
        down.download(byteArrayOutputStream, response, outFile);
    }
}
