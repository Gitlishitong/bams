<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../common.jsp" %>
<%@include  file="../editmsgbox.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath %>/dwr/interface/dwrOfficeResourcesService.js"></script>
<title>会议纪要</title>
<script type="text/javascript">


//查询方法
function queryData(){
	startQuery();
	var meetapply = getQueryParam();
	var pager = getPager();
	
	dwrOfficeResourcesService.listMyMeetSummary(meetapply,pager,queryCallback);
}

function queryCallback(data){
	if(data.success == true){
		initGridData(data.resultList,data.pager);
	}else{
		alert(data.message);
	}
	endQuery();
}

//双击数据

function dblCallback(obj){
	var url = '<%=contextPath%>/erp/office_resources/meetSummary_detail.jsp?cid='+obj.value;
	openMDITab(url);
}

function createProcessMethod(rowObj){
	var	str="";
	if(rowObj.oaMeetapplyStatus == <%=EnumUtil.OA_MEETAPPLY_STATUS.APPLYING.value%>){
		str="<a href='javascript:void(0)' title='会议未开始，不能录入纪要' onclick=\"\"><img src='<%=contextPath%>/images/grid_images/page_.png' border='0' style='filter:gray'/></a>&nbsp;&nbsp";
	}else{
		str="<a href='javascript:void(0)' title='录入纪要' onclick=\"edit('"+rowObj.primaryKey+"')\"><img src='<%=contextPath%>/images/grid_images/page_.png' border='0'/></a>&nbsp;&nbsp";
	}
	return str;
}
function edit(pk){
    var url = '<%=contextPath%>/erp/office_resources/summary_add.jsp?meetapplypk=' +pk;  
    openMDITab(url);
}

function add(){
	Sys.load('<%=contextPath%>/erp/office_resources/meetapply_add.jsp');
}


function del(pk){
   confirmmsg("确定要删除该会议记录吗?","delok("+pk+")");
}
function delok(id){
   var ids = new Array();
	ids[0] = id;
    dwrOfficeResourcesService.deleteMeetingById(ids,delcallback);
}

function delcallback(data){
   alertmsg(data,"queryData()");
}



function deleteObject(){
	//针对多条记录进行操作
	if(getAllRecordArray() != false){
		confirmmsg("确定要删除选中的会议吗?","deletMeetings()");
	}else{
	   alertmsg("请你选择您要删除的会议！");
	}
}

function deletMeetings(){
	var recordsPks = getAllRecordArray();
	dwrOfficeResourcesService.deleteMeetapplysByPks(recordsPks,deleteCallback);
}

function deleteCallback(data){
	alertmsg(data,"queryData()");
}

function repleaStatus(rowObj){
    str = "";
    if(rowObj.oaMeetapplyStatus == <%=EnumUtil.OA_MEETAPPLY_STATUS.APPLYING.value%>){
         str= "<font color='red'><%=EnumUtil.OA_MEETAPPLY_STATUS.valueOf(EnumUtil.OA_MEETAPPLY_STATUS.APPLYING.value)%></font>";
    }else if(rowObj.oaMeetapplyStatus == <%=EnumUtil.OA_MEETAPPLY_STATUS.PROCESSING.value%>){
         str= "<font color='green'><%=EnumUtil.OA_MEETAPPLY_STATUS.valueOf(EnumUtil.OA_MEETAPPLY_STATUS.PROCESSING.value)%></font>";
    }else{
         str= "<font color='blue'><%=EnumUtil.OA_MEETAPPLY_STATUS.valueOf(EnumUtil.OA_MEETAPPLY_STATUS.COMPLETE.value)%></font>";
    }
    return str;
}
function repleaDegree(rowObj){
    src = "";
    if(rowObj.oaMeetapplyDegree == <%=EnumUtil.OA_MEET_TYPE.TWO.value%>){
         src= "<image src='<%=request.getContextPath()%>/images/lve1.gif' border='0' title='重要' height='13' style='vertical-align: middle;'/>" ;
	}
    return src;
}

//获取纪要数
function getsummaryCount(rowObj){
    var count = 0;
    if(rowObj.summaryCount != null&&rowObj.summaryCount != undefined&& rowObj.summaryCount != "undefined"&&rowObj.summaryCount.length>0){
		count = rowObj.summaryCount;
	}
	return count;
}
//获取附件数
function getAffixCount(rowObj){
	var count =0 ;
	if(rowObj.oaMeetapplyAffix!=null&&rowObj.oaMeetapplyAffix != undefined&& rowObj.oaMeetapplyAffix != "undefined"&&rowObj.oaMeetapplyAffix.length>0){
		var cs = rowObj.oaMeetapplyAffix.split(",");
		count = cs.length;
	}
	return count;
}



