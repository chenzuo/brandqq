using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Net;

using BrandQQ.Membership;
using BrandQQ.BMCE;
using BrandQQ.Util;
using BrandQQ.BQIPD;

namespace BrandQQ.WebControls
{
    public class AjaxPost:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            string text = "";
            if (Request.HttpMethod == "POST")
            {
                string action = Request.Form["AjaxAction"];
                switch (action.ToLower())
                {
                    case "login":
                        text=Login();
                        break;
                    case "register":
                        text=Register();
                        break;
                    case "savecompany":
                        text = SaveCompany();
                        break;
                    case "resetpass":
                        text = ResetPass();
                        break;
                    case "saveresultremark":
                        text = SaveResultRemark();
                        break;
                    case "sendbmceresultshare":
                        text = SendBMCEResultShare();
                        break;
                    case "updatepass":
                        text = UpdateMyPass();
                        break;

                    case "bqipd":
                        text = BQIPD();
                        Response.ContentEncoding = Encoding.UTF8;
                        Response.ContentType = "text/xml";
                        break;

                    case "me"://module evaluation
                        text = MEval();
                        break;

                    case "bqipdfollow"://BQIPD Follow
                        text = BQIPDFollow();
                        break;
                }
            }

            Response.Write(text);
            Response.End();
        }

        /// <summary>
        /// �����û���������
        /// </summary>
        /// <returns></returns>
        private string BQIPDFollow()
        {
            string str = "FAILED";

            if (!Member.IsLogined)
            {
                return str;
            }

            if (Request.Form["domain"] != null)
            {
                BQIPDRecords.SaveUserFollow(new QueryUrl(Request.Form["domain"]).Host);
                str = "OK";
                /*try
                {
                    
                }
                catch
                {
                }*/
            }
            return str;
        }

        /// <summary>
        /// ��������
        /// </summary>
        /// <returns></returns>
        private string UpdateMyPass()
        {
            string str = "FAILED";
            if (Request.Form["mypass"] != null && Request.Form["mypass2"] != null)
            {
                Member.ResetPassword(Request.Form["mypass"].Trim());
                str = "OK";
            }

            return str;
        }

        /// <summary>
        /// ���ͷ���
        /// </summary>
        /// <returns></returns>
        private string SendBMCEResultShare()
        {
            string str = "FAILED";
            if (Request.Form["maillist"] != null && Request.Form["message"] != null && Request.Form["mymail"] != null && Request.Form["result"] != null)
            {
                string mails = Request.Form["maillist"].Trim();
                string msg = Request.Form["message"].Trim();
                string myMail = Request.Form["mymail"].Trim();
                string result = Request.Form["result"].Trim();

                string[] mailArray=mails.Split(';');
                string sn = result.Split(',')[0].Trim();
                string guid = result.Split(',')[1].Trim();
                int rid = Convert.ToInt32(result.Split(',')[2]);

                string body = "���ã�\n\n��������" + myMail + "�μ���һ��BrandQQ��Ʒ�ƹ�����������,�������ԵĽ����������\n\n�������ӣ�http://www.brandqq.com/bmce/share/?";
                body += sn + guid.Substring(0, 15) + rid.ToString() + guid.Substring(15, 17);

                if (!String.IsNullOrEmpty(msg))
                {
                    body += "\n\n��������(��)���������ԣ�\n\n" + msg;
                }

                body += "\n\n��ӭ���ʣ�http://www.brandQQ.com \n\n";

                Email.SendMail(mailArray, myMail + "��������BrandQQ��Ʒ�ƹ����������Խ��", body,false, GeneralConfig.MailSenderInstance);

                Result.SaveShareMailList(sn, guid, rid, mails, msg);
                str = "OK";
            }
            return str;
        }

        /// <summary>
        /// �û���¼
        /// </summary>
        /// <returns></returns>
        private string Login()
        {
            string str = "FAILED";
            if (Request.Form["email"] != null && Request.Form["password"] != null && Request.Form["loginOption"] != null)
            {
                string email = Request.Form["email"].Trim();
                string pass = Request.Form["password"].Trim();
                int option = Convert.ToInt16(Request.Form["loginOption"]);

                if (Member.Login(email, pass, option))
                {
                    str = "OK";
                }
            }
            return str;
        }

        /// <summary>
        /// �û�ע��
        /// </summary>
        /// <returns></returns>
        private string Register()
        {
            string str = "FAILED";
            if (Request.Form["email"] != null && Request.Form["password"] != null && Request.Form["password2"] != null)
            {
                string email = Request.Form["email"].Trim();
                string pass = Request.Form["password"].Trim();
                string pass2 = Request.Form["password2"].Trim();

                if (Member.IsExistEmail(email))
                {
                    str="EXISTS_EMAIL";
                }

                if (pass != pass2)
                {
                    str="ERROR_PASS";
                }

                Member m = new Member();
                m.Email = email;
                m.Name = "";
                m.Password = pass;

                m.Save();
                Member.Login(email, pass);

                Email.SendMail(email, "��ӭ����BrandQQ.com", "��ӭ������BrandQQ,���ĵ�¼�ʺ�:" + email + ",��¼����:" + pass + " \n\n ��¼��BrandQQ.com http://www.brandqq.com \n\n \n\n����Ʒ�ƹ��� http://www.foresight.net.cn", false, GeneralConfig.MailSenderInstance);

                str = "OK";
            }
            return str;
        }

        /// <summary>
        /// ������ҵ����
        /// </summary>
        /// <returns></returns>
        private string SaveCompany()
        {
            string str = "FAILED";
            //Response.Write("comId:" + Request.Form["comId"]);
            //Response.Write("comIndustry:" + Request.Form["comName"]);
            //Response.Write("comIndustry:" + Request.Form["comIndustry"]);
            //Response.Write("comRegion:" + Request.Form["comRegion"]);
            //Response.Write("comTurnover:" + Request.Form["comTurnover"]);
            //Response.Write("comEmployee:" + Request.Form["comEmployee"]);
            //Response.Write("comContact:" + Request.Form["comContact"]);
            //Response.End();
            if (Request.Form["comId"] != null && Request.Form["comName"] != null && Request.Form["comNature"] != null && 
                Request.Form["comIndustry"] != null && Request.Form["comRegion"] != null && Request.Form["comYear"] != null && 
                Request.Form["comTurnover"] != null && Request.Form["comEmployee"] != null && Request.Form["comContact"] != null && 
                Request.Form["comPhone"] != null)
            {
                try
                {
                    int id = Convert.ToInt32(Request.Form["comId"]);
                    if (id <= 0)
                    {
                        return str;
                    }

                    Company com = new Company();
                    com.Id = id;
                    com.ComName = Request.Form["comName"];
                    com.Nature = Request.Form["comNature"];
                    com.Industry = Request.Form["comIndustry"];
                    com.Region = Request.Form["comRegion"];
                    com.Year = Convert.ToInt16(Request.Form["comYear"]);
                    com.Turnover = ((IntRange)Company.TurnoverCollection[Convert.ToInt16(Request.Form["comTurnover"])]);
                    com.Employee = ((IntRange)Company.EmployeeCollection[Convert.ToInt16(Request.Form["comEmployee"])]);
                    com.Contact = Request.Form["comContact"];
                    com.Phone = Request.Form["comPhone"];
                    com.Fax = Request.Form["comFax"] == null ? "" : Request.Form["comFax"];
                    com.Website = Request.Form["comWebsite"] == null ? "" : Request.Form["comWebsite"];
                    com.Save();
                    str = "OK";
                }
                catch
                {
                    throw;
                }
            }

            return str;
        }

        /// <summary>
        /// ��������ʱ��������
        /// </summary>
        /// <returns></returns>
        private string ResetPass()
        {
            string str = "FAILED";
            if (Request.Form["email"] != null && Request.Form["password"] != null && Request.Form["guid"] != null)
            {
                try
                {
                    Member.ResetPassword(Request.Form["email"].Trim(), Request.Form["guid"].Trim(), Request.Form["password"].Trim());
                    str = "OK";
                }
                catch
                {
                    throw;
                }
            }
            return str;
        }

        private string SaveResultRemark()
        {
            string str = "FAILED";
            if (Request.Form["ResultSN"] != null && Request.Form["ResultGuid"] != null && Request.Form["Remark"] != null)
            {
                try
                {
                    ResultFile result = ResultFile.Load(GeneralConfig.Instance.PaperResultTempSavePath +Request.Form["ResultSN"]+"-"+ Request.Form["ResultGuid"].Trim() + ".rst");
                    if (result.UserInfo == null)
                    {
                        result.UserInfo = new ResultUserInfo();
                    }
                    result.UserInfo.Remark = Server.HtmlEncode(Request.Form["Remark"]);
                    result.Save(GeneralConfig.Instance.PaperResultTempSavePath + Request.Form["ResultSN"] + "-" + Request.Form["ResultGuid"].Trim() + ".rst");
                    str = "OK";
                }
                catch
                {
                    //
                }
            }
            return str;
        }

        /// <summary>
        /// �������ƹ����
        /// </summary>
        /// <returns></returns>
        private string BQIPD()
        {
            /*if (Request.UrlReferrer == null)
            {
                return "�Ƿ�����";
            }

            if (Request.UrlReferrer.Host != Request.Url.Host)
            {
                return "�Ƿ�����";
            }*/

            string url = "";
            string keywords = "";

            if (Request.Form["u"] == null || Request.Form["q"] == null)
            {
                return "ȱ�����������";
            }

            keywords = Request.Form["q"].Trim();
            url = Request.Form["u"].Trim();

            QueryUrl qUrl = null;

            try
            {
                qUrl = new QueryUrl(url);
            }
            catch
            {
                return "��֧�� " + url  + " �ĸ�ʽ��";
            }


            BQIPDQuery query = new BQIPDQuery(QueryType.PRKA, qUrl, keywords);
            BQIPDQueryResult result = null;

            try
            {
                result = query.Query();
            }
            catch
            {
                return "��Ϲ����г��ִ���������";
            }

            return BQIPDConclusion.GetConclusionXML(result);
        }

        /// <summary>
        /// ģ�鷴��
        /// </summary>
        /// <returns></returns>
        private string MEval()
        {
            string str = "FAILED";
            if (Request.Form["module"] == null || Request.Form["usab"] == null 
                || Request.Form["frid"] == null || Request.Form["func"] == null 
                 || Request.Form["eval"] == null)
            {
                return str;
            }

            string mName = Request.Form["module"].Trim().ToLower();
            short usab = Convert.ToInt16(Request.Form["usab"]);
            short frid = Convert.ToInt16(Request.Form["frid"]);
            short func = Convert.ToInt16(Request.Form["func"]);
            string eval = Request.Form["eval"].Trim();

            Util.ModuleEval.MEvaluation.DoEval(mName, usab, frid, func, eval);

            return "OK";
        }
    }
}
