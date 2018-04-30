<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../base.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
	<script type="text/javascript" src="${ctx}/js/validate/jquery-1.11.0.js" ></script>
		<!--validate校验库-->
		<script type="text/javascript" src="${ctx}/js/validate/jquery.validate.js" ></script>
		<!--国际化库，中文提示-->
		<script type="text/javascript" src="${ctx}/js/validate/messages_zh.js" ></script>
		<script type="text/javascript">
			 $(function(){
				 $("#formid").validate({
					rules:{
						productNo:"required",
						price:"number",
						sizeLenght:"number",
						sizeWidth:"number",
						sizeHeight:"number",
						type20:"number",
						type40:"number",
						type40hc:"number",
						qty:"number",
						mpsizeLenght:"number",
						qty:"number",
						cbm:"number",
						mpsizeLenght:"number",
						mpsizeWidth:"number",
						mpsizeHeight:"number",
					},
					message:{
						productNo:"编号不能为空",
						price:"价钱只能为数字!",
						sizeLenght:"尺寸只能为数字!",
						sizeWidth:"尺寸只能为数字!",
						sizeHeight:"尺寸只能为数字!",
						type20:"只能为数字!",
						type40:"只能为数字!",
						type40hc:"只能为数字!",
						qty:"只能为数字!",
						cbm:"只能为数字!",
						mpsizeLenght:"只能为数字!",
						mpsizeWidth:"只能为数字!",
						mpsizeHeight:"只能为数字!",
					}
				}); 
			});
		</script>
</head>
<script type="text/javascript">
		//设置厂家名称隐藏域，这样无需再次查询数据库
		function setFactoryName( val ){
			document.getElementById("factoryName").value = val; 
		}
	</script>
<body>
<form name="icform" id="formid" action="${ctx}/baseinfo/productAction_update" target="_self" method="post" enctype="multipart/form-data">
	<input type="hidden" name="id" value="${id}"/>
	<!--修改时,放一个隐藏域存放旧图片的路径-->
	<input type="hidden" name="productImage" value="${productImage}"/>

<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<ul>
<li id="save"><a href="#" onclick="javascript:$('#formid').submit()">保存</a></li>
<li id="back"><a href="#" onclick="history.go(-1);">返回</a></li>
</ul>
  </div>
</div>
</div>
</div>
   
  <div class="textbox-title">
	<img src="${ctx}/skin/default/images/icon/currency_yen.png"/>
   修改商品
  </div> 
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">编号：</td>
	            <td class="tableContent"><input type="text" name="productNo" value="${productNo}"/></td>
	            <td class="columnTitle">照片：</td>
	            <td class="tableContent">
	            	<input type="file" name="upload"/>
	            </td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">描述：</td>
	            <td class="tableContent"><input type="text" name="description" value="${description}"/></td>
	            <td class="columnTitle">生产厂商:</td>
	            <td class="tableContent">
	            	<s:select name="factory.id" list="factoryList" 
	            				onchange="setFactoryName(this.options[this.selectedIndex].text);"
	            				listKey="id" listValue="factoryName" 
	            				headerKey="" headerValue="--请选择--"/>
	            	<input type="hidden" id="factoryName" name="factoryName" value=""/>
	         </td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">市场价：</td>
	            <td class="tableContent"><input type="text" name="price" value="${price}"/></td>
	            <td class="columnTitle">尺寸长：</td>
	            <td class="tableContent"><input type="text" name="sizeLenght" value="${sizeLenght}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">尺寸宽：</td>
	            <td class="tableContent"><input type="text" name="sizeWidth" value="${sizeWidth}"/></td>
	            <td class="columnTitle">尺寸宽：</td>
	            <td class="tableContent"><input type="text" name="sizeHeight" value="${sizeHeight}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">颜色：</td>
	            <td class="tableContent"><input type="text" name="color" value="${color}"/></td>
	            <td class="columnTitle">包装：</td>
	            <td class="tableContent"><input type="text" name="packing" value="${packing}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">PCS/SETS：</td>
	            <td class="tableContent"><input type="text" name="packingUnit" value="${packingUnit}"/></td>
	            <td class="columnTitle">集装箱类别20：</td>
	            <td class="tableContent"><input type="text" name="type20" value="${type20}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">集装箱类别40：</td>
	            <td class="tableContent"><input type="text" name="type40" value="${type40}"/></td>
	            <td class="columnTitle">集装箱类别40：</td>
	            <td class="tableContent"><input type="text" name="type40hc" value="${type40hc}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">数量：</td>
	            <td class="tableContent"><input type="text" name="qty" value="${qty}"/></td>
	            <td class="columnTitle">体积：</td>
	            <td class="tableContent"><input type="text" name="cbm" value="${cbm}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">大箱尺寸长：</td>
	            <td class="tableContent"><input type="text" name="mpsizeLenght" value="${mpsizeLenght}"/></td>
	            <td class="columnTitle">大箱尺寸宽：</td>
	            <td class="tableContent"><input type="text" name="mpsizeWidth" value="${mpsizeWidth}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">大箱尺寸高：</td>
	            <td class="tableContent"><input type="text" name="mpsizeHeight" value="${mpsizeHeight}"/></td>
	            <td class="columnTitle">NOTE：</td>
	            <td class="tableContent"><input type="text" name="remark" value="${remark}"/></td>
	        </tr>	
		</table>
	</div>
 
 
</form>
</body>
</html>

