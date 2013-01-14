<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    string modulesn = "";
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "ModuleListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["modulesn"] != null)
        {
            modulesn = Request.Form["modulesn"];
        }

        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach (Module obj in Module.List(modulesn, pager))
        {
            html.AppendLine("<tr id=\"MODULE_" + obj.Id.ToString() + "\">");
            html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
            html.AppendLine("<td><a href=\"module.aspx?id="+ obj.Id.ToString() +"\">" + obj.SN + "</a></td>");
            html.AppendLine("<td><a href=\"module.aspx?id=" + obj.Id.ToString() + "\">" + obj.Title + "</a></td>");
            html.AppendLine("<td>" + IndustryUtil.GetName(obj.Industry) + "</td>");
            html.AppendLine("<td>" + obj.OrderNum.ToString() + "</td>");
            html.AppendLine("<td><a href=\"createModule.aspx?id=" + obj.Id.ToString() + "\">编辑</a> <a href=\"javascript:deleteModule(" + obj.Id.ToString() + ");\">删除</a> <a href=\"createQuestion.aspx?pid="+obj.Id.ToString()+"\">添加问题</a> <a href=\"createConclusion.aspx?t=2&tid=" + obj.Id.ToString() + "\">添加结论</a></td>");
            html.AppendLine("</tr>");
        }
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>BMCE</title>
<link href="../skin/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript" src="../../jscript/AjaxRequest.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/AjaxResponse.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/tabContainor.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form id="ModuleListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li class="active">已有模块管理</li>
				<li><a href="createModule.aspx">新建模块</a></li>
			</ul>
		</div>
		
		<div class="body">
		    <div class="header">
		    编号：<input name="modulesn" type="text" class="txt" size="15" />
	            <input name="cmdQuery" type="button" class="cmdGeneral" value="查询" />
		    </div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">记录号</th>
					<th scope="col">编号</th>
					<th scope="col">标题</th>
					<th scope="col">行业</th>
					<th scope="col">顺序</th>
					<th scope="col">操作</th>
				</tr>
				<%Response.Write(html.ToString()); %>
			</table>
			<div class="footer">
				<%Response.Write("记录数：" + pager.RecordCount + " 页数：" + pager.PageCount + " | " + pager.PagerHtml); %>
			</div>
		</div>
	</div>
</body>
</form>
</html>
