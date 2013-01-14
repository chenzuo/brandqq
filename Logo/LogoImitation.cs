using System;
using System.Collections;
using System.Text;
using System.Xml;
using System.IO;
using System.Data;
using System.Data.SqlClient;

using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Drawing.Text;

using BrandQQ.Util;
using BrandQQ.Membership;

namespace BrandQQ.Logo
{
    /// <summary>
    /// Logo Imitation Show
    /// </summary>
    public sealed class LogoImitation
    {
        /// <summary>
        /// 获取所有样式列表
        /// </summary>
        public static ArrayList Styles
        {
            get
            {
                ArrayList styles = new ArrayList();
                XmlDocument doc = new XmlDocument();
                doc.Load(GeneralConfig.Instance.LogoImitationShowConfigFile);
                
                foreach (XmlNode node in doc.DocumentElement.SelectNodes("Style"))
                {
                    LogoStyle s = new LogoStyle();
                    s.Id = node.Attributes["id"].Value;
                    s.Name = node.Attributes["name"].Value;
                    s.Font = node.Attributes["font"].Value;
                    s.FontSize = node.Attributes["size"].Value;
                    s.Image = node.Attributes["image"].Value;
                    s.Colors = node.Attributes["colors"].Value.Split(',');
                    s.UpperCase = node.Attributes["upperCase"].Value;
                    s.Description = node.FirstChild.Value;
                    styles.Add(s);
                }

                return styles;
            }
        }

        /// <summary>
        /// 获取指定ID的样式
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>LogoStyle</returns>
        public static LogoStyle GetStyle(string id)
        {
            foreach (LogoStyle style in Styles)
            {
                if(style.Id==id)
                {
                    return style;
                }
            }
            return null;
        }

        public static Boolean CreateLogo(string styleId, string text, string color, string guid)
        {
            LogoStyle style = GetStyle(styleId);
            if (style == null)
            {
                return false;
            }

            string fontName = style.Font;
            string fontText = text;
            int fontSize = Convert.ToInt16(style.FontSize);

            if (style.UpperCase.ToLower() == "first")
            {
                fontText = fontText.Substring(0, 1).ToUpper() + fontText.Substring(1, fontText.Length - 1).ToLower();
            }
            else if (style.UpperCase.ToLower() == "all")
            {
                fontText = fontText.ToUpper();
            }
            else if (style.UpperCase.ToLower() == "none")
            {
                fontText = fontText.ToLower();
            }

            Font font = new Font(fontName, fontSize, FontStyle.Regular);

            Bitmap bitmap = new Bitmap(1, 1);
            Graphics g = Graphics.FromImage(bitmap);
            SizeF f = g.MeasureString(fontText, font);

            bitmap = new Bitmap(Convert.ToInt16(f.Width) + 20, Convert.ToInt16(f.Height) + 20);//留10px白边
            g = Graphics.FromImage(bitmap);
            
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            g.CompositingQuality = CompositingQuality.HighQuality;
            g.TextRenderingHint = TextRenderingHint.AntiAlias;

            if (style.Colors.Length > 2)//多种颜色
            {
                PointF p = new PointF(10, 10);
                Color letterClr;
                string[] letterClrs;
                int clrIndex = 0;

                for (int i = 0; i < text.Length; i++)
                {

                    if (clrIndex >= style.Colors.Length)
                    {
                        clrIndex = 0;
                    }

                    letterClrs = style.Colors[clrIndex].Split('.');
                    letterClr = Color.FromArgb(Convert.ToInt16(letterClrs[0]), Convert.ToInt16(letterClrs[1]), Convert.ToInt16(letterClrs[2]));
                    g.DrawString(text.Substring(i, 1), font, new SolidBrush(letterClr), p);
                    p.X += g.MeasureString(text.Substring(i, 1), font).Width*(float)0.61;
                    clrIndex++;
                }

            }
            else//单一颜色
            {
                Color clr;
                string[] clrs;
                if (color == "" || color.Split('.').Length<3)//使用默认颜色
                {
                    clrs = style.Colors[0].Split('.');
                    clr = Color.FromArgb(Convert.ToInt16(clrs[0]), Convert.ToInt16(clrs[1]), Convert.ToInt16(clrs[2]));
                }
                else//使用自定义颜色
                {
                    clrs = color.Split('.');
                    clr = Color.FromArgb(Convert.ToInt16(clrs[0]), Convert.ToInt16(clrs[1]), Convert.ToInt16(clrs[2]));
                }

                g.DrawString(fontText, font, new SolidBrush(clr), new PointF(10, 10));
            }

            string filename = GeneralConfig.Instance.LogoDataSourcePath + "logoImShImages\\" + styleId + "\\" + guid + ".png";

            //MemoryStream bitmapStream = new MemoryStream();
            bitmap.Save(filename, ImageFormat.Png);
            bitmap.Dispose();
            g.Dispose();

            return true;
        }

    }

