using System;
using System.Collections;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Mail;

namespace BrandQQ.Util
{
    /// <summary>
    /// 表示一个电子邮件
    /// </summary>
    public class Email
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        public Email()
        {

        }
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="title">邮件标题</param>
        /// <param name="body">邮件正文</param>
        public Email(string title,string body)
        {
            Title = title;
            Body = body;
            IsHtml = false;
            Encode = Encoding.Default;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="title">邮件标题</param>
        /// <param name="body">邮件正文</param>
        /// <param name="encode">邮件编码</param>
        public Email(string title, string body,Encoding encode)
        {
            Title = title;
            Body = body;
            IsHtml = false;
            Encode = encode;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="title">邮件标题</param>
        /// <param name="body">邮件正文</param>
        /// <param name="isHtml">是否采用超文本格式</param>
        public Email(string title, string body, bool isHtml)
        {
            Title = title;
            Body = body;
            IsHtml = isHtml;
            Encode = Encoding.Default;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="title">邮件标题</param>
        /// <param name="body">邮件正文</param>
        /// <param name="encode">邮件编码</param>
        /// <param name="isHtml">是否采用超文本格式</param>
        public Email(string title, string body, Encoding encode, bool isHtml)
        {
            Title = title;
            Body = body;
            IsHtml = isHtml;
            Encode = encode;
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人</param>
        /// <returns></returns>
        public bool Send(string to)
        {
            if (Sender == null)
            {
                throw new Exception("发送邮件的SMTP帐户错误");
            }

            return SendMail(to, Title, Body,IsHtml,Encode,Sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人数组</param>
        /// <returns></returns>
        public bool Send(string[] to)
        {
            if (Sender == null)
            {
                throw new Exception("发送邮件的SMTP帐户错误");
            }

            return SendMail(to, Title, Body, IsHtml, Encode, Sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人</param>
        /// <param name="title">标题</param>
        /// <param name="body">正文</param>
        /// <param name="sender">发送帐户</param>
        /// <returns></returns>
        public static bool SendMail(string to, string title, string body, MailSender sender)
        {
            return SendMail(new string[] { to }, title, body, false, Encoding.Default, sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人</param>
        /// <param name="title">标题</param>
        /// <param name="body">正文</param>
        /// <param name="isHtml">是否超文本格式</param>
        /// <param name="sender">发送帐户</param>
        /// <returns></returns>
        public static bool SendMail(string to, string title, string body, bool isHtml, MailSender sender)
        {
            return SendMail(new string[] { to }, title, body, isHtml, Encoding.Default, sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人数组</param>
        /// <param name="title">标题</param>
        /// <param name="body">正文</param>
        /// <param name="sender">发送帐户</param>
        /// <returns></returns>
        public static bool SendMail(string[] to, string title, string body, MailSender sender)
        {
            return SendMail(to, title, body, false, Encoding.Default, sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人数组</param>
        /// <param name="title">标题</param>
        /// <param name="body">正文</param>
        /// <param name="isHtml">是否超文本格式</param>
        /// <param name="sender">发送帐户</param>
        /// <returns></returns>
        public static bool SendMail(string[] to, string title, string body, bool isHtml, MailSender sender)
        {
            return SendMail(to, title, body, isHtml, Encoding.Default, sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人</param>
        /// <param name="title">标题</param>
        /// <param name="body">正文</param>
        /// <param name="isHtml">是否超文本格式</param>
        /// <param name="encode">编码</param>
        /// <param name="sender">发送帐户</param>
        /// <returns></returns>
        public static bool SendMail(string to, string title, string body, bool isHtml, Encoding encode, MailSender sender)
        {
            return SendMail(new string[] { to }, title, body, isHtml, encode, sender);
        }

        /// <summary>
        /// 发送电子邮件
        /// </summary>
        /// <param name="to">收件人数组</param>
        /// <param name="title">标题</param>
        /// <param name="body">正文</param>
        /// <param name="isHtml">是否超文本格式</param>
        /// <param name="encode">编码</param>
        /// <param name="sender">发送帐户</param>
        /// <returns></returns>
        public static bool SendMail(string[] to, string title, string body, bool isHtml,Encoding encode,MailSender sender)
        {
            bool bln = false;
            MailMessage mail = new MailMessage();
            mail.Subject = title;
            mail.SubjectEncoding = encode;
            mail.Body = body;
            mail.BodyEncoding = encode;
            mail.From = new MailAddress(sender.Email, sender.DisplayName == "" ? sender.Email : sender.DisplayName);
            int i = 0;
            foreach (string s in to)
            {
                if (!String.IsNullOrEmpty(s))
                {
                    mail.To.Add(s);
                    if (i == MAX_TO) break;
                }
            }

            if (mail.To.Count == 0)
            {
                return false;
            }

            mail.IsBodyHtml = isHtml;
            SmtpClient smtp = new SmtpClient(sender.Server, sender.Port);
            smtp.Credentials = (ICredentialsByHost)(new NetworkCredential(sender.Email,sender.Password));

            try
            {
                smtp.Send(mail);
                bln = true;
            }
            catch
            {
                //
            }
            finally
            {
                mail.Dispose();
            }

            return bln;
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
        /// 邮件标题
        /// </summary>
        public string Title;

        /// <summary>
        /// 邮件正文
        /// </summary>
        public string Body;

        /// <summary>
        /// 邮件是否采用超文本格式,默认False
        /// </summary>
        public bool IsHtml;

        /// <summary>
        /// 发送帐户
        /// </summary>
        public MailSender Sender;

        /// <summary>
        /// 邮件编码
        /// </summary>
        public Encoding Encode;

        /// <summary>
        /// 一次发送最多的收件人数量,默认10
        /// </summary>
        public static int MAX_TO = 10;
    }

    /// <summary>
    /// 表示一个发送邮件的SMTP帐户
    /// </summary>
    public class MailSender
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        public MailSender()
        {
            Server = "";
            Port = 25;
            Email = "";
            DisplayName = "";
            Password = "";
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="server">SMTP服务器</param>
        /// <param name="email">帐户邮件地址</param>
        /// <param name="pass">帐户密码</param>
        public MailSender(string server,string email,string pass)
        {
            Server = server;
            Port = 25;
            Email = email;
            DisplayName = "";
            Password = pass;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="server">SMTP服务器</param>
        /// <param name="email">帐户邮件地址</param>
        /// <param name="pass">帐户密码</param>
        /// <param name="name">发送人的名字</param>
        public MailSender(string server, string email, string pass,string name)
        {
            Server = server;
            Port = 25;
            Email = email;
            DisplayName = name;
            Password = pass;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="server">SMTP服务器</param>
        /// <param name="port">SMTP服务器端口</param>
        /// <param name="email">帐户邮件地址</param>
        /// <param name="pass">帐户密码</param>
        public MailSender(string server, int port,string email, string pass)
        {
            Server = server;
            Port = port;
            Email = email;
            DisplayName = "";
            Password = pass;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="server">SMTP服务器</param>
        /// <param name="port">SMTP服务器端口</param>
        /// <param name="email">帐户邮件地址</param>
        /// <param name="pass">帐户密码</param>
        /// <param name="name">发送人的名字</param>
        public MailSender(string server, int port, string email, string pass,string name)
        {
            Server = server;
            Port = port;
            Email = email;
            DisplayName = name;
            Password = pass;
        }

        /// <summary>
        /// SMTP服务器
        /// </summary>
        public string Server;

        /// <summary>
        /// SMTP服务器端口,默认25
        /// </summary>
        public int Port;

        /// <summary>
        /// 帐户邮件地址
        /// </summary>
        public string Email;

        /// <summary>
        /// 发送人的名字，用以替代邮件地址显示
        /// </summary>
        public string DisplayName;

        /// <summary>
        /// 帐户密码
        /// </summary>
        public string Password;
    }
}
