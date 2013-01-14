using System;
using System.Collections;
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
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    public class BQIPDChart : Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            bitmap = Image.FromFile(BQIPDConfig.Instance.BQIPDHisChartImage);
            g = Graphics.FromImage(bitmap);
            g.SmoothingMode = SmoothingMode.HighQuality;
            if (Request.QueryString == null)
            {
                g.DrawString("No Data", new Font("黑体", 24), new SolidBrush(Color.Black), 230, 125);
            }
            else
            {
                url = new QueryUrl(Request.QueryString.ToString());
                Draw();
                /*try
                {
                    url = new QueryUrl(Request.QueryString.ToString());
                    Draw();
                }
                catch
                {
                    g.DrawString("No Data", new Font("黑体", 24), new SolidBrush(Color.Black), 230, 125);
                }*/
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

        private void Draw()
        {
            Font baseF = new Font("宋体", 12);
            SizeF f = g.MeasureString(url.Host, new Font("宋体",12));
            g.DrawString(url.Host, baseF, new SolidBrush(Color.Black), bitmap.Width - 5 - f.Width, 5);

            BQIPDDrawPoint[] points = BQIPDRecords.DrawPointList(url);

            

            if (points.Length == 0)
            {
                g.DrawString("No Data", new Font("黑体", 24), new SolidBrush(Color.Black), 230, 125);
                return;
            }

            //计算间隔的天数
            DateTime firstDay = points[0].Date;
            DateTime lastDay = points[points.Length - 1].Date;
            int days = Convert.ToInt16(Util.Utility.DateDiff(DateTimeInterval.Day, firstDay, lastDay));

            //计算每天的距离间隔
            int wp = Convert.ToInt16(BASEWIDTH / days);

            Point dotPoint = new Point(Convert.ToInt16(LEFTPADDING - POINTRADIUS),0);
            Point linePoint1 = new Point();
            Point linePoint2 = new Point();

            Point monthPoint = new Point(0, BASELINE_Y0);
            Point curMonth;
            for(int i=0;i<points.Length;i++)
            {
                dotPoint.X = wp * Convert.ToInt16(Util.Utility.DateDiff(DateTimeInterval.Day, points[0].Date, points[i].Date)) + LEFTPADDING - Convert.ToInt16(POINTRADIUS);
                dotPoint.Y = Convert.ToInt16(BASELINE_Y1 - points[i].Score * 2 - POINTRADIUS);//放大2倍

                monthPoint.X = Convert.ToInt16(Util.Utility.DateDiff(DateTimeInterval.Month, points[0].Date, points[i].Date)) * 30 * wp + LEFTPADDING;
                monthPoint.X -= points[0].Date.Day * wp;

                //画点
                g.FillEllipse(Brushes.Blue, dotPoint.X, dotPoint.Y, POINTRADIUS * 2, POINTRADIUS * 2);

                g.DrawString(points[i].Score.ToString(), baseF, Brushes.Green, dotPoint.X, dotPoint.Y + 5);

                if (i > 0)
                {
                    linePoint1.X = wp * Convert.ToInt16(Util.Utility.DateDiff(DateTimeInterval.Day, points[0].Date, points[i - 1].Date)) + LEFTPADDING;
                    linePoint1.Y = BASELINE_Y1 - points[i - 1].Score * 2;
                    linePoint2.X = wp * Convert.ToInt16(Util.Utility.DateDiff(DateTimeInterval.Day, points[0].Date, points[i].Date)) + LEFTPADDING;
                    linePoint2.Y = BASELINE_Y1 - points[i].Score * 2;
                    //连线
                    g.DrawLine(Pens.Blue, linePoint1, linePoint2);
                }

                //画时间刻度
                curMonth = new Point(points[i].Date.Year, points[i].Date.Month);
                if (!monthPoints.Contains(curMonth) && monthPoint.X > LEFTPADDING && monthPoint.X < BASEWIDTH + LEFTPADDING)
                {
                    g.DrawLine(new Pen(Color.FromArgb(238,238,238)), monthPoint.X, BASELINE_Y0, monthPoint.X, BASELINE_Y1 + 5);
                    if (curMonth.Y == 1)
                    {
                        g.DrawString(MONTHNAMES[curMonth.Y]+"\n"+curMonth.X.ToString(), baseF, Brushes.Gray, monthPoint.X, BASELINE_Y1 + 5);
                    }
                    else
                    {
                        g.DrawString(MONTHNAMES[curMonth.Y], baseF, Brushes.Gray, monthPoint.X, BASELINE_Y1 + 5);
                    }
                }
                monthPoints.Add(curMonth);
            }
        }

        

        private const int LEFTPADDING = 25;
        private const float POINTRADIUS = 3;
        private const int BASELINE_Y0 = 43;
        private const int BASELINE_Y1 = 243;
        private const int BASEWIDTH = 500;

        private ArrayList monthPoints=new ArrayList();
        private string[] MONTHNAMES =new string[]{ "none", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" };

        private QueryUrl url;
        private Image bitmap;
        private Graphics g;
    }
}
