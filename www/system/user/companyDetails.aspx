<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    Company com = new Company();
    Member m;
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            if (Request["id"].Trim() == "0")
            {
                Response.Write("不存在企业资料");
                Response.End();
            }

            m = Member.Get(Convert.ToInt32(Request["id"]));
            com = Company.Get(Convert.ToInt32(Request["id"]));
            foreach (SimpleResultStatusRecord obj in Result.StatusList(m.RegGuid,new Pager(1, 50)))
            {
                html.AppendLine("<tr>");
                html.AppendLine("<td><a href=\"../bmce/specimensView.aspx?id="+obj.Id.ToString()+"\">" + obj.PaperTitle + "</a></td>");
                html.AppendLine("<td>" + obj.Begin.ToShortDateString() + "</td>");
                html.AppendLine("<td>" + obj.Update.ToShortDateString() + "</td>");
                html.AppendLine("<td><img src=\"../skin/blank.gif\" class=\"resultSta_" + obj.Status.ToString() + "\" /></td>");
                html.AppendLine("<td><a href=\"../bmce/specimensView.aspx?id=" + obj.Id.ToString() + "\">详细</a></td>");
                html.AppendLine("</tr>");
            }
        }
        else
        {
            Response.Write("不存在企业资料");
            Response.End();
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
				<li><a href="companies.aspx">企业用户管理</a></li>
				<li class="active">企业明细</li>
			</ul>
		</div>
		
		<div class="body">
            <div class="header">
            企业名称：<%Response.Write(com.ComName); %> <a href="company.aspx?id=<%Response.Write(com.Id); %>">查看企业资料</a>
            </div>
            <div class="header">
            <strong>基本帐户信息：</strong>
            <p>姓名：<%Response.Write(String.IsNullOrEmpty(m.Name) ? "&lt;未设置&gt;" : m.Name); %></p>
            <p>电子邮件：<%Response.Write(m.Email); %></p>
            <p>注册时间：<%Response.Write(m.RegDate.ToString()); %></p>
            <p>最后登录：<%Response.Write(m.LastLogin.ToString()+"("+m.LastIp+")"); %></p>
            </div>
            <div>该企业的最近问卷样本记录(Top 20)：</div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">问卷</th>
					<th scope="col">开始日期</th>
					<th scope="col">更新日期</th>
					<th scope="col">状态</th>
					<th scope="col">操作</th>
				</tr>
				<%Response.Write(html.ToString()); %>
			</table>
            <div class="footer">
	            
            </div>
		</div>
	</div>
</form>
</body>
</html>
