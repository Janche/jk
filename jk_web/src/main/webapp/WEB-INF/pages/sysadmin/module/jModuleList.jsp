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
<shiro:hasPermission name="模块管理_查看">
	<li id="view"><a href="#" onclick="formSubmit('${ctx}/module/toview','_self');this.blur();">查看</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="模块管理_新增">
	<li id="new"><a href="#" onclick="formSubmit('${ctx}/module/tocreate','_self');this.blur();">新增</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="模块管理_修改">
	<li id="update"><a href="#" onclick="formSubmit('${ctx}/module/toupdate','_self');this.blur();">修改</a></li>
</shiro:hasPermission>
<shiro:hasPermission name="模块管理_删除">
	<li id="delete"><a href="#" onclick="formSubmit('${ctx}/module/delete','_self');this.blur();">删除</a></li>
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
    模块列表
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
		<td class="tableHeader">模块名</td>
		<td class="tableHeader">层数</td>
		<td class="tableHeader">权限标识</td>
		<td class="tableHeader">链接</td>
		<td class="tableHeader">类型</td>
		<td class="tableHeader">从属</td>
		<td class="tableHeader">状态</td>
	</tr>
	</thead>
	<tbody class="tableBody" >
	${page.links }
	<c:forEach items="${page.results}" var="o" varStatus="status">
	<tr align="left" class="odd" onmouseover="this.className='highlight'" onmouseout="this.className='odd'" >
		<td><input type="checkbox" name="id" value="${o.id}"/></td>
		<td>${status.index+1}</td>
		<td><a href="moduleAction_toview?id=${o.id}">${o.name}</a></td>
		<td>${o.layerNum}</td>
		<td>${o.cpermission}</td>
		<td>${o.curl}</td>
		<td>${o.ctype}</td>
		<td>${o.belong}</td>
		<td>${o.state}</td>
	</tr>
	</c:forEach>
	
	</tbody>
</table>
</div>
 
</div>
 
 
</form>
</body>
</html>

