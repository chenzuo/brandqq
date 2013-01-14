<%@ Page Language="C#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;mybrandqq.js" Css="/skin/style.css" Title="我的BrandQQ" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<form method="post" id="UserForm" action="">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li class="active"><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li><a href="mylogos.aspx">我的Logo</a></li>
					</ul>
				</div>
				
				<div class="body">
					<div class="clientMsgNotice">您帐户的电子邮件地址是：<strong><%Response.Write(Member.Instance.Email);%></strong></div>
					<p>&nbsp;</p>
					<p>您的名字：<%Response.Write(String.IsNullOrEmpty(Member.Instance.Name) ? "&lt;未设置(如果已更改，下次登录后更新)&gt;" : Member.Instance.Name);%></p>
					<br />
					<p class="lineheight35;"><strong>您可以修改您的登录密码</strong></p>
					<p class="lineheight35;">
					输入新密码：
					<input name="mypass" type="password" id="mypass" size="25" maxlength="20" />
					<img src="../skin/blank.gif" alt="验证" class="valid" id="formValid1" /><span id="formValidMsg1"></span>
					</p>
					<p class="lineheight35;">
					确认新密码：
					<input name="mypass2" type="password" id="mypass2" size="25" maxlength="20" />
					<img src="../skin/blank.gif" alt="验证" class="valid" id="formValid2" /><span id="formValidMsg2"></span>
					</p>
					<p class="lineheight35;">　　　　　　
					<input name="cmdUpdatePass" type="button" class="cmdGeneral" id="cmdUpdatePass" value="保存修改" onclick="updateMyPass(this.form);" />
					<input type="hidden" name="AjaxAction" value="UpdatePass" />
					<br/>
					</p>
					<p>&nbsp;</p>
				</div>
			</div>
		</form>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
