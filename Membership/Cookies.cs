using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace BrandQQ.Membership
{
    /// <summary>
    /// ����COOKIE�ľ�̬��
    /// </summary>
    public static class Cookies
    {
        /// <summary>
        /// ��鵱ǰӦ���Ƿ����ָ������Cookie
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <returns></returns>
        public static bool HasCookie(string name)
        {
            return HttpContext.Current.Request.Cookies[name] != null;
        }

        /// <summary>
        /// ���ָ��COOKIE�Ƿ����ָ����ֵ
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <param name="key">����</param>
        /// <param name="value">��ֵ</param>
        /// <returns></returns>
        public static bool HasCookieValue(string name, string key, string value)
        {
            if (!HasCookie(name))
            {
                return false;
            }

            if (HttpContext.Current.Request.Cookies[name].Values[key] == null)
            {
                return false;
            }

            return HttpContext.Current.Request.Cookies[name].Values[key] == value;
        }

        /// <summary>
        ///  ���ָ��COOKIE�Ƿ����ָ����ֵ
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <param name="key">����</param>
        /// <param name="value">��ֵ</param>
        /// <returns></returns>
        public static bool HasCookieValue(string name, string key, int value)
        {
            return HasCookieValue(name, key, value.ToString());
        }

        /// <summary>
        /// дCOOKIE����
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <param name="keys">��������</param>
        /// <param name="values">��ֵ����</param>
        public static void WriteCookie(string name, string[] keys, string[] values)
        {
            WriteCookie(name, "", 0, keys, values);
        }

        /// <summary>
        /// дCOOKIE����
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <param name="expires">��������</param>
        /// <param name="keys">��������</param>
        /// <param name="values">��ֵ����</param>
        public static void WriteCookie(string name, int expires, string[] keys, string[] values)
        {
            WriteCookie(name, "", expires, keys, values);
        }

        /// <summary>
        /// дCOOKIE����
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <param name="domain">COOKIE��</param>
        /// <param name="keys">��������</param>
        /// <param name="values">��ֵ����</param>
        public static void WriteCookie(string name, string domain, string[] keys, string[] values)
        {
            WriteCookie(name, domain, 0, keys, values);
        }

        /// <summary>
        /// дCOOKIE����
        /// </summary>
        /// <param name="name">cookie����</param>
        /// <param name="domain">COOKIE��</param>
        /// <param name="expires">��������</param>
        /// <param name="keys">��������</param>
        /// <param name="values">��ֵ����</param>
        public static void WriteCookie(string name, string domain, int expires, string[] keys, string[] values)
        {
            HttpCookie cookie;
            if (!HasCookie(name))
            {
                cookie = new HttpCookie(name);
            }
            else
            {
                cookie = HttpContext.Current.Request.Cookies[name];
            }

            if (!String.IsNullOrEmpty(domain))
            {
                cookie.Domain = domain;
            }

            if (expires > 0)
            {
                cookie.Expires = DateTime.Now.AddDays(expires);
            }

            if (keys.Length >= values.Length)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    cookie.Values[keys[i]] = values[i];
                }
            }
            else
            {
                for (int i = 0; i < keys.Length; i++)
                {
                    cookie.Values[keys[i]] = values[i];
                }
            }

            HttpContext.Current.Response.AppendCookie(cookie);
        }

        /// <summary>
        /// ��ȡָ��COOKIE���ض���ֵ
        /// </summary>
        /// <param name="name">Cookie����</param>
        /// <param name="key">����</param>
        /// <returns>String</returns>
        public static string GetCookieValue(string name, string key)
        {
            if (!HasCookie(name))
            {
                return String.Empty;
            }

            if (HttpContext.Current.Request.Cookies[name].Values[key] == null)
            {
                return String.Empty;
            }

            return HttpContext.Current.Request.Cookies[name][key].ToString();
        }

        /// <summary>
        /// ɾ��һ��Cookie
        /// </summary>
        /// <param name="name"></param>
        public static void RemoveCookie(string name)
        {
            HttpContext.Current.Response.Cookies[name].Expires=DateTime.Now;
        }
    }
}
