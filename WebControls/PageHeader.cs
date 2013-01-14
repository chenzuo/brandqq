using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.Membership;

namespace BrandQQ.WebControls
{
    [ToolboxData(@"<{0}:PageHeader runat='server' />")]
    public class PageHeader:Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            writer.WriteLine("<div id=\"PageHeader\" class=\"clear\">");
            writer.WriteLine("  <div class=\"logo\"><img src=\"/skin/logo.gif\" alt=\"logo\" width=\"180\" height=\"60\" /></div>");
            writer.WriteLine("      <div id=\"GlobalMenuContainor\">");
            writer.WriteLine("          <div class=\"topMenu\"> <a href=\"http://www.foresight.net.cn\" target=\"_blank\" title=\"欢迎访问迈迪公司网站\">迈迪品牌管理</a> | ");

            if (Member.TempInfo != null)
            {
                if (!String.IsNullOrEmpty(Member.TempInfo.PaperSN) && Member.TempInfo.ResultId > 0 && HttpContext.Current.Request.Path.IndexOf("/bmce/default.aspx")==-1)
                {
                    writer.WriteLine("<a href=\"/bmce\"><img src=\"/images/bmce_go_on.gif\" border=\"0\" alt=\"继续测试\" title=\"您当前有尚未完成的测试\" /></a> ");
                }
            }
            
            if (Member.IsLogined)
            {
                writer.WriteLine("          <a href=\"/mybrandqq\">" + (String.IsNullOrEmpty(Member.Instance.Name) ? Member.Instance.Email : Member.Instance.Name) + "的帐户</a> <a href=\"/logout.aspx\">退出登录</a>");
                if (Member.Instance.IsSysUser)
                {
                    writer.Write(" <a href=\"/system\">管理系统</a>");
                }
            }
            else
            {
                writer.WriteLine("          <a href=\"/login.aspx\">登录</a> <a href=\"/reg.aspx\">创建新用户</a>");
            }
            writer.WriteLine("          </div>");
            writer.WriteLine("          <ul class=\"globalMenu\">");
            writer.WriteLine("              <li" + (ActiveMenu == 1 ? " class=\"active1\"" : "") + "><a href=\"/\">首 页</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 2 ? " class=\"active1\"" : "") + "><a href=\"/bmce\">品牌自测</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 3 ? " class=\"active1\"" : "") + "><a href=\"/logo\">Logo <img src=\"/images/new.gif\" style=\"border:none;\" /></a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 4 ? " class=\"active1\"" : "") + "><a href=\"/bmi\">指数发布</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 5 ? " class=\"active1\"" : "") + "><a href=\"/bqipd\">推广诊断</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 6 ? " class=\"active2\"" : "") + "><a href=\"/mybrandqq\">我的BrandQQ</a></li>");
            writer.WriteLine("          </ul>");
            writer.WriteLine("      </div>");
            writer.WriteLine("      <div class=\"clearLine\"></div>");
            writer.WriteLine(" </div>");
            writer.WriteLine("<div class=\"clearLine\"></div>");
        }

        private int ActiveMenu
        {
            get
            {
                if (HttpContext.Current.Request.Path.ToLower() == "/default.aspx")
                {
                    return 1;
                }
                else if (HttpContext.Current.Request.Path.ToLower().IndexOf("/bmce") != -1)
                {
                    return 2;
                }
                else if (HttpContext.Current.Request.Path.ToLower().IndexOf("/logo") != -1)
                {
                    return 3;
                }
                else if (HttpContext.Current.Request.Path.ToLower().IndexOf("/bmi") != -1)
                {
                    return 4;
                }
                else if (HttpContext.Current.Request.Path.ToLower().IndexOf("/bqipd") != -1)
                {
                    return 5;
                }
                else if (HttpContext.Current.Request.Path.ToLower().IndexOf("/mybrandqq") != -1)
                {
                    return 6;
                }
                else
                {
                    return 1;
                }
            }
        }
    }
}
