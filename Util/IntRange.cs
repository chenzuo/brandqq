using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// ��ʾһ��������Χ
    /// </summary>
    [Serializable]
    public struct IntRange
    {
        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="l">����(����)</param>
        /// <param name="u">����</param>
        public IntRange(int l, int u)
        {
            Lower = l;
            Upper = u;
        }
        /// <summary>
        /// ����(����)
        /// </summary>
        public int Lower;

        /// <summary>
        /// ����
        /// </summary>
        public int Upper;

        /// <summary>
        /// ����һ��Ϊ��Ϊ��1��������Χ
        /// </summary>
        public static IntRange None
        {
            get
            {
                return new IntRange(-1,-1);
            }
        }

        public new string ToString()
        {
            return this.Lower.ToString() + " - " + this.Upper.ToString();
        }
    }
}
