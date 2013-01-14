using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Drawing;

namespace BrandQQ.FlexLib
{
    public sealed class FileWriter:BinaryWriter
    {
        public FileWriter(Stream stream)
            : base(stream)
        {
            fileStream = stream;
            littleEndian = true;
        }

        public FileWriter(Stream stream, bool isLittleEndian)
            : base(stream)
        {
            fileStream = stream;
            littleEndian = isLittleEndian;
        }

        public override void Write(float value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(int value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(double value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(long value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(short value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(uint value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(string value)
        {
            base.Write(Encoding.GetEncoding("GB2312").GetBytes(value));
        }

        public override void Write(char ch)
        {
            base.Write(Encoding.GetEncoding("GB2312").GetBytes(new char[] { ch }));
        }

        public override void Write(char[] chars)
        {
            base.Write(Encoding.GetEncoding("GB2312").GetBytes(chars));
        }

        public override void Write(ulong value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public override void Write(ushort value)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(value);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(value);
            }
        }

        public void Write(RectangleF rect)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(rect.X);
                Array.Reverse(bytes);
                base.Write(bytes);
                bytes = BitConverter.GetBytes(rect.Y);
                Array.Reverse(bytes);
                base.Write(bytes);
                bytes = BitConverter.GetBytes(rect.Width);
                Array.Reverse(bytes);
                base.Write(bytes);
                bytes = BitConverter.GetBytes(rect.Height);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(rect.X);
                base.Write(rect.Y);
                base.Write(rect.Width);
                base.Write(rect.Height);
            }
        }

        public void Write(PointF point)
        {
            if (littleEndian)
            {
                byte[] bytes = BitConverter.GetBytes(point.X);
                Array.Reverse(bytes);
                base.Write(bytes);
                bytes = BitConverter.GetBytes(point.Y);
                Array.Reverse(bytes);
                base.Write(bytes);
            }
            else
            {
                base.Write(point.X);
                base.Write(point.Y);
            }
        }

        public void Write(PointF[] points)
        {
            foreach (PointF point in points)
            {
                if (littleEndian)
                {
                    byte[] bytes = BitConverter.GetBytes(point.X);
                    Array.Reverse(bytes);
                    base.Write(bytes);
                    bytes = BitConverter.GetBytes(point.Y);
                    Array.Reverse(bytes);
                    base.Write(bytes);
                }
                else
                {
                    base.Write(point.X);
                    base.Write(point.Y);
                }
            }
        }

        private Stream fileStream;
        private bool littleEndian;
    }
}
