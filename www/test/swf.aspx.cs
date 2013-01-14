using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Drawing;
using SwfDotNet.IO;
using SwfDotNet.IO.Tags;
using SwfDotNet.IO.Tags.Types;

using BrandQQ.FlexLib;

public partial class test_swf : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        SwfReader reader = new SwfReader(@"F:\BrandQQ\www\test\100107105.swf");
        Swf swf = reader.ReadSwf();
        reader.Close();

        DefineShape shape;
        Glyph glyph = new Glyph(GlyphType.Symbol); ;
        Segment seg;
        PointF point0;
        PointF basePoint=new PointF(0,0);
        PointF curvePoint1,curvePoint2;

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
}
