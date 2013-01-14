<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>

<script runat="server">
    StringBuilder html = new StringBuilder();
    string answertitle="";
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "AnswerListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["answertitle"] != null)
        {
            answertitle = Request.Form["answertitle"];
        }

        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach (Answer obj in Answer.List(answertitle,pager))
        {
            html.AppendLine("<tr id=\"ANSWER_" + obj.Id.ToString() + "\">");
            html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
            html.AppendLine("<td>" + obj.Title + " "+(obj.Only?"<img src=\"../skin/key.gif\" alt=\"唯一项\" />":"")+"</td>");
            html.AppendLine("<td>" + obj.Score.ToString() + "</td>");
            html.AppendLine("<td>" + obj.OrderNum.ToString() + "</td>");
            html.AppendLine("<td>");
            html.AppendLine("<a href=\"createAnswer.aspx?id=" + obj.Id.ToString() + "\">编辑</a> ");
			html.AppendLine("<a href=\"javascript:deleteAnswer(" + obj.Id.ToString() + ");\">删除</a>");
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
<form id="AnswerListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li class="active">已有答案管理</li>
				<li><a href="createAnswer.aspx">新建答案</a></li>
			</ul>
		</div>
		
		<div class="body">
		    <div class="header">
	            标题：
	            <input name="answertitle" type="text" class="txt" size="15" />
	            <input name="cmdQuery" type="button" class="cmdGeneral" value="查询" />
            </div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">记录号</th>
					<th width="50%" scope="col">标题</th>
					<th scope="col">分值</th>
					<th scope="col">序号</th>
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
