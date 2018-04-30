<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../base.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
</head>

<body>
<form name="icform" method="post">

<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<ul>
<li id="back"><a href="#" onclick="history.go(-1);">返回</a></li>
</ul>
  </div>
</div>
</div>
</div>
   
  <div class="textbox-title">
	<img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
   浏览工厂信息
  </div>
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">工厂id：</td>
	            <td class="tableContent">${factory.id}</td>
	            <td class="columnTitle">厂家类型：</td>
	            <td class="tableContent">${factory.ctype}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">厂家全称：</td>
	            <td class="tableContent">${factory.fullName}</td>
	            <td class="columnTitle">厂家简称：</td>
	            <td class="tableContent">${factory.factoryName}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">联系人：</td>
	            <td class="tableContent">${factory.contacts}</td>
	            <td class="columnTitle">电话：</td>
	            <td class="tableContent">${factory.phone}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">手机：</td>
	            <td class="tableContent">${factory.mobile}</td>
	            <td class="columnTitle">传真：</td>
	            <td class="tableContent">${factory.fax}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">地址：</td>
	            <td class="tableContent">${factory.address}</td>
	            <td class="columnTitle">验货员：</td>
	            <td class="tableContent">${factory.inspector}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">说明：</td>
	            <td class="tableContent">${factory.remark}</td>
	            <td class="columnTitle">排序号：</td>
	            <td class="tableContent">${factory.orderNo}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">创建人：</td>
	            <td class="tableContent">${createName}</td>
	            <td class="columnTitle">创建人id：</td>
	            <td class="tableContent">${factory.createBy}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">创建部门：</td>
	            <td class="tableContent">${factory.createDept}</td>
	            <td class="columnTitle">创建时间：</td>
	            <td class="tableContent">${factory.createTime}</td>
	        </tr>	
	        <tr>
	            <td class="columnTitle">修改人：</td>
	            <td class="tableContent">${updateName}</td>
	            <td class="columnTitle">修改时间：</td>
	            <td class="tableContent">${factory.updateTime}</td>
	        </tr>
	        <tr>
	        	<td class="columnTitle">状态：</td>
	            <td class="tableContent">${factory.state==1?"正常":"停用"}</td>
	        </tr>	
		</table>
	</div>
 
 
</form>
</body>
</html>

