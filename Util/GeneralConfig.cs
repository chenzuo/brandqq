using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace BrandQQ.Util
{
    /// <summary>
    /// 表示基本配置
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
        /// 返回基本配置的一个实例
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
        /// 返回SMTP帐户实例
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
        /// 配置文件路径
        /// </summary>
        public static string ConfigFile
        {
            get
            {
                return configFile;
            }
        }


        private static string configFile;
        private static string configFileLastUpdate = "";//配置文件的上次更新时间
        private static string configFileUpdate = "";//配置文件的最后更新时间
        private static GeneralInfo info;
        private static object locker = new object();
    }

    
}
