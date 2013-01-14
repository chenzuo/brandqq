using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;

using BrandQQ.Membership;

namespace BrandQQ.WebControls.System
{
    public class SystemPageHeader:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            if (!Member.IsLogined)
            {
                Response.Redirect(LoginUrl);
                Response.End();
            }

            if (!Member.Instance.IsSysUser)
            {
                Response.Redirect(LoginUrl);
                Response.End();
            }
        }

        public string LoginUrl="/login.aspx";
    }

}
