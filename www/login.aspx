<%@ Page Language="c#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/login.js" Css="skin/style.css" Title="登录到品牌管理自助平台 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />
<body onload="initForm();">
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<div class="box1">
			<div class="inner">
				<h1>登录到我的BrandQQ.com帐户</h1>
				<h2><a href="reg.aspx">立即创建新用户</a></h2>
				<div class="body">
					<form id="loginForm" action="" method="post">
					<div>邮件地址：</div>
					<div><input name="email" type="text" size="40" maxlength="45" />
						<img src="skin/blank.gif" alt="验证" class="valid" id="loginFormValid1" /><span id="loginFormMsg1"></span></div>
					
					<div>登录密码：</div>
					<div><input name="password" type="password" size="30" maxlength="20" />
						<img src="skin/blank.gif" alt="验证" class="valid" id="loginFormValid2" /><span id="loginFormMsg2"></span></div>
					<!--div class="font12">忘记密码？</div-->
					<div>登录选项：</div>
					<ul class="pad5">
							<li><input type="radio" name="loginOption" id="loginOption1" value="180" /><label for="loginOption1">让我半年内不需要再次登录</label></li>
							<li><input type="radio" name="loginOption" id="loginOption2" value="30" /><label for="loginOption2">让我1个月内不需要再次登录</label></li>
							<li><input type="radio" name="loginOption" id="loginOption3" value="7" /><label for="loginOption3">让我1周内不需要再次登录</label></li>
							<li><input name="loginOption" type="radio" id="loginOption4" value="0" checked="checked" />
							<label for="loginOption4">让我每次重新登录</label></li>
					</ul>
					
					<div class="pad5"><a href="javascript:;" onclick="document.getElementById('GetPassPannel').style.display='';">忘记密码？</a></div>
					<div class="pad5" style="display:none;" id="GetPassPannel">
					<p>请输入您的邮件地址：<input name="getPassEmail" type="text" size="30" maxlength="45" />
					<input name="cmdSendPass" type="button" class="cmdGeneral" value="发送密码" /><img src="skin/blank.gif" alt="验证" class="valid" id="loginFormValid3" /><span id="loginFormMsg3"></span>
					</p>
					<p class="font12 clrF00">密码将发送到您帐户的邮件地址中，请注意查收邮件！</p>
					</div>
					<div class="pad5"><a href="reg.aspx">还没有创建帐户？</a></div>
					
					<div class="pad5 alignCenter">
						<input name="cmdLogin" type="submit" class="cmdConfirm" value="登录" />
						<input name="AjaxAction" type="hidden" value="login" />
						<input name="ref" type="hidden" value="<%Response.Write(Request.UrlReferrer==null?"":Request.UrlReferrer.ToString()); %>" />
						
					</div>
				</form>
				</div>
			</div>
		</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
