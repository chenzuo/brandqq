using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;

using BrandQQ.Membership;
using BrandQQ.Util;
using BrandQQ.FlexLib;
using BrandQQ.FlexLib.GlyphUtils;

namespace BrandQQ.FlexLib.Responses
{
    public class GlyphResponse:Page
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

            glyphBytes = new byte[] { };

            switch (flexAction)
            {
                case "CONVERT_SWF_GLYPH":
                    GetSwfGlyph();
                    break;

                case "TEXT_GLYPH":
                    GetTextGlyph();
                    break;
            }

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(glyphBytes);
            Response.End();
        }


        /// <summary>
        /// 获取指定文本的特定字体、样式以及大小的轮廓数据
        /// </summary>
        private void GetTextGlyph()
        {
            string text, font, size, style;
            if (Request.Form["TEXT"] != null && Request.Form["FONT"] != null &&
                    Request.Form["SIZE"] != null && Request.Form["STYLE"] != null)
            {
                text = Request.Form["TEXT"].Trim();
                font = Request.Form["FONT"].Trim();
                size = Request.Form["SIZE"].Trim();
                style = Request.Form["STYLE"].Trim();
            }
            else
            {
                return;
            }

            if(String.IsNullOrEmpty(text))
            {
                return;
            }

            FontFamily _font = new FontFamily(font);
            FontStyle _style = FontStyle.Regular;

            int _size = 12;
            try
            {
                _size = Convert.ToInt16(size);
            }
            catch
            {
                //
            }

            if (style== "1")
            {
                _style |= FontStyle.Bold;
            }
            else if (style== "2")
            {
                _style |= FontStyle.Italic;
            }
            else if (style == "3")
            {
                _style |= FontStyle.Bold;
                _style |= FontStyle.Italic;
            }

            glyphBytes = Glyph.CreateFromText(text, _font, _size, _style).GetBytes();
        }

        /// <summary>
        /// 提取Swf文件的轮廓
        /// </summary>
        private void GetSwfGlyph()
        {
            if (Request.Files.Count == 0)
            {
                return;
            }

            HttpPostedFile file = Request.Files[0];

            SwfConverter converter = new SwfConverter(file.InputStream);
            glyphBytes = converter.GetGlyph().GetBytes();
        }

        private string flexAction;
        private byte[] glyphBytes;
    }
}
