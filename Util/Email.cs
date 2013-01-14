using System;
using System.Collections;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Mail;

namespace BrandQQ.Util
{
    /// <summary>
    /// ��ʾһ�������ʼ�
    /// </summary>
    public class Email
    {
        /// <summary>
        /// ���캯��
        /// </summary>
        public Email()
        {

        }
        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="title">�ʼ�����</param>
        /// <param name="body">�ʼ�����</param>
        public Email(string title,string body)
        {
            Title = title;
            Body = body;
            IsHtml = false;
            Encode = Encoding.Default;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="title">�ʼ�����</param>
        /// <param name="body">�ʼ�����</param>
        /// <param name="encode">�ʼ�����</param>
        public Email(string title, string body,Encoding encode)
        {
            Title = title;
            Body = body;
            IsHtml = false;
            Encode = encode;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="title">�ʼ�����</param>
        /// <param name="body">�ʼ�����</param>
        /// <param name="isHtml">�Ƿ���ó��ı���ʽ</param>
        public Email(string title, string body, bool isHtml)
        {
            Title = title;
            Body = body;
            IsHtml = isHtml;
            Encode = Encoding.Default;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="title">�ʼ�����</param>
        /// <param name="body">�ʼ�����</param>
        /// <param name="encode">�ʼ�����</param>
        /// <param name="isHtml">�Ƿ���ó��ı���ʽ</param>
        public Email(string title, string body, Encoding encode, bool isHtml)
        {
            Title = title;
            Body = body;
            IsHtml = isHtml;
            Encode = encode;
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ���</param>
        /// <returns></returns>
        public bool Send(string to)
        {
            if (Sender == null)
            {
                throw new Exception("�����ʼ���SMTP�ʻ�����");
            }

            return SendMail(to, Title, Body,IsHtml,Encode,Sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ�������</param>
        /// <returns></returns>
        public bool Send(string[] to)
        {
            if (Sender == null)
            {
                throw new Exception("�����ʼ���SMTP�ʻ�����");
            }

            return SendMail(to, Title, Body, IsHtml, Encode, Sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ���</param>
        /// <param name="title">����</param>
        /// <param name="body">����</param>
        /// <param name="sender">�����ʻ�</param>
        /// <returns></returns>
        public static bool SendMail(string to, string title, string body, MailSender sender)
        {
            return SendMail(new string[] { to }, title, body, false, Encoding.Default, sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ���</param>
        /// <param name="title">����</param>
        /// <param name="body">����</param>
        /// <param name="isHtml">�Ƿ��ı���ʽ</param>
        /// <param name="sender">�����ʻ�</param>
        /// <returns></returns>
        public static bool SendMail(string to, string title, string body, bool isHtml, MailSender sender)
        {
            return SendMail(new string[] { to }, title, body, isHtml, Encoding.Default, sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ�������</param>
        /// <param name="title">����</param>
        /// <param name="body">����</param>
        /// <param name="sender">�����ʻ�</param>
        /// <returns></returns>
        public static bool SendMail(string[] to, string title, string body, MailSender sender)
        {
            return SendMail(to, title, body, false, Encoding.Default, sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ�������</param>
        /// <param name="title">����</param>
        /// <param name="body">����</param>
        /// <param name="isHtml">�Ƿ��ı���ʽ</param>
        /// <param name="sender">�����ʻ�</param>
        /// <returns></returns>
        public static bool SendMail(string[] to, string title, string body, bool isHtml, MailSender sender)
        {
            return SendMail(to, title, body, isHtml, Encoding.Default, sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ���</param>
        /// <param name="title">����</param>
        /// <param name="body">����</param>
        /// <param name="isHtml">�Ƿ��ı���ʽ</param>
        /// <param name="encode">����</param>
        /// <param name="sender">�����ʻ�</param>
        /// <returns></returns>
        public static bool SendMail(string to, string title, string body, bool isHtml, Encoding encode, MailSender sender)
        {
            return SendMail(new string[] { to }, title, body, isHtml, encode, sender);
        }

        /// <summary>
        /// ���͵����ʼ�
        /// </summary>
        /// <param name="to">�ռ�������</param>
        /// <param name="title">����</param>
        /// <param name="body">����</param>
        /// <param name="isHtml">�Ƿ��ı���ʽ</param>
        /// <param name="encode">����</param>
        /// <param name="sender">�����ʻ�</param>
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
        /// �ʼ�����
        /// </summary>
        public string Title;

        /// <summary>
        /// �ʼ�����
        /// </summary>
        public string Body;

        /// <summary>
        /// �ʼ��Ƿ���ó��ı���ʽ,Ĭ��False
        /// </summary>
        public bool IsHtml;

        /// <summary>
        /// �����ʻ�
        /// </summary>
        public MailSender Sender;

        /// <summary>
        /// �ʼ�����
        /// </summary>
        public Encoding Encode;

        /// <summary>
        /// һ�η��������ռ�������,Ĭ��10
        /// </summary>
        public static int MAX_TO = 10;
    }

    /// <summary>
    /// ��ʾһ�������ʼ���SMTP�ʻ�
    /// </summary>
    public class MailSender
    {
        /// <summary>
        /// ���캯��
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
        /// ���캯��
        /// </summary>
        /// <param name="server">SMTP������</param>
        /// <param name="email">�ʻ��ʼ���ַ</param>
        /// <param name="pass">�ʻ�����</param>
        public MailSender(string server,string email,string pass)
        {
            Server = server;
            Port = 25;
            Email = email;
            DisplayName = "";
            Password = pass;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">SMTP������</param>
        /// <param name="email">�ʻ��ʼ���ַ</param>
        /// <param name="pass">�ʻ�����</param>
        /// <param name="name">�����˵�����</param>
        public MailSender(string server, string email, string pass,string name)
        {
            Server = server;
            Port = 25;
            Email = email;
            DisplayName = name;
            Password = pass;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">SMTP������</param>
        /// <param name="port">SMTP�������˿�</param>
        /// <param name="email">�ʻ��ʼ���ַ</param>
        /// <param name="pass">�ʻ�����</param>
        public MailSender(string server, int port,string email, string pass)
        {
            Server = server;
            Port = port;
            Email = email;
            DisplayName = "";
            Password = pass;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">SMTP������</param>
        /// <param name="port">SMTP�������˿�</param>
        /// <param name="email">�ʻ��ʼ���ַ</param>
        /// <param name="pass">�ʻ�����</param>
        /// <param name="name">�����˵�����</param>
        public MailSender(string server, int port, string email, string pass,string name)
        {
            Server = server;
            Port = port;
            Email = email;
            DisplayName = name;
            Password = pass;
        }

        /// <summary>
        /// SMTP������
        /// </summary>
        public string Server;

        /// <summary>
        /// SMTP�������˿�,Ĭ��25
        /// </summary>
        public int Port;

        /// <summary>
        /// �ʻ��ʼ���ַ
        /// </summary>
        public string Email;

        /// <summary>
        /// �����˵����֣���������ʼ���ַ��ʾ
        /// </summary>
        public string DisplayName;

        /// <summary>
        /// �ʻ�����
        /// </summary>
        public string Password;
    }
}
