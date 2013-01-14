<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    private string code="";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString != null)
        {
            code = Request.QueryString.ToString();
        }
        CompanyList.IndustryCode = code;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="../jscript/Ubb2Html.js" Css="../skin/style.css" Title="最新加入的企业 - 面向中小企业的品牌管理自助平台 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />
<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
	    <script language="javascript" type="text/javascript">
	        FlashPlayer("../images/topBanner.swf?2007-11-19",800,160);
	    </script>
	</div>
	
	<div class="globalLayout">
	
	    <div class="leftLayout">
	        <div class="box2">
			    <div class="inner">
				    <h1>最新加入的企业</h1>
				    <div class="body">
				    <ul>
				    <BrandQQ:DataList ID="CompanyList" IsCheckedCompany="1" Type="company2" 
				        RepeatTemplate="<li>{1}</li>" Count="200" runat="server" />
				    </ul>
				    </div>
			    </div>
		    </div>
		</div>
	
	    <div class="rightLayout">
	        <!--//行业-->
	        <div class="box1">
			    <div class="inner">
				    <h1>按照行业浏览</h1>
		            <div class="body">
		                <%
                            foreach (Industry indus in IndustryUtil.Industries)
                            {
                                Response.Write("<div><strong>" + indus.Name + "</strong></div>");
                                foreach (Industry sub in indus.Children)
                                {
                                    Response.Write("<span><a href='?" + sub.Code + "'>" + sub.Name + "</a></span> | ");
                                }
                            }
		                 %>
		            </div>
		        </div>
		    </div>
		    <!--行业//-->
		</div>
	
	    
	    <div class="clearLine"></div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
	
</body>
</html>
