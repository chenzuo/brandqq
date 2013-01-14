using System;
using System.Collections;
using System.Text;
using System.Xml;

using BrandQQ.Util;

namespace BrandQQ.Membership
{
    public static class IndustryUtil
    {
        static IndustryUtil()
        {
            if (industryCollection == null)
            {

                industryCollection = new ArrayList();
                IndustryNames = new Hashtable();
                IndustryBTypes = new Hashtable();

                XmlDocument doc = new XmlDocument();
                doc.Load(GeneralConfig.Instance.IndustryDictionaryFile);
                foreach (XmlNode node in doc.DocumentElement.SelectNodes("Industry"))
                {
                    industryCollection.Add(new Industry(node));
                }
            }
        }

        /// <summary>
        /// 行业类型
        /// </summary>
        public static ArrayList Industries
        {
            get
            {
                return industryCollection;
            }
        }

        /// <summary>
        /// 获取指定代码的子级集合
        /// </summary>
        /// <param name="code">代码</param>
        /// <returns></returns>
        public static ArrayList GetChildren(string code)
        {
            foreach (Industry indus in industryCollection)
            {
                if (indus.Code == code)
                {
                    return indus.Children;
                }
            }

            return new ArrayList();
        }

        /// <summary>
        /// 依据编号获取名称
        /// </summary>
        /// <param name="code">编号</param>
        /// <returns></returns>
        public static string GetName(string code)
        {
            try
            {
                return IndustryNames[code].ToString();
            }
            catch
            {
                //
            }
            return "";
        }

        /// <summary>
        /// 依据行业编号推断生意模式
        /// </summary>
        /// <param name="code">行业编号</param>
        /// <returns>B/C</returns>
        public static BusinessType GetBusiType(string code)
        {
            if (String.IsNullOrEmpty(code))
            {
                return BusinessType.None;
            }

            if (IndustryBTypes.ContainsKey(code))
            {
                if (IndustryBTypes[code].ToString() == "1")
                {
                    return BusinessType.B2B;
                }
                else if (IndustryBTypes[code].ToString() == "2")
                {
                    return BusinessType.B2C;
                }
                else
                {
                    return BusinessType.None;
                }
            }
            else
            {
                return BusinessType.None;
            }
        }

        /// <summary>
        /// 行业类型
        /// </summary>
        private static ArrayList industryCollection;

        public static Hashtable IndustryNames;
        public static Hashtable IndustryBTypes;
    }
}
