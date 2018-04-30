<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../base.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<title></title>
	<script type="text/javascript" src="../../js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//设置厂家名称隐藏域，这样无需再次查询数据库
		function setFactoryName( val ){
			document.getElementById("factoryName").value = val; 
		}
	</script>
</head>

<body>
<form name="icform" method="post">
	<input type="hidden" name="id" value="${extCproduct.id}"/>
	<input type="hidden" name="contractProduct.contract.id" value="${extCproduct.contractProduct.contract.id}"/>
	<input type="hidden" name="contractProduct.id" value="${extCproduct.contractProduct.id}"/>
	
	<input type="hidden" name="amount" value="${extCproduct.amount }"/>
<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<ul>
<li id="save"><a href="#" onclick="formSubmit('${ctx}/extCproduct/update','_self');this.blur();">保存</a></li>
<li id="back"><a href="#" onclick="history.go(-1);">返回</a></li>
</ul>
  </div>
</div>
</div>
</div>
   
  <div class="textbox-title">
	<img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
   修改附件
  </div> 
  

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">生产厂家：</td>
	            <td class="tableContent">
	            
	             <select name="factory.id">
						<c:forEach items="${factoryList}" var="factory">
							<c:if test="${extCproduct.contractProduct.factory.id == factory.id }">
								<option selected="selected" value="${factory.id}">${factory.factoryName}</option>
							</c:if>
							<c:if test="${extCproduct.contractProduct.factory.id != factory.id }">
								<option value="${factory.id}">${factory.factoryName}</option>
							</c:if>
						</c:forEach>
					</select>
	            	
	            </td>
	            <td class="columnTitle">货号：</td>
	            <td class="tableContentAuto"><input type="text" name="productNo" value="${extCproduct.productNo}"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">货物照片：</td>
	            <td class="tableContent"><input type="text" name="productImage" value="${extCproduct.productImage}"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">数量：</td>
	            <td class="tableContent"><input type="text" name="cnumber" value="${extCproduct.cnumber}"/></td>
	            <td class="columnTitle">包装单位：</td>
	            <td class="tableContentAuto">
	            	<input type="radio" name="packingUnit" value="PCS" <c:if test="${extCproduct.packingUnit=='PCS'}">checked</c:if> class="input">只
	            	<input type="radio" name="packingUnit" value="SETS" <c:if test="${extCproduct.packingUnit=='SETS'}">checked</c:if> class="input">套
	            </td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">单价：</td>
	            <td class="tableContent"><input type="text" name="price" value="${extCproduct.price}"/></td>
	            <td class="columnTitle">排序号：</td>
	            <td class="tableContent"><input type="text" name="orderNo" value="${extCproduct.orderNo}"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">货物描述：</td>
	            <td class="tableContent"><textarea name="productDesc" style="height:150px;">${extCproduct.productDesc}</textarea>
	            <td class="columnTitle">要求：</td>
	            <td class="tableContent"><textarea name="productRequest" style="height:150px;">${extCproduct.productRequest}</textarea>
	        </tr>		
		</table>
	</div>

 
</form>
</body>
</html>

