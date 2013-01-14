<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    string name="", email="";
    Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "UserListForm");
    void Page_Load(object sender, EventArgs e)
    {
        if(Request.Form["uname"]!=null)
        {
            name = Request.Form["uname"];
        }

        if (Request.Form["email"] != null)
        {
            email = Request.Form["email"];
        }

        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex =Convert.ToInt16(Request.Form["__pageindex"]);
        }
        

        foreach (Member m in Member.List(name, email, pager))
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td>" + m.Id.ToString() + "</td>");
            html.AppendLine("<td>" + (String.IsNullOrEmpty(m.Name)?"&lt;未设置&gt;":m.Name) + "</td>");
            html.AppendLine("<td>" + m.Email + "</td>");
            html.AppendLine("<td>" + m.RegDate.ToShortDateString() + "</td>");
            html.AppendLine("<td>" + m.LastLogin.ToShortDateString() + "[" + m.LastIp + "]" + "</td>");
            html.AppendLine("<td>" + m.LoginTimes.ToString() + "</td>");
            //html.AppendLine("<td>删除</td>");
            html.AppendLine("</tr>");
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>User</title>
<link href="../skin/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript" src="../../jscript/AjaxRequest.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/AjaxResponse.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/tabContainor.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form method="post" id="UserListForm" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li class="active">基本帐户管理</li>
				<li><a href="companies.aspx">企业用户管理</a></li>
			</ul>
		</div>
		
		<div class="body">
			
            <div class="header">
            用户名：
	            <input name="uname" type="text" class="txt" size="15" />
	            电子邮件：
	            <input name="email" type="text" class="txt" size="15" />
	            <input name="cmdQuery" type="button" class="cmdGeneral" value="查询" />
            </div>
            <table width="100%" border="0" class="grid1">
            <tr>
            <th>记录号</th>
            <th>用户名</th>
            <th>电子邮件</th>
            <th>注册时间</th>
            <th>最后登录</th>
            <th>登录次数</th>
            <!--th>操作</th-->
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
