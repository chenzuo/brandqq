<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>

<script runat="server">
    StringBuilder html = new StringBuilder();
    Paper paper=new Paper();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            try
            {
                paper = Paper.Get(Convert.ToInt32(Request["id"]));
                paper.GetConclusions();

                foreach (Conclusion obj in paper.Conclusions)
                {
                    html.AppendLine("<tr id=\"CONSULSION_"+obj.Id.ToString()+"\">");
                    html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
                    html.AppendLine("<td>" + obj.Content + "</td>");
                    html.AppendLine("<td>" + obj.LowerScore.ToString() + " - " + obj.UpperScore.ToString() + "%</td>");
                    html.AppendLine("<td>");
                    html.AppendLine("<a href=\"createConclusion.aspx?id=" + obj.Id.ToString() + "\">编辑</a>");
					html.AppendLine(" <a href=\"javascript:deleteConsulsion("+obj.Id.ToString()+");\">删除</a>");
                    html.AppendLine("</td>");
                    html.AppendLine("</tr>");
                }
            }
            catch
            {
                Response.Write("输入了错误的问卷编号！");
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
				<li><a href="newPapers.aspx">待发布的新问卷</a></li>
				<li><a href="editingPapers.aspx">编辑中的问卷</a></li>
				<li><a href="publishedPapers.aspx">已发布的问卷</a></li>
				<li><a href="abrogatedPapers.aspx">废除的问卷</a></li>
				<li><a href="createPaper.aspx">新建空白问卷</a></li>
				<li class="active">未发布问卷明细</li>
			</ul>
		</div>
		
		<div class="body">
            <table width="100%" border="0" class="grid2">
				<tr>
					<td width="50%">问卷编号：<%Response.Write(paper.SN.ToString());%></td>
					<td>适用行业：<%Response.Write(IndustryUtil.GetName(paper.Industry)); %></td>
				</tr>
				
				<tr>
					<td colspan="2">问卷说明：</td>
				</tr>
				<tr>
					<td colspan="2"><%Response.Write(paper.Description);%></td>
				</tr>
			</table>
			
			<div class="pad5">包含以下结论：</div>
			<table width="100%" border="0" class="grid1">
					<tr>
						<th scope="col">记录号</th>
						<th width="60%" scope="col">内容</th>
						<th scope="col">分值范围</th>
						<th scope="col">操作</th>
					</tr>
					<%Response.Write(html.ToString()); %>
				</table>
            <div class="footer">
            	<input name="cmdAddConclusion" type="button" class="cmdConfirm" id="cmdAddConclusion" value="添加结论" onClick="location='createConclusion.aspx?t=1&tid=<%Response.Write(paper.Id);%>&backurl=newPaper.aspx%3fid%3d<%Response.Write(paper.Id);%>';" />
            	<input name="cmdDeletePaper" type="button" class="cmdGeneral" id="cmdDeletePaper" value="删除问卷" onClick="deleteNewPaper(<%Response.Write(paper.Id);%>,this);" />
            </div>
		</div>
	</div>
</form>
</body>
</html>
