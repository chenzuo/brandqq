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
    /// 表示基本用户
    /// </summary>
    public class Member
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        public Member()
        {
            this.id = 0;
        }

        #region methods

        /// <summary>
        /// 保存资料
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

                //创建用户的结果文件存储目录
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
        /// 检查一个Guid是否合法用户
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <returns>null或者Member</returns>
        public static Member IsMember(string guid)
        {
            return IsMember(guid, "", "");
        }

        /// <summary>
        /// 检查一个Email/password是否合法用户
        /// </summary>
        /// <param name="mail">邮件地址</param>
        /// <param name="pwd">密码</param>
        /// <returns>null或者Member</returns>
        public static Member IsMember(string mail, string pwd)
        {
            return IsMember("",mail, pwd);
        }

        /// <summary>
        /// 检查一个Guid或者(Email/password)是否合法用户
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
        /// 检查一个Email地址是否已存在
        /// </summary>
        /// <param name="email">邮件地址</param>
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
        /// 检查登录是否成功
        /// </summary>
        /// <param name="u">Member</param>
        /// <returns></returns>
        public static bool Login(Member u)
        {
            return Login(u.email,u.password);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="u">Member</param>
        /// <param name="expire">过期天数</param>
        /// <returns></returns>
        public static bool Login(Member u,int expire)
        {
            return Login(u.email, u.password, expire);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <returns></returns>
        public static bool Login(string guid)
        {
            return Login(guid, (Member)null, "", "", 0);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <param name="m">包含完整信息的Member实例</param>
        /// <returns></returns>
        public static bool Login(string guid,Member m)
        {
            return Login(guid, m, "", "", 0);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <param name="expire">过期天数</param>
        /// <returns></returns>
        public static bool Login(string guid, int expire)
        {
            return Login(guid,(Member)null, "", "", expire);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="email">邮件地址</param>
        /// <param name="pwd">密码</param>
        /// <returns></returns>
        public static bool Login(string email, string pwd)
        {
            return Login(email, pwd, 0);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="email">邮件地址</param>
        /// <param name="pwd">密码</param>
        /// <param name="expire">过期天数</param>
        /// <returns></returns>
        public static bool Login(string email, string pwd,int expire)
        {
            return Login("",(Member)null, email, pwd, expire);
        }

        /// <summary>
        /// 检查登录是否成功
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <param name="member">包含完整信息的Member实例</param>
        /// <param name="email">邮件地址</param>
        /// <param name="pwd">密码</param>
        /// <param name="expire">过期天数</param>
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
                    //查找登录之前创建的结果文件
                    //同步更新数据库中的状态记录
                    string tempPath = GeneralConfig.Instance.PaperResultTempSavePath + Member.TempInfo.ResultId.ToString() + ".rst";
                    if (File.Exists(tempPath))
                    {
                        UpdateResultStatusGuid(Member.TempInfo.ResultId, Member.Instance.Guid);
                    }
                }

                //更新临时标志串
                Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "GUID" }, new string[] { m.RegGuid });
            }

            return true;
        }

        /// <summary>
        /// 登录时更新状态记录的GUID
        /// </summary>
        /// <param name="rid">结果文件记录号</param>
        /// <param name="guid">登录用户的Guid</param>
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
        /// 退出登录
        /// </summary>
        public static void Logout()
        {
            Cookies.RemoveCookie(__cookieName);
        }

        /// <summary>
        /// 读取用户资料
        /// </summary>
        /// <param name="id">用户记录号</param>
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
        /// 判断当前用户是否已登录
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
        /// 读取用户记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <returns></returns>
        public static ArrayList List(Pager pager)
        {
            return List("", "", pager);
        }

        /// <summary>
        /// 读取用户记录
        /// </summary>
        /// <param name="email">邮件地址关键字</param>
        /// <param name="pager">分页对象</param>
        /// <returns></returns>
        public static ArrayList List(string mail, Pager pager)
        {
            return List(mail, "", pager);
        }

        /// <summary>
        /// 读取用户记录
        /// </summary>
        /// <param name="email">邮件地址关键字</param>
        /// <param name="name">姓名关键字</param>
        /// <param name="Pager">分页对象</param>
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
        /// 创建客户端临时标识信息
        /// </summary>
        public static void SetTempInfo()
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                Cookies.WriteCookie("BRANDQQ_TEMP_INFO", GeneralConfig.Instance.UserTempInfoDuration, new string[] { "GUID", "PAPERSN", "RESULTID", "MODULEID", "QUESTIONID" }, new string[] { Utility.NewGuid, "", "0", "0", "0" });
            }
        }

        /// <summary>
        /// 清除客户端临时标识信息
        /// </summary>
        public static void ClearTempInfo()
        {
            if (Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                Cookies.RemoveCookie("BRANDQQ_TEMP_INFO");
            }
        }

        /// <summary>
        /// 忘记密码时,更新用户GUID标志串
        /// </summary>
        /// <param name="email">用户邮件地址</param>
        /// <param name="guid">GUID标志串</param>
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
        /// 忘记密码时,更新用户GUID标志串
        /// </summary>
        /// <param name="id">用户记录号</param>
        /// <param name="guid">GUID标志串</param>
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
        /// 重置用户密码
        /// </summary>
        /// <param name="pass">密码</param>
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
                string body = "您于" + DateTime.Now.ToString() + "更新了您的登录密码!\n\n";
                body += "新密码是：" + pass + "\n\n";
                body += "您的登录帐号是：" + Member.Instance.Email + "\n\n\n";
                body += "http://www.brandQQ.com";
                Util.Email.SendMail(Member.Instance.Email, "您更新了在BrandQQ的登录密码", body, false, GeneralConfig.MailSenderInstance);
            }
            catch
            {
                //
            }
        }

        /// <summary>
        /// 忘记密码时重置密码,并将用户Guid置空
        /// </summary>
        /// <param name="email">用户邮件地址</param>
        /// <param name="guid">验证标志串</param>
        /// <param name="pass">密码</param>
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
        /// 获取或设置用户记录号
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
        /// 获取或设置用户的唯一标志串
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
        /// 获取或设置电子邮件
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
        /// 获取或设置用户名称
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
        /// 获取或设置登录密码
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
        /// 获取或设置注册日期
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
        /// 获取或设置最后登录日期
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
        /// 获取或设置登录次数
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
        /// 获取或设置最后登录的IP地址
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
        /// 读取客户端临时标识信息
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
        /// 获取当前登录用户的Cookie实例
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
    /// 登录用户的Cookie实例
    /// </summary>
    public class MemberInstance
    {
        /// <summary>
        /// 设置或获取用户记录号
        /// </summary>
        public int Id;

        /// <summary>
        /// 设置或获取用户唯一标志串
        /// </summary>
        public string Guid;

        /// <summary>
        /// 设置或获取用户邮件地址
        /// </summary>
        public string Email;

        /// <summary>
        /// 设置或获取用户名字
        /// </summary>
        public string Name;

        /// <summary>
        /// 获取当前用户是否是系统用户
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
    /// 表示用户的临时信息,存储在客户端的Cookie中
    /// </summary>
    public class MemberTempInfo
    {
        /// <summary>
        /// 设置或获取唯一标志串
        /// </summary>
        public string Guid;

        /// <summary>
        /// 设置或获取最后问卷的编号
        /// </summary>
        public string PaperSN;

        /// <summary>
        /// 结果文件记录号
        /// </summary>
        public int ResultId;

        /// <summary>
        /// 设置或获取最后模块的记录号
        /// </summary>
        public int ModuleId;

        /// <summary>
        /// 设置或获取最后问题的记录号
        /// </summary>
        public int QuestionId;

        /// <summary>
        /// 作为未注册用户,参与问卷测试时,设置更新问卷的进度信息
        /// </summary>
        /// <param name="sn">问卷的编号</param>
        /// <param name="mid">模块的记录号</param>
        /// <param name="qid">问题的记录号</param>
        public static void Set(string sn,int rid, int mid, int qid)
        {
            if (!Cookies.HasCookie("BRANDQQ_TEMP_INFO"))
            {
                return;
            }

            Cookies.WriteCookie("BRANDQQ_TEMP_INFO",GeneralConfig.Instance.UserTempInfoDuration, new string[] { "PAPERSN","RESULTID", "MODULEID", "QUESTIONID" }, new string[] { sn,rid.ToString(), mid.ToString(),qid.ToString() });
        }

        /// <summary>
        /// 更新当前模块和问题记录号
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
        /// 重置所有值
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
        /// 重置RESULTID为0
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
        /// 清除
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
    /// 表示FlexLib的用户信息
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
