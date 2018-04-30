<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../baselist.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
	<script type="text/javascript" src="${ctx }/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//动态设置生产厂家的名称 
		function setFactoryName(val){
			document.getElementById("factoryName").value = val;
		}
	</script>
</head>

<body>
<form name="icform" method="post">
	<input type="hidden" name="id" value="${contractProduct.id}"/>
	<input type="hidden" name="contract.id" value="${contractProduct.contract.id}"/>

<div id="menubar">
<div id="middleMenubar">
<div id="innerMenubar">
  <div id="navMenubar">
<ul>
<li id="save"><a href="#" onclick="formSubmit('${ctx}/contractProduct/update','_self');this.blur();">保存</a></li>
<li id="back"><a href="#" onclick="history.go(-1);">返回</a></li>
</ul>
  </div>
</div>
</div>
</div>
   
  <div class="textbox-title">
	<img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
   修改货物
  </div> 

 
    <div>
		<table class="commonTable" cellspacing="1">
	        <tr>
	            <td class="columnTitle">生产厂家：</td>
	            <td class="tableContent">
	            <select name="factory.id">
						<c:forEach items="${factoryList}" var="factory">
							<c:if test="${contractProduct.factory.id == factory.id }">
								<option selected="selected" value="${factory.id}">${factory.factoryName}</option>
							</c:if>
							<c:if test="${contractProduct.factory.id != factory.id }">
								<option value="${factory.id}">${factory.factoryName}</option>
							</c:if>
						</c:forEach>
					</select> 
	            
	            	<input type="hidden" id="factoryName" name="factoryName" value="${contractProduct.factoryName }"/>
	            </td>
	            <td class="columnTitle">货号：</td>
	            <td class="tableContentAuto"><input type="text" name="productNo" value="${contractProduct.productNo }"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">货物照片：</td>
	            <td class="tableContent"><input type="text" name="productImage" value="${contractProduct.productImage }"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">数量：</td>
	            <td class="tableContent"><input type="text" name="cnumber" value="${contractProduct.cnumber }"/>  
	                <input type="hidden" name="amount" value="${contractProduct.amount }"/>
	            </td>
	            <td class="columnTitle">包装单位：</td>
	            <td class="tableContentAuto">
	            	<input type="radio" name="packingUnit" value="PCS" ${contractProduct.packingUnit=='PCS'?"checked":"" } class="input">只
	            	<input type="radio" name="packingUnit" value="SETS" ${contractProduct.packingUnit=='SETS'?"checked":"" } class="input">套
	            </td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">装率：</td>
	            <td class="tableContent"><input type="text" name="loadingRate" value="${contractProduct.loadingRate }"/></td>
	            <td class="columnTitle">箱数：</td>
	            <td class="tableContent"><input type="text" name="boxNum" value="${contractProduct.boxNum }"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">单价：</td>
	            <td class="tableContent"><input type="text" name="price" value="${contractProduct.price }"/></td>
	            <td class="columnTitle">排序号：</td>
	            <td class="tableContent"><input type="text" name="orderNo" value="${contractProduct.orderNo }"/></td>
	        </tr>		
	        <tr>
	            <td class="columnTitle">货物描述：</td>
	            <td class="tableContent"><textarea name="productDesc" style="height:150px;">${contractProduct.productDesc }</textarea>
	            <td class="columnTitle">要求：</td>
	            <td class="tableContent"><textarea name="productRequest" style="height:150px;">${contractProduct.productRequest }</textarea>
	        </tr>		
		</table>
	</div>

</form>
</body>
</html>

