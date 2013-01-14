<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    string comname="";
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "ComListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["comname"] != null)
        {
            comname = Request.Form["comname"];
        }

        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach (Company obj in Company.List("",pager))
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td>" + obj.Id.ToString() + "</td>");
            html.AppendLine("<td>" + obj.ComName + "</td>");
            html.AppendLine("<td>" + IndustryUtil.GetName(obj.Industry) + "</td>");
            html.AppendLine("<td>" + CompanyNature.Get(obj.Nature) + "</td>");
            html.AppendLine("<td>" + Region.Get(obj.Region) + "</td>");
            html.AppendLine("<td>" + obj.BusiType.ToString() + "</td>");
            html.AppendLine("<td>" + (obj.IsChecked ? "<span style=\"color:green\">已认证</span>" : "<a href=\"companyCheck.aspx?id=" + obj.Id.ToString() + "\"><span style=\"color:red\">未认证</span></a>") + "</td>");
            html.AppendLine("<td><a href=\"companyDetails.aspx?id=" + obj.Id.ToString() + "\">详细</a> <a href=\"company.aspx?id=" + obj.Id.ToString() + "\">编辑</a></td>");
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
<form method="post" id="ComListForm" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="default.aspx">基本帐户管理</a></li>
				<li class="active">企业用户管理</li>
			</ul>
		</div>
		
		<div class="body">
			
            <div class="header">
            企业名称：
	            <input name="comname" type="text" class="txt" size="15" />
	            <input name="cmdQuery" type="button" class="cmdGeneral" value="查询" />
            </div>
            <table width="100%" border="0" class="grid1">
            <tr>
            <th>记录号</th>
            <th>企业名称</th>
            <th>行业</th>
            <th>性质</th>
            <th>地区</th>
            <th>生意模式</th>
            <th>确认</th>
            <th>操作</th>
            </tr>
            <%Response.Write(html.ToString()); %>
            </table>
            <div class="footer">
	            <%Response.Write("记录数："+pager.RecordCount+" ┊ "+pager.PagerHtml); %>
            </div>
		</div>
	</div>
</form>
</body>
</html>
