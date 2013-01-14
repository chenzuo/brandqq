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
        /// ��ҵ����
        /// </summary>
        public static ArrayList Industries
        {
            get
            {
                return industryCollection;
            }
        }

        /// <summary>
        /// ��ȡָ��������Ӽ�����
        /// </summary>
        /// <param name="code">����</param>
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
        /// ���ݱ�Ż�ȡ����
        /// </summary>
        /// <param name="code">���</param>
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
        /// ������ҵ����ƶ�����ģʽ
        /// </summary>
        /// <param name="code">��ҵ���</param>
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
        /// ��ҵ����
        /// </summary>
        private static ArrayList industryCollection;

        public static Hashtable IndustryNames;
        public static Hashtable IndustryBTypes;
    }
}
