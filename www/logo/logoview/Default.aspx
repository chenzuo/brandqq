<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    private LogoBase logo;
    private string imgSrc;
    
    //private StringBuilder listHtml1 = new StringBuilder();
    //private StringBuilder listHtml2 = new StringBuilder();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString == null)
        {
            Response.Write("Error parameter(s)!");
            Response.End();
        }

        string id = Request.QueryString.ToString();

        if (id.Split('.').Length != 2)
        {
            Response.Write("Error parameter(s)!");
            Response.End();
        }
        
        string guid = id.Split('.')[1];
        id = id.Split('.')[0];

        logo = LogoBase.Get(guid);

        if (logo == null)
        {
            Response.Write("Logo not found!");
            Response.End();
        }

        HtmlHeader.Title = "Logo作品:" + logo.Title + " 免费在线Logo设计 ";

        //行业对比列表
        /*ArrayList industryCompareList = LogoBase.GetComparesList(LogoCompareType.IndustryCompare, guid);

        listHtml1.AppendLine("<div class=\"floatLeft alignCenter pad5\" style=\"width:140px;\">");
        listHtml1.AppendLine("<img src=\"../img?" + logo.ImageSrc + "\" width=\"120\" height=\"90\" alt=\"" + logo.Title + "\" />");
        listHtml1.AppendLine("<br/>" + logo.Title + "<br/>");
        listHtml1.AppendLine("<img src=\"../../skin/blank.gif\" class=\"goodLogo1\" alt=\"更喜欢这个\" title=\"更喜欢这个\" onclick=\"javascript:addScore2('" + logo.Guid + "',this);\" />");
        listHtml1.AppendLine("</div>");
        
        
        foreach (LogoBase compareLogo in industryCompareList)
        {
            listHtml1.AppendLine("<div class=\"floatLeft alignCenter pad5\" style=\"width:140px;\">");
            listHtml1.AppendLine("<img src=\"../img?" + compareLogo.ImageSrc + "\" width=\"120\" height=\"90\" alt=\"" + compareLogo.Title + "\" />");
            listHtml1.AppendLine("<br/>" + compareLogo.Title + "<br/>");
            listHtml1.AppendLine("<img src=\"../../skin/blank.gif\" class=\"goodLogo1\" alt=\"更喜欢这个\" title=\"更喜欢这个\" onclick=\"javascript:addScore2('" + compareLogo.Guid + "',this);\" />");
            listHtml1.AppendLine("</div>");
        }

        //内部比较列表
        ArrayList internalCompareList = LogoBase.GetComparesList(LogoCompareType.InternalCompare, guid);
        foreach (LogoBase compareLogo in internalCompareList)
        {
            listHtml2.AppendLine("<div class=\"floatLeft alignCenter pad5\">");
            listHtml2.AppendLine("<img src=\"../img?" + compareLogo.ImageSrc + "\" width=\"120\" height=\"90\" alt=\"" + compareLogo.Title + "\" />");
            listHtml2.AppendLine("<br/>" + compareLogo.Title + "</div>");
        }*/
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" 
        Jscript="../../jscript/String.prototype.js;../../jscript/AjaxRequest.js;../../jscript/Cookies.js;../../jscript/LogoFunctions.js" 
        Css="../../skin/style.css" 
        Keywords="中小企业品牌建设，免费在线Logo设计,品牌管理,品牌能力，在线品牌管理,品牌管理能力指数" 
        Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader1" runat="server" />
	<div class="globalLayout">
	    <div class="box1">
		    <div class="inner">
			    <h1>Logo作品：<%Response.Write(logo.Title); %></h1>
			    <h2></h2>
			    <div class="body">
			        <div class="floatLeft">
			            <img src="../img?<%Response.Write(logo.ImageSrc);%>" width="120" height="90" alt="<%Response.Write(logo.Title);%>" style="border:none;" />
			        </div>
			        <div class="floatLeft">
			            <p>作者：<%Response.Write(logo.ComName); %></p>
			            <p>创作时间：<%Response.Write(logo.CreateDatetime.ToString()); %></p>
			            <%if (!String.IsNullOrEmpty(logo.Description))
                         {
                             Response.Write("<p>作品简介：" + logo.Description + "</p>");
                         } %>
			        </div>
			        <div class="floatRight alignCenter" style="padding:20px;">
			            <span class="logoScore" id="LOGOSCORE"><%Response.Write(logo.Score.ToString().PadLeft(6,'0')); %></span>
			            <div class="pad5">
			                <img src="../../skin/btn_good.png" alt="给予支持" title="给予支持" 
			                    style="border:none;cursor:pointer;" onclick="javascript:addScore('<%Response.Write(logo.Guid); %>',document.getElementById('LOGOSCORE'));" />
			            </div>
			        </div>
			        <div class="clear"></div>
			    </div>
		    </div>
	    </div>
	    
	    
	    <%/* %>
	    <div class="box1">
		    <div class="inner">
			    <h1>行业评比</h1>
			    <h2>
			    <%
                    if (Member.IsLogined)
                    {
                        if (Member.Instance.Id == logo.UserId)//当前用户
                        {
                            Response.Write("上传Logo进行对比");
                        }
                    }
			     %>
			    </h2>
			    <div class="body">
			       <%Response.Write(listHtml1.ToString()); %>
			       <div class="clear"></div>
			    </div>
		    </div>
	    </div>
	    
	    
	    
	    <%if(listHtml2.ToString()!=""){ %>
	    <div class="box1">
		    <div class="inner">
			    <h1>请您定夺</h1>
			    <h2></h2>
			    <div class="body">
			       <%//Response.Write(listHtml2.ToString()); %>
			    </div>
		    </div>
	    </div>
	    <%} %>
	    
	    <%*/ %>
	      
	    <div class="box3">
		    <div class="inner">
			    <h1>最近Logo作品</h1>
			    <h2></h2>
			    <div class="body alignCenter">
			       <BrandQQ:LogoList ID="LogoListByUserId" Count="5" Enabled="true" runat="server" 
			        RepeatTemplate="<div class='floatLeft alignCenter' style='padding:5px 15px 5px 10px;'><a href='../logoview?{4}{3}{7}{2}.{1}'><img src='../img?{4}{3}{7}.{1}' style='width:120px;height:90px;border:none;' alt='{5}'/><br/>{5}</a></div>" />
			       <div class="clear"></div>
			    </div>
		    </div>
	    </div>
	    
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
