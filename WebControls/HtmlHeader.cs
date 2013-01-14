using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.BMCE;
using BrandQQ.Membership;
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    [ToolboxData(@"<{0}:HtmlHeader runat='server' />")]
    public class HtmlHeader:Control
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (HttpContext.Current.Request.Path.ToLower().IndexOf("/mybrandqq") != -1 && !Member.IsLogined)
            {
                HttpContext.Current.Response.Redirect("/login.aspx");
            }

        }
        protected override void Render(HtmlTextWriter writer)
        {
            

            writer.WriteLine("<head>");
            writer.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />");
            writer.WriteLine("<meta name=\"keywords\" content=\"" + keywords + "\" />");
            writer.WriteLine("<meta name=\"description\" content=\"" + description + "\" />");
            writer.WriteLine("<meta name=\"Author\" content=\"mickeydream@hotmail.com\" />");
            writer.WriteLine("<meta name=\"Copyright\" content=\"BrandQQ.com\" />");
            writer.WriteLine("<title>" + title + " - " + keywords + " - BrandQQ.com</title>");
            if (!String.IsNullOrEmpty(css))
            {
                foreach (string s in css.Split(';'))
                {
                    if (!String.IsNullOrEmpty(s))
                    {
                        writer.WriteLine("<link href=\"" + s + "\" rel=\"stylesheet\" type=\"text/css\" />");
                    }
                }
            }

            if (!String.IsNullOrEmpty(jscript))
            {
                foreach (string s in jscript.Split(';'))
                {
                    if (!String.IsNullOrEmpty(s))
                    {
                        writer.WriteLine("<script language=\"javascript\" type=\"text/javascript\" src=\"" + s + "\"></script>");
                    }
                }
            }
            
            writer.WriteLine("</head>");
        }

        public string Jscript
        {
            set
            {
                jscript = value;
            }
        }

        public string Css
        {
            set
            {
                css = value;
            }
        }

        public string Title
        {
            set
            {
                title = value;
            }
        }

        public string Keywords
        {
            set
            {
                keywords = value;
            }
        }

        public string Description
        {
            set
            {
                description = value;
            }
        }

        private string jscript;
        private string css;
        private string title;
        private string keywords;
        private string description;
    }
}
