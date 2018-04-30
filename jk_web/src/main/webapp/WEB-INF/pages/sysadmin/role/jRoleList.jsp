<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../baselist.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
<shiro:hasPermission name="角色管理_查看">
<li id="view"><a href="#" onclick="formSubmit('${ctx}/role/toview','_self');this.blur();">查看</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="角色管理_新增">
<li id="new"><a href="#" onclick="formSubmit('${ctx}/role/tocreate','_self');this.blur();">新增</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="角色管理_修改">
<li id="update"><a href="#" onclick="formSubmit('${ctx}/role/toupdate','_self');this.blur();">修改</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="角色管理_删除">
<li id="delete"><a href="#" onclick="formSubmit('${ctx}/role/delete','_self');this.blur();">删除</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="角色管理_权限">
<li id="new"><a href="#" onclick="formSubmit('${ctx}/role/tomodule','_self');this.blur();" title="分配权限">权限</a></li>
</shiro:hasPermission>
</ul>
  </div>
</div>
</div>
</div>
   
<div class="textbox" id="centerTextbox">
  <div class="textbox-header">
  <div class="textbox-inner-header">
  <div class="textbox-title">
    角色列表
  </div> 
  </div>
  </div>
  
<div>


<div class="eXtremeTable" >
<table id="ec_table" class="tableRegion" width="98%" >
	<thead>
	<tr>
		<td class="tableHeader"><input type="checkbox" name="selid" onclick="checkAll('id',this)"></td>
		<td class="tableHeader">序号</td>
		<td class="tableHeader">编号</td>
		<td class="tableHeader">名称</td>
		<td class="tableHeader">说明</td>
	</tr>
	</thead>
	<tbody class="tableBody" >
	${page.links }
	<c:forEach items="${page.results}" var="o" varStatus="status">
	<tr align="left" class="odd" onmouseover="this.className='highlight'" onmouseout="this.className='odd'" >
		<td><input type="checkbox" name="id" value="${o.id}"/></td>
		<td>${status.index+1}</td>
		<td>${o.id}</td>
		<td><a href="roleAction_toview?id=${o.id}">${o.name}</a></td>
		<td>${o.remark}</td>
	</tr>
	</c:forEach>
	
	</tbody>
</table>
</div>
 
</div>
 
 
</form>
</body>
</html>

