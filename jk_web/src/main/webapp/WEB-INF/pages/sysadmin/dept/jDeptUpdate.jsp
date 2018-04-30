<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../base.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
</head>

<body>
<form name="icform" method="post">
      <input type="hidden" name="id" value="${dept.id}"/>
      
<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<ul>
<li id="save"><a href="#" onclick="formSubmit('${ctx}/dept/update','_self');this.blur();">保存</a></li>
<li id="back"><a href="#" onclick="history.go(-1);">返回</a></li>
</ul>
  </div>
</div>
</div>
</div>
   
  <div class="textbox-title">
	<img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
   修改部门
  </div> 
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">上级部门：</td>
	            <td class="tableContent">
	            	<!-- Struts标签默认具有自动回显功能 
	            		原理：它默认会取值栈的栈顶的值
	            		-->
	            	<select name="parent.id">
						<c:forEach items="${deptList}" var="dept1">
							<c:if test="${dept.parent.id == dept1.id }">
								<option selected="selected" value="${dept1.id}">${dept1.deptName}</option>
							</c:if>
							<c:if test="${dept.parent.id != dept1.id }">
								<option value="${dept1.id}">${dept1.deptName}</option>
							</c:if>
						</c:forEach>
					</select> 
					<!-- <s:select name="parent.id" list="deptList"
	            		listKey="id" listValue="deptName"
	            		headerKey="" headerValue="--请选择--"
	            	></s:select> -->
	            </td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">部门名称：</td>
	            <td class="tableContent"><input type="text" name="deptName" value="${dept.deptName }"/>
	            </td>
	        </tr>		
		</table>
	</div>
 </form>
</body>
</html>