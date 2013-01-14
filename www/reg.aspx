<%@ Page %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/reg.js" Css="skin/style.css" Title="创建新用户 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />

<body onload="initForm();">
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<div class="box1">
			<div class="inner">
				<h1>开始创建新用户</h1>
				<h2><a href="login.aspx">登录</a></h2>
				<div class="body">
				<form id="registerForm" action="" method="post">
					<div>输入邮件地址：</div>
					<div><input name="email" type="text" size="40" maxlength="45" />
						<img src="skin/blank.gif" alt="验证" class="valid" id="registerFormValid1" /><span id="registerFormMsg1"></span></div>
					<div class="grayTip" id="registerFormTip1">请输入您常用的电子邮件地址，以便能及时收到来自BrandQQ.com的通知<br/><strong>特别地，电子邮件将用于帮助您找回密码</strong></div>
					<div>设置登录密码：</div>
					<div><input name="password" type="password" size="30" maxlength="20" />
						<img src="skin/blank.gif" alt="验证" class="valid" id="registerFormValid2" /><span id="registerFormMsg2"></span></div>
					<div class="grayTip" id="registerFormTip2">密码至少由6个字符组成，不能在密码中包含空格，密码区分大小写</div>
					<div>再输入一次登录密码：</div>
					<div><input name="password2" type="password" size="30" maxlength="20" />
						<img src="skin/blank.gif" alt="验证" class="valid" id="registerFormValid3" /><span id="registerFormMsg3"></span></div>
					<div class="grayTip" id="registerFormTip3">请重复输入一次上边的密码，以确保您输入的密码正确</div>
					<div class="pad5 alignCenter">
						<input name="isAgree" type="checkbox" id="isAgree" value="1" checked="checked" />
						<label for="isAgree">同意BrandQQ.com用户服务协议</label>
						<input name="cmdSave" type="submit" class="cmdConfirm" value="创建用户" />
						<input name="AjaxAction" type="hidden" value="register" />
					</div>
				</form>
				</div>
			</div>
		</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
