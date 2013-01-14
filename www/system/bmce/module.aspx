<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>


<script runat="server">
    StringBuilder html1 = new StringBuilder();
	StringBuilder html2 = new StringBuilder();
    Module module = new Module();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            try
            {
                int mid = Convert.ToInt32(Request["id"]);
                module = Module.Get(mid);

                foreach (Question obj in Question.List(mid))
				{
					html1.AppendLine("<tr id=\"QUESTION_"+ obj.Id.ToString() + "\">");
					html1.AppendLine("<td>" + obj.Id.ToString() + "</td>");
                    html1.AppendLine("<td><img src=\"../skin/blank.gif\" class=\"" + (obj.IsMulti ? "check" : "radio") + "\" alt=\"类型\" /><a href=\"question.aspx?id=" + obj.Id.ToString() + "\">" + obj.Title + "</a></td>");
					html1.AppendLine("<td>" + obj.IsMulti.ToString() + "</td>");
					html1.AppendLine("<td>" + obj.OrderNum.ToString() + "</td>");
                    html1.AppendLine("<td>");
                    html1.AppendLine("<a href=\"createQuestion.aspx?id=" + obj.Id.ToString() + "&backurl=module.aspx%3fid%3d" + obj.ParentId.ToString() + "\">编辑</a> ");
                    html1.AppendLine("<a href=\"javascript:deleteQuestion(" + obj.Id.ToString() + ");\">删除</a> ");
                    html1.AppendLine("<a href=\"createAnswer.aspx?pid=" + obj.Id.ToString() + "&backurl=module.aspx%3fid%3d" + obj.ParentId.ToString() + "\">添加答案</a>");
                    html1.AppendLine("</td>");
					html1.AppendLine("</tr>");
				}

                foreach (Conclusion obj in Conclusion.List(ConclusionType.M,mid))
				{
					html2.AppendLine("<tr>");
					html2.AppendLine("<td>" + obj.Id.ToString() + "</td>");
					html2.AppendLine("<td>" + obj.LowerScore.ToString() + " - " + obj.UpperScore.ToString() + "%</td>");
					html2.AppendLine("<td>" + obj.Content.ToString() + "</td>");
                    html2.AppendLine("<td><a href=\"createConclusion.aspx?id=" + obj.Id.ToString() + "&backurl=module.aspx%3fid%3d" + mid.ToString() + "\">编辑</a></td>");
					html2.AppendLine("</tr>");
				}
            }
            catch
            {
                Response.Write("输入了错误的参数！");
                Response.End();
            }
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
<form id="PaperListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="modules.aspx">已有模块管理</a></li>
				<li><a href="createModule.aspx">新建模块</a></li>
				<li class="active">模块明细</li>
			</ul>
		</div>
		
		<div class="body">
            <table width="100%" border="0" class="grid2">
				<tr>
					<td width="50%">编号：<%Response.Write(module.SN);%></td>
					<td>标题：<%Response.Write(module.Title); %></td>
				</tr>
			</table>
			
			<div class="pad5">包含以下问题：</div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">记录号</th>
					<th width="50%" scope="col">标题</th>
					<th scope="col">多选</th>
					<th scope="col">序号</th>
					<th scope="col">操作</th>
				</tr>
				<%Response.Write(html1.ToString()); %>
			</table>
			<div class="footer">
				<input name="cmdAddQuestion" type="button" class="cmdConfirm" id="cmdAddQuestion" value="添加问题" onClick="location='createQuestion.aspx?pid=<%Response.Write(module.Id);%>&backurl=module.aspx%3fid%3d<%Response.Write(module.Id);%>';" />
</div>
			<div class="pad5">包含以下结论：</div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th width="10%" scope="col">记录号</th>
					<th width="15%" scope="col">分值范围</th>
					<th width="60%" scope="col">内容</th>
					<th scope="col">操作</th>
				</tr>
				<%Response.Write(html2.ToString()); %>
			</table>
			<div class="footer">
				<input name="cmdAddConsultion" type="button" class="cmdConfirm" id="cmdAddConsultion" value="添加结论" onclick="location='createConclusion.aspx?t=2&tid=<%Response.Write(module.Id);%>&backurl=module.aspx%3fid%3d<%Response.Write(module.Id);%>';" />
			</div>
			<div class="footer">
				<input name="cmdDeleteModule" type="button" class="cmdGeneral" id="cmdDeleteModule" value="删除模块" onclick="deleteModule(<%Response.Write(module.Id);%>,this);" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
