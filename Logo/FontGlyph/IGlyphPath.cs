using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace BrandQQ.Logo.FontGlyph
{
    public interface IGlyphPath
    {
        PathType Type{get;}
        byte PointNum{get;}
        int BytesLength { get;}
        PointF[] Points { get;}
        byte[] GetData{get;}
    }
}
