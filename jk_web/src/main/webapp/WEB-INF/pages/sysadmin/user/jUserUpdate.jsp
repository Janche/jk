<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../base.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
</head>

<body>
<form name="icform" method="post">
      <input type="hidden" name="id" value="${user.id}"/>
<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<ul>
<li id="save"><a href="#" onclick="formSubmit('${ctx }/user/update','_self');this.blur();">保存</a></li>
<li id="back"><a href="#" onclick="history.go(-1);">返回</a></li>
</ul>
  </div>
</div>
</div>
</div>
   
  <div class="textbox-title">
	<img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
   查看用户
  </div> 
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">所在部门：</td>
	             <td class="tableContent">
	             	<select name="dept.id">
	            		<c:forEach items="${deptList}" var="dept">
	            			<c:if test="${dept.id == user.dept.id }">
	            				<option selected="selected" value="${dept.id}">${dept.deptName}</option>
	            			</c:if>
	            			<c:if test="${dept.id != user.dept.id }">
	            				<option value="${dept.id}">${dept.deptName}</option>
	            			</c:if>
	            		</c:forEach>
	            	</select>
	            	
	            </td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">用户名：</td>
	            <td class="tableContent"><input type="text" name="userName" value="${user.userName }"/></td>
	        </tr>	
	         <tr>
	            <td class="columnTitle">状态：</td>
	            <td class="tableContentAuto">
	              <input type="radio" name="state" class="input" ${user.state==0?'checked':'' } value="0">停用 
	              <input type="radio" name="state" class="input"  ${user.state==1?'checked':'' } value="1">启用 
	            </td>
	        </tr>		
		</table>
	</div>
 </form>
</body>
</html>