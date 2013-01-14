using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace BrandQQ.Util
{
    /// <summary>
    /// ��ʾ��������
    /// </summary>
    public class GeneralConfig
    {
        private GeneralConfig() { }

        static GeneralConfig()
        {
            if (String.IsNullOrEmpty(configFile))
            {
                try
                {
                    configFile = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data/General.config");
                }
                catch
                {
                    throw new Exception("The Config File Not Found!");
                }
            }

            configFileLastUpdate = File.GetLastWriteTime(configFile).ToString();

            info = (GeneralInfo)XMLSerializer.Load(typeof(GeneralInfo), configFile);
        }

        /// <summary>
        /// ���ػ������õ�һ��ʵ��
        /// </summary>
        public static GeneralInfo Instance
        {
            get
            {
                configFileUpdate = File.GetLastWriteTime(configFile).ToString();
                if (configFileUpdate != configFileLastUpdate)
                {
                    configFileLastUpdate = configFileUpdate;

                    lock (locker)
                    {
                        info = (GeneralInfo)XMLSerializer.Load(typeof(GeneralInfo), configFile);
                    }
                }

                if (String.IsNullOrEmpty(info.ConnectionString))
                {
                    throw new Exception("Empty Connection String!");
                }

                return info;
            }
        }

        /// <summary>
        /// ����SMTP�ʻ�ʵ��
        /// </summary>
        public static MailSender MailSenderInstance
        {
            get
            {
                MailSender sender = new MailSender();
                sender.Server = Instance.SmtpServer;
                sender.Port = Instance.SmtpServerPort;
                sender.Email = Instance.SmtpServerEmail;
                sender.DisplayName = Instance.SmtpServerDisplayName;
                sender.Password = Instance.SmtpServerPassword;
                return sender;
            }
        }

        /// <summary>
        /// �����ļ�·��
        /// </summary>
        public static string ConfigFile
        {
            get
            {
                return configFile;
            }
        }


        private static string configFile;
        private static string configFileLastUpdate = "";//�����ļ����ϴθ���ʱ��
        private static string configFileUpdate = "";//�����ļ���������ʱ��
        private static GeneralInfo info;
        private static object locker = new object();
    }

    
}
