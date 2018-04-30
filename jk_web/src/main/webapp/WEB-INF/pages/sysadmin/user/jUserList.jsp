<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../baselist.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
	<script type="text/javascript" src="${ctx }/js/jquery-1.4.4.js"></script>
	<script>
	     function isOnlyChecked(){
	    	 var checkBoxArray = document.getElementsByName('id');
				var count=0;
				for(var index=0; index<checkBoxArray.length; index++) {
					if (checkBoxArray[index].checked) {
						count++;
					}	
				} 
			//jquery
			//var count = $("[input name='id']:checked").size();
			if(count==1)
				return true;
			else
				return false;
	     }
	     function toView(){
	    	 if(isOnlyChecked()){
	    		 formSubmit('${ctx }/user/toview','_self');
	    	 }else{
	    		 alert("请先选择一项并且只能选择一项，再进行操作！");
	    	 }
	     }
	     //实现更新
	     function toUpdate(){
	    	 if(isOnlyChecked()){
	    		 formSubmit('${ctx }/user/toupdate','_self');
	    	 }else{
	    		 alert("请先选择一项并且只能选择一项，再进行操作！");
	    	 }
	     }
	</script>
</head>

<body>
<form name="icform" method="post">
<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<!-- <ul>
<li id="view"><a href="javascript:toView()">查看</a></li>
<li id="new"><a href="#" onclick="formSubmit('userAction_tocreate','_self');this.blur();">新增</a></li>
<li id="update"><a href="#" onclick="javascript:toUpdate()">修改</a></li>
<li id="update"><a href="#" onclick="formSubmit('userAction_torole','_self');this.blur();">角色</a></li>
<li id="delete"><a href="#" onclick="formSubmit('userAction_delete','_self');this.blur();">删除</a></li>
</ul> -->
<!-- <span id="topmenu" onclick="toModule('home');">系统首页</span><span id="tm_separator"></span> -->
	<ul>
		<shiro:hasPermission name="用户管理_查看">
			<li id="view"><a href="javascript:toView()">查看</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="用户管理_新增">
			<li id="new"><a href="#" onclick="formSubmit('${ctx }/user/tocreate','_self');this.blur();">新增</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="用户管理_修改">
			<li id="update"><a href="#" onclick="javascript:toUpdate()">修改</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="用户管理_角色">
			<li id="update"><a href="#" onclick="formSubmit('${ctx }/user/torole','_self');this.blur();">角色</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="用户管理_删除">
			<li id="delete"><a href="#" onclick="formSubmit('${ctx }/user/delete','_self');this.blur();">删除</a></li>
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
     用户列表
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
		<td class="tableHeader">用户名</td>
		<td class="tableHeader">状态</td>
	</tr>
	</thead>
	<tbody class="tableBody" >
${page.links}
	
	<c:forEach items="${page.results}" var="o" varStatus="status">
	<tr align="left" class="odd" onmouseover="this.className='highlight'" onmouseout="this.className='odd'">
		<td><input type="checkbox" name="id" value="${o.id}"/></td>
		<td>${status.index+1}</td>
		<td><a href="userAction_toview?id=${o.id}">${o.userName}</a></td>
		<td>${o.state }</td>
	</tr>
	</c:forEach>
	
	</tbody>
</table>
</div>
 
</div>
 
 
</form>
</body>
</html>

