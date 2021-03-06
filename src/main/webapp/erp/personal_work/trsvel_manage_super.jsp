<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath %>/dwr/interface/dwrPersonalProcessService.js"></script>
<title>出差管理</title>
<script type="text/javascript">
//查询方法
function queryData() {
	startQuery();
	var oaTrsvel = getQueryParam();
	var pager = getPager();
	dwrPersonalProcessService.listAllOaTrsvel(oaTrsvel, pager, queryCallback);
}

function queryCallback(data) {
	if (data.success == true) {
		initGridData(data.resultList, data.pager);
	} else {
		alert(data.message);
	}
	endQuery();
}

function detail(primaryKey, processInstanceId) {
	var url = "<%=contextPath%>/erp/personal_work/trsvel_detail.jsp?pk="+primaryKey+"&processInstanceId="+processInstanceId;
	var box = new Sys.msgbox('明细查看', url, '800', '500');
	box.show();
}

function createProcessMethod(rowObj) {
	var str = "<a href='javascript:void(0)' title='查看详情' onclick=\"detail('"+rowObj.primaryKey+"','"+rowObj.processInstanceId+"')\"><img src='<%=contextPath%>/images/grid_images/rowinfo.png' border='0'/></a>";
	str += "&nbsp;&nbsp;<a href='javascript:void(0)' title='删除' onclick=\"del('"+rowObj.primaryKey+"')\"><img src='<%=contextPath%>/images/grid_images/rowdel.png' border='0'/></a>";
	return str;
}

function del(pk){
    confirmmsg("确定要删除出差信息吗?","delok('"+pk+"')");
}
function delok(pk){
    var pks = new Array();
    pks[0] = pk;
    dwrPersonalProcessService.deleteOaTrsvelByPksSuper(pks,delCallback);
}
function delCallback(data){
    alertmsg(data,"queryData()");
}

function delbatch(){
    if(getAllRecordArray() != false){
        confirmmsg("确定要删除请假信息吗?","delbatchok()");
    }else{
        alertmsg("请选择要删除的请假信息...");
    }
}
function delbatchok(){
    var pks = getAllRecordArray();
    dwrPersonalProcessService.deleteOaTrsvelByPksSuper(pks,delCallback);
}


</script>
</head>
<body>
<%
	SysGrid bg =new SysGrid(request);
	bg.setTableTitle("出差管理");
	//设置附加信息
	bg.setQueryFunction("queryData");	//查询的方法名
	bg.setDblFunction("dblCallback");	//双击列的方法名，又返回值，为列对象
	bg.setDblBundle("primaryKey");		//双击列的绑定的列值
	
	//放入按钮
	ArrayList<SysGridBtnBean> btnList =new ArrayList<SysGridBtnBean>();
	btnList.add(new SysGridBtnBean("批量删除","delbatch()","close.png"));
	bg.setBtnList(btnList);
	
	ArrayList<SysColumnControl> sccList = new ArrayList<SysColumnControl>();
	sccList.add(new SysColumnControl("applyEmployee.hrmEmployeeName","申请人",1,2,2,0));
	sccList.add(new SysColumnControl("trsvelArea","出差地点",1,2,2,0));
	sccList.add(new SysColumnControl("trsvelCause","出差事由",1,2,2,20));
	sccList.add(new SysColumnControl("trsvelBegindata","出差开始时间",1,2,2,0));
	sccList.add(new SysColumnControl("trsvelEnddata","出差结束时间",1,2,2,0));
	sccList.add(new SysColumnControl("applydata","申请时间",1,2,2,0));
	ArrayList<SysGridColumnBean> colList = UtilTool.getGridColumnList(sccList); 
	//进行高级查询显示处理
	for(int i=0;i<colList.size();i++){
		SysGridColumnBean bc =colList.get(i);
		if("".equalsIgnoreCase(bc.getDataName())){
			bc.setColumnReplace("");
			bc.setColumnStyle("text-align:center");
		}
	}
	bg.setColumnList(colList);
	bg.setCheckboxOrNum(true);
	bg.setShowProcess(true);
	bg.setShowImg(false);
	bg.setProcessMethodName("createProcessMethod");
	//开始创建
	out.print(bg.createTable());
%>
</body>
</html>