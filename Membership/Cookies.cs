using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace BrandQQ.Membership
{
    /// <summary>
    /// 操作COOKIE的静态类
    /// </summary>
    public static class Cookies
    {
        /// <summary>
        /// 检查当前应用是否包含指定名称Cookie
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <returns></returns>
        public static bool HasCookie(string name)
        {
            return HttpContext.Current.Request.Cookies[name] != null;
        }

        /// <summary>
        /// 检查指定COOKIE是否包含指定键值
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <param name="key">键名</param>
        /// <param name="value">键值</param>
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
        ///  检查指定COOKIE是否包含指定键值
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <param name="key">键名</param>
        /// <param name="value">键值</param>
        /// <returns></returns>
        public static bool HasCookieValue(string name, string key, int value)
        {
            return HasCookieValue(name, key, value.ToString());
        }

        /// <summary>
        /// 写COOKIE操作
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <param name="keys">键名数组</param>
        /// <param name="values">键值数组</param>
        public static void WriteCookie(string name, string[] keys, string[] values)
        {
            WriteCookie(name, "", 0, keys, values);
        }

        /// <summary>
        /// 写COOKIE操作
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <param name="expires">过期天数</param>
        /// <param name="keys">键名数组</param>
        /// <param name="values">键值数组</param>
        public static void WriteCookie(string name, int expires, string[] keys, string[] values)
        {
            WriteCookie(name, "", expires, keys, values);
        }

        /// <summary>
        /// 写COOKIE操作
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <param name="domain">COOKIE域</param>
        /// <param name="keys">键名数组</param>
        /// <param name="values">键值数组</param>
        public static void WriteCookie(string name, string domain, string[] keys, string[] values)
        {
            WriteCookie(name, domain, 0, keys, values);
        }

        /// <summary>
        /// 写COOKIE操作
        /// </summary>
        /// <param name="name">cookie名称</param>
        /// <param name="domain">COOKIE域</param>
        /// <param name="expires">过期天数</param>
        /// <param name="keys">键名数组</param>
        /// <param name="values">键值数组</param>
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
        /// 获取指定COOKIE的特定键值
        /// </summary>
        /// <param name="name">Cookie名称</param>
        /// <param name="key">键名</param>
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
        /// 删除一个Cookie
        /// </summary>
        /// <param name="name"></param>
        public static void RemoveCookie(string name)
        {
            HttpContext.Current.Response.Cookies[name].Expires=DateTime.Now;
        }
    }
}
