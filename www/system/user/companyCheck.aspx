<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    int cid = 0;
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            cid = Convert.ToInt32(Request["id"]);
            Company com = Company.Get(cid);
            if (com != null)
            {
				Member m = Member.Get(cid);

                ComName.Text = com.ComName;
                ComId.Value = cid.ToString();
                MailTitle.Text = "恭喜您成为品牌经理人-BrandQQ的认证用户！";
                MailBody.Text = "尊敬的 " + (String.IsNullOrEmpty(com.Contact)?com.ComName:com.Contact) +",您好！\n\n";
                MailBody.Text += "经过我们的认证检查，贵公司的信息已填写详实，我们已经对 “"+com.ComName+"” 进行了认证，感谢您对“品牌经理人”网站的支持！\n\n";
                MailBody.Text += "特别提示：\n";
				MailBody.Text += "1、贵公司品牌管理能力完整的分析报告，包括“7大品牌力”的分析，在网上您的帐户里有保存；\n";
				MailBody.Text += "2、您已成为认证用户，可以得到更为详尽的分题答案，并赠送价值3000元的完整版《中国企业品牌管理能力白皮书》（1、2期），下载地址http://brandqq.brandmanager.com.cn/bmi \n\n";
				MailBody.Text += "-------------------------------------------------\n\n";
				MailBody.Text += "您在BrandQQ的登录用户名是："+m.Email+"，（如果您忘记密码，可以在http://brandqq.brandmanager.com.cn/login.aspx 找回）\n\n";
				MailBody.Text += "品牌经理人-brandqq工具\nhttp://brandqq.brandmanager.com.cn";

                
                EmailLabel.Text=ComEmail.Value = m.Email;
            }
        }
    }

    private void CmdCheck_Click(object s, EventArgs e)
    {
        if (ComEmail.Value != "")
        {
            Company.Check(Convert.ToInt32(ComId.Value), IsCheck.Checked);
            Email.SendMail(ComEmail.Value, MailTitle.Text, MailBody.Text, false, GeneralConfig.MailSenderInstance);
            ((Button)s).Enabled = false;
            EmailLabel.Text += " (通知已发送)";
            EmailLabel.Style["color"] = "#F00";
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
<form runat="server" method="post" id="ComForm" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="default.aspx">基本帐户管理</a></li>
				<li><a href="companies.aspx">企业用户管理</a></li>
				<li class="active">认证企业</li>
			</ul>
		</div>
		
		<div class="body">
			<div class="pad5">认证企业：<asp:Label ID="ComName" runat="server"></asp:Label></div>
			<div class="pad5">邮件地址：<asp:Label ID="EmailLabel" runat="server"></asp:Label></div>
			<div class="pad5">通知邮件标题：<asp:TextBox ID="MailTitle" Columns="50" CssClass="txt" runat="server"></asp:TextBox></div>
			<div class="pad5">通知邮件内容：</div>
			<div class="pad5">
                <asp:TextBox ID="MailBody" TextMode="MultiLine" Rows="15" Columns="50" runat="server"></asp:TextBox>
            </div>
            <div class="pad5">
                <asp:CheckBox ID="IsCheck" runat="server" Text="通过认证" Checked="true" /></div>
			<div class="footer">
                <asp:Button ID="CmdCheck" runat="server" Text="确定" CssClass="cmdConfirm" OnClick="CmdCheck_Click" />
				<input name="cmdCompanyDetails" type="button" class="cmdGeneral" id="cmdCompanyDetails" value="查看明细" onclick="location='companyDetails.aspx?id=<%Response.Write(cid);%>';" />
				<asp:HiddenField ID="ComId" runat="server" />
				<asp:HiddenField ID="ComEmail" runat="server" />
			</div>

		</div>
	</div>
</form>
</body>
</html>
