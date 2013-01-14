using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// ��ʾ�������ýṹ
    /// </summary>
    public class GeneralInfo
    {
        /// <summary>
        /// ���캯��
        /// </summary>
        public GeneralInfo()
        {
        }

        /// <summary>
        /// ���浱ǰ����
        /// </summary>
        public void Save()
        {
            XMLSerializer.Save(this, GeneralConfig.ConfigFile);
        }

        /// <summary>
        /// ���浱ǰ����
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
        /// ���û��ȡ���ݿ����Ӵ�
        /// </summary>
        public string ConnectionString;

        /// <summary>
        /// ���û��ȡ��ҵ�ʵ��ļ�·��
        /// </summary>
        public string IndustryDictionaryFile;
        
        
        /// <summary>
        /// ���û��ȡ�����ҵ�Ľ��������ļ�
        /// </summary>
        public string IndustryConclusionFile;

        /// <summary>
        /// ���û��ȡ�ʾ���·��
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
        /// ���û��ȡ�ʾ�������·��
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
        /// ���û��ȡ�ʾ�����ʱ����·��
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
        /// BMI�����ĵ�·��
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
        /// BMI���������ļ�
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
        /// logoϵͳ��������ļ�Ŀ¼
        /// </summary>
        public string LogoDataSourcePath;

        /// <summary>
        /// logoģ���������ļ�
        /// </summary>
        public string LogoImitationShowConfigFile;

        /// <summary>
        /// ���û��ȡSMTP������
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
        /// ���û��ȡSMTP�������˿�
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
        /// ���û��ȡSMTP�������ʻ�
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
        /// ���û��ȡSMTP�������ʻ�����
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
        /// ���û��ȡSMTP�������ʻ���ʾ����
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
        /// �����ʼ�ģ�������ļ�·��
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
        /// ���û��ȡ�ͻ�����ʱ��Ϣ�ı�������(��)
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
        /// ϵͳ�û���Email��
        /// <para>����û�֮���÷ֺŸ���</para>
        /// <para>ϵͳ�û���������Ч�Ļ����û�</para>
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
        /// BQIPD ���������ļ�
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
        /// BQIPD SEO Icon���Ŀ¼
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
        /// BQIPD SEO ����Ƶ��
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
