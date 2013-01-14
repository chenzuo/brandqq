using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib
{
    public enum GlyphType
    {
        /// <summary>
        /// 未知类型
        /// </summary>
        None=0x0,

        /// <summary>
        /// 文本串
        /// </summary>
        Text = 0x1,

        /// <summary>
        /// 图形
        /// </summary>
        Symbol = 0x2
    }

    public enum SegmentType
    {
        /// <summary>
        /// 线段起点
        /// </summary>
        StartPoint = 0x0,

        /// <summary>
        /// 直线
        /// </summary>
        Line = 0x1,

        /// <summary>
        /// 二次贝塞尔曲线
        /// </summary>
        QuadraticBezier = 0x2,

        /// <summary>
        /// 三次贝塞尔曲线
        /// </summary>
        CubicBezier = 0x3
    }
}
