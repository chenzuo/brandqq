<%@ Page Language="C#" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    private LogoType logoType;
    private void Page_Load(object sender, EventArgs e)
    {   
        LogoList.Pager.PageSize = 15;
        LogoList.Pager.Method = PagerHttpMethod.POST;
        LogoList.Pager.FormId = "logoListForm";
        
        LogoList.Type = LogoType.Record;
        LogoList.UserId = Member.Instance.Id;

        if (Request.Form["__pageindex"] != null)
        {
            LogoList.Pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        StringBuilder html = new StringBuilder();
        html.AppendLine("<div class=\"floatLeft alignCenter pad5\" style=\"margin:5px;\">");
        html.AppendLine("<a href=\"/logo/logoview?{4}{3}{7}{2}.{1}\" target=\"_blank\">");
        html.AppendLine("<img style='border:1px solid #DDD;' src='/logo/img?{4}{3}{7}.{1}' width='120' height='90' alt='{9}'/>");
        html.AppendLine("<br/>{5}</a>");
        html.AppendLine("</div>");
        
        LogoList.RepeatTemplate = html.ToString();
        
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js" Css="/skin/style.css" Title="我的Logo" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<form method="post" id="logoListForm" action="">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li class="active"><a href="mylogos.aspx">我的Logo</a></li>
					</ul>
				</div>
				
				<div class="body">
					<p>我最近设计的Logo</p>
					<div>
					    <BrandQQ:LogoList ID="LogoList" runat="server" />
					    <div class="clear"></div>
					</div>
					<div class="alignCenter pad5"><%Response.Write(LogoList.Pager.PagerHtml); %></div>
				</div>
			</div>
		</form>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
