<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    private string styleCode = "";
    private string styleName = "";

    private int pageindex = 1;
    private Pager pager = new Pager(1, 20);
    private StringBuilder html = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["PAGEINDEX"] != null)
        {
            try
            {
                pager.PageIndex = Convert.ToInt16(Request["PAGEINDEX"]);
            }
            catch
            {
                //
            }
        }
        
        if (Request["s"]!=null)
        {
            styleCode = Request["s"].Trim();
            LogoStyle style = LogoImitation.GetStyle(styleCode);
            if (style != null)
            {
                styleName = style.Name;
                HtmlHeader1.Title = "Logo模仿秀-模仿" + styleName + " 自助在线Logo设计 - BrandQQ - 中小企业品牌建设，品牌管理,品牌能力，在线品牌管理";
            }
            else
            {
                styleCode = "";
            }
        }

        foreach (LogoShowItem item in LogoShowItem.List(pager, styleCode))
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td><img src=\"LogoImage.aspx?g=" + item.Guid + "&s=" + item.StyleId + "\" alt=\"" + item.Text + "\" style=\"border:1px dotted #666;\" /></td>");
            html.AppendLine("<td>" + item.Text + "</td>");
            html.AppendLine("<td>" + item.Datetime.ToString() + "</td>");
            html.AppendLine("</tr>");
        }

        if (html.Length == 0)
        {
            html.AppendLine("<tr><td colspan=\"3\">无模仿" + styleName + "的作品 <a href=\"./\">我来模仿一个</a></td></tr>");
        }
        pager.Method = PagerHttpMethod.GET;
        pager.PrefixUrl = "logos.aspx?s=" + styleCode + "";
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader1" 
    Jscript="../jscript/logoImitation.js;../jscript/String.prototype.js" 
    Css="../skin/style.css" 
    Title="Logo模仿秀 自助在线Logo设计 - BrandQQ - 中小企业品牌建设，品牌管理,品牌能力，在线品牌管理"
    Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,品牌管理能力指数" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务"
    runat="server" />
<body>
    <BrandQQ:PageHeader ID="PageHeader1" runat="server" />
    <div class="globalLayout">
        <form id="logoISForm" method="post" onsubmit="return makeLogoImitation(this);">
            <div class="box1">
                <div class="inner">
                    <h1>Logo模仿秀-模仿<%Response.Write(styleName); %>作品</h1>
                    <h2><a href="./">我来模仿</a></h2>
                    <div class="body">
                        <div class="alignRight"><%Response.Write(pager.PagerHtml); %></div>
                        <table border="0" width="100%">
                            <tr>
                                  <th>Logo</th>
                                  <th>名称</th>
                                  <th>创作时间</th>
                            </tr>
                            <%
                                Response.Write(html.ToString());
                            %>
                        </table>
                        <div class="alignRight"><%Response.Write(pager.PagerHtml); %></div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
