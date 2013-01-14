<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>

<script runat="server">
    StringBuilder html = new StringBuilder();
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "ConclusionListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach (Conclusion obj in Conclusion.List(ConclusionType.M,pager))
        {
            html.AppendLine("<tr id=\"CONSULSION_"+obj.Id.ToString()+"\">");
            html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
            html.AppendLine("<td>" + obj.TypeId.ToString() + "</td>");
            html.AppendLine("<td>" + obj.Content + "</td>");
            html.AppendLine("<td>" + obj.LowerScore.ToString() + " - " + obj.UpperScore.ToString() + "%</td>");
            html.AppendLine("<td>");
            html.AppendLine("<a href=\"createConclusion.aspx?id=" + obj.Id.ToString() + "\">编辑</a> ");
			html.AppendLine("<a href=\"javascript:deleteConsulsion("+obj.Id.ToString()+");\">删除</a>");
            html.AppendLine("</td>");
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
<form id="ConclusionListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="conclusions1.aspx">已有问卷结论</a></li>
				<li class="active">已有模块结论</li>
				<li><a href="createConclusion.aspx">新建结论</a></li>
			</ul>
		</div>
		
		<div class="body">
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">记录号</th>
					<th scope="col">模块记录号</th>
					<th scope="col" width="60%">内容</th>
					<th scope="col">分值范围</th>
					<th scope="col">操作</th>
				</tr>
				<%Response.Write(html.ToString()); %>
			</table>
			<div class="footer">
				<%Response.Write("记录数：" + pager.RecordCount + " 页数：" + pager.PageCount + " | " + pager.PagerHtml); %>
			</div>
		</div>
	</div>
</form>
</body>
</html>
