<%@ Page Language="C#" ValidateRequest="false" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>

<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    Paper paper = new Paper();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            paper = Paper.Get(Convert.ToInt32(Request["id"]));
            industry.SelectedValue = paper.Industry;
        }
        
        if(Request.HttpMethod=="POST")
		{
            Paper p = new Paper();
            p.Id = Convert.ToInt32(Request.Form["paperid"]);
            p.Title = Request.Form["title"];
            p.Industry = Request.Form["industry"];
            p.Description = Request.Form["description"];
            p.Save();
            Response.Redirect("newPapers.aspx");
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
<script language="javascript" type="text/javascript" src="../../jscript/UbbToolBar.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form id="PaperForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="newPapers.aspx">待发布的新问卷</a></li>
				<li><a href="editingPapers.aspx">编辑中的问卷</a></li>
				<li><a href="publishedPapers.aspx">已发布的问卷</a></li>
				<li><a href="abrogatedPapers.aspx">废除的问卷</a></li>
				<li class="active">新建空白问卷</li>
			</ul>
		</div>
		
		<div class="body">
			<table width="100%" border="0" class="details">
				<tr>
					<th scope="row">问卷标题：</th>
					<td><input name="title" type="text" class="txt" size="60" value="<%Response.Write(paper.Title); %>"></td>
				</tr>
				<tr>
					<th scope="row">适用行业：</th>
					<td>
					<BrandQQ:IndustrySelect runat="server" ID="industry" Name="industry" />					</td>
				</tr>
				<tr>
					<th scope="row">问卷描述：</th>
					<td>
					<script language="javascript" type="text/javascript">
						var ubbToolBar1=new UBBToolBar("PAPER_DESCRIPTION");
					</script>
					<textarea id="PAPER_DESCRIPTION" name="description" cols="60" rows="10"><%Response.Write(paper.Description); %></textarea>
					</td>
				</tr>
			</table>
			<div class="footer">
				<input name="Submit" type="submit" class="cmdConfirm" value="保存">
				<input type="hidden" name="paperid" value="<%Response.Write(paper.Id); %>" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
