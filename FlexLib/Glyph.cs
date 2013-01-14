using System;
using System.Collections;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace BrandQQ.FlexLib
{
    /// <summary>
    /// 表示一个轮廓
    /// </summary>
    public sealed class Glyph:IBytes
    {
        public Glyph(GlyphType glyphType)
        {
            segments = new ArrayList();
            rect = new RectangleF();
            type = glyphType;
        }

        /// <summary>
        /// 从指定样式的文本创建相应的轮廓
        /// </summary>
        /// <param name="text">文本内容</param>
        /// <param name="font">字体</param>
        /// <param name="fontSize">字号</param>
        /// <param name="style">样式</param>
        /// <returns></returns>
        public static Glyph CreateFromText(string text,FontFamily font,int fontSize,FontStyle style)
        {
            Glyph glyph = new Glyph(GlyphType.Text);
            GraphicsPath path = new GraphicsPath();
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.LineAlignment = StringAlignment.Near;

            path.AddString(text, font, (int)style, fontSize, new Point(0, 0), sf);

            //将边框矩形左上角恢复到{0,0}点
            glyph.rect = path.GetBounds();
            float xOffset = glyph.rect.X;
            float yOffset = glyph.rect.Y;
            glyph.rect.X = 0;
            glyph.rect.Y = 0;
            glyph.rect.Width -= xOffset;
            glyph.rect.Height -= yOffset;

            byte pt;
            PointF pp;
            PointF pp0;
            PointF pp1;
            PointF pp2;

            for (int i = 0; i < path.PointCount; i++)
            {
                pt = path.PathTypes[i];
                pp = path.PathPoints[i];
                pp.X -= xOffset;
                pp.Y -= yOffset;
                if (pt == 0)
                {
                    glyph.segments.Add(new Segment(SegmentType.StartPoint, new PointF[] { pp }));
                }
                else if (pt == 1 || pt == 129 || pt == 161)
                {
                    glyph.segments.Add(new Segment(SegmentType.Line, new PointF[] { pp }));
                }
                else if (pt == 3 || pt == 131 || pt == 163)
                {
                    pp0 = path.PathPoints[i - 1];
                    pp1 = path.PathPoints[i + 1];
                    pp2 = path.PathPoints[i + 2];
                    pp0.X -= xOffset;
                    pp0.Y -= yOffset;
                    pp1.X -= xOffset;
                    pp1.Y -= yOffset;
                    pp2.X -= xOffset;
                    pp2.Y -= yOffset;

                    glyph.segments.Add(new Segment(SegmentType.CubicBezier,
                            new PointF[] { pp0, pp, pp1, pp2 }));
                    i += 2;
                }
            }

            return glyph;
        }

        /// <summary>
        /// 从给定的swf文件中提起轮廓
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public static Glyph CreateFromSwfFile(string file)
        {
            Glyph glyph = new Glyph(GlyphType.Symbol);

            return glyph;
        }

        public GlyphType Type
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

        public RectangleF Rect
        {
            get
            {
                return this.rect;
            }
            set
            {
                this.rect = value;
            }
        }

        public ArrayList Segments
        {
            get
            {
                return this.segments;
            }
            set
            {
                this.segments = value;
            }
        }

        private GlyphType type;
        private RectangleF rect;
        private ArrayList segments;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            MemoryStream stream = new MemoryStream();
            FileWriter writer = new FileWriter(stream);
            writer.Write((byte)type);
            writer.Write((uint)0);//字节数
            writer.Write(rect.X);
            writer.Write(rect.Y);
            writer.Write(rect.Width);
            writer.Write(rect.Height);

            foreach (Segment seg in segments)
            {
                writer.Write(seg.GetBytes());
            }

            writer.Seek(1, SeekOrigin.Begin);
            writer.Write((uint)(stream.Length - 1));//更新字节数
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
