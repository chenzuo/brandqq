using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Drawing;

namespace BrandQQ.FlexLib.Files.Types
{
    public class Thumbnail
    {
        public Thumbnail(byte[] thumbnail,ThumbnailType type)
        {
            thumbType = type;
            Stream stream = new MemoryStream(thumbnail);
            FileReader reader = new FileReader(stream);
            reader.ReadBytes(4);//skip Tag 'THUM'

            width = (int)(reader.ReadUInt32());
            height = (int)(reader.ReadUInt32());

            byte[] readBytes = reader.ReadBytes(thumbnail.Length-12);
            pngBytes = new byte[readBytes.Length];
            readBytes.CopyTo(pngBytes, 0);

            stream.Close();
            reader.Close();
        }

        public void Save(string file)
        {
            Bitmap outputImage;
            Graphics g;

            Size thumbSize;

            if (thumbType == ThumbnailType.CardThumbnail)
            {
                thumbSize = CardFile.THUMBNAIL_SIZE;
            }
            else
            {
                thumbSize = LogoFile.THUMBNAIL_SIZE;
            }

            if (pngBytes.Length <= 0)//¿Õ°×
            {
                outputImage = new Bitmap(thumbSize.Width, thumbSize.Height);
                g = Graphics.FromImage(outputImage);
                g.FillRectangle(new SolidBrush(Color.White), 0, 0, thumbSize.Width, thumbSize.Height);//Ìî³ä°×É«±³¾°
                g.DrawLine(Pens.Gray, 0, 0, thumbSize.Width, thumbSize.Height);
                g.DrawLine(Pens.Gray, thumbSize.Width, 0, 0, thumbSize.Height);
                outputImage.Save(file);
                g.Dispose();
                outputImage.Dispose();
                return;
            }


            Stream stream = new MemoryStream(pngBytes);
            Image source = Bitmap.FromStream(stream);

            PointF newPoint = new Point(0, 0);//»æÍ¼×ø±ê
            Size newSize = new Size();
            bool isScale = false;
            

            //¼ÆËã³ö·ûºÏ±ÈÀýµÄ¸ß¶ÈºÍ¿í¶È
            if (width / height > thumbSize.Width / thumbSize.Height)//Ì«¿í
            {
                newSize.Height = height * thumbSize.Width / width;
                newSize.Width = thumbSize.Width;
                newPoint.Y = (thumbSize.Height - newSize.Height) / 2;
                isScale = true;
            }
            else if (width / height == thumbSize.Width / thumbSize.Height)//±ÈÀý·ûºÏ
            {
                newSize.Width = thumbSize.Width;
                newSize.Height = thumbSize.Height;
            }
            else//Ì«¸ß
            {
                newSize.Width = width * thumbSize.Height / height;
                newSize.Height = thumbSize.Height;
                newPoint.X = (thumbSize.Width - newSize.Width) / 2;
                isScale = true;
            }

            Image thumbnail = source.GetThumbnailImage(newSize.Width, newSize.Height, new Image.GetThumbnailImageAbort(ThumbnailCallBack), IntPtr.Zero);

            outputImage = (Bitmap)thumbnail;

            if (isScale)
            {
                outputImage = new Bitmap(thumbSize.Width, thumbSize.Height);
                g = Graphics.FromImage(outputImage);
                g.FillRectangle(new SolidBrush(Color.White), 0, 0, thumbSize.Width, thumbSize.Height);//Ìî³ä°×É«±³¾°
                g.DrawImage(thumbnail, newPoint.X, newPoint.Y, newSize.Width, newSize.Height);
            }

            outputImage.Save(file);

            outputImage.Dispose();
            thumbnail.Dispose();
            source.Dispose();
            stream.Dispose();
        }

        private bool ThumbnailCallBack()
        {
            return false;
        }

        public ThumbnailType Type
        {
            get
            {
                return thumbType;
            }
        }

        public int Width
        {
            get
            {
                return width;
            }
        }

        public int Height
        {
            get
            {
                return height;
            }
        }

        public byte[] Png
        {
            get
            {
                return pngBytes;
            }
        }

        private ThumbnailType thumbType;
        private int width;
        private int height;
        private byte[] pngBytes;

        private const string Tag = "THUM";
    }
}
