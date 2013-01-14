<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>

<script runat="server">
    StringBuilder html = new StringBuilder();
    string questiontitle="";
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "QuestionListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["questiontitle"] != null)
        {
            questiontitle = Request.Form["questiontitle"];
        }

        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach (Question obj in Question.List(questiontitle,pager))
        {
            html.AppendLine("<tr id=\"QUESTION_"+ obj.Id.ToString() + "\">");
            html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
            html.AppendLine("<td>" + obj.ParentId.ToString() + "</td>");
            html.AppendLine("<td><img src=\"../skin/blank.gif\" class=\"" + (obj.IsMulti ? "check" : "radio") + "\" alt=\"类型\" /> <a href=\"question.aspx?id=" + obj.Id.ToString() + "\">" + obj.Title + "</a></td>");
            html.AppendLine("<td>" + obj.IsMulti.ToString() + "</td>");
            html.AppendLine("<td>" + obj.OrderNum.ToString() + "</td>");
            html.AppendLine("<td><a href=\"createQuestion.aspx?id=" + obj.Id.ToString() + "\">编辑</a> <a href=\"javascript:deleteQuestion(" + obj.Id.ToString() + ");\">删除</a> <a href=\"createAnswer.aspx?pid=" + obj.Id.ToString() + "\">添加答案</a></td>");
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
<form id="QuestionListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li class="active">已有问题管理</li>
				<li><a href="createQuestion.aspx">新建问题</a></li>
			</ul>
		</div>
		
		<div class="body">
			<div class="header">
	            标题：
	            <input name="questiontitle" type="text" class="txt" size="15" />
	            <input name="cmdQuery" type="button" class="cmdGeneral" value="查询" />
            </div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">记录号</th>
					<th scope="col">模块</th>
					<th scope="col">标题</th>
					<th scope="col">多选</th>
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