    /// <summary>
    /// 表示一个Logo模仿秀的样式
    /// </summary>
    public class LogoStyle
    {
        public string Id;
        public string Name;
        public string Font;
        public string FontSize;
        public string Image;
        public string[] Colors;
        public string UpperCase;
        public string Description;
    }

    /// <summary>
    /// 表示一个Logo模仿秀作品
    /// </summary>
    public class LogoShowItem
    {
        public LogoShowItem()
        {
            Guid = Utility.NewGuid;
            StyleId = "00";
            Text = "";
            UserId = Member.IsLogined ? Member.Instance.Id : 0;
        }

        public int Save()
        {
            /* LogoImShSave
                @guid char(32),
                @uid int=0,
                @style char(2),
                @text varchar(50)
           */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@guid",SqlDbType.Char,32,Guid),
                Database.MakeInParam("@uid",SqlDbType.Int,UserId),
                Database.MakeInParam("@style",SqlDbType.Char,2,StyleId),
                Database.MakeInParam("@text",SqlDbType.VarChar,50,Text)
            };

            int newId = 0;
            try
            {
                newId = Database.ExecuteNonQuery(CommandType.StoredProcedure, "LogoImShSave", prams);
            }
            catch
            {
                newId = -1;
            }

            return newId;
        }

        public static ArrayList List(Pager pager)
        {
            return List(pager, "00", 0);
        }

        public static ArrayList List(Pager pager, string style)
        {
            return List(pager, style, 0);
        }

        public static ArrayList List(Pager pager, int uid)
        {
            return List(pager, "00", uid);
        }

        public static ArrayList List(Pager pager, string style, int uid)
        {
            ArrayList list = new ArrayList();
            /*
             LogoImShList
            @style char(2)='00',
            @uid int=0,
            @pageindex int=1,
            @pagesize int=20,
            @sort int=0
             */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@style",SqlDbType.Char,2,style),
                Database.MakeInParam("@uid",SqlDbType.Int,uid),
                Database.MakeInParam("@pageindex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pagesize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "LogoImShList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);

                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id],Guid, UserId, Datetime, StyleId, LogoText,Score*/
                            LogoShowItem logo = new LogoShowItem();
                            logo.Id = reader.GetInt32(0);
                            logo.Guid = reader.GetString(1);
                            logo.UserId = reader.GetInt32(2);
                            logo.Datetime = reader.GetDateTime(3);
                            logo.StyleId = reader.GetString(4);
                            logo.Text = reader.GetString(5);
                            logo.Score = reader.GetInt32(6);
                            list.Add(logo);
                        }
                    }
                }
                reader.Close();
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            return list;
        }

        public void AddScore()
        {
            Set("AddScore", Guid);
        }

        public static void AddScore(int id)
        {
            Set("AddScore", id.ToString());
        }

        public static void AddScore(string guid)
        {
            Set("AddScore", guid);
        }

        public static void Delete(int id)
        {
            Delete(id.ToString());
        }

        public static void Delete(string guid)
        {
            Set("Delete", guid);
        }

        public static void DeleteByUser(int uid)
        {
            Set("DeleteByUser", uid.ToString());
        }

        private static void Set(string action, string id)
        {
            /*
             LogoImShSet
                @action varchar(15),
                @id varchar(32)
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@action",SqlDbType.VarChar,15,action),
                Database.MakeInParam("@id",SqlDbType.VarChar,32,id)
            };

            Database.ExecuteNonQuery(CommandType.StoredProcedure, "LogoImShSet", prams);
        }

        public int Id;
        public string Guid;
        public int UserId;
        public DateTime Datetime;
        public string StyleId;
        public string Text;
        public int Score;
    }
}
