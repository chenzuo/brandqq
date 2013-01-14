using System;
using System.Collections;
using System.Text;
using System.Web;
using System.IO;
using System.Data;
using System.Data.SqlClient;

using BrandQQ.Util;

namespace BrandQQ.Membership
{
    /// <summary>
    /// ��ʾ�����û�
    /// </summary>
    public class Member
    {
        /// <summary>
        /// ���캯��
        /// </summary>
        public Member()
        {
            this.id = 0;
        }

        #region methods

        /// <summary>
        /// ��������
        /// </summary>
        public int Save()
        {
            /* MemberSave
             * @id int=0,
             * @email varchar(50)='',
             * @name varchar(20)='',
             * @pass varchar(32)='',
             * @regGuid varchar(32)
             */
            int newId = 0;
            string regGuid="";

            if (TempInfo == null)
            {
                SetTempInfo();
            }

            regGuid = TempInfo.Guid;

            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@id",SqlDbType.Int,this.id),
                Database.MakeInParam("@email",SqlDbType.VarChar,50,this.email),
                Database.MakeInParam("@name",SqlDbType.VarChar,20,this.name),
                Database.MakeInParam("@pass",SqlDbType.VarChar,32,Utility.MD5(this.password)),
                Database.MakeInParam("@regGuid",SqlDbType.VarChar,32,regGuid)
            };
            
            try
            {
                newId = Database.ExecuteNonQuery(CommandType.StoredProcedure, "MemberSave", prams);

                //�����û��Ľ���ļ��洢Ŀ¼
                if (!Directory.Exists(GeneralConfig.Instance.PaperResultSavePath + newId.ToString() + "\\"))
                {
                    Directory.CreateDirectory(GeneralConfig.Instance.PaperResultSavePath + newId.ToString() + "\\");
                }
            }
            catch
            {
                //
            }

            return newId;
        }

        /// <summary>
        /// ���һ��Guid�Ƿ�Ϸ��û�
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <returns>null����Member</returns>
        public static Member IsMember(string guid)
        {
            return IsMember(guid, "", "");
        }

        /// <summary>
        /// ���һ��Email/password�Ƿ�Ϸ��û�
        /// </summary>
        /// <param name="mail">�ʼ���ַ</param>
        /// <param name="pwd">����</param>
        /// <returns>null����Member</returns>
        public static Member IsMember(string mail, string pwd)
        {
            return IsMember("",mail, pwd);
        }

        /// <summary>
        /// ���һ��Guid����(Email/password)�Ƿ�Ϸ��û�
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="mail"></param>
        /// <param name="pwd"></param>
        /// <returns></returns>
        public static Member IsMember(string guid,string mail, string pwd)
        {
            /* MemberCheck
             * @guid varchar(32)='',
             * @email varchar(50),
             * @pass varchar(32)='',
             * @ip varchar(50)=''
             */

            Member m = null;

            SqlParameter[] prams ={
                Database.MakeInParam("@guid",SqlDbType.VarChar,32,guid),
                Database.MakeInParam("@email",SqlDbType.VarChar,50,mail),
                Database.MakeInParam("@pass",SqlDbType.VarChar,32,Utility.MD5(pwd)),
                Database.MakeInParam("@ip",SqlDbType.VarChar,50,HttpContext.Current.Request.UserHostAddress)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "MemberCheck", prams);
                if (reader.HasRows)
                {
                    m = new Member();
                    if (reader.Read())
                    {
                        /*[Id],RegGuid, [Name], RegDate, LastLogin, LoginTimes, LastIp*/
                        m.Id = reader.GetInt32(0);
                        m.Email = mail;
                        m.RegGuid = reader.GetString(1);
                        m.Name = reader.GetString(2);
                        m.RegDate = reader.GetDateTime(3);
                        m.LastLogin = reader.GetDateTime(4);
                        m.LoginTimes = reader.GetInt32(5);
                        m.LastIp = reader.GetString(6);
                    }
                }
                reader.Close();
            }
            catch
            {
                //
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            return m;
        }

        /// <summary>
        /// ���һ��Email��ַ�Ƿ��Ѵ���
        /// </summary>
        /// <param name="email">�ʼ���ַ</param>
        /// <returns></returns>
        public static bool IsExistEmail(string email)
        {
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@email",SqlDbType.VarChar,50,email)
            };

