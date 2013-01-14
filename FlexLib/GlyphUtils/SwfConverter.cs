using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Drawing;

using SwfDotNet.IO;
using SwfDotNet.IO.Tags;
using SwfDotNet.IO.Tags.Types;

namespace BrandQQ.FlexLib.GlyphUtils
{
    /// <summary>
    /// 提取SWF文件第一帧中的轮廓
    /// </summary>
    public sealed class SwfConverter:IConverter
    {
        public SwfConverter(string file)
        {
            SwfReader reader = new SwfReader(file);
            swf = reader.ReadSwf();
            reader.Close();
            Convert();
        }

        public SwfConverter(Stream stream)
        {
            SwfReader reader = new SwfReader(stream);
            swf = reader.ReadSwf();
            reader.Close();
            Convert();
        }

        private void Convert()
        {
            DefineShape shape;
            glyph = new Glyph(GlyphType.Symbol); ;
            Segment seg;
            PointF point0;
            PointF basePoint = new PointF(0, 0);
            PointF curvePoint1, curvePoint2;

            foreach (BaseTag tag in swf.Tags)
            {
                if (tag is DefineShape)
                {
                    shape = (DefineShape)tag;
                    glyph.Rect = shape.Rect.RectangleF;

                    foreach (ShapeRecord record in shape.ShapeWithStyle.Shapes)
                    {
                        if (record is StyleChangeRecord)
                        {
                            basePoint = ((StyleChangeRecord)record).Point0;
                            seg = new Segment(SegmentType.StartPoint, new PointF[] { basePoint });
                            glyph.Segments.Add(seg);
                        }
                        else if (record is StraightEdgeRecord)
                        {
                            point0 = ((StraightEdgeRecord)record).Point0;
                            basePoint.X += point0.X;
                            basePoint.Y += point0.Y;
                            seg = new Segment(SegmentType.Line, new PointF[] { basePoint });
                            glyph.Segments.Add(seg);
                        }
                        else if (record is CurvedEdgeRecord)
                        {
                            point0 = ((CurvedEdgeRecord)record).Point0;
                            curvePoint1 = basePoint;
                            curvePoint1.X += point0.X;
                            curvePoint1.Y += point0.Y;

                            point0 = ((CurvedEdgeRecord)record).Point1;
                            curvePoint2 = curvePoint1;
                            curvePoint2.X += point0.X;
                            curvePoint2.Y += point0.Y;

                            basePoint = curvePoint2;

                            seg = new Segment(SegmentType.QuadraticBezier, new PointF[] { curvePoint1, curvePoint2 });
                            glyph.Segments.Add(seg);
                        }
                    }
                }

                if (tag is ShowFrameTag)
                {
                    break;
                }
            }
        }

        private Glyph glyph;
        private Swf swf;

        #region IConverter 成员

        /// <summary>
        /// 获取轮廓
        /// </summary>
        /// <returns></returns>
        public Glyph GetGlyph()
        {
            return glyph;
        }

        #endregion
    }
}
