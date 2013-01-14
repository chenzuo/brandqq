using System;
using System.Collections;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// 地区
    /// </summary>
    public static class Region
    {
        static Region()
        {
            if (t == null)
            {
                t = new Hashtable();
                t.Add("1000", "北京");
                t.Add("1100", "上海");
                t.Add("1200", "天津");
                t.Add("1300", "重庆");
                t.Add("1400", "浙江");
                t.Add("1500", "福建");
                t.Add("1600", "江苏");
                t.Add("1700", "安徽");
                t.Add("1800", "广东");
                t.Add("1900", "广西");
                t.Add("2000", "贵州");
                t.Add("2100", "海南");
                t.Add("2200", "河北");
                t.Add("2300", "河南");
                t.Add("2400", "黑龙江");
                t.Add("2500", "湖北");
                t.Add("2600", "湖南");
                t.Add("2700", "吉林");
                t.Add("2800", "江西");
                t.Add("2900", "辽宁");
                t.Add("3000", "内蒙古");
                t.Add("3100", "宁夏");
                t.Add("3200", "青海");
                t.Add("3300", "山东");
                t.Add("3400", "山西");
                t.Add("3500", "陕西");
                t.Add("3600", "云南");
                t.Add("3700", "四川");
                t.Add("3800", "甘肃");
                t.Add("3900", "新疆");
                t.Add("4000", "西藏");
                t.Add("4100", "香港");
                t.Add("4200", "澳门");
                t.Add("4300", "台湾");
                t.Add("4400", "其他");
            }
        }

        /// <summary>
        /// 地区Hashtable
        /// </summary>
        public static Hashtable Regions
        {
            get
            {
                return t;
            }
        }

        /// <summary>
        /// 由一个编号获取地区名字
        /// </summary>
        /// <param name="key">编号</param>
        /// <returns>对于不存在的编号将返回空字符串</returns>
        public static string Get(string key)
        {
            if (String.IsNullOrEmpty(key))
            {
                return "";
            }

            if (t.ContainsKey(key))
            {
                return t[key].ToString();
            }
            else
            {
                return "";
            }
        }

        private static Hashtable t;
    }
}
