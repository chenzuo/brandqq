using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.ComponentModel;

namespace BrandQQ.WebControls
{
    [ToolboxData(@"<{0}:PageFooter runat='server' />")]
    public class PageFooter : Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            base.Render(writer);
            writer.WriteLine("<div class=\"clearLine\"></div>");
            writer.WriteLine("<div id=\"Copyright\">");
            writer.WriteLine("<p>&copy; 2002-2007 BrandQQ.com All Rights Reserved <a href=\"http://www.miibeian.gov.cn\" target=\"_blank\">沪ICP备05000705号</a><//p>");
            writer.WriteLine("<p>");
            writer.WriteLine("<a href=\"/html/about.html\" target=\"_blank\">关于BrandQQ</a> | ");
            writer.WriteLine("<a href=\"/html/privacy.html\" target=\"_blank\">隐私声明</a> | ");
            writer.WriteLine("<a href=\"/html/contact.html\" target=\"_blank\">联系我们</a> | ");
            writer.WriteLine("<a href=\"/help/bmce.aspx\" target=\"_blank\">使用帮助</a> | ");
            writer.WriteLine("<a href=\"/html/feedback.html\" target=\"_blank\">用户反馈</a>");
            writer.WriteLine("</p>");
            writer.WriteLine("<script type=\"text/javascript\" src=\"http://js.tongji.linezing.com/367703/tongji.js\"></script>");
            writer.WriteLine("</div>");
        }
    }
}
