using System;
using System.Collections;
using System.Text;

using System.Drawing;
using System.IO;

namespace BrandQQ.Logo
{
    public class LogoUtil
    {
        /// <summary>
        /// 创建图片的缩略图
        /// </summary>
        /// <param name="imgPath"></param>
        public static void CreateThumbnail(string imgPath,bool rename)
        {
            if (!File.Exists(imgPath))
            {
                return;
            }

            Image img = Image.FromFile(imgPath);

            if (img.Size.IsEmpty)
            {
                return;
            }

            float newHeight;
            float newWidth;
            float oldWidth=(float)img.Width;
            float oldHeight=(float)img.Height;

            Point newPoint = new Point(0,0) ;//绘图坐标
            bool isScale = false;

            //计算出符合比例的高度和宽度
            if (oldWidth / oldHeight > THUMBNAIL_WIDTH / THUMBNAIL_HEIGHT)//太宽
            {
                newHeight = oldHeight * THUMBNAIL_WIDTH / oldWidth;
                newWidth = THUMBNAIL_WIDTH;
                newPoint.Y = (int)((THUMBNAIL_HEIGHT - newHeight) / 2);
                isScale = true;
            }
            else if (oldWidth / oldHeight == THUMBNAIL_WIDTH / THUMBNAIL_HEIGHT)//比例符合
            {
                newWidth = THUMBNAIL_WIDTH;
                newHeight = THUMBNAIL_HEIGHT;
            }
            else//太高
            {
                newWidth = oldWidth * THUMBNAIL_HEIGHT / oldHeight;
                newHeight = THUMBNAIL_HEIGHT;
                newPoint.X = (int)((THUMBNAIL_WIDTH - newWidth) / 2);
                isScale = true;
            }

            Image thumbnail = img.GetThumbnailImage((int)newWidth, (int)newHeight, new Image.GetThumbnailImageAbort(ThumbnailCallBack),IntPtr.Zero);

            Bitmap outBitmap = (Bitmap)thumbnail;

            if (isScale)
            {
                outBitmap = new Bitmap((int)THUMBNAIL_WIDTH, (int)THUMBNAIL_HEIGHT);
                Graphics g = Graphics.FromImage(outBitmap);
                g.FillRectangle(new SolidBrush(Color.White), 0, 0, (int)THUMBNAIL_WIDTH, (int)THUMBNAIL_HEIGHT);//填充白色背景
                g.DrawImage(thumbnail, (float)newPoint.X, (float)newPoint.Y, newWidth, newHeight);
            }

            if (rename)
            {
                outBitmap.Save(imgPath + ".s");
            }
            else
            {
                outBitmap.Save(imgPath);
            }

            outBitmap.Dispose();

            img.Dispose();
        }

        /// <summary>
        /// 创建图片的缩略图
        /// </summary>
        /// <param name="imgPath">源图片文件路径</param>
        public static void CreateThumbnail(string imgPath)
        {
            CreateThumbnail(imgPath, true);
        }

        /// <summary>
        /// 从文件流创建图片的缩略图
        /// </summary>
        /// <param name="stream">文件流</param>
        /// <param name="savePath">缩略图保存路径</param>
        public static void CreateThumbnail(Stream stream,string savePath)
        {
            if (stream.Length == 0)
            {
                return;
            }

            Image img = Image.FromStream(stream);
            
            float newHeight;
            float newWidth;
            float oldWidth = (float)img.Width;
            float oldHeight = (float)img.Height;

            Point newPoint = new Point(0, 0);//绘图坐标
            bool isScale = false;

            //计算出符合比例的高度和宽度
            if (oldWidth / oldHeight > THUMBNAIL_WIDTH / THUMBNAIL_HEIGHT)//太宽
            {
                newHeight = oldHeight * THUMBNAIL_WIDTH / oldWidth;
                newWidth = THUMBNAIL_WIDTH;
                newPoint.Y = (int)((THUMBNAIL_HEIGHT - newHeight) / 2);
                isScale = true;
            }
            else if (oldWidth / oldHeight == THUMBNAIL_WIDTH / THUMBNAIL_HEIGHT)//比例符合
            {
                newWidth = THUMBNAIL_WIDTH;
                newHeight = THUMBNAIL_HEIGHT;
            }
            else//太高
            {
                newWidth = oldWidth * THUMBNAIL_HEIGHT / oldHeight;
                newHeight = THUMBNAIL_HEIGHT;
                newPoint.X = (int)((THUMBNAIL_WIDTH - newWidth) / 2);
                isScale = true;
            }

            Image thumbnail = img.GetThumbnailImage((int)newWidth, (int)newHeight, new Image.GetThumbnailImageAbort(ThumbnailCallBack), IntPtr.Zero);

            Bitmap outBitmap = (Bitmap)thumbnail;

            if (isScale)
            {
                outBitmap = new Bitmap((int)THUMBNAIL_WIDTH, (int)THUMBNAIL_HEIGHT);
                Graphics g = Graphics.FromImage(outBitmap);
                g.FillRectangle(new SolidBrush(Color.White), 0, 0, (int)THUMBNAIL_WIDTH, (int)THUMBNAIL_HEIGHT);//填充白色背景
                g.DrawImage(thumbnail, (float)newPoint.X, (float)newPoint.Y, newWidth, newHeight);
            }

            outBitmap.Save(savePath);

            outBitmap.Dispose();

            img.Dispose();
        }


        private static bool ThumbnailCallBack()
        {
            return false;
        }

        /// <summary>
        /// 从一组列表中随机抽取元素，组成新的列表
        /// </summary>
        /// <param name="sourceList">源列表</param>
        /// <param name="count">新列表的元素数</param>
        /// <returns>ArrayList</returns>
        public static ArrayList GetRandomList(ArrayList sourceList,int count)
        {
            if (sourceList.Count <= count)
            {
                return sourceList;
            }

            ArrayList list = new ArrayList(count);

            for (int i = 0; i < count; i++)
            {
                int rnd = new Random().Next(0, sourceList.Count);
                list.Add(sourceList[rnd]);
            }
            return list;
        }

        /// <summary>
        /// Logo缩略图尺寸
        /// </summary>
        static readonly float THUMBNAIL_WIDTH = 120;
        static readonly float THUMBNAIL_HEIGHT = 90;

        /// <summary>
        /// Logo对比的最大个数
        /// </summary>
        public static readonly int LOGO_COMPARE_MAXCOUNT = 5;
    }
}
