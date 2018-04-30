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
						sizeHeight:"number"
					},
					message:{
						productNo:"编号不能为空",
						price:"价钱只能为数字!",
						sizeLenght:"尺寸只能为数字!",
						sizeWidth:"尺寸只能为数字!",
						sizeHeight:"尺寸只能为数字!"
					}
				});
			});
		</script>
</head>
<body>
<script type="text/javascript">
		//设置厂家名称隐藏域，这样无需再次查询数据库
		function setFactoryName( val ){
			document.getElementById("factoryName").value = val; 
		}
	</script>
<form id="formid" name="icform" method="post" action="${ctx }/baseinfo/productAction_insert" target="_self" enctype="multipart/form-data">
		
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
   新增商品
  </div> 
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">编号：</td>
	            <td class="tableContent"><input type="text" name="productNo" value=""/></td>
	            <td class="columnTitle">照片：</td>
	            <td class="tableContent">
	            	<input type="file" name="upload"/>
	            </td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">描述：</td>
	            <td class="tableContent"><input type="text" name="description" value=""/></td>
	            <td class="columnTitle">厂家名称：</td>
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
	            <td class="tableContent">
	            	<input type="text" id="price" name="price" value=""/>
	            </td>
	            <td class="columnTitle">尺寸长：</td>
	            <td class="tableContent"><input type="text" name="sizeLenght" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">尺寸宽：</td>
	            <td class="tableContent"><input type="text" name="sizeWidth" value=""/></td>
	            <td class="columnTitle">尺寸高：</td>
	            <td class="tableContent"><input type="text" name="sizeHeight" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">颜色：</td>
	            <td class="tableContent">
	            	<input type="text" name="color" value=""/>
	            </td>
	          
	            <td class="columnTitle">NOTE：</td>
	            <td class="tableContent"><input type="text" name="remark" value=""/></td>
	        </tr>	
		</table>
	</div>
 
 <!--   <td class="columnTitle">包装：</td>
	            <td class="tableContent"><input type="text" name="packing" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">PCS/SETS：</td>
	            <td class="tableContent"><input type="text" name="packingUnit" value=""/></td>
	            <td class="columnTitle">集装箱类别20：</td>
	            <td class="tableContent"><input type="text" name="type20" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">集装箱类别40：</td>
	            <td class="tableContent"><input type="text" name="type40" value=""/></td>
	            <td class="columnTitle">集装箱类别40HC：</td>
	            <td class="tableContent"><input type="text" name="type40hc" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">数量：</td>
	            <td class="tableContent"><input type="text" name="qty" value=""/></td>
	            <td class="columnTitle">体积：</td>
	            <td class="tableContent"><input type="text" name="cbm" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">大箱尺寸长：</td>
	            <td class="tableContent"><input type="text" name="mpsizeLenght" value=""/></td>
	            <td class="columnTitle">大箱尺寸宽：</td>
	            <td class="tableContent"><input type="text" name="mpsizeWidth" value=""/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">大箱尺寸高：</td>
	            <td class="tableContent"><input type="text" name="mpsizeHeight" value=""/></td> -->
</form>
</body>
</html>

