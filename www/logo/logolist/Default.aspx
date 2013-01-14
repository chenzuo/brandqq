<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    private int pageindex=1;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["PAGEINDEX"] != null)
        {
            try
            {
                pageindex = Convert.ToInt16(Request["PAGEINDEX"]);
                if (pageindex < 1) pageindex = 1;
            }
            catch
            {
                //
            }
        }

        LogoList.Pager.PrefixUrl = "./";
        LogoList.Pager.Method = PagerHttpMethod.GET;
        LogoList.Pager.PageIndex = pageindex;
        LogoList.Pager.PageSize = 10;

        StringBuilder html = new StringBuilder();
        html.AppendLine("<div style=\"border-bottom:1px dotted #0CF;\">");
        html.AppendLine("   <div class=\"floatLeft alignCenter\">");
        html.AppendLine("       <p><a href=\"../logoview?{4}{3}{7}{2}.{1}\">");
        html.AppendLine("       <img src=\"../img?{4}{3}{7}.{1}\" alt=\"{5}\" width=\"120\" height=\"90\" style=\"border:none\"/>");
        html.AppendLine("       </a></p>");
        html.AppendLine("       <p><span class=\"logoScore\"><img src=\"../../skin/icon_good.gif\" alt=\"评价\" style=\"margin-bottom:-3px;\" />{6}</span></p>");
        html.AppendLine("   </div>");
        html.AppendLine("   <div class=\"floatLeft pad5\">");
        html.AppendLine("       <p><a href=\"../logoview?{4}{3}{7}{2}.{1}\">{5}</a> </p>");
        html.AppendLine("       <p>作者：{9}</p>");
        html.AppendLine("       <p>创建日期：{8}</p>");
        html.AppendLine("       <p></p>");
        html.AppendLine("   </div>");
        html.AppendLine("   <p class=\"clear\"/>");
        html.AppendLine("</div>");
        LogoList.RepeatTemplate = html.ToString();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader1" Jscript="../../jscript/String.prototype.js;../../jscript/AjaxRequest.js" Css="../../skin/style.css" Title="Logo - 免费在线Logo设计 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,品牌管理能力指数" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader1" runat="server" />
	<div class="globalLayout">
	    <div class="leftLayout">
		    <div class="box1">
			    <div class="inner">
				    <h1>Logo作品</h1>
				    <h2><a href="/logo/flex">开始创作Logo</a></h2>
				    <div class="body">
				        <BrandQQ:LogoList ID="LogoList" Enabled="true" runat="server" />
				    </div>
				    <div class="font12 pad5">
		            <%Response.Write("共 <strong>" + LogoList.Pager.RecordCount.ToString() + "</strong> 个Logo作品，分 <strong>" + LogoList.Pager.PageCount.ToString() + "</strong> 页显示，当前在第 <strong>" + LogoList.Pager.PageIndex + "</strong> 页　　" + LogoList.Pager.PagerHtml); %>
		            </div>
			    </div>
		    </div>
		    
    	</div>
		
		
		<div class="rightLayout">
		    <div class="box2">
				<div class="inner">
					<div class="body">
					    
					</div>
				</div>
			</div>
		
		
		    <div class="box3">
				<div class="inner">
					<h1>LOGO人气排行榜</h1>
					<h2></h2>
					<div class="body">
					    <BrandQQ:LogoList ID="LogoListByScore" Count="10" Sort="12" 
					    RepeatTemplate="<div class='pad5 floatLeft'><a href='../logoview?{4}{3}{7}{2}.{1}'><img src='../img?{4}{3}{7}.{1}' alt='{5}' width='120' height='90' style='border:none'/></a></div><div class='pad5 floatLeft' style='width:120px;'><p><span class='logoScore'>{6}</span></p><p>{9}</p></div><div class='clear'></div>" 
					    Enabled="true" runat="server" />
					</div>
				</div>
			</div>
						
		</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
