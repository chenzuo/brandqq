using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace BrandQQ.Logo.FontGlyph
{
    class GlyphPath
    {
        public GlyphPath()
        {
            this.character = "";
            this.points = new PointF[0];;
            this.pointTypes = new byte[0];
            this.size = new SizeF(0,0);
        }

        public void SetData(string c,PathData pd,RectangleF rect)
        {
            this.character = c;
            this.points = pd.Points;
            this.pointTypes = pd.Types;
            this.size = new SizeF(rect.Width, rect.Height);
        }


        public string Character
        {
            get
            {
                return this.character;
            }
            set
            {
                this.character = value;
            }
        }

        public PointF[] Points
        {
            get
            {
                return this.points;
            }
        }

        public byte[] Types
        {
            get
            {
                return this.pointTypes;
            }
        }

        public SizeF Size
        {
            get
            {
                return this.size;
            }
        }

        private string character;
        private PointF[] points;
        private byte[] pointTypes;
        private SizeF size;
    }
}
