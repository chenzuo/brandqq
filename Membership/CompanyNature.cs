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
                t.Add("A", "私营企业");
                t.Add("B", "集体企业");
                t.Add("C", "国有企业");
                t.Add("D", "合资企业");
                t.Add("E", "外资独资企业");
                t.Add("F", "政府机关");
                t.Add("G", "事业单位");
                t.Add("H", "其他");
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
        /// 获取企业性质描述
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
