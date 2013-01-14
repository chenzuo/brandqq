using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;

using BrandQQ.Logo;
using BrandQQ.Membership;
using BrandQQ.Util;

namespace BrandQQ.WebControls.System
{
    public class LogoAjaxResponse:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            if (!Member.IsLogined)
            {
                Response.End();
            }

            if (!Member.Instance.IsSysUser)
            {
                Response.End();
            }

            string result="";
            if (Request["action"] != null)
            {
                switch (Request["action"].ToLower())
                {
                    case "setlogoenabled":
                        result = SetLogoEnabled();
                        break;
                }
            }
            Response.Write(result);
            Response.End();
        }

        /// <summary>
        /// �л�Logo�Ŀ���״̬
        /// </summary>
        /// <returns></returns>
        private string SetLogoEnabled()
        {
            if (Request["guid"] != null)
            {
                LogoBase.SwitchEnabled(Request["guid"].Trim());
                return "ok,�������";
            }
            return "failed,����ʧ��";
        }
    }
}
