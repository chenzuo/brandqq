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
        /// ����һ��Email��ַ�Ƿ��Ѵ���
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
        /// �����û�����
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
        /// �����һ�������ʼ�
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
                    mail.Title = "����BrandQQ��������ʾ";
                    mail.Body = "�����·�������,�Ա������������ĵ�¼����\n\n";

                    mail.Body += "��������ܵ������,�븴���·��ĵ�ַ��������ҳ�������ַ���н��з���!\n\n";
                    mail.Body += url;
                    mail.Body += "\n\n(ע:�������ӵ�ַֻ����Чʹ��һ��,�ڶ�����������ʱ,���BrandQQ.com��ȡ�µ���ʾ�ʼ�)";
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
        /// ����Logo��ֵ
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
