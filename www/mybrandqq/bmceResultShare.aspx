<%@ Page Language="C#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Util" %>
<script runat="server">
    string share = "";
    void Page_Load(object s,EventArgs e)
    {
        if(Request["id"]!=null)
        {
            int resultId = 0;

            try
            {
                resultId = Convert.ToInt32(Request["id"]);
            }
            catch
            {
                //
            }

            if (resultId == 0)
            {
                Response.Write("错误的参数");
                Response.End();
            }
            
            SimpleResultStatusRecord status = Result.GetResultStatus(resultId);
            if (status == null)
            {
                Response.Write("未找到相关记录");
                Response.End();
            }

            share = status.PaperSN.ToString() + "," + status.Guid + "," + status.Id.ToString();
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/Ubb2Html.js;mybrandqq.js" Css="/skin/style.css" Title="我的BrandQQ" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body onload="InitShareMyBMCEResultForm();">
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<form method="post" id="MyShareForm" action="" onsubmit="return ShareMyBMCEResult();">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li><a href="mylogos.aspx">我的Logo</a></li>
						<li class="active">分享测试结果</li>
					</ul>
				</div>
				
				<div class="body">
				    <div class="activeTip" id="MESSAGE">您可以同时将您的评估报告分享给多个人！</div>
					<div class="pad5">分享给：
						<input name="maillist" type="text" size="60" maxlength="300" />
						<img src="../skin/blank.gif" alt="验证" class="valid" id="formValid1" /><span id="formValidMsg1"></span>
					</div>
					<div class="font12" style="padding-left:65px;">请输入Email地址，多个地址之间用分号隔开，最多10个地址</div>
					<div class="pad5">我的留言(最多300字)：</div>
					<div style="padding:5px 20px;">
						<textarea name="message" rows="5"></textarea><br />
						<img src="../skin/blank.gif" alt="验证" class="valid" id="formValid2" /><span id="formValidMsg2"></span>
					</div>
					<div class="pad5">
					我的邮件：<input name="mymail" type="text" size="40" maxlength="40" value="<%Response.Write(Member.Instance.Email); %>" />
					<img src="../skin/blank.gif" alt="验证" class="valid" id="formValid3" /><span id="formValidMsg3"></span>
					</div>
					
					<div class="font12" style="padding-left:70px;">您可以输入您的其他邮件地址，方便您的朋友给您回复</div>
					
					<div class="pad5 alignCenter">
						<input name="CmdSend" type="submit" class="cmdConfirm" value="发送分享" />
						<input name="result" type="hidden" value="<%Response.Write(share); %>" />
						<input name="AjaxAction" type="hidden" value="sendbmceresultshare" />
					</div>
					
				</div>
			</div>
		</form>
	</div>
	
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
