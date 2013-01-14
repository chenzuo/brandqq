using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.IO;

using BrandQQ.Membership;
using BrandQQ.Util;
using BrandQQ.FlexLib.DBUtils;

namespace BrandQQ.FlexLib.Responses
{
    public class UserResponse:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            base.EnableViewState = false;

            this.responseXML = new StringBuilder();
            this.responseXML.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            this.responseXML.AppendLine("<RESPONSE>");

            flexAction = "";
            if (Request.Headers["FLEX_ACTION"] != null)
            {
                flexAction = Request.Headers["FLEX_ACTION"];
            }

            File.AppendAllText(@"F:\BrandQQ\www\flexLib\FlexActions.txt", flexAction + "\r\n");
            
            switch (flexAction)
            {
                case "STATUS":
                    this.responseXML.Append(this.GetStatus());
                    break;

                case "LOGIN":
                    string email = "",pwd="";
                    if (Request.Headers["EMAIL"] != null)
                    {
                        email = Request.Headers["EMAIL"].Trim();
                    }
                    if (Request.Headers["PWD"] != null)
                    {
                        pwd = Request.Headers["PWD"].Trim();
                    }

                    if (email != "" && pwd != "")
                    {
                        this.responseXML.Append(this.Login(email,pwd));
                    }
                    break;

                case "LOGOUT":
                    this.responseXML.Append(this.Logout());
                    break;

                case "USER_LOGO_LIST":
                    this.responseXML.Append(this.UserLogoList());
                    break;

                case "USER_CARD_LIST":
                    this.responseXML.Append(this.UserCardList());
                    break;
                case "USER_UPDATE_GUID":
                    if (Request.Headers["GUID_TYPE"] != null && Request.Headers["GUID"] != null)
                    {
                        string type=Request.Headers["GUID_TYPE"].Trim();
                        string guid = Request.Headers["GUID"].Trim();
                        switch (type)
                        {
                            case "LOGO":
                                MeberFlexInfo.Instance.LogoGuid = guid;
                                break;

                            case "CARD":
                                MeberFlexInfo.Instance.CardGuid = guid;
                                break;

                            case "CARDTEMP":
                                MeberFlexInfo.Instance.CardTempGuid = guid;
                                break;
                        }
                    }
                    break;
            }

            this.responseXML.AppendLine("</RESPONSE>");

            Response.Clear();
            Response.ContentType = "text/xml";
            Response.Write(this.responseXML.ToString());
            Response.End();
        }

        /// <summary>
        /// 获取当前用户状态
        /// </summary>
        private string GetStatus()
        {
            StringBuilder xml = new StringBuilder();
            if (Member.IsLogined)
            {
                xml.AppendLine("<Id>" + Member.Instance.Id.ToString() + "</Id>");
                xml.AppendLine("<Guid>" + Member.Instance.Email + "</Guid>");
                xml.AppendLine("<Name><![CDATA[" + Member.Instance.Name + "]]></Name>");
                xml.AppendLine("<Email>" + Member.Instance.Email + "</Email>");

                Company com = Company.Get(Member.Instance.Id);
                if (com != null)
                {
                    xml.AppendLine("<ComName><![CDATA[" + com.ComName + "]]></ComName>");
                    xml.AppendLine("<ComIndus>" + com.Industry + "</ComIndus>");
                }
                xml.AppendLine("<LogoGuid>" + MeberFlexInfo.Instance.LogoGuid + "</LogoGuid>");
                xml.AppendLine("<CardGuid>" + MeberFlexInfo.Instance.CardGuid + "</CardGuid>");
                xml.AppendLine("<CardTempGuid>" + MeberFlexInfo.Instance.CardTempGuid + "</CardTempGuid>");
            }

            return xml.ToString();
        }

        private string Login(string email, string pass)
        {
            Member.Login(email, pass);
            return GetStatus();
        }

        private string Logout()
        {
            Member.Logout();
            return GetStatus();
        }

        /// <summary>
        /// 获取当前用户创作的Logo列表
        /// </summary>
        /// <returns></returns>
        private string UserLogoList()
        {
            if (!Member.IsLogined)
            {
                return "";
            }

            StringBuilder xml = new StringBuilder();

            foreach (Logo logo in DBUtil.GetLogos(Member.Instance.Id,100))
            {
                xml.AppendLine("<Logo>");
                xml.AppendLine("    <Guid>" + logo.Guid + "</Guid>");
                xml.AppendLine("    <Title><![CDATA["+logo.Title+"]]></Title>");
                xml.AppendLine("</Logo>");
            }
            
            return xml.ToString();
        }

        /// <summary>
        /// 获取当前用户创作的Card列表
        /// </summary>
        /// <returns></returns>
        private string UserCardList()
        {
            if (!Member.IsLogined)
            {
                return "";
            }

            StringBuilder xml = new StringBuilder();

            foreach (BusinessCard card in DBUtil.GetCards(Member.Instance.Id,100))
            {
                xml.AppendLine("<Card>");
                xml.AppendLine("    <Guid>" + card.Guid + "</Guid>");
                xml.AppendLine("    <Name><![CDATA[" + card.Name + "]]></Name>");
                xml.AppendLine("</Card>");
            }

            return xml.ToString();
        }

        private string flexAction;
        private StringBuilder responseXML;
    }
}
