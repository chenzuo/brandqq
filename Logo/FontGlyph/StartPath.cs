using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace BrandQQ.Logo.FontGlyph
{
    public class StartPath:IGlyphPath
    {
        protected StartPath() { }

        public StartPath(PointF point)
        {
            this.type = PathType.Start;
            this.pointNum = 0x1;
            this.points = new PointF[] { point };
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
                return 2 + 8;
            }
        }

        public PointF[] Points
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
                byte[] bytes = new byte[10];
                bytes[0] = (byte)this.type;
                bytes[1] = this.pointNum;
                byte[] xBytes = BitConverter.GetBytes(this.points[0].X);
                xBytes.CopyTo(bytes, 2);
                byte[] yBytes = BitConverter.GetBytes(this.points[0].Y);
                xBytes.CopyTo(bytes, 6);
                return bytes;
            }
        }

        #endregion
    }
}
