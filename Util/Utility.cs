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
        /// ����һ���������ַ�"-"��GUID��
        /// </summary>
        public static string NewGuid
        {
            get
            {
                return Guid.NewGuid().ToString().Replace("-", String.Empty);
            }
        }

        /// <summary>
        /// MD5�����ַ���
        /// </summary>
        /// <param name="str">�����ܵ��ַ���</param>
        /// <returns>���ܵ��ַ���(����32)</returns>
        public static string MD5(string str)
        {
            return FormsAuthentication.HashPasswordForStoringInConfigFile(str, "MD5").ToLower();
        }

        /// <summary>
        /// �ж�һ���ַ����Ƿ����Email��ַ��ʽ
        /// </summary>
        /// <param name="str">�������ַ���</param>
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
        /// ����һ���ַ����Ƿ���Uri
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
        /// ��������ʱ���
        /// </summary>
        /// <param name="interval">ָ�����</param>
        /// <param name="StartDate">��ʼʱ��</param>
        /// <param name="EndDate">����ʱ��</param>
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
        /// ���㿪ʼʱ�䵽��ʱ�˿̵�ʱ���
        /// </summary>
        /// <param name="interval">ָ�����</param>
        /// <param name="StartDate">��ʼʱ��</param>
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
        /// ����ʱ������ǰ��/����/�����
        /// </summary>
        /// <param name="dt">ʱ��</param>
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
                dtName = "ǰ��";
                return dtName;
            }
            else if (days == 1)
            {
                dtName = "����";
                return dtName;
            }
            else
            {
                long minutes = DateDiff(DateTimeInterval.Minute, dt, DateTime.Now);
                if (minutes >= 60)//����Сʱ��
                {
                    dtName = ((int)minutes / 60).ToString() + "Сʱǰ";
                }
                else if (minutes < 60 && minutes >= 1)//������Ӽ�
                {
                    dtName = minutes.ToString() + "����ǰ";
                }
                else
                {
                    dtName = DateDiff(DateTimeInterval.Second, dt, DateTime.Now).ToString() + "��ǰ";
                }
            }
            
            return dtName;
        }

        /// <summary>
        /// ת��һ������Ϊ����λ����ʽ����10000����ת��Ϊ1��
        /// </summary>
        /// <param name="num">����</param>
        /// <param name="unit">��λ��3:��λ;4:ǧλ;5:��λ;6:ʮ��λ;7:����λ;8:ǧ��λ;9:��λ;10:ʮ��λ;11:����λ</param>
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
                    return num.Substring(0,num.Length-2) + "��";
                case 4:
                    return num.Substring(0,num.Length-3) + "ǧ";
                case 5:
                    return num.Substring(0,num.Length-4) + "��";
                case 6:
                    return num.Substring(0,num.Length-5) + "ʮ��";
                case 7:
                    return num.Substring(0,num.Length-6) + "����";
                case 8:
                    return num.Substring(0,num.Length-7) + "ǧ��";
                case 9:
                    return num.Substring(0, num.Length - 8) + "��";
                case 10:
                    return num.Substring(0, num.Length - 9) + "ʮ��";
                case 11:
                    return num.Substring(0, num.Length - 10) + "����";
                default:
                    return num;
            }
        }

        /// <summary>
        /// ���ص�ǰʱ��(��ȷ����)�ĳ���Ϊ14�Ĵ��ַ�����ʾ,��:20071109144332
        /// </summary>
        /// <returns></returns>
        public static string DateTimeSerialString()
        {
            return DateTimeSerialString(DateTime.Now);
        }

        /// <summary>
        /// ����ָ��ʱ��(��ȷ����)�ĳ���Ϊ14�Ĵ��ַ�����ʾ,��:20071109144332
        /// </summary>
        /// <param name="dt">ʱ��</param>
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
        /// ����ָ�����ڵĳ���Ϊ8�Ĵ��ַ�����ʾ,��:20071109
        /// </summary>
        /// <param name="dt">ʱ��</param>
        /// <returns></returns>
        public static string DateSerialString(DateTime dt)
        {
            string str = dt.Year.ToString();
            str += dt.Month.ToString().PadLeft(2, '0');
            str += dt.Day.ToString().PadLeft(2, '0');
            return str;
        }



        /// <summary>
        /// ת��UBB���뵽html
        /// </summary>
        /// <param name="ubbCode">��UBB���������</param>
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
    /// ʱ����ö��
    /// </summary>
    public enum DateTimeInterval
    {
        Second, Minute, Hour, Day, Week, Month, Quarter, Year
    }

}
