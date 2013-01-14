using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace BrandQQ.Logo.FontGlyph
{
    public class CurvePath:IGlyphPath
    {
        protected CurvePath() { }
        public CurvePath(PointF controlPoint,PointF endPoint)
        {
            this.type = PathType.Curve;
            this.pointNum = 0x2;
            this.points = new PointF[2] { controlPoint, endPoint };
        }

        private PathType type;
        private byte pointNum;
        private PointF[] points;

        #region IGlyphPath ≥…‘±

        public PathType Type
        {
            get 
            {
                return this.type;
            }
        }

        public byte PointNum
        {
            get
            {
                return this.pointNum;
            }
        }

        public int BytesLength
        {
            get
            {
                return 2+2*8;
            }
        }

        public System.Drawing.PointF[] Points
        {
            get
            {
                return this.points;
            }
        }

        public byte[] GetData
        {
            get
            {
                byte[] bytes = new byte[18];
                bytes[0] = (byte)this.type;
                bytes[1] = this.pointNum;
                byte[] x1Bytes = BitConverter.GetBytes(this.points[0].X);
                x1Bytes.CopyTo(bytes, 2);
                byte[] y1Bytes = BitConverter.GetBytes(this.points[0].Y);
                x1Bytes.CopyTo(bytes, 6);
                byte[] x2Bytes = BitConverter.GetBytes(this.points[1].X);
                x2Bytes.CopyTo(bytes, 10);
                byte[] y2Bytes = BitConverter.GetBytes(this.points[1].Y);
                x2Bytes.CopyTo(bytes, 14);
                return bytes;
            }
        }

        #endregion
    }
}
