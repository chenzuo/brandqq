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
using BrandQQ.BQIPD.SEOImage;

namespace BrandQQ.WebControls
{
    public class SEOImage : Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            if (Request.QueryString != null)
            {
                string s = Request.QueryString.ToString();
                imageStyle = SEOImageConfig.GetStyle(s);
                if (imageStyle == null)
                {
                    imageStyle = SEOImageStyle.DefaultStyle;
                }
            }
            else
            {
                imageStyle = SEOImageStyle.DefaultStyle;
            }

            string baseimg = imageStyle.Image;

            Image bitmap = Image.FromFile(baseimg);

            Graphics g = Graphics.FromImage(bitmap);

            if (Request.UrlReferrer != null)
            {
                refferUri = Request.UrlReferrer;

                SEOImageHistory history = SEOImageHistory.Get(refferUri.Host);

                BQIPDQueryResult result;

                if (history != null)
                {
                    result = new BQIPDQueryResult();
                    result.PageRank = history.PageRank;
                    result.GoogleRecords = history.Google;
                    result.BaiduRecords = history.Baidu;
                    result.YahooRecords = history.Yahoo;
                    result.AlexaRank = history.AlexaRank;
                    result.AlexaLinkIn = history.AlexaLinkIn;
                    result.AlexaSpeed = history.AlexaSpeed;
                    DrawDataImage(g, result, history.Datetime.ToShortDateString());
                }
                else
                {
                    result = BQIPDQuery.Query(imageStyle.Query, new QueryUrl(refferUri.Host));
                    SEOImageHistory.Save(result, refferUri.Host);
                    DrawDataImage(g, result, DateTime.Now.ToShortDateString());
                }
            }
            else
            {
                g.DrawImage(Image.FromFile(SEOImageConfig.Instance.DefaultIcon), imageStyle.IconMap.X, imageStyle.IconMap.Y);
                g.DrawString("Error or Unknown Site!", imageStyle.DomainMap.Font, new SolidBrush(imageStyle.DomainMap.Color), imageStyle.DomainMap.Point);
            }

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

        private void DrawDataImage(Graphics g, BQIPDQueryResult result, string dt)
        {
            Icon icon = new SEOImageIcon(refferUri).GetIcon();
            if (icon == null)
            {
                g.DrawImage(Image.FromFile(SEOImageConfig.Instance.DefaultIcon), imageStyle.IconMap.X, imageStyle.IconMap.Y);
            }
            else
            {
                g.DrawIcon(icon, new Rectangle(imageStyle.IconMap.X, imageStyle.IconMap.Y, 16, 16));
            }

            g.DrawString(refferUri.Host, imageStyle.DomainMap.Font, new SolidBrush(imageStyle.DomainMap.Color), imageStyle.DomainMap.Point);
            g.DrawString(dt, imageStyle.DateMap.Font, new SolidBrush(imageStyle.DateMap.Color), imageStyle.DateMap.Point);

            //PageRank
            if (imageStyle.QueryString.IndexOf("P") != -1)
            {
                if (result.PageRank > 0)
                {
                    //画pagerank矩形
                    g.FillRectangle(new SolidBrush(imageStyle.PageRankImageMap.Color), new Rectangle(imageStyle.PageRankImageMap.X, imageStyle.PageRankImageMap.Y, result.PageRank * 6, 6));
                    //写Pagerank值
                    g.DrawString(result.PageRank.ToString(), imageStyle.PageRankTextMap.Font, new SolidBrush(imageStyle.PageRankTextMap.Color), imageStyle.PageRankTextMap.Point);
                }
                else
                {
                    g.DrawString("0", imageStyle.PageRankTextMap.Font, new SolidBrush(imageStyle.PageRankTextMap.Color), imageStyle.PageRankTextMap.Point);
                }
            }

            //收录数
            if (imageStyle.QueryString.IndexOf("R") != -1)
            {
                //写Google结果
                g.DrawString(result.GoogleRecords.ToString(), imageStyle.GoogleMap.Font, new SolidBrush(imageStyle.GoogleMap.Color), imageStyle.GoogleMap.Point);


                //写Biadu结果
                g.DrawString(result.BaiduRecords.ToString(), imageStyle.BaiduMap.Font, new SolidBrush(imageStyle.BaiduMap.Color), imageStyle.BaiduMap.Point);

                //写Yahoo结果
                g.DrawString(result.YahooRecords.ToString(), imageStyle.YahooMap.Font, new SolidBrush(imageStyle.YahooMap.Color), imageStyle.YahooMap.Point);
            }

            if (imageStyle.QueryString.IndexOf("A") != -1)
            {
                //写Alexa结果
                g.DrawString(result.AlexaRank.ToString(), imageStyle.AlexaMap.Font, new SolidBrush(imageStyle.AlexaMap.Color), imageStyle.AlexaMap.Point);
                g.DrawString(result.AlexaLinkIn.ToString(), imageStyle.LinkInMap.Font, new SolidBrush(imageStyle.LinkInMap.Color), imageStyle.LinkInMap.Point);
            }
        }


        private SEOImageStyle imageStyle;
        private Uri refferUri;
    }

}
