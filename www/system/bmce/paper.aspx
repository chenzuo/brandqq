<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>


<script runat="server">
    StringBuilder html = new StringBuilder();
    SerialNumber papersn=new SerialNumber();
    Paper paper=new Paper();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["sn"] != null)
        {
            try
            {
                papersn = new SerialNumber(Request["sn"]);
                paper = Paper.Load(papersn);
            }
            catch
            {
                Response.Write("输入了错误的问卷编号！");
                Response.End();
            }
        }

        foreach (Module m in paper.Modules)
        {
            Response.Write(m.Title+"<br/>");
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
				<li class="active">问卷明细</li>
			</ul>
		</div>
		
		<div class="body">
			<div class="header">
             
            </div>
            
            <p></p>
            
            <table width="100%" border="0" class="grid2">
				<tr>
					<td width="50%">问卷编号：<%Response.Write(papersn.ToString());%></td>
					<td>适用行业：<%Response.Write(IndustryUtil.GetName(paper.Industry)); %></td>
				</tr>
				
				<tr>
					<td colspan="2">问卷说明：</td>
				</tr>
				<tr>
					<td colspan="2"><%Response.Write(paper.Description);%></td>
				</tr>
			</table>
            <div class="footer">
	            
            </div>
		</div>
	</div>
</form>
</body>
</html>
