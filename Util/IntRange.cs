using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// 表示一个整数范围
    /// </summary>
    [Serializable]
    public struct IntRange
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="l">下限(包含)</param>
        /// <param name="u">上限</param>
        public IntRange(int l, int u)
        {
            Lower = l;
            Upper = u;
        }
        /// <summary>
        /// 下限(包含)
        /// </summary>
        public int Lower;

        /// <summary>
        /// 上限
        /// </summary>
        public int Upper;

        /// <summary>
        /// 返回一个为都为负1的整数范围
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