            return Database.ExecuteNonQuery(CommandType.StoredProcedure, "MemberCheck", prams) > 0;
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="u">Member</param>
        /// <returns></returns>
        public static bool Login(Member u)
        {
            return Login(u.email,u.password);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="u">Member</param>
        /// <param name="expire">��������</param>
        /// <returns></returns>
        public static bool Login(Member u,int expire)
        {
            return Login(u.email, u.password, expire);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <returns></returns>
        public static bool Login(string guid)
        {
            return Login(guid, (Member)null, "", "", 0);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <param name="m">����������Ϣ��Memberʵ��</param>
        /// <returns></returns>
        public static bool Login(string guid,Member m)
        {
            return Login(guid, m, "", "", 0);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <param name="expire">��������</param>
        /// <returns></returns>
        public static bool Login(string guid, int expire)
        {
            return Login(guid,(Member)null, "", "", expire);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="email">�ʼ���ַ</param>
        /// <param name="pwd">����</param>
        /// <returns></returns>
        public static bool Login(string email, string pwd)
        {
            return Login(email, pwd, 0);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="email">�ʼ���ַ</param>
        /// <param name="pwd">����</param>
        /// <param name="expire">��������</param>
        /// <returns></returns>
        public static bool Login(string email, string pwd,int expire)
        {
            return Login("",(Member)null, email, pwd, expire);
        }

        /// <summary>
        /// ����¼�Ƿ�ɹ�
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <param name="member">����������Ϣ��Memberʵ��</param>
        /// <param name="email">�ʼ���ַ</param>
        /// <param name="pwd">����</param>
        /// <param name="expire">��������</param>
        /// <returns></returns>
        private static bool Login(string guid,Member member, string email, string pwd, int expire)
        {
            Member m;
            if (member == null)
            {
                if (!String.IsNullOrEmpty(guid))
                {
                    m = IsMember(guid);
                }
                else
                {
                    m = IsMember(email, pwd);
                }

                if (m == null)
                {
                    return false;
                }
            }
            else
            {
                m = member;
            }

            if (expire > 0)
            {
                Cookies.WriteCookie(__cookieName, expire, new string[] { "ID", "GUID", "EMAIL", "NAME" }, new string[] { m.Id.ToString(), m.RegGuid, email, HttpContext.Current.Server.UrlEncode(m.Name.ToString()) });
            }
            else
            {
                Cookies.WriteCookie(__cookieName, new string[] { "ID", "GUID", "EMAIL", "NAME" }, new string[] { m.Id.ToString(), m.RegGuid, email, HttpContext.Current.Server.UrlEncode(m.Name.ToString()) });
            }
            
            if (Member.TempInfo != null)
            {
                if (Member.TempInfo.ResultId > 0)
                {
                    //���ҵ�¼֮ǰ�����Ľ���ļ�
                    //ͬ���������ݿ��е�״̬��¼
                    string tempPath = GeneralConfig.Instance.PaperResultTempSavePath + Member.TempInfo.ResultId.ToString() + ".rst";
                    if (File.Exists(tempPath))
                    {
                        UpdateResultStatusGuid(Member.TempInfo.ResultId, Member.Instance.Guid);
                    }
                }

                //������ʱ��־��
                Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "GUID" }, new string[] { m.RegGuid });
            }

            return true;
        }

        /// <summary>
        /// ��¼ʱ����״̬��¼��GUID
        /// </summary>
        /// <param name="rid">����ļ���¼��</param>
        /// <param name="guid">��¼�û���Guid</param>
        private static void UpdateResultStatusGuid(int rid,string guid)
        {
            /* BMCEResultStatusUpdateGuid
             * @id int,
             * @guid varchar(32)
             */

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,rid),
                Database.MakeInParam("@guid",SqlDbType.VarChar,32,guid)
            };

            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "BMCEResultStatusUpdateGuid", prams);
            }
            catch
            {
                //
            }
        }

        /// <summary>
        /// �˳���¼
        /// </summary>
        public static void Logout()
        {
            Cookies.RemoveCookie(__cookieName);
        }

