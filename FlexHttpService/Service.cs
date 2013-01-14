using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Drawing.Text;
using System.IO;
using System.Web.UI;
using System.Web;

using BrandQQ.Membership;
using BrandQQ.Util;
using BrandQQ.Logo;

namespace BrandQQ.FlexHttpService
{
    public class Service : Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            //foreach (string s in Request.Headers.Keys)
            //{
            //    File.AppendAllText(@"F:\BrandQQ\1.txt", s+"="+Request.Headers[s]+";\r\n");
            //}

            string action = "";
            if (Request.Headers["FLEX_ACTION"] != null)
            {
                action = Request.Headers["FLEX_ACTION"].Trim();
            }

            switch (action)
            {
                case "GET_INDUSTRIES"://��ҵ����
                    getIndustries();
                    break;

                case "GET_CHARACTER_COLOR"://Ʒ�Ƹ�����ɫ��
                    getCharacterColors();
                    break;

                case "GET_CATEGORIES"://ͼ�η���
                    getCatetories();
                    break;

                case "GET_CATEGORY_ICON"://ͼ�η���ͼ��
                    getCategoryIcon();
                    break;

                case "GET_SYMBOL_LIST"://ͼ���б�
                    getSymbolList();
                    break;

                case "GET_SYMBOL"://ͼ��ͼ��
                    getSymbol();
                    break;

                case "GET_FONTLIST"://�����б�
                    getFontList();
                    break;

                case "GET_FONT_ICON"://����ͼ��
                    getFontIcon();
                    break;

                case "TEXT_PNG"://ת���ı�Ϊpng��ʽ
                    OutputTextPng();
                    break;

                case "USER_STATUS"://��ȡ�û�״̬
                    getLoginStatus();
                    break;

                case "USER_LOGIN"://�����û���¼
                    doLogin();
                    break;

                case "SET_USER_INFO"://�����û���Ϣ,��ҵ���ƺ���ҵ����
                    setUserInfo();
                    break;

                case "SAVE_LOGO"://����logo����
                    saveLogo();
                    break;
            }
        }

        /// <summary>
        /// ��ȡ��ҵ����
        /// </summary>
        private void getIndustries()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "IndustryDatasource.xml");
            Response.Flush();
        }

        /// <summary>
        /// ��ȡ�Ը���ɫ��
        /// </summary>
        private void getCharacterColors()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "CharacterColorsDataSource.xml");
            Response.Flush();
        }

        /// <summary>
        /// ��ȡͼ�η���
        /// </summary>
        private void getCatetories()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "CategoriesDataSource.xml");
            Response.Flush();
        }

        /// <summary>
        /// ��ȡ����ͼ��
        /// </summary>
        private void getCategoryIcon()
        {
            string code = "";
            if (Request.Form["CATE_CODE"] != null)
            {
                code = Request.Form["CATE_CODE"].Trim();
            }

            Response.ContentType = "application/x-shockwave-flash";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "categoryIcons\\" + code + ".swf");
            Response.Flush();
        }

        /// <summary>
        /// ��ȡͼ���б�
        /// </summary>
        private void getSymbolList()
        {
            string cateCode = "";
            string indusCode = "";
            string keywords = "";
            if (Request.Form["CATEGORY_CODE"] != null)
            {
                cateCode = Request.Form["CATEGORY_CODE"].Trim();
            }
            if (Request.Form["INDUSTRY_CODE"] != null)
            {
                indusCode = Request.Form["INDUSTRY_CODE"].Trim();
            }
            if (Request.Form["KEYWORDS"] != null)
            {
                keywords = Request.Form["KEYWORDS"].Trim();
            }

            if (cateCode.Length != 3 && cateCode.Length != 6)
            {
                return;
            }

            string path = GeneralConfig.Instance.LogoDataSourcePath + "symbols\\";
            if (cateCode.Length == 3)
            {
                path += cateCode + "\\SymbolList.xml";
            }
            else if (cateCode.Length == 6)
            {
                path += cateCode.Substring(0, 3) + "\\" + cateCode + "\\SymbolList.xml";
            }
            else
            {
                return;
            }

            if (File.Exists(path))
            {
                Response.ContentType = "text/xml";
                Response.WriteFile(path);
                Response.Flush();
            }
        }

        /// <summary>
        /// ��ȡͼ��
        /// </summary>
        private void getSymbol()
        {
            string code = "";
            if (Request.Form["SYMBOL_CODE"] != null)
            {
                code = Request.Form["SYMBOL_CODE"].Trim();
            }

            if (code.Length != 9)
            {
                return;
            }

            string path = GeneralConfig.Instance.LogoDataSourcePath+"symbols\\";
            path += code.Substring(0, 3) + "\\" + code.Substring(0, 6) + "\\" + code+".swf";
            if (File.Exists(path))
            {
                Response.ContentType = "application/x-shockwave-flash";
                Response.WriteFile(path);
                Response.Flush();
            }
        }

        /// <summary>
        /// ��ȡ�����б�
        /// </summary>
        private void getFontList()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "FontListDataSource.xml");
            Response.Flush();
        }

        /// <summary>
        /// ��ȡ����ͼ��
        /// </summary>
        private void getFontIcon()
        {
            string code = "";
            if (Request.Form["FONT_CODE"] != null)
            {
                code = Request.Form["FONT_CODE"].Trim();
            }

            Response.ContentType = "application/x-shockwave-flash";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "fontsIcon\\" + code + ".swf");
            Response.Flush();
        }

        /// <summary>
        /// ת������Ϊpng��ʽͼƬ
        /// </summary>
        private void OutputTextPng()
        {
            string fontName = "";
            string fontText = "";
            string fontStyle = "00";
            int fontSize = 16;

            if (Request.Form["FONT_NAME"] != null && Request.Form["FONT_STYLE"] != null && Request.Form["FONT_TEXT"] != null && Request.Form["FONT_SIZE"] != null)
            {
                fontName = Request.Form["FONT_NAME"].Trim();
                fontText = Request.Form["FONT_TEXT"].Trim();
                fontSize = Convert.ToInt16(Request.Form["FONT_SIZE"]);
                fontStyle = Request.Form["FONT_STYLE"].Trim();
            }
            else
            {
                return;
            }

            FontStyle style = FontStyle.Regular;
            if (fontStyle.Substring(0, 1) == "1")
            {
                style |= FontStyle.Bold;
            }
            if (fontStyle.Substring(1, 1) == "1")
            {
                style |= FontStyle.Italic;
            }

            Font font = new Font(fontName, fontSize, style);

            Bitmap bitmap = new Bitmap(1, 1);
            Graphics g = Graphics.FromImage(bitmap);
            SizeF f = g.MeasureString(fontText, font);

            bitmap = new Bitmap(Convert.ToInt16(f.Width), Convert.ToInt16(f.Height));
            g = Graphics.FromImage(bitmap);

            g.SmoothingMode = SmoothingMode.HighQuality;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            g.CompositingQuality = CompositingQuality.HighQuality;
            g.TextRenderingHint = TextRenderingHint.AntiAlias;

            g.DrawString(fontText, font, new SolidBrush(Color.Black), new PointF(0, 0));

            MemoryStream bitmapStream = new MemoryStream();
            bitmap.Save(bitmapStream, ImageFormat.Png);
            Response.ClearContent();
            Response.ContentType = "image/png";
            Response.BinaryWrite(bitmapStream.ToArray());
            bitmap.Dispose();
            g.Dispose();
        }


        /// <summary>
        /// �û���¼
        /// </summary>
        private void doLogin()
        {
            StringBuilder userXML = new StringBuilder();
            userXML.AppendLine("<User>");
            if (Request.Form["EMAIL"] != null && Request.Form["PASSWORD"] != null)
            {
                string email = Request.Form["EMAIL"].Trim();
                string pass = Request.Form["PASSWORD"].Trim();

                if (Member.Login(email, pass))
                {
                    userXML.AppendLine("<Guid>" + Utility.NewGuid + "</Guid>");
                    userXML.AppendLine("<Id>" + Member.Instance.Id + "</Id>");
                    userXML.AppendLine("<Email>" + Member.Instance.Email + "</Email>");
                    userXML.AppendLine("<Name>" + Member.Instance.Name + "</Name>");

                    Company com=Company.Get(Member.Instance.Id);
                    if (com != null)
                    {
                        userXML.AppendLine("<Industry>" + com.Industry + "</Industry>");
                        userXML.AppendLine("<Company>" + com.ComName + "</Company>");
                    }
                }
            }
            userXML.AppendLine("</User>");

            Response.Write(userXML.ToString());
            Response.Flush();
        }

        /// <summary>
        /// ��ȡ�û���¼״̬
        /// </summary>
        private void getLoginStatus()
        {
            StringBuilder userXML = new StringBuilder();
            userXML.AppendLine("<User>");

            if (Member.IsLogined)
            {
                userXML.AppendLine("<Guid>" + Utility.NewGuid + "</Guid>");
                userXML.AppendLine("<Id>" + Member.Instance.Id + "</Id>");
                userXML.AppendLine("<Email>" + Member.Instance.Email + "</Email>");
                userXML.AppendLine("<Name>" + Member.Instance.Name + "</Name>");

                Company com = Company.Get(Member.Instance.Id);
                if (com != null)
                {
                    userXML.AppendLine("<Industry>" + com.Industry + "</Industry>");
                    userXML.AppendLine("<Company>" + com.ComName + "</Company>");
                }
            }

            userXML.AppendLine("</User>");

            Response.Write(userXML);
            Response.Flush();
        }

        /// <summary>
        /// �����û���Ϣ����ҵ���ƺ���ҵ����
        /// </summary>
        private void setUserInfo()
        {
            if (!Member.IsLogined)
            {
                return;
            }

            string comName = "";
            string industry = "";

            if (Request.Form["COM_NAME"] != null && Request.Form["INDUS_CODE"] != null)
            {
                comName = Request.Form["COM_NAME"].Trim();
                comName = Server.HtmlEncode(comName);
                industry = Request.Form["INDUS_CODE"].Trim();
            }

            if (comName == "" || industry == "")
            {
                return;
            }

            Company com = Company.Get(Member.Instance.Id);

            if (com == null)
            {
                com = new Company(Member.Instance.Id);
            }

            com.Industry = industry;
            com.ComName = comName;
            com.Save();
        }


        /// <summary>
        /// ����logo�ṹ����
        /// </summary>
        private void saveLogo()
        {
            if (!Member.IsLogined)
            {
                return;
            }

            string industry="";
            string guid = "";

            if (Request.Headers["INDUSTRY_CODE"] != null && Request.Headers["GUID"] != null)
            {
                industry = Request.Headers["INDUSTRY_CODE"].Trim();
                guid = Request.Headers["GUID"].Trim();
            }

            if (industry.Length != 6 && guid.Length != 32)
            {
                return;
            }

            BinaryReader reader = new BinaryReader(Request.InputStream, Encoding.UTF8);

            //title
            byte[] lenBytes = reader.ReadBytes(4);
            Array.Reverse(lenBytes);
            int len = BitConverter.ToInt32(lenBytes, 0);
            string title = Encoding.UTF8.GetString(reader.ReadBytes(len));

            //remark
            lenBytes = reader.ReadBytes(4);
            Array.Reverse(lenBytes);
            len = BitConverter.ToInt32(lenBytes, 0);
            string remark = Encoding.UTF8.GetString(reader.ReadBytes(len));

            //xml
            lenBytes = reader.ReadBytes(4);
            Array.Reverse(lenBytes);
            len = BitConverter.ToInt32(lenBytes, 0);
            string xml = Encoding.UTF8.GetString(reader.ReadBytes(len));

            //xml path
            string xmlPath = GeneralConfig.Instance.LogoDataSourcePath + "LogoRecords\\" + industry + "\\" + guid;

            //image path
            string imgPath = GeneralConfig.Instance.LogoDataSourcePath + "LogoImages\\" + industry + "\\" + guid;

            File.WriteAllText(xmlPath, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<Logo>\r\n" + xml + "\r\n</Logo>");

            File.WriteAllBytes(imgPath, reader.ReadBytes((int)(reader.BaseStream.Length - reader.BaseStream.Position)));

            reader.Close();

            //����logo��¼
            LogoBase logo = LogoBase.Create(LogoType.Record);
            logo.Guid = guid;
            logo.UserId = Member.Instance.Id;
            logo.Industry = industry;
            logo.ImageType = LogoImageType.Png;
            logo.Title = title;
            logo.Description = remark;
            logo.Enabled = true;
            logo.Save();

            //��������ͼ
            LogoUtil.CreateThumbnail(imgPath);

            Response.Write("OK");
            Response.Flush();
        }
    }
}
