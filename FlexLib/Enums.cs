using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib
{
    public enum GlyphType
    {
        /// <summary>
        /// δ֪����
        /// </summary>
        None=0x0,

        /// <summary>
        /// �ı���
        /// </summary>
        Text = 0x1,

        /// <summary>
        /// ͼ��
        /// </summary>
        Symbol = 0x2
    }

    public enum SegmentType
    {
        /// <summary>
        /// �߶����
        /// </summary>
        StartPoint = 0x0,

        /// <summary>
        /// ֱ��
        /// </summary>
        Line = 0x1,

        /// <summary>
        /// ���α���������
        /// </summary>
        QuadraticBezier = 0x2,

        /// <summary>
        /// ���α���������
        /// </summary>
        CubicBezier = 0x3
    }
}