        /// <summary>
        /// ��ȡ�û�����
        /// </summary>
        /// <param name="id">�û���¼��</param>
        /// <returns></returns>
        public static Member Get(int id)
        {
            /* MemberGet
             * @id int
             */

            Member m = new Member();

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,id)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "MemberGet", prams);
                if (reader.Read())
                {
                    /*RegGuid,Email, [Name],[Password], RegDate, LastLogin, LoginTimes, LastIp*/
                    m.Id = id;
                    m.RegGuid = reader.GetString(0);
                    m.Email = reader.GetString(1);
                    m.Name = reader.GetString(2);
                    m.Password = reader.GetString(3);
                    m.RegDate = reader.GetDateTime(4);
                    m.LastLogin = reader.GetDateTime(5);
                    m.LoginTimes = reader.GetInt32(6);
                    m.LastIp = reader.GetString(7);
                }
                reader.Close();
            }
            catch
            {
                //
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            return m;
        }

        /// <summary>
        /// �жϵ�ǰ�û��Ƿ��ѵ�¼
        /// </summary>
        /// <returns></returns>
        public static bool IsLogined
        {
            get
            {
                if (!Cookies.HasCookie(__cookieName))
                {
                    return false;
                }

                if (!String.IsNullOrEmpty(Cookies.GetCookieValue(__cookieName, "ID")) && !String.IsNullOrEmpty(Cookies.GetCookieValue(__cookieName, "EMAIL")))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        /// <summary>
        /// ��ȡ�û���¼
        /// </summary>
        /// <param name="pager">��ҳ����</param>
        /// <returns></returns>
        public static ArrayList List(Pager pager)
        {
            return List("", "", pager);
        }

        /// <summary>
        /// ��ȡ�û���¼
        /// </summary>
        /// <param name="email">�ʼ���ַ�ؼ���</param>
        /// <param name="pager">��ҳ����</param>
        /// <returns></returns>
        public static ArrayList List(string mail, Pager pager)
        {
            return List(mail, "", pager);
        }

        /// <summary>
        /// ��ȡ�û���¼
        /// </summary>
        /// <param name="email">�ʼ���ַ�ؼ���</param>
        /// <param name="name">�����ؼ���</param>
        /// <param name="Pager">��ҳ����</param>
        /// <returns></returns>
        public static ArrayList List(string mail, string name, Pager pager)
        {
            /* MemberList
             * @email varchar(50)='',
             * @name varchar(20)='',
             * @pageindex int=1,
             * @pagesize int=20,
             * @sort int=0
             */

            ArrayList list = new ArrayList();
            SqlParameter[] prams ={
                Database.MakeInParam("@email",SqlDbType.VarChar,50,mail),
                Database.MakeInParam("@name",SqlDbType.VarChar,20,name),
                Database.MakeInParam("@pageIndex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pageSize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;
            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "MemberList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);
                    
                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id], Email, [Name], RegDate, LastLogin, LoginTimes, LastIp*/
                            Member m = new Member();
                            m.Id = reader.GetInt32(0);
                            m.Email = reader.GetString(1);
                            m.Name = reader.GetString(2);
                            m.RegDate = reader.GetDateTime(3);
                            m.LastLogin = reader.GetDateTime(4);
                            m.LoginTimes = reader.GetInt32(5);
                            m.LastIp = reader.GetString(6);

                            list.Add(m);
                        }
                    }
                }

                reader.Close();
            }
            catch(Exception e)
            {
                throw new Exception("Member.List: +"+e.ToString());
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            return list;
        }

        /// <summary>
        /// �����ͻ�����ʱ��ʶ��Ϣ
        /// </summary>
        public static void SetTempInfo()
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "GUID", "PAPERSN", "RESULTID", "MODULEID", "QUESTIONID" }, new string[] { Utility.NewGuid, "", "0", "0", "0" });
            }
        }

        /// <summary>
        /// ����ͻ�����ʱ��ʶ��Ϣ
        /// </summary>
        public static void ClearTempInfo()
        {
            if (Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                Cookies.RemoveCookie("BRANDQQ_TEMP_INFO");
            }
        }

        /// <summary>
        /// ��������ʱ,�����û�GUID��־��
        /// </summary>
        /// <param name="email">�û��ʼ���ַ</param>
        /// <param name="guid">GUID��־��</param>
        public static void UpdateGuid(string email, string guid)
        {
            /*MemberUpdateGuid
             * @id int=0,
             * @email varchar(50)='',
             * @guid varchar(32)
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@email",SqlDbType.VarChar,50,email),
                Database.MakeInParam("@guid",SqlDbType.VarChar,32,guid)
            };

            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "MemberUpdateGuid", prams);
            }
            catch
            {

            }
        }

        /// <summary>
        /// ��������ʱ,�����û�GUID��־��
        /// </summary>
        /// <param name="id">�û���¼��</param>
        /// <param name="guid">GUID��־��</param>
        public static void UpdateGuid(int id, string guid)
        {
            /* MemberUpdateGuid
             * @id int=0,
             * @email varchar(50)='',
             * @guid varchar(32)
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,id),
                Database.MakeInParam("@guid",SqlDbType.VarChar,32,guid)
            };
            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "MemberUpdateGuid", prams);
            }
            catch
            {

            }
        }

        /// <summary>
        /// �����û�����
        /// </summary>
        /// <param name="pass">����</param>
        public static void ResetPassword(string pass)
        {
            /* MemberUpdatePassword
             * @id int=0,
             * @email varchar(50)='',
             * @guid varchar(32)='',
             * @pass varchar(32)
             */

            if (!IsLogined)
            {
                return;
            }

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,Member.Instance.Id),
                Database.MakeInParam("@pass",SqlDbType.VarChar,32,Util.Utility.MD5(pass))
            };
            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "MemberUpdatePassword", prams);
                //Send mail
                string body = "����" + DateTime.Now.ToString() + "���������ĵ�¼����!\n\n";
                body += "�������ǣ�" + pass + "\n\n";
                body += "���ĵ�¼�ʺ��ǣ�" + Member.Instance.Email + "\n\n\n";
                body += "http://www.brandQQ.com";
                Util.Email.SendMail(Member.Instance.Email, "����������BrandQQ�ĵ�¼����", body, false, GeneralConfig.MailSenderInstance);
            }
            catch
            {
                //
            }
        }

        /// <summary>
        /// ��������ʱ��������,�����û�Guid�ÿ�
        /// </summary>
        /// <param name="email">�û��ʼ���ַ</param>
        /// <param name="guid">��֤��־��</param>
        /// <param name="pass">����</param>
        public static void ResetPassword(string email, string guid, string pass)
        {
            /* MemberUpdatePassword
             * @id int=0,
             * @email varchar(50)='',
             * @guid varchar(32)='',
             * @pass varchar(32)
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@email",SqlDbType.VarChar,50,email),
                Database.MakeInParam("@guid",SqlDbType.VarChar,32,guid),
                Database.MakeInParam("@pass",SqlDbType.VarChar,32,Util.Utility.MD5(pass))
            };
            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "MemberUpdatePassword", prams);
            }
            catch
            {
                //
            }
        }

        #endregion

        #region properties
        /// <summary>
        /// ��ȡ�������û���¼��
        /// </summary>
        public int Id
        {
            get
            {
                return id;
            }
            set
            {
                id = value;
            }
        }

        /// <summary>
        /// ��ȡ�������û���Ψһ��־��
        /// </summary>
        public string RegGuid
        {
            get
            {
                return regGuid;
            }
            set
            {
                regGuid = value;
            }
        }

        /// <summary>
        /// ��ȡ�����õ����ʼ�
        /// </summary>
        public string Email
        {
            get
            {
                return email;
            }
            set
            {
                email = value;
            }
        }

        /// <summary>
        /// ��ȡ�������û�����
        /// </summary>
        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
            }
        }

        /// <summary>
        /// ��ȡ�����õ�¼����
        /// </summary>
        public string Password
        {
            get
            {
                return password;
            }
            set
            {
                password = value;
            }
        }

        /// <summary>
        /// ��ȡ������ע������
        /// </summary>
        public DateTime RegDate
        {
            get
            {
                return regDate;
            }
            set
            {
                regDate = value;
            }
        }

        /// <summary>
        /// ��ȡ����������¼����
        /// </summary>
        public DateTime LastLogin
        {
            get
            {
                return lastLogin;
            }
            set
            {
                lastLogin = value;
            }
        }

        /// <summary>
        /// ��ȡ�����õ�¼����
        /// </summary>
        public int LoginTimes
        {
            get
            {
                return loginTimes;
            }
            set
            {
                loginTimes = value;
            }
        }

        /// <summary>
        /// ��ȡ����������¼��IP��ַ
        /// </summary>
        public string LastIp
        {
            get
            {
                return lastIp;
            }
            set
            {
                lastIp = value;
            }
        }

        /// <summary>
        /// ��ȡ�ͻ�����ʱ��ʶ��Ϣ
        /// </summary>
        public static MemberTempInfo TempInfo
        {
            get
            {
                if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
                {
                    return (MemberTempInfo)null;
                }
                else
                {
                    MemberTempInfo info = new MemberTempInfo();
                    info.Guid = Cookies.GetCookieValue("BRANDQQ_TEMP_INFO", "GUID");
                    info.PaperSN = Cookies.GetCookieValue("BRANDQQ_TEMP_INFO", "PAPERSN");
                    info.ResultId = Convert.ToInt32(Cookies.GetCookieValue("BRANDQQ_TEMP_INFO", "RESULTID"));
                    info.ModuleId = Convert.ToInt32(Cookies.GetCookieValue("BRANDQQ_TEMP_INFO", "MODULEID"));
                    info.QuestionId = Convert.ToInt32(Cookies.GetCookieValue("BRANDQQ_TEMP_INFO", "QUESTIONID"));
                    return info;
                }
            }
        }

        /// <summary>
        /// ��ȡ��ǰ��¼�û���Cookieʵ��
        /// </summary>
        public static MemberInstance Instance
        {
            get
            {
                MemberInstance instance = null;
                if (IsLogined)
                {
                    instance = new MemberInstance();
                    instance.Id = Convert.ToInt32(Cookies.GetCookieValue(__cookieName, "ID"));
                    instance.Guid = Cookies.GetCookieValue(__cookieName, "GUID");
                    instance.Email = Cookies.GetCookieValue(__cookieName, "EMAIL");
                    instance.Name = HttpContext.Current.Server.UrlDecode(Cookies.GetCookieValue(__cookieName, "NAME"));
                }
                return instance;
            }
        }

        #endregion

        private int id;
        private string regGuid;
        private string email;
        private string name;
        private string password;
        private DateTime regDate;
        private DateTime lastLogin;
        private int loginTimes;
        private string lastIp;

        private static readonly string __cookieName = "BRANDQQ_WEB_COOKIE";
    }

    /// <summary>
    /// ��¼�û���Cookieʵ��
    /// </summary>
    public class MemberInstance
    {
        /// <summary>
        /// ���û��ȡ�û���¼��
        /// </summary>
        public int Id;

        /// <summary>
        /// ���û��ȡ�û�Ψһ��־��
        /// </summary>
        public string Guid;

        /// <summary>
        /// ���û��ȡ�û��ʼ���ַ
        /// </summary>
        public string Email;

        /// <summary>
        /// ���û��ȡ�û�����
        /// </summary>
        public string Name;

        /// <summary>
        /// ��ȡ��ǰ�û��Ƿ���ϵͳ�û�
        /// </summary>
        public bool IsSysUser
        {
            get
            {
                return GeneralConfig.Instance.SystemUsers.ToLower().IndexOf(Email.ToLower()) != -1;
            }
        }
    }

    /// <summary>
    /// ��ʾ�û�����ʱ��Ϣ,�洢�ڿͻ��˵�Cookie��
    /// </summary>
    public class MemberTempInfo
    {
        /// <summary>
        /// ���û��ȡΨһ��־��
        /// </summary>
        public string Guid;

        /// <summary>
        /// ���û��ȡ����ʾ�ı��
        /// </summary>
        public string PaperSN;

        /// <summary>
        /// ����ļ���¼��
        /// </summary>
        public int ResultId;

        /// <summary>
        /// ���û��ȡ���ģ��ļ�¼��
        /// </summary>
        public int ModuleId;

        /// <summary>
        /// ���û��ȡ�������ļ�¼��
        /// </summary>
        public int QuestionId;

        /// <summary>
        /// ��Ϊδע���û�,�����ʾ����ʱ,���ø����ʾ�Ľ�����Ϣ
        /// </summary>
        /// <param name="sn">�ʾ�ı��</param>
        /// <param name="mid">ģ��ļ�¼��</param>
        /// <param name="qid">����ļ�¼��</param>
        public static void Set(string sn,int rid, int mid, int qid)
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                return;
            }

            Cookies.WriteCookie("BRANDQQ_TEMP_INFO",GeneralConfig.Instance.UserTempInfoDuration, new string[] { "PAPERSN","RESULTID", "MODULEID", "QUESTIONID" }, new string[] { sn,rid.ToString(), mid.ToString(),qid.ToString() });
        }

        /// <summary>
        /// ���µ�ǰģ��������¼��
        /// </summary>
        /// <param name="mid"></param>
        /// <param name="qid"></param>
        public static void Set(int mid, int qid)
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                return;
            }

            Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "MODULEID", "QUESTIONID" }, new string[] { mid.ToString(), qid.ToString() });
        }

        /// <summary>
        /// ��������ֵ
        /// </summary>
        public static void Reset()
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                return;
            }

            Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "PAPERSN", "RESULTID", "MODULEID", "QUESTIONID" }, new string[] { "","0","0","0" });
        }

        /// <summary>
        /// ����RESULTIDΪ0
        /// </summary>
        public static void ResetResultId()
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                return;
            }

            Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "RESULTID"}, new string[] { "0" });
        }

        /// <summary>
        /// ���
        /// </summary>
        public static void Clear()
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                return;
            }
            Cookies.RemoveCookie("BRANDQQ_TEMP_INFO");
        }
    }

    /// <summary>
    /// ��ʾFlexLib���û���Ϣ
    /// </summary>
    public class MeberFlexInfo
    {
        private MeberFlexInfo()
        {
            LogoGuid = "";
            CardGuid = "";
            CardTempGuid = "";
        }

        public static MeberFlexInfo Instance
        {
            get
            {
                MeberFlexInfo info = new MeberFlexInfo();
                if (!Cookies.HasCookie("BRANDQQ_FLEX_INFO"))
                {
                    Cookies.WriteCookie("BRANDQQ_FLEX_INFO", 360,
                        new string[] { "LOGOGUID", "CARDGUID", "CARDTEMPGUID" },
                        new string[] { info.logoGuid, info.cardGuid, info.cardTempGuid });
                }
                else
                {
                    info.logoGuid = Cookies.GetCookieValue("BRANDQQ_FLEX_INFO", "LOGOGUID");
                    info.cardGuid = Cookies.GetCookieValue("BRANDQQ_FLEX_INFO", "CARDGUID");
                    info.cardTempGuid = Cookies.GetCookieValue("BRANDQQ_FLEX_INFO", "CARDTEMPGUID");
                }
                return info;
            }
        }

        public string LogoGuid
        {
            get
            {
                return logoGuid;
            }
            set
            {
                logoGuid = value;
                Cookies.WriteCookie("BRANDQQ_FLEX_INFO", new string[] { "LOGOGUID" }, new string[] { logoGuid });
            }
        }

        public string CardGuid
        {
            get
            {
                return cardGuid;
            }
            set
            {
                cardGuid = value;
                Cookies.WriteCookie("BRANDQQ_FLEX_INFO", new string[] { "CARDGUID" }, new string[] { cardGuid });
            }
        }

        public string CardTempGuid
        {
            get
            {
                return cardTempGuid;
            }
            set
            {
                cardTempGuid = value;
                Cookies.WriteCookie("BRANDQQ_FLEX_INFO", new string[] { "CARDTEMPGUID" }, new string[] { cardTempGuid });
            }
        }

        public static void Clear()
        {
            if (!Cookies.HasCookie("BRANDQQ_FLEX_INFO"))
            {
                return;
            }
            Cookies.RemoveCookie("BRANDQQ_FLEX_INFO");
        }

        private string logoGuid;
        private string cardGuid;
        private string cardTempGuid;
    }
}
