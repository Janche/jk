<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="../../baselist.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
</head>
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
            formSubmit('toview','_self');
        }else{
            alert("请先选择一项并且只能选择一项，再进行操作！");
        }
    }
    //实现更新
    function toUpdate(){
        if(isOnlyChecked()){
            formSubmit('toupdate','_self');
        }else{
            alert("请先选择一项并且只能选择一项，再进行操作！");
        }
    }
</script>
<body>
<form name="icform" method="post">

    <div id="menubar">
        <div id="middleMenubar">
            <div id="innerMenubar">
                <div id="navMenubar">

                    <ul>
                        <shiro:hasPermission name="厂家信息_查看">
                            <li id="view"><a href="#" onclick="javascript:toView()">查看</a></li>
                        </shiro:hasPermission>
                        <shiro:hasPermission name="厂家信息_新增">
                            <li id="new"><a href="#" onclick="formSubmit('tocreate.action','_self');this.blur();">新增</a>
                            </li>
                        </shiro:hasPermission>
                        <shiro:hasPermission name="厂家信息_修改">
                            <li id="update"><a href="#" onclick="javascript:toUpdate()">修改</a></li>
                        </shiro:hasPermission>
                        <shiro:hasPermission name="厂家信息_删除">
                            <li id="delete"><a href="#" onclick="formSubmit('delete.action','_self');this.blur();">删除</a>
                            </li>
                        </shiro:hasPermission>
                    </ul>

                </div>
            </div>
        </div>
    </div>

    <div class="textbox-title">
        <img src="${ctx }/skin/default/images/icon/currency_yen.png"/>
        工厂列表
    </div>

    <div>


        <div class="eXtremeTable">
            <table id="ec_table" class="tableRegion" width="98%">
                <thead>
                <tr>
                    <td class="tableHeader"><input type="checkbox" name="selid" onclick="checkAll('id',this)"></td>
                    <td class="tableHeader">序号</td>
                    <td class="tableHeader">货物/附件</td>
                    <td class="tableHeader">厂家全称</td>
                    <td class="tableHeader">联系人</td>
                    <td class="tableHeader">电话</td>
                    <td class="tableHeader">手机</td>
                    <td class="tableHeader">传真</td>
                    <td class="tableHeader">地址</td>
                    <td class="tableHeader">验货员</td>
                    <td class="tableHeader">说明</td>
                    <td class="tableHeader">排序号</td>
                    <td class="tableHeader">状态</td>
                </tr>
                </thead>
                <tbody class="tableBody">
                ${page.links}

                <c:forEach items="${page.results}" var="o" varStatus="status">
                    <tr class="odd" onmouseover="this.className='highlight'" onmouseout="this.className='odd'">
                        <td><input type="checkbox" name="id" value="${o.id}"/></td>
                        <td>${status.index+1}</td>
                        <td>${o.ctype}</td>
                        <td>${o.fullName}</td>
                        <td>${o.contacts}</td>
                        <td>${o.phone}</td>
                        <td>${o.mobile}</td>
                        <td>${o.fax}</td>
                        <td>${o.address}</td>
                        <td>${o.inspector}</td>
                        <td>${o.remark}</td>
                        <td>${o.orderNo}</td>
                        <td>
                                ${o.state==1?"正常":"停用"}
                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
        </div>

    </div>


</form>
</body>
</html>

