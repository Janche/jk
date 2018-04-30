<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${ctx}/js/jquery-1.4.4.min.js"></script>
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
			if(count==1){
				return true;
			}
			else {
				return false;
			}
	     }
	     
	     function isChecked() {
	    	 var count = $("[input name='id']:checked").size();
	    	 if (count == 0) {
	    		 return false;
	    	 } else {
	    		 return true;
	    	 }
	     }
	     
	     function toView(){
	    	 if(isOnlyChecked()){
	    		 formSubmit("${buttonName}_toview",'_self');
	    	 }else{
	    		 alert("请先选择一项并且只能选择一项，再进行操作！");
	    	 }
	     }
	     //实现更新
	     function toUpdate(){
	    	 if(isOnlyChecked()){
	    		 formSubmit("${buttonName}_toupdate",'_self');
	    	 }else{
	    		 alert("请先选择一项并且只能选择一项，再进行操作！");
	    	 }
	     }
	     //新增请求
	     function toCreate() {
	    	 formSubmit("${buttonName}_tocreate",'_self');
	     }
	     //删除请求
	     function toDelete() {
	    	 if (isChecked()) {
		    	 if (window.confirm("确定要删除?")){
		    		 formSubmit("${buttonName}_delete",'_self');
		    	 }
	    	 } else {
	    		 alert("请至少选择一项");
	    	 }
	     }
	   //角色请求
	     function toRole() {
	    	 if (isOnlyChecked()) {
	    		 formSubmit("${buttonName}_torole",'_self');
	    	 } else {
	    		 alert("请先选择一项并且只能选择一项，再进行操作！");
	    	 }
	     }
	   // 提交请求
	   	function toSubmit() {
		   if (isChecked()) {
			   formSubmit("${buttonName}_submit",'_self');
		   } else {
			   alert("请至少选择一项再操作");
		   }  
	   }
	 	// 取消请求
	   	function toCancel() {
		   if (isChecked()) {
			   formSubmit("${buttonName}_cancel",'_self');
		   } else {
			   alert("请至少选择一项再操作");
		   }  
	   }
	  //打印
	  function toPrint(){
		if (isOnlyChecked()>0) {
			formSubmit('shippingOrderAction_print','_self');
		}else{
			alert("请选择一条数据打印！");
		}
	}
</script>

<%--
<ul>
            <c:set var="aaa" value=""/>
            <!-- 遍历当前登录用户的角色列表 -->
			<c:forEach items="${_CURRENT_USER.roles }" var="role">
			       <!-- 遍历每个角色下的模块 -->
			       <c:forEach items="${role.modules }" var="module">
			            <!-- 如果该模块没有输出过，则要进行输出，否则这个模块就不输出 -->
			            <c:if test="${ (buttonName eq module.remark) and module.ctype==2  }">
			            		
				               <c:if test="${fn:contains(aaa,module.cpermission) eq false }">
				               
				                  <c:set var="aaa" value="${aaa},${module.cpermission }"/>
				                  
			                      		<li id="${module.ico }"><a href="#" onclick="${module.curl }">${module.cpermission }</a></li>
			                      
			                 </c:if>  
			            </c:if>
			            
			       </c:forEach>
			</c:forEach>
</ul>--%>
