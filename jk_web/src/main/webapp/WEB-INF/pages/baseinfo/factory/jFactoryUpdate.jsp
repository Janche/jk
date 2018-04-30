<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../base.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
</head>
<script type="text/javascript" src="${ctx }/js/jquery-1.11.0.min.js" ></script>
	<%--<script type="text/javascript" src="${ctx }/js/validate/jquery.validate.js" ></script>
	<script type="text/javascript" src="${ctx }/js/validate/messages_zh.js" ></script>--%>
	<script>
		$(function(){
			$("#formid").validate({
				rules:{
					fullName:"required",
					phone:"digits",
					mobile:"digits",
					orderNo:"digits"
				},
				messages:{
					fullName:"工厂名不能为空",
					phone:"电话只能是数字",
					mobile:"电话只能是数字",
					orderNo:"排序号只能是数字"
					
				}
			});
		})
	</script>
<body>
<form name="icform" id="formid" method="post" action="update.action" target="_self">
	<input type="hidden" name="id" value="${factory.id}"/>

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
	<img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
   修改厂家信息
  </div> 
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">厂家类型：</td>
	            <td class="tableContentAuto">
	            	<input type="radio" name="ctype" value="货物" ${factory.ctype=="货物"?"checked":"" }>货物
					<input type="radio" name="ctype" value="附件" ${factory.ctype=="附件"?"checked":"" }>附件
				</td>
	            <td class="columnTitle">厂家全称：</td>
	            <td class="tableContent"><input type="text" name="fullName" value="${factory.fullName}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">厂家简称：</td>
	            <td class="tableContent"><input type="text" name="factoryName" value="${factory.factoryName}"/></td>
	            <td class="columnTitle">联系人：</td>
	            <td class="tableContent"><input type="text" name="contacts" value="${factory.contacts}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">电话：</td>
	            <td class="tableContent"><input type="text" name="phone" value="${factory.phone}"/></td>
	            <td class="columnTitle">手机：</td>
	            <td class="tableContent"><input type="text" name="mobile" value="${factory.mobile}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">传真：</td>
	            <td class="tableContent"><input type="text" name="fax" value="${factory.fax}"/></td>
	            <td class="columnTitle">地址：</td>
	            <td class="tableContent"><input type="text" name="address" value="${factory.address}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">验货员：</td>
	            <td class="tableContent"><input type="text" name="inspector" value="${factory.inspector}"/></td>
	            <td class="columnTitle">说明：</td>
	            <td class="tableContent"><input type="text" name="remark" value="${factory.remark}"/></td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">排序号：</td>
	            <td class="tableContent"><input type="text" name="orderNo" value="${factory.orderNo}"/></td>
	            <td class="columnTitle">状态：</td>
	            <td class="tableContentAuto">
	            	<input type="radio" name="state" value="1" ${factory.state==1?"checked":"" }>启用
					<input type="radio" name="state" value="2" ${factory.state==2?"checked":"" }>停用
				</td>
	        </tr>	
		</table>
	</div>
 
 
</form>
</body>
</html>

