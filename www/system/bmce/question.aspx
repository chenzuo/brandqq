<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>


<script runat="server">
    StringBuilder html = new StringBuilder();
    Question question = new Question();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            try
            {
                int qid = Convert.ToInt32(Request["id"]);
                question = Question.Get(qid);

                foreach (Answer obj in Answer.List(qid))
				{
					html.AppendLine("<tr id=\"ANSWER_"+obj.Id.ToString()+"\">");
					html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
                    html.AppendLine("<td>" + obj.Title + " " + (obj.Only ? "<img src=\"../skin/key.gif\" alt=\"唯一项\" />" : "") + "</td>");
					html.AppendLine("<td>" + obj.Score.ToString() + "</td>");
					html.AppendLine("<td>" + obj.OrderNum.ToString() + "</td>");
                    html.AppendLine("<td>");
                    html.AppendLine("<a href=\"createAnswer.aspx?id=" + obj.Id.ToString() + "&backurl=question.aspx%3fid%3d" + qid.ToString() + "\">编辑</a> ");
					html.AppendLine("<a href=\"javascript:deleteAnswer(" + obj.Id.ToString() + ");\">删除</a>");
                    html.AppendLine("</td>");
					html.AppendLine("</tr>");
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
				<li><a href="questions.aspx">已有问题管理</a></li>
				<li><a href="createQuestion.aspx">新建问题</a></li>
				<li class="active">问题明细</li>
			</ul>
		</div>
		
		<div class="body">
            <table width="100%" border="0" class="grid2">
				<tr>
					<td>标题：<%Response.Write(question.Title);%> 
					<img src="../skin/blank.gif" alt="类型" class="<%Response.Write(question.IsMulti?"check":"radio");%>"/>
					</td>
				</tr>
			</table>
			
			<div class="pad5">包含以下答案项：</div>
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
				<input name="cmdAddAnswer" type="button" class="cmdConfirm" id="cmdAddAnswer" value="添加答案" onClick="location='createAnswer.aspx?pid=<%Response.Write(question.Id);%>&backurl=question.aspx%3fid%3d<%Response.Write(question.Id);%>';" />
			
			<input name="cmdDeleteQuestion" type="button" class="cmdGeneral" id="cmdDeleteQuestion" value="删除问题" onclick="deleteQuestion(<%Response.Write(question.Id);%>,this);" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
