using System;
using System.Collections;
using System.Text;
using System.IO;
using System.Drawing;

namespace BrandQQ.FlexLib
{
    public sealed class Segment : IBytes
    {
        public Segment(SegmentType type, PointF[] points)
        {
            this.type = type;
            this.points = points;
        }

        public SegmentType Type
        {
            get
            {
                return this.type;
            }
            set
            {
                this.type = value;
            }
        }

        public PointF[] Points
        {
            get
            {
                return this.points;
            }
            set
            {
                this.points = value;
            }
        }

        private SegmentType type;
        private PointF[] points;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            MemoryStream stream = new MemoryStream();
            FileWriter writer = new FileWriter(stream);
            writer.Write((byte)type);
            //writer.Write((uint)0);//字节数

            foreach (PointF p in points)
            {
                writer.Write(p.X);
                writer.Write(p.Y);
            }

            //writer.Seek(1, SeekOrigin.Begin);
            //writer.Write(stream.Length - 1);//更新字节数
            
            writer.Seek(0, SeekOrigin.Begin);

            BinaryReader reader = new BinaryReader(stream);
            byte[] buffer = reader.ReadBytes((int)stream.Length);

            byte[] newBuffer = new byte[buffer.Length];
            buffer.CopyTo(newBuffer, 0);
            reader.Close();
            writer.Close();
            stream.Dispose();
            return buffer;
        }

        public void WriteTo(FileWriter writer)
        {
            writer.Write(GetBytes());
        }

        #endregion
    }
}
