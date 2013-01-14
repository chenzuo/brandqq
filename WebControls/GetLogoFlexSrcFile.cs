using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;

using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    public class GetLogoFlexSrcFile:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            GetFile();
        }

        private void GetFile()
        {
            //if (Request.UrlReferrer != null && Request.UrlReferrer.Host.ToLower().IndexOf("brandqq.com")==-1)
            //{
            //    return;
            //}

            if (!Request.UserAgent.StartsWith("Mozilla")
                && !Request.UserAgent.StartsWith("Opera"))
            {
                return;
            }

            string fileSrc = GeneralConfig.Instance.LogoDataSourcePath + "BrandQQLogoSys.swf";

            Response.Clear();
            Response.ContentEncoding = Encoding.UTF8;
            Response.ContentType = "application/x-shockwave-flash";
            Response.WriteFile(fileSrc);
        }
    }
}
