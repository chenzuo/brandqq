<%@ Page %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
string guid="",email="";
void Page_Load(object s,EventArgs e)
{
    if(Request["guid"]==null || Request["email"]==null)
    {
        Response.Redirect("login.aspx");
    }
    
    guid=Request["guid"].Trim();
    email=Request["email"].Trim();
    
    if((!Regex.IsMatch(guid,"^[a-z0-9]{32}$")) || (!Utility.IsEmail(email)))
    {
        Response.Redirect("login.aspx");
    }
}
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/login.js" Css="skin/style.css" Title="重置密码  - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />
<body onload="initResetPassForm();">
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<div class="box1">
			<div class="inner">
				<h1>重新设置登录密码</h1>
				<h2><a href="reg.aspx">立即创建新用户</a></h2>
				<div class="body alignCenter">
				<form id="resetPassForm" action="" method="post">
					<div class="lineheight50">
					输入新密码：<input name="password" type="password" size="30" maxlength="20" />
					<img src="skin/blank.gif" alt="验证" class="valid" id="formValid1" /><span id="formValidMsg1"></span>
					</div>
					<div class="lineheight50">
					确认新密码：<input name="password2" type="password" size="30" maxlength="20" />
					<img src="skin/blank.gif" alt="验证" class="valid" id="formValid2" /><span id="formValidMsg2"></span>
					</div>
					
					<div class="pad5 lineheight50">
						<input name="cmdResetPass" type="submit" class="cmdConfirm" value="确定" />
						<input name="guid" type="hidden" value="<% Response.Write(guid); %>" />
						<input name="email" type="hidden" value="<% Response.Write(email); %>" />
						<input name="AjaxAction" type="hidden" value="resetpass" />
					</div>
				</form>
				</div>
			</div>
		</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