</script>
</head>
<body>
<%
	SysGrid bg =new SysGrid(request);
bg.setTableTitle("会议纪要");
bg.setShowImg(false);//默认为true 显示切换视图 为true必须指定图片相关信息
bg.setCheckboxOrNum(false);
//bg.setIsautoQuery(false);//默认为自动执行查询
//bg.setTableRowSize(20);//默认每页显示记录数30 选择10 20 30 50 80  
//设置附加信息
bg.setQueryFunction("queryData");	//查询的方法名
bg.setDblFunction("dblCallback");	//双击列的方法名，又返回值，为列对象
bg.setDblBundle("primaryKey");		//双击列的绑定的列值

//放入列
ArrayList<SysColumnControl> sccList = new ArrayList<SysColumnControl>();
sccList.add(new SysColumnControl("oaMeetapplyDegree","",1,2,2,0)); 
sccList.add(new SysColumnControl("oaMeetapplyName","会议名称",1,1,1,10));
sccList.add(new SysColumnControl("library.libraryInfoName","会议类型",1,2,2,0));
sccList.add(new SysColumnControl("oaMeetapplyType","会议类型",2,2,1,0));
sccList.add(new SysColumnControl("oaMeetapplyStar","开始时间",1,2,1,0));
sccList.add(new SysColumnControl("oaMeetapplyEnd","结束时间",1,2,1,0)); 
sccList.add(new SysColumnControl("oaMeetapplyStatus","会议状态",1,2,1,0));
ArrayList<SysGridColumnBean> colList = UtilTool.getGridColumnList(sccList);

//进行高级查询显示处理
for(int i=0;i<colList.size();i++){
	SysGridColumnBean bc =colList.get(i);
	if(bc.isShowAdvanced()||bc.isShowColumn()){
		if("oaMeetapplyStar".equalsIgnoreCase(bc.getDataName()) || "oaMeetapplyEnd".equalsIgnoreCase(bc.getDataName())){
	//高级查询显示
	DateType date = new DateType();
	//date.setDefaultDate(UtilWork.getToday());
	date.setDateFmt("yyyy-MM-dd HH:mm");
	bc.setColumnTypeClass(date);
	//列样式
	bc.setColumnStyle("padding-left:15px;");
		}
		
		if("oaMeetapplyType".equalsIgnoreCase(bc.getDataName())){
	//设置高级查询显示样式
	
	SelectType select  = new SelectType(UtilTool.getLibraryInfoList(this.getServletContext(),request,"-1,-请选择会议类型-","12"));
	select.setCustomerFunction(new String[]{"onchange=\"queryData();\""});
	bc.setColumnTypeClass(select);
	
	
	//设置列显示样式
	bc.setColumnStyle("text-align:center;");
		}
		if("oaMeetapplyDegree".equalsIgnoreCase(bc.getDataName())){
	//设置高级查询显示样式
	
	SelectType select  = new SelectType(EnumUtil.OA_MEET_TYPE.getSelectAndText("-1,-请选择重要程度-"));
	select.setCustomerFunction(new String[]{"onchange=\"queryData();\""});
	bc.setColumnTypeClass(select);
	
	bc.setColumnReplace("repleaDegree");
	
	//设置列显示样式
	bc.setColumnStyle("text-align:center;");
		}
		
		if("oaMeetapplyStatus".equalsIgnoreCase(bc.getDataName())){
	//设置高级查询显示样式
	
	SelectType select  = new SelectType(EnumUtil.OA_MEETAPPLY_STATUS.getSelectAndText("-1,-请选择会议状态-"));
	select.setCustomerFunction(new String[]{"onchange=\"queryData();\""});
	bc.setColumnTypeClass(select);
	
	bc.setColumnReplace("repleaStatus");
	
	//设置列显示样式
	bc.setColumnStyle("text-align:center;");
		}
		
	}
}
colList.add(ColumnUtil.getCusterShowColumn("summaryCount","纪要数","getsummaryCount",0,"text-align:center")); 
colList.add(ColumnUtil.getCusterShowColumn("affixCount","附件数","getAffixCount",0,"text-align:center"));

bg.setColumnList(colList);

//设置列操作对象
bg.setShowProcess(true);//默认为false 为true请设置processMethodName
bg.setProcessMethodName("createProcessMethod");//生成该操作图标的js方法,系统默认放入数据行对象

//开始创建
out.print(bg.createTable());
%>
</body>
</html>