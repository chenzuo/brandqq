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
            writer.WriteLine("          <div class=\"topMenu\"> <a href=\"http://www.foresight.net.cn\" target=\"_blank\" title=\"��ӭ�������Ϲ�˾��վ\">����Ʒ�ƹ���</a> | ");

            if (Member.TempInfo != null)
            {
                if (!String.IsNullOrEmpty(Member.TempInfo.PaperSN) && Member.TempInfo.ResultId > 0 && HttpContext.Current.Request.Path.IndexOf("/bmce/default.aspx")==-1)
                {
                    writer.WriteLine("<a href=\"/bmce\"><img src=\"/images/bmce_go_on.gif\" border=\"0\" alt=\"��������\" title=\"����ǰ����δ��ɵĲ���\" /></a> ");
                }
            }
            
            if (Member.IsLogined)
            {
                writer.WriteLine("          <a href=\"/mybrandqq\">" + (String.IsNullOrEmpty(Member.Instance.Name) ? Member.Instance.Email : Member.Instance.Name) + "���ʻ�</a> <a href=\"/logout.aspx\">�˳���¼</a>");
                if (Member.Instance.IsSysUser)
                {
                    writer.Write(" <a href=\"/system\">����ϵͳ</a>");
                }
            }
            else
            {
                writer.WriteLine("          <a href=\"/login.aspx\">��¼</a> <a href=\"/reg.aspx\">�������û�</a>");
            }
            writer.WriteLine("          </div>");
            writer.WriteLine("          <ul class=\"globalMenu\">");
            writer.WriteLine("              <li" + (ActiveMenu == 1 ? " class=\"active1\"" : "") + "><a href=\"/\">�� ҳ</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 2 ? " class=\"active1\"" : "") + "><a href=\"/bmce\">Ʒ���Բ�</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 3 ? " class=\"active1\"" : "") + "><a href=\"/logo\">Logo <img src=\"/images/new.gif\" style=\"border:none;\" /></a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 4 ? " class=\"active1\"" : "") + "><a href=\"/bmi\">ָ������</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 5 ? " class=\"active1\"" : "") + "><a href=\"/bqipd\">�ƹ����</a></li>");
            writer.WriteLine("              <li" + (ActiveMenu == 6 ? " class=\"active2\"" : "") + "><a href=\"/mybrandqq\">�ҵ�BrandQQ</a></li>");
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
