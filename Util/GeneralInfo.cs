using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// 表示基本配置结构
    /// </summary>
    public class GeneralInfo
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        public GeneralInfo()
        {
        }

        /// <summary>
        /// 保存当前配置
        /// </summary>
        public void Save()
        {
            XMLSerializer.Save(this, GeneralConfig.ConfigFile);
        }

        /// <summary>
        /// 保存当前配置
        /// </summary>
        public void Save(string path)
        {
            try
            {
                XMLSerializer.Save(this, path);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        /// <summary>
        /// 设置或获取数据库连接串
        /// </summary>
        public string ConnectionString;

        /// <summary>
        /// 设置或获取行业词典文件路径
        /// </summary>
        public string IndustryDictionaryFile;
        
        
        /// <summary>
        /// 设置或获取针对行业的结论配置文件
        /// </summary>
        public string IndustryConclusionFile;

        /// <summary>
        /// 设置或获取问卷保存路径
        /// </summary>
        public string PaperSavePath
        {
            get
            {
                return paperSavePath.EndsWith("\\") ? paperSavePath : paperSavePath + "\\";
            }
            set
            {
                paperSavePath = value;
            }
        }

        /// <summary>
        /// 设置或获取问卷结果保存路径
        /// </summary>
        public string PaperResultSavePath
        {
            get
            {
                return paperResultSavePath.EndsWith("\\") ? paperResultSavePath : paperResultSavePath + "\\";
            }
            set
            {
                paperResultSavePath = value;
            }
        }

        /// <summary>
        /// 设置或获取问卷结果临时保存路径
        /// </summary>
        public string PaperResultTempSavePath
        {
            get
            {
                return paperResultTempSavePath.EndsWith("\\") ? paperResultTempSavePath : paperResultTempSavePath + "\\";
            }
            set
            {
                paperResultTempSavePath = value;
            }
        }

        /// <summary>
        /// BMI下载文档路径
        /// </summary>
        public string BMIDownloadPath
        {
            get
            {
                return bmiDownloadPath.EndsWith("\\") ? bmiDownloadPath : bmiDownloadPath + "\\";
            }
            set
            {
                bmiDownloadPath = value;
            }
        }

        /// <summary>
        /// BMI下载配置文件
        /// </summary>
        public string BMIDownloadConfigFile
        {
            get
            {
                return bmiDownloadConfigFile;
            }
            set
            {
                bmiDownloadConfigFile = value;
            }
        }

        /// <summary>
        /// logo系统相关数据文件目录
        /// </summary>
        public string LogoDataSourcePath;

        /// <summary>
        /// logo模仿秀配置文件
        /// </summary>
        public string LogoImitationShowConfigFile;

        /// <summary>
        /// 设置或获取SMTP服务器
        /// </summary>
        public string SmtpServer
        {
            get
            {
                return smptServer;
            }
            set
            {
                smptServer = value;
            }
        }

        /// <summary>
        /// 设置或获取SMTP服务器端口
        /// </summary>
        public int SmtpServerPort
        {
            get
            {
                return smptServerPort;
            }
            set
            {
                smptServerPort = value;
            }
        }

        /// <summary>
        /// 设置或获取SMTP服务器帐户
        /// </summary>
        public string SmtpServerEmail
        {
            get
            {
                return smptServerEamil;
            }
            set
            {
                smptServerEamil = value;
            }
        }

        /// <summary>
        /// 设置或获取SMTP服务器帐户密码
        /// </summary>
        public string SmtpServerPassword
        {
            get
            {
                return smptServerPass;
            }
            set
            {
                smptServerPass = value;
            }
        }

        /// <summary>
        /// 设置或获取SMTP服务器帐户显示名称
        /// </summary>
        public string SmtpServerDisplayName
        {
            get
            {
                return smptServerDisplayName;
            }
            set
            {
                smptServerDisplayName = value;
            }
        }

        /// <summary>
        /// 电子邮件模板配置文件路径
        /// </summary>
        public string MailTemplatesFile
        {
            get
            {
                return mailTemplatesFile;
            }
            set
            {
                mailTemplatesFile = value;
            }
        }

        /// <summary>
        /// 设置或获取客户端临时信息的保存期限(天)
        /// </summary>
        public int UserTempInfoDuration
        {
            get
            {
                return userTempInfoDuration;
            }
            set
            {
                userTempInfoDuration = value;
            }
        }

        /// <summary>
        /// 系统用户的Email串
        /// <para>多个用户之间用分号隔开</para>
        /// <para>系统用户必须是有效的基本用户</para>
        /// </summary>
        public string SystemUsers
        {
            get
            {
                return systemUsers;
            }
            set
            {
                systemUsers = value;
            }
        }


        /// <summary>
        /// BQIPD 结论配置文件
        /// </summary>
        public string BQIPDConclusionFile
        {
            get
            {
                return _BQIPDConclusionFile;
            }
            set
            {
                _BQIPDConclusionFile = value;
            }
        }

        /// <summary>
        /// BQIPD SEO Icon存放目录
        /// </summary>
        public string BQIPDSEOImageIconPath
        {
            get
            {
                return _BQIPDSEOImageIconPath.EndsWith("\\") ? _BQIPDSEOImageIconPath : _BQIPDSEOImageIconPath+"\\";
            }
            set
            {
                _BQIPDSEOImageIconPath = value;
            }
        }

        /// <summary>
        /// BQIPD SEO 更新频率
        /// </summary>
        public string BQIPDSEOImageUpdateInterval
        {
            get
            {
                return _BQIPDSEOImageUpdateInterval;
            }
            set
            {
                _BQIPDSEOImageUpdateInterval = value;
            }
        }

        #region fields

        private string paperSavePath;
        private string paperResultSavePath;
        private string paperResultTempSavePath;

        private string bmiDownloadPath;
        private string bmiDownloadConfigFile;

        private string smptServer;
        private int smptServerPort;
        private string smptServerEamil;
        private string smptServerPass;
        private string smptServerDisplayName;

        private string mailTemplatesFile;

        private int userTempInfoDuration;

        private string systemUsers;

        private string _BQIPDConclusionFile;
        private string _BQIPDSEOImageIconPath;
        private string _BQIPDSEOImageUpdateInterval;

        #endregion
    }
}
