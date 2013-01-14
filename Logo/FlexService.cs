using System;
using System.Collections;
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
using BrandQQ.Logo.FontGlyph;

namespace BrandQQ.Logo
{
    public class FlexService : Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            string action = "";
            if (Request.Headers["FLEX_ACTION"] != null)
            {
                action = Request.Headers["FLEX_ACTION"].Trim();
            }

            Response.Clear();
            switch (action)
            {
                case "GET_INDUSTRIES"://行业分类
                    getIndustries();
                    break;

                case "GET_CHARACTER_COLOR"://品牌个性颜色表
                    getCharacterColors();
                    break;

                case "GET_CATEGORIES"://图形分类
                    getCatetories();
                    break;

                case "GET_CATEGORY_ICON"://图形分类图标
                    getCategoryIcon();
                    break;

                case "GET_SYMBOL_LIST"://图形列表
                    getSymbolList();
                    break;

                case "GET_SYMBOL"://图形图标
                    getSymbol();
                    break;

                case "GET_FONTLIST"://字体列表
                    getFontList();
                    break;

                case "GET_FONT_ICON"://字体图标
                    getFontIcon();
                    break;

                case "FONT_GLYPH"://转换文本为png格式
                    OutputFontGlyph();
                    break;

                case "USER_STATUS"://获取用户状态
                    getLoginStatus();
                    break;

                case "USER_LOGIN"://处理用户登录
                    doLogin();
                    break;

                case "SET_USERINFO"://设置用户信息,企业名称和行业代码
                    setUserInfo();
                    break;

                case "SAVE_LOGO"://保存logo数据
                    saveLogo();
                    break;
            }
            Response.End();
        }

        /// <summary>
        /// 获取行业分类
        /// </summary>
        private void getIndustries()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "IndustryDatasource.xml");
        }

        /// <summary>
        /// 获取性格颜色表
        /// </summary>
        private void getCharacterColors()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "CharacterColorsDataSource.xml");
        }

        /// <summary>
        /// 获取图形分类
        /// </summary>
        private void getCatetories()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "CategoriesDataSource.xml");
        }

        /// <summary>
        /// 获取分类图标
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
        }

        /// <summary>
        /// 获取图形列表
        /// </summary>
        private void getSymbolList()
        {
            string cateCode = "";
            string indusCode = "";
            string keywords = "";

            Pager pager = new Pager(1, 10);

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
                keywords = Request.Form["KEYWORDS"].Trim().Replace("'","");
            }
            if (Request.Form["PAGEINDEX"] != null && Request.Form["PAGESIZE"]!=null)
            {
                try
                {
                    pager.PageIndex = Convert.ToInt16(Request.Form["PAGEINDEX"]);
                    pager.PageSize = Convert.ToInt16(Request.Form["PAGESIZE"]);
                }
                catch
                {
                    //
                }
            }

            if (cateCode.Length != 3 && cateCode.Length != 6)
            {
                return;
            }

            StringBuilder xml = new StringBuilder();
            xml.AppendLine("<? xml version=\"1.0\" encoding=\"utf-8\" ?>");

            ArrayList list = LogoSymbol.List(pager, cateCode, indusCode, keywords);

            xml.AppendLine("<Symbols page=\"" + pager.PageCount + "\" count=\"" + pager.RecordCount + "\">");

            foreach (LogoSymbol symbol in list)
            {
                xml.AppendLine("<Symbol code=\"" + symbol.Code + "\" industries=\"" + symbol.Industries + "\" title=\"" + symbol.Title + "\" />");
            }

            xml.AppendLine("</Symbols>");
            Response.Clear();
            Response.ContentType = "text/xml";
            Response.Write(xml.ToString());
        }

        /// <summary>
        /// 获取图形
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
            Response.Clear();
            if (File.Exists(path))
            {
                Response.ContentType = "application/x-shockwave-flash";
                Response.WriteFile(path);
            }
            Response.End();
        }

        /// <summary>
        /// 获取字体列表
        /// </summary>
        private void getFontList()
        {
            Response.ContentType = "text/xml";
            Response.WriteFile(GeneralConfig.Instance.LogoDataSourcePath + "FontListDataSource.xml");
        }

        /// <summary>
        /// 获取字体图标
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
        }

        /// <summary>
        /// 转换文字为png格式图片
        /// </summary>
        private void OutputFontGlyph()
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


            Glyph glyph = new Glyph(fontName, fontStyle, fontText, fontSize);
            Response.ContentType = "text/xml";
            Response.Write(glyph.GetXML());
            Response.Flush();
        }


        /// <summary>
        /// 用户登录
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
                        userXML.AppendLine("<Industry>" + (String.IsNullOrEmpty(com.Industry) ? "" : com.Industry) + "</Industry>");
                        userXML.AppendLine("<Company>" + (String.IsNullOrEmpty(com.ComName) ? "" : com.ComName) + "</Company>");
                    }
                }
            }
            userXML.AppendLine("</User>");

            Response.Write(userXML.ToString());
        }

        /// <summary>
        /// 获取用户登录状态
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
                    userXML.AppendLine("<Industry>" + (String.IsNullOrEmpty(com.Industry) ? "" : com.Industry) + "</Industry>");
                    userXML.AppendLine("<Company>" + (String.IsNullOrEmpty(com.ComName) ? "" : com.ComName) + "</Company>");
                }
            }

            userXML.AppendLine("</User>");

            Response.Write(userXML);
        }

        /// <summary>
        /// 设置用户信息：企业名称和行业代码
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
            Response.Write("OK");
        }


        /// <summary>
        /// 保存logo结构数据
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

            //保存logo记录
            LogoBase logo = LogoBase.Create(LogoType.Record);
            logo.Guid = guid;
            logo.UserId = Member.Instance.Id;
            logo.Industry = industry;
            logo.ImageType = LogoImageType.Png;
            logo.Title = title;
            logo.Description = remark;
            logo.Enabled = true;
            logo.Save();

            //生成缩略图
            LogoUtil.CreateThumbnail(imgPath);

            Response.Write("OK,"+Utility.NewGuid);
        }
    }
}
