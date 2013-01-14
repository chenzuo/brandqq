<%@ Page Language="C#" Debug="true" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Util" %>
<script runat="server">
    string shareLink = "";
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
            
            //如果还存在RESULTID等于当前ID的Cookie,则重置为0
            if (Member.TempInfo != null)
            {
                if (Member.TempInfo.ResultId == resultId)
                {
                    MemberTempInfo.ResetResultId();
                }
            }

            SimpleResultStatusRecord status = Result.GetResultStatus(resultId);
            if (status == null)
            {
                Response.Write("未找到相关记录");
                Response.End();
            }

            if (status.Guid != Member.Instance.Guid)
            {
                Response.Write("非法访问");
                Response.End();
            }

            if (((int)status.Status) >= ((int)ResultStatus.Finished))
            {
                shareLink = "<div class=\"pad5 alignRight\"><a href=\"bmceResultShare.aspx?id=" + status.Id.ToString() + "\"><img src=\"/images/btn_bmce_send_rst.gif\" style=\"border:none;\" alt=\"发送分享\" /></a>";
                //shareLink += " <br/>分享链接：http://www.brandqq.com/bmce/shareView.aspx?" + status.PaperSN.ToString() + status.Guid + status.Id.ToString();
                shareLink += "</div>";
            }

            ResultFile result = ResultFile.Load(resultId);

            if (result == null)
            {
                Response.Write("未找到相关记录");
                Response.End();
            }
            
            Company com=Company.Get(Member.Instance.Id);
            if(com==null)
            {
                try{
                    if(!result.UserInfo.Filled)
                    {
                        result.UserInfo.CopyToCompany(Member.Instance.Id);
                    }
                }
                catch
                {
                    //
                }
                
                if (((int)result.Status) >= ((int)ResultStatus.Finished))
                {
                    Message.Text = "<a href=mycompany.aspx>完成企业资料</a> 后，能得到更详细的评估报告!";
                }
            }
            else
            {
                
                BMCEResultFileView.Industry=com.Industry;
                if(com.IsChecked)
                {
                    BMCEResultFileView.ShowDetails=1;
                }
                else
                {
                    if (((int)result.Status) >= ((int)ResultStatus.Finished))
                    {
                        Message.Text = "<a href=mycompany.aspx>更新您的企业资料</a>，经过BrandQQ认证后，能得到详尽的评估报告!";
                    }
                }
            }
            BMCEResultFileView.FileId = resultId;
            
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/Ubb2Html.js;mybrandqq.js" Css="/skin/style.css" Title="我的BrandQQ" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<form method="post" id="Form" action="">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li class="active">评估报告</li>
					</ul>
				</div>
				
				<div class="body">
				    
				    <p>
					<asp:Label ID="Message" runat="server" style="display:block;" CssClass="font12"></asp:Label>
					</p>
					
					<%Response.Write(shareLink); %>
					
					<div class="ResultView">
					<BrandQQ:BMCEResultFileView ShowDetails="2" ShowScore="false" ID="BMCEResultFileView" runat="server" />
					</div>
					<%Response.Write(shareLink); %>
				</div>
			</div>
			<br />
			<div>
			图例：<img src="../skin/blank.gif" class="scoreLevel_A" />优秀&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="../skin/blank.gif" class="scoreLevel_B" />良好&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="../skin/blank.gif" class="scoreLevel_C" />一般&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="../skin/blank.gif" class="scoreLevel_D" />差&nbsp;&nbsp;&nbsp;&nbsp;
			</div>
		</form>
	</div>
	
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
