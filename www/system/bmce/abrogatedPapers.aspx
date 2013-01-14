<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>


<script runat="server">
    StringBuilder html = new StringBuilder();
    SerialNumber papersn;
    string papertitle;
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "PaperListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["papersn"] != null)
        {
            papersn = new SerialNumber(Request.Form["papersn"]);
        }

        if (Request.Form["papertitle"] != null)
        {
            papertitle = Request.Form["papertitle"];
        }

        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach (Paper obj in Paper.List(papersn,papertitle,PaperStatus.Abrogated,pager))
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td>" + obj.SN.ToString() + "</td>");
            html.AppendLine("<td><a href=\"paper.aspx?sn=" + obj.SN.ToString() + "\">" + obj.Title + "</a></td>");
            html.AppendLine("<td>" + obj.CreatedDate.ToShortDateString() + "</td>");
            html.AppendLine("<td><a href=\"paper.aspx?sn=" + obj.SN.ToString() + "\">详细</a> 编辑</td>");
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
<form id="PaperListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="newPapers.aspx">待发布的新问卷</a></li>
				<li><a href="editingPapers.aspx">编辑中的问卷</a></li>
				<li><a href="publishedPapers.aspx">已发布的问卷</a></li>
				<li class="active">废除的问卷</li>
				<li><a href="createPaper.aspx">新建空白问卷</a></li>
			</ul>
		</div>
		
		<div class="body">
			<div class="header">
            问卷编号：
	            <input name="papersn" type="text" class="txt" size="15" />
	            标题：
	            <input name="papertitle" type="text" class="txt" size="15" />
	            <input name="cmdQuery" type="button" class="cmdGeneral" value="查询" />
            </div>
            
            <table width="100%" border="0" class="grid1">
	            <tr>
		            <th scope="col">问卷编号</th>
		            <th scope="col">标题</th>
		            <th scope="col">发布时间</th>
		            <th scope="col">操作</th>
	            </tr>
	            <%Response.Write(html.ToString()); %>
            </table>
            
            <div class="footer">
	            <%Response.Write(pager.PagerHtml); %>
            </div>
		</div>
	</div>
</form>
</body>
</html>
