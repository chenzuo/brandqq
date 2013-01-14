using System;
using System.Collections.Generic;
using System.Text;

using System.Web;
using System.Web.UI;

using BrandQQ.Membership;
using BrandQQ.BMCE;
using BrandQQ.Util;
using BrandQQ.Logo;

namespace BrandQQ.WebControls
{
    public class AjaxGet:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            string text = "FAILED";
            if (Request["AjaxAction"] != null)
            {
                switch (Request["AjaxAction"].ToLower())
                {
                    case "checkemail":
                        text=Checkemail();
                        break;
                    case "updatemyname":
                        text = UpdateMyName();
                        break;
                    case "chkgetpassemail":
                        text = SendGetPassEmail();
                        break;
                    case "addlogoscore":
                        text = AddLogoScore();
                        break;
                }
            }
            Response.Write(text);
            Response.End();
        }

        /// <summary>
        /// 检验一个Email地址是否已存在
        /// </summary>
        /// <returns></returns>
        private string Checkemail()
        {
            string str = "EXISTS";
            if (Request["email"] != null)
            {
                if (!Member.IsExistEmail(Request["email"].Trim()))
                {
                    str = "NOTEXISTS";
                }
            }
            return str;
        }

        /// <summary>
        /// 更新用户名字
        /// </summary>
        /// <returns></returns>
        private string UpdateMyName()
        {
            string str = "FAILED";
            if (Request["name"] != null && Member.IsLogined)
            {
                Member m = Member.Get(Member.Instance.Id);
                m.Name = Request["name"].Trim();
                m.Save();
                str = "OK";
            }
            return str;
        }

        /// <summary>
        /// 发送找回密码的邮件
        /// </summary>
        /// <returns></returns>
        private string SendGetPassEmail()
        {
            string str = "FAILED";
            if (Request["email"] != null)
            {
                string email = Request["email"].Trim();
                if (Member.IsExistEmail(email))
                {
                    string guid = Util.Utility.NewGuid;
                    string url = "http://www.brandqq.com/resetpwd.aspx?email=" + email + "&guid=" + guid;
                    Email mail = new Email();
                    mail.Title = "您在BrandQQ的密码提示";
                    mail.Body = "请点击下方的链接,以便重新设置您的登录密码\n\n";

                    mail.Body += "如果您不能点击链接,请复制下方的地址到您的网页浏览器地址栏中进行访问!\n\n";
                    mail.Body += url;
                    mail.Body += "\n\n(注:上述链接地址只能有效使用一次,第二次重置密码时,请从BrandQQ.com获取新的提示邮件)";
                    mail.Encode = Encoding.UTF8;
                    mail.IsHtml = false;
                    mail.Sender = GeneralConfig.MailSenderInstance;
                    mail.Send(email);

                    Member.UpdateGuid(email, guid);

                    str = "OK";
                }
            }

            return str;
        }

        /// <summary>
        /// 增加Logo分值
        /// </summary>
        /// <returns></returns>
        private string AddLogoScore()
        {
            string guid = "";
            int score=0;
            if (Request["g"] != null && Request["s"] != null)
            {
                guid = Request["g"].Trim();
                try
                {
                    score = Convert.ToInt32(Request["s"]);
                }
                catch
                {
                    //
                }
            }

            LogoBase.AddScore(guid);
            score++;
            return score.ToString().PadLeft(6,'0');
        }
    }
}
