<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>

<script runat="server">
    StringBuilder html = new StringBuilder();
    PaperFile paper;
	Pager pager = new Pager(1, 20);
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["sn"] != null)
        {
            try
            {
                SerialNumber papersn = new SerialNumber(Request["sn"]);
                paper = PaperFile.Load(papersn);
                foreach (SimpleResultStatusRecord obj in Result.StatusList(papersn, pager))
				{
					html.AppendLine("<tr>");
                    if (obj.ComId == 0)
                    {
                        html.AppendLine("<td>&lt;未设置&gt;</td>");
                    }
                    else
                    {
                        html.AppendLine("<td><a href=\"../user/company.aspx?id=" + obj.ComId.ToString() + "\">" + obj.ComName + "</a></td>");
                    }
					html.AppendLine("<td>"+obj.Begin.ToShortDateString()+"</td>");
					html.AppendLine("<td>" + obj.Update.ToShortDateString() + "</td>");
					html.AppendLine("<td>" + obj.Status.ToString() + "</td>");
                    if (obj.ComId == 0)
                    {
                        html.AppendLine("<td>&nbsp;</td>");
                    }
                    else
                    {
                        html.AppendLine("<td><a href=\"specimensView.aspx?sn=" + obj.PaperSN.ToString() + "&uid=" + obj.ComId.ToString() + "\">详细</a></td>");
                    }
                    
					html.AppendLine("</tr>");
				}
            }
            catch
            {
                //Response.Write("加载问卷失败！");
                //Response.End();
                throw;
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
				<li class="active">已发布问卷明细</li>
			</ul>
		</div>
		
		<div class="body">
			<div class="header">
             问卷编号：<%Response.Write(paper.SN.ToString());%><br/>
			 问卷标题：<%Response.Write(paper.Title);%><br/>
			 样本总数：<strong><%Response.Write(pager.RecordCount);%></strong> 
            </div>
            
            <div class="pad5">该问卷的最新样本记录(Top 20)：</div>
            <table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">企业</th>
					<th scope="col">开始日期</th>
					<th scope="col">更新日期</th>
					<th scope="col">状态</th>
					<th scope="col">操作</th>
				</tr>
				<%Response.Write(html.ToString()); %>
			</table>
            
            <div class="footer">
	            <input name="cmdAllResult" type="button" class="cmdGeneral" id="cmdAllResult" value="所有样本" />
            </div>
		</div>
	</div>
</form>
</body>
</html>
