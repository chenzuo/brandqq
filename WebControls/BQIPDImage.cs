using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Drawing.Text;

using BrandQQ.BQIPD;

namespace BrandQQ.WebControls
{
    public class BQIPDImage:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            int[] datas = new int[6];
            
            try
            {
                string s = HttpContext.Current.Server.UrlDecode(Request.QueryString.ToString());
                for (int i = 0; i < s.Split(',').Length; i++)
                {
                    datas[i] = Convert.ToInt16((s.Split(','))[i]);
                }
            }
            catch
            {
                //
            }

            datas[5] = Convert.ToInt32(datas[0] * 0.2 + datas[1] * 0.2 + datas[2] * 0.3 + datas[3] * 0.2 + datas[4] * 0.1);

            Image bitmap = Image.FromFile(BQIPDConfig.Instance.BQIPDChartImage);

            Graphics g = Graphics.FromImage(bitmap);

            Color clr1 = Color.FromArgb(90,0, 153, 0);
            Color clr2 = Color.FromArgb(90, 153, 204, 0);
            Color clr3 = Color.FromArgb(90, 255, 204, 0);
            Color clr4 = Color.FromArgb(90, 0, 51, 102);
            Color clr5 = Color.FromArgb(90, 0, 153, 255);
            Color clr6 = Color.FromArgb(90, 255, 102, 0);

            Font fnt1 = new Font("Arial", 12);
            Font fnt2 = new Font("Arial", 12,FontStyle.Bold);
            Color fClr1 = Color.FromArgb(51, 51, 51);
            Color fClr2 = Color.FromArgb(255, 0, 0);

            g.FillRectangle(new SolidBrush(clr1), new Rectangle(103, 30, datas[0]*3, 15));
            g.DrawString(datas[0].ToString(), fnt1, new SolidBrush(fClr1),413,32);

            g.FillRectangle(new SolidBrush(clr2), new Rectangle(103, 63, datas[1] * 3, 15));
            g.DrawString(datas[1].ToString(), fnt1, new SolidBrush(fClr1), 413, 65);

            g.FillRectangle(new SolidBrush(clr3), new Rectangle(103, 98, datas[2] * 3, 15));
            g.DrawString(datas[2].ToString(), fnt1, new SolidBrush(fClr1), 413, 100);

            g.FillRectangle(new SolidBrush(clr4), new Rectangle(103, 133, datas[3] * 3, 15));
            g.DrawString(datas[3].ToString(), fnt1, new SolidBrush(fClr1), 413, 135);

            g.FillRectangle(new SolidBrush(clr5), new Rectangle(103, 168, datas[4] * 3, 15));
            g.DrawString(datas[4].ToString(), fnt1, new SolidBrush(fClr1), 413, 171);

            g.FillRectangle(new SolidBrush(clr6), new Rectangle(103, 203, datas[5] * 3, 15));
            g.DrawString(datas[5].ToString(), fnt2, new SolidBrush(fClr2), 413, 205);

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);

            Response.Clear();
            Response.ContentType = "image/png";
            Response.AddHeader("Pragma", "no-cache");
            Response.AddHeader("Cache-Control", "no-cache");
            Response.AddHeader("Expires", "0");
            Response.BinaryWrite(stream.ToArray());
            Response.Flush();
            g.Dispose();
            bitmap.Dispose();
        }
    }
}
