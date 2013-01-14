using System;
using System.Collections;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// ����
    /// </summary>
    public static class Region
    {
        static Region()
        {
            if (t == null)
            {
                t = new Hashtable();
                t.Add("1000", "����");
                t.Add("1100", "�Ϻ�");
                t.Add("1200", "���");
                t.Add("1300", "����");
                t.Add("1400", "�㽭");
                t.Add("1500", "����");
                t.Add("1600", "����");
                t.Add("1700", "����");
                t.Add("1800", "�㶫");
                t.Add("1900", "����");
                t.Add("2000", "����");
                t.Add("2100", "����");
                t.Add("2200", "�ӱ�");
                t.Add("2300", "����");
                t.Add("2400", "������");
                t.Add("2500", "����");
                t.Add("2600", "����");
                t.Add("2700", "����");
                t.Add("2800", "����");
                t.Add("2900", "����");
                t.Add("3000", "���ɹ�");
                t.Add("3100", "����");
                t.Add("3200", "�ຣ");
                t.Add("3300", "ɽ��");
                t.Add("3400", "ɽ��");
                t.Add("3500", "����");
                t.Add("3600", "����");
                t.Add("3700", "�Ĵ�");
                t.Add("3800", "����");
                t.Add("3900", "�½�");
                t.Add("4000", "����");
                t.Add("4100", "���");
                t.Add("4200", "����");
                t.Add("4300", "̨��");
                t.Add("4400", "����");
            }
        }

        /// <summary>
        /// ����Hashtable
        /// </summary>
        public static Hashtable Regions
        {
            get
            {
                return t;
            }
        }

        /// <summary>
        /// ��һ����Ż�ȡ��������
        /// </summary>
        /// <param name="key">���</param>
        /// <returns>���ڲ����ڵı�Ž����ؿ��ַ���</returns>
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
