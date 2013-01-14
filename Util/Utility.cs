using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Security;

namespace BrandQQ.Util
{
    public class Utility
    {
        public static string FilterSql(string sql)
        {
            return sql.Replace("'", "");
        }
        /// <summary>
        /// 产生一个不含连字符"-"的GUID串
        /// </summary>
        public static string NewGuid
        {
            get
            {
                return Guid.NewGuid().ToString().Replace("-", String.Empty);
            }
        }

        /// <summary>
        /// MD5加密字符串
        /// </summary>
        /// <param name="str">待加密的字符串</param>
        /// <returns>加密的字符串(长度32)</returns>
        public static string MD5(string str)
        {
            return FormsAuthentication.HashPasswordForStoringInConfigFile(str, "MD5").ToLower();
        }

        /// <summary>
        /// 判断一个字符串是否符合Email地址格式
        /// </summary>
        /// <param name="str">待检验字符串</param>
        /// <returns></returns>
        public static bool IsEmail(string str)
        {
            if (Regex.IsMatch(str, @"^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 检验一个字符串是否是Uri
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static bool IsUrl(string url)
        {
            string pattern = @"^(http://|https://|ftp://){0,1}((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
            return Regex.IsMatch(url, pattern, RegexOptions.IgnoreCase);
        }

        public static bool IsHostFormat(string url)
        {
            string pattern = @"^(([a-zA-Z0-9\-]+\.)+)((com|net|org|info|biz|name|mobi|edu|gov|mil|pro|jobs|cn|hk|tw|tv|sh|travel|ac|cc|ws|us|asia|com\.cn|net\.cn|org\.cn|edu\.cn|gov\.cn)+)$";
            return Regex.IsMatch(url, pattern, RegexOptions.IgnoreCase);
        }

        public static bool IsHostFormat(string url,HostFormat format)
        {
            if (!IsHostFormat(url))
            {
                return false;
            }

            if (url.ToLower().EndsWith("."+format.ToString().Replace('_','.')))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 计算两个时间差
        /// </summary>
        /// <param name="interval">指定间隔</param>
        /// <param name="StartDate">开始时间</param>
        /// <param name="EndDate">结束时间</param>
        /// <returns></returns>
        public static long DateDiff(DateTimeInterval interval, DateTime StartDate,DateTime EndDate)
        {
            long lngDateDiffValue = 0;
            TimeSpan TS = new System.TimeSpan(EndDate.Ticks - StartDate.Ticks);
            switch (interval)
            {
                case DateTimeInterval.Day:
                    lngDateDiffValue = (long)TS.Days;
                    break;
                case DateTimeInterval.Hour:
                    lngDateDiffValue = (long)TS.TotalHours;
                    break;
                case DateTimeInterval.Minute:
                    lngDateDiffValue = (long)TS.TotalMinutes;
                    break;
                case DateTimeInterval.Month:
                    lngDateDiffValue = (long)(TS.Days / 30);
                    break;
                case DateTimeInterval.Quarter:
                    lngDateDiffValue = (long)((TS.Days / 30) / 3);
                    break;
                case DateTimeInterval.Second:
                    lngDateDiffValue = (long)TS.TotalSeconds;
                    break;
                case DateTimeInterval.Week:
                    lngDateDiffValue = (long)(TS.Days / 7);
                    break;
                case DateTimeInterval.Year:
                    lngDateDiffValue = (long)(TS.Days / 365);
                    break;
            }
            return (lngDateDiffValue);
        }

        /// <summary>
        /// 计算开始时间到此时此刻的时间差
        /// </summary>
        /// <param name="interval">指定间隔</param>
        /// <param name="StartDate">开始时间</param>
        /// <returns></returns>
        public static long DateDiff(DateTimeInterval interval, DateTime StartDate)
        {
            long lngDateDiffValue = 0;
            DateTime EndDate=DateTime.Now;
            TimeSpan TS = new System.TimeSpan(EndDate.Ticks - StartDate.Ticks);
            switch (interval)
            {
                case DateTimeInterval.Day:
                    lngDateDiffValue = (long)TS.Days;
                    break;
                case DateTimeInterval.Hour:
                    lngDateDiffValue = (long)TS.TotalHours;
                    break;
                case DateTimeInterval.Minute:
                    lngDateDiffValue = (long)TS.TotalMinutes;
                    break;
                case DateTimeInterval.Month:
                    lngDateDiffValue = (long)(TS.Days / 30);
                    break;
                case DateTimeInterval.Quarter:
                    lngDateDiffValue = (long)((TS.Days / 30) / 3);
                    break;
                case DateTimeInterval.Second:
                    lngDateDiffValue = (long)TS.TotalSeconds;
                    break;
                case DateTimeInterval.Week:
                    lngDateDiffValue = (long)(TS.Days / 7);
                    break;
                case DateTimeInterval.Year:
                    lngDateDiffValue = (long)(TS.Days / 365);
                    break;
            }
            return (lngDateDiffValue);
        }

        /// <summary>
        /// 返回时间名，前天/昨天/今天等
        /// </summary>
        /// <param name="dt">时间</param>
        /// <returns>string</returns>
        public static string DateTimeName(DateTime dt)
        {
            string dtName = "";

            long days = DateDiff(DateTimeInterval.Day, dt);
            if (days > 2)
            {
                dtName=dt.ToString();
                return dtName;
            }
            else if (days == 2)
            {
                dtName = "前天";
                return dtName;
            }
            else if (days == 1)
            {
                dtName = "昨天";
                return dtName;
            }
            else
            {
                long minutes = DateDiff(DateTimeInterval.Minute, dt, DateTime.Now);
                if (minutes >= 60)//今天小时级
                {
                    dtName = ((int)minutes / 60).ToString() + "小时前";
                }
                else if (minutes < 60 && minutes >= 1)//今天分钟级
                {
                    dtName = minutes.ToString() + "分钟前";
                }
                else
                {
                    dtName = DateDiff(DateTimeInterval.Second, dt, DateTime.Now).ToString() + "秒前";
                }
            }
            
            return dtName;
        }

        /// <summary>
        /// 转化一个数字为带单位的形式，如10000，可转化为1万
        /// </summary>
        /// <param name="num">数字</param>
        /// <param name="unit">单位，3:百位;4:千位;5:万位;6:十万位;7:百万位;8:千万位;9:亿位;10:十亿位;11:百亿位</param>
        /// <returns></returns>
        public static string NumberUnit(string num,int unit)
        {
            if (num.ToString().Length < unit)
            {
                return num;
            }

            switch (unit)
            {
                case 3:
                    return num.Substring(0,num.Length-2) + "百";
                case 4:
                    return num.Substring(0,num.Length-3) + "千";
                case 5:
                    return num.Substring(0,num.Length-4) + "万";
                case 6:
                    return num.Substring(0,num.Length-5) + "十万";
                case 7:
                    return num.Substring(0,num.Length-6) + "百万";
                case 8:
                    return num.Substring(0,num.Length-7) + "千万";
                case 9:
                    return num.Substring(0, num.Length - 8) + "亿";
                case 10:
                    return num.Substring(0, num.Length - 9) + "十亿";
                case 11:
                    return num.Substring(0, num.Length - 10) + "百亿";
                default:
                    return num;
            }
        }

        /// <summary>
        /// 返回当前时间(精确到秒)的长度为14的纯字符串表示,如:20071109144332
        /// </summary>
        /// <returns></returns>
        public static string DateTimeSerialString()
        {
            return DateTimeSerialString(DateTime.Now);
        }

        /// <summary>
        /// 返回指定时间(精确到秒)的长度为14的纯字符串表示,如:20071109144332
        /// </summary>
        /// <param name="dt">时间</param>
        /// <returns></returns>
        public static string DateTimeSerialString(DateTime dt)
        {
            string str = dt.Year.ToString();
            str += dt.Month.ToString().PadLeft(2, '0');
            str += dt.Day.ToString().PadLeft(2, '0');

            str += dt.Hour.ToString().PadLeft(2, '0');
            str += dt.Minute.ToString().PadLeft(2, '0');
            str += dt.Second.ToString().PadLeft(2, '0');

            return str;
        }
        /// <summary>
        /// 返回指定日期的长度为8的纯字符串表示,如:20071109
        /// </summary>
        /// <param name="dt">时间</param>
        /// <returns></returns>
        public static string DateSerialString(DateTime dt)
        {
            string str = dt.Year.ToString();
            str += dt.Month.ToString().PadLeft(2, '0');
            str += dt.Day.ToString().PadLeft(2, '0');
            return str;
        }



        /// <summary>
        /// 转换UBB代码到html
        /// </summary>
        /// <param name="ubbCode">含UBB代码的内容</param>
        /// <returns></returns>
        public static string UBB2Html(string ubbCode)
        {
            ubbCode = Regex.Replace(ubbCode, @"\[B\](.*?)\[/B\]", "<strong>$1</strong>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[I\](.*?)\[/I\]", "<i>$1</i>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[U\](.*?)\[/U\]", "<u>$1</u>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[LEFT\](.*?)\[/LEFT\]", "<p style=\"text-align:left;\">$1</p>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[CENTER\](.*?)\[/CENTER\]", "<p style=\"text-align:center;\">$1</p>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[RIGHT\](.*?)\[/RIGHT\]", "<p style=\"text-align:right;\">$1</p>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[IMG\](.*?)\[/IMG\]", "<img src=\"$1\" />", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[IMG,(\d+),(\d+)\](.*?)\[/IMG\]", "<img src=\"$3\" width=\"$1\" height=\"$2\" />", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[IMG,(\d+)\](.*?)\[/IMG\]", "<img src=\"$2\" width=\"$1\" />", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            
            ubbCode = Regex.Replace(ubbCode, @"\[SWF\](.*?)\[/SWF\]", "<script>FlashPlayer('$1');</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[SWF,(\d+),(\d+)\](.*?)\[/SWF\]", "<script>FlashPlayer('$3',$1,$2);</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[SWF,(\d+)\](.*?)\[/SWF\]", "<script>FlashPlayer('$2',$1);</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            
            ubbCode = Regex.Replace(ubbCode, @"\[FLV\](.*?)\[/FLV\]", "<script>FlvPlayer('$1');</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[FLV,(\d+),(\d+)\](.*?)\[/FLV\]", "<script>FlvPlayer('$3',$1,$2);</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[FLV,(\d+)\](.*?)\[/FLV\]", "<script>FlvPlayer('$2',$1);</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);

            ubbCode = Regex.Replace(ubbCode, @"\[VIDEO\](.*?)\[/VIDEO\]", "<script>VIDEOPlayer('$1');</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[VIDEO,(\d+),(\d+)\](.*?)\[/VIDEO\]", "<script>VIDEOPlayer('$3',$1,$2);</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[VIDEO,(\d+)\](.*?)\[/VIDEO\]", "<script>VIDEOPlayer('$1',$2);</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);

            ubbCode = Regex.Replace(ubbCode, @"\[AUDIO\](.*?)\[/AUDIO\]", "<script>AUDIOPlayer('$1');</script>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            
            ubbCode = Regex.Replace(ubbCode, @"\[URL\](.*?)\[/URL\]", "<a href=\"$1\" target=\"_blank\">$1</a>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            ubbCode = Regex.Replace(ubbCode, @"\[URL=(.*?)\](.*?)\[/URL\]", "<a href=\"$1\" target=\"_blank\">$2</a>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            return ubbCode;
        }
    }

    /// <summary>
    /// 时间间隔枚举
    /// </summary>
    public enum DateTimeInterval
    {
        Second, Minute, Hour, Day, Week, Month, Quarter, Year
    }

}
