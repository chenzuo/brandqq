using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;

using BrandQQ.Membership;
using BrandQQ.Util;
using BrandQQ.FlexLib;
using BrandQQ.FlexLib.Files;

namespace BrandQQ.FlexLib.Responses
{
    public class FileResponse : Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            base.EnableViewState = false;
            
            flexAction = "";
            if (Request.Headers["FLEX_ACTION"] != null)
            {
                flexAction = Request.Headers["FLEX_ACTION"];
            }

            File.AppendAllText(Server.MapPath("/flexLib/") + "log.txt", DateTime.Now.ToString()+"   ["+flexAction+"]\r\n");

            switch (flexAction)
            {
                case "READ_FILE":
                    ReadFile();
                    break;

                case "SAVE_FILE":
                    SaveFile();
                    break;
            }

        }

        /// <summary>
        /// 读取文件
        /// </summary>
        private void ReadFile()
        {
            string fileType, fileGuid;
            if (Request.Headers["FILE_TYPE"] != null && Request.Headers["FILE_GUID"] != null)
            {
                fileType = Request.Headers["FILE_TYPE"].Trim();
                fileGuid = Request.Headers["FILE_GUID"].Trim();
            }
            else
            {
                return;
            }

            string filePath = Server.MapPath("/flexLib/Files/");

            if (fileType == "logo")
            {
                filePath += "Logos/" + fileGuid + ".logo";
            }
            else if (fileType == "card")
            {
                filePath += "Cards/" + fileGuid + ".card";
            }
			else if (fileType == "cardTemp")
            {
                filePath += "CardTemps/" + fileGuid + ".card";
            }

            if (File.Exists(filePath))
            {
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.BinaryWrite(File.ReadAllBytes(filePath));
                Response.End();
            }
        }

        /// <summary>
        /// 保存文件
        /// </summary>
        private void SaveFile()
        {
            string fileType, fileGuid,fileUid;
            if (Request.Headers["FILE_TYPE"] != null && Request.Headers["FILE_GUID"] != null && Request.Headers["FILE_UID"] != null)
            {
                fileType = Request.Headers["FILE_TYPE"].Trim();
                fileGuid = Request.Headers["FILE_GUID"].Trim();
                fileUid = Request.Headers["FILE_UID"].Trim();

                IFile file = null;
                if (fileType == "logo")
                {
                    file = new LogoFile(Request.InputStream);
                }
                else if (fileType == "card")
                {
                    file = new CardFile(Request.InputStream);
                }
                else if (fileType == "cardTemp")
                {
                    file = new CardTempFile(Request.InputStream);
                }

                if (file != null)
                {
                    file.Save();
                }

                Response.Clear();
                Response.ContentType = "text/xml";
                Response.Write("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
                Response.Write("<RESPONSE>");
                Response.Write("<Result status=\"1\" guid=\"" + fileGuid + "\"/>");
                Response.Write("</RESPONSE>");
                Response.End();
            }
            else
            {
                Response.Clear();
                Response.ContentType = "text/xml";
                Response.Write("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
                Response.Write("<RESPONSE>");
                Response.Write("<Result status=\"0\"/>");
                Response.Write("</RESPONSE>");
                Response.End();
                return;
            }
        }


        private string flexAction;
    }
}
