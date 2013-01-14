using System;
using System.Collections;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace BrandQQ.Logo.FontGlyph
{
    public class Glyph
    {
        protected Glyph() { }
        public Glyph(string fntName, string fntStyle, string str,int fSzie)
        {
            this.font = new FontFamily(fntName);
            this.fontStyle = FontStyle.Regular;
            if (fntStyle.Substring(0, 1) == "1")
            {
                this.fontStyle |= FontStyle.Bold;
            }

            if (fntStyle.Substring(1, 1) == "1")
            {
                this.fontStyle |= FontStyle.Italic;
            }

            this.text = str.Trim();
            string txt;

            this.glyphPaths = new Hashtable();

            for (int i = 0; i < this.text.Length; i++)
            {
                txt = this.text[i].ToString();
                if (!this.glyphPaths.Contains(txt))
                {
                    this.glyphPaths.Add(txt, new GlyphPath());
                }
            }

            GraphicsPath path = new GraphicsPath();
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.LineAlignment = StringAlignment.Near;

            foreach (string c in this.glyphPaths.Keys)
            {
                path.AddString(c, this.font, (int)this.fontStyle, fSzie, new Point(0, 0), sf);
                ((GlyphPath)(this.glyphPaths[c])).SetData(c, path.PathData, path.GetBounds());
                path.Reset();
            }
            
            path.Dispose();
            //Init();
        }

        /// <summary>
        /// 以XML格式返回轮廓数据
        /// </summary>
        /// <returns></returns>
        public string GetXML()
        {
            StringBuilder xml = new StringBuilder();
            xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            xml.AppendLine("<R>");
            byte pt;
            GlyphPath g;
            foreach (string c in this.glyphPaths.Keys)
            {
                g = (GlyphPath)(this.glyphPaths[c]);
                xml.AppendLine("    <G>");
                xml.AppendLine("        <T><![CDATA[" + g.Character + "]]></T>");
                xml.AppendLine("        <P s=\"" + g.Size.Width.ToString() + "," + g.Size.Height.ToString() + "\">");
                for (int i = 0; i < g.Points.Length; i++)
                {
                    pt = g.Types[i];

                    if (pt == 0)
                    {
                        xml.AppendLine("            <S t=\"0\" p=\"" + g.Points[i].X.ToString() + "," + g.Points[i].Y.ToString() + "\" />");
                    }
                    else if (pt == 1 || pt == 129 || pt == 161)
                    {
                        xml.AppendLine("            <S t=\"1\" p=\"" + g.Points[i].X.ToString() + "," + g.Points[i].Y.ToString() + "\" />");
                    }
                    else if (pt == 3 || pt == 131 || pt == 163)
                    {
                        xml.Append("            <S t=\"2\" p=\"" + g.Points[i - 1].X.ToString() + "," + g.Points[i - 1].Y.ToString() + ",");
                        xml.Append(g.Points[i].X.ToString() + "," + g.Points[i].Y.ToString() + ",");
                        xml.Append(g.Points[i + 1].X.ToString() + "," + g.Points[i + 1].Y.ToString() + ",");
                        xml.AppendLine(g.Points[i + 2].X.ToString() + "," + g.Points[i + 2].Y.ToString() + "\" />");
                        i += 2;
                    }
                }
                xml.AppendLine("        </P>");
                xml.AppendLine("    </G>");
            }

            xml.AppendLine("</R>");

            return xml.ToString();
        }

        public override string ToString()
        {
            StringBuilder str = new StringBuilder();
            GlyphPath g;
            foreach (string c in this.glyphPaths.Keys)
            {
                g = (GlyphPath)(this.glyphPaths[c]);
                for (int i = 0; i < g.Points.Length; i++)
                {
                    str.AppendLine("PointType=" + g.Types[i].ToString() + ",Point=" + g.Points[i].ToString() + "");
                }
            }
            return str.ToString();
        }

        /*
               private byte[] GetBytes()
               {
                   IGlyphPath glyphPath;
                   int i;

                   PointF p0;//segement start point
                   byte pt;
                   for (i = 0; i < pathPoints.Length; i++)
                   {
                       pt = pathPointTypes[i];
                       if (pt == 0)
                       {
                           p0 = pathPoints[i];
                           glyphPath = new StartPath(pathPoints[i]);
                           pathCollection.Add(glyphPath);
                           byteLength += glyphPath.BytesLength;
                       }
                       else if (pt == 1 || pt == 129 || pt == 161)
                       {
                           glyphPath = new LinePath(pathPoints[i]);
                           pathCollection.Add(glyphPath);
                           byteLength += glyphPath.BytesLength;
                       }
                       else if (pt == 3 || pt == 131 || pt == 163)
                       {
                           CurvePath[] ps = caclCurvePoints(new PointF[] { pathPoints[i-1], pathPoints[i], pathPoints[i + 1], pathPoints[i + 2] });
                           for (int n = 0; n < ps.Length; n++)
                           {
                               pathCollection.Add(ps[n]);
                               byteLength += ps[n].BytesLength;
                           }
                           i += 2;
                       }
                   }

                   byte[] bytes = new byte[this.byteLength];
                   int s = 0;
                   byte[] b;
                   foreach (IGlyphPath path in pathCollection)
                   {
                       b = path.GetData;
                       b.CopyTo(bytes, s);
                       s += b.Length;
                   }

                   return bytes;
               }


               /// <summary>
               /// 中点法转化三次Bezier为二次Bezier
               /// </summary>
               /// <param name="points">三次Bezier的四个点</param>
               /// <returns>二次Bezier</returns>
               private CurvePath[] caclCurvePoints(PointF[] points)
               {
                   PointF p1 = points[0];
                   PointF c1 = points[1];
                   PointF c2 = points[2];
                   PointF p2 = points[3];
            
                   PointF anchor1, anchor2, anchor3, anchor4, anchor5;
                   PointF control1, control2, control3, control4;

                   anchor1 = p1;
                   anchor5 = p2;

                   PointF m1 = GetMidPoint(p1, c1);
                   PointF m2 = GetMidPoint(c1, c2);
                   PointF m3 = GetMidPoint(c2, p2);
                   PointF m4 = GetMidPoint(m1, m2);
                   PointF m5 = GetMidPoint(m2, m3);

                   anchor3 = GetMidPoint(m4, m5);

                   PointF m6 = GetMidPoint(p1, m1);
                   PointF m7 = GetMidPoint(p2, m3);

                   PointF m8 = GetMidPoint(m4, anchor3);
                   PointF m9 = GetMidPoint(anchor3, m5);

                   control1 = GetMidPoint(m6, m1);
                   control2 = GetMidPoint(m4, m8);
                   control3 = GetMidPoint(m9, m5);
                   control4 = GetMidPoint(m3, m7);

                   anchor2 = GetMidPoint(control1, control2);
                   anchor4 = GetMidPoint(control3, control4);

                   CurvePath[] paths=new CurvePath[4];
                   paths[0] = new CurvePath(control1, anchor2);
                   paths[1] = new CurvePath(control2, anchor3);
                   paths[2] = new CurvePath(control3, anchor4);
                   paths[3] = new CurvePath(control4, anchor5);
                   return paths;
               }

               private PointF GetMidPoint(PointF p1, PointF p2)
               {
                   PointF midPoint = new PointF(0, 0);
                   if (p1.X == p2.X)
                   {
                       midPoint.X = p1.X;
                   }
                   if (p1.X < p2.X)
                   {
                       midPoint.X = p1.X + (p2.X - p1.X) / 2;
                   }
                   if (p1.X > p2.X)
                   {
                       midPoint.X = p2.X + (p1.X - p2.X) / 2;
                   }
                   if (p1.Y == p2.Y)
                   {
                       midPoint.Y = p1.Y;
                   }
                   if (p1.Y < p2.Y)
                   {
                       midPoint.Y = p1.Y + (p2.Y - p1.Y) / 2;
                   }
                   if (p1.Y > p2.Y)
                   {
                       midPoint.Y = p2.Y + (p1.Y - p2.Y) / 2;
                   }

                   return midPoint;
               }
               private ArrayList pathCollection;
               private int byteLength;
       */

        

        private FontFamily font;
        private FontStyle fontStyle;
        private string text;

        private Hashtable glyphPaths;
        
    }

}
