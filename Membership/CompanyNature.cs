using System;
using System.Collections;
using System.Text;

namespace BrandQQ.Membership
{
    public static class CompanyNature
    {
        static CompanyNature()
        {
            if (t == null)
            {
                t = new Hashtable();
                t.Add("A", "˽Ӫ��ҵ");
                t.Add("B", "������ҵ");
                t.Add("C", "������ҵ");
                t.Add("D", "������ҵ");
                t.Add("E", "���ʶ�����ҵ");
                t.Add("F", "��������");
                t.Add("G", "��ҵ��λ");
                t.Add("H", "����");
            }
        }


        public static Hashtable Natures
        {
            get
            {
                return t;
            }
        }

        /// <summary>
        /// ��ȡ��ҵ��������
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string Get(string key)
        {
            if (String.IsNullOrEmpty(key))
            {
                return "";
            }

            
            try
            {
                return t[key].ToString();
            }
            catch
            {
                //
            }
            return "";
        }

        private static Hashtable t;
    }
}
