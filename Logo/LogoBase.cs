using System;
using System.Collections;
using System.Text;
using System.Data;
using System.Data.SqlClient;


using BrandQQ.Util;
using BrandQQ.Membership;

namespace BrandQQ.Logo
{
    /// <summary>
    /// 
    /// </summary>
    public class LogoBase
    {
        private LogoBase()
        {
        }

        public static LogoBase Create(LogoType type)
        {
            LogoBase logo = new LogoBase();
            logo.LType = type;
            return logo;
        }
               

        /// <summary>
        /// 获取或设置logo记录号
        /// </summary>
        public int Id;

        /// <summary>
        /// logo 类型
        /// </summary>
        public LogoType LType;

        /// <summary>
        /// 获取或设置logo Guid
        /// </summary>
        public string Guid;

        /// <summary>
        /// 获取或设置相关用户ID
        /// </summary>
        public int UserId;

        /// <summary>
        /// 获取相关企业名称
        /// </summary>
        public string ComName;

        /// <summary>
        /// 获取或设置logo 标题
        /// </summary>
        public string Title;

        /// <summary>
        /// 所属行业代码
        /// </summary>
        public string Industry;

        /// <summary>
        /// 分值
        /// </summary>
        public int Score;

        /// <summary>
        /// 可用性审核
        /// </summary>
        public bool Enabled;

        /// <summary>
        /// 图片文件的物理路径
        /// </summary>
        public string FilePath
        {
            get
            {
                string path = GeneralConfig.Instance.LogoDataSourcePath;
                switch (LType)
                {
                    case LogoType.Record:
                        path += "LogoImages\\";
                        break;
                    case LogoType.Sample:
                        path += "LogoImages\\";
                        break;
                    case LogoType.Upload:
                        path += "LogoImages\\";
                        break;
                }
                return path + Industry + "\\" + Guid + "." + ImageType;
            }
        }

        /// <summary>
        /// 获取图片路径参数
        /// </summary>
        public string ImageSrc
        {
            get
            {
                return this.Industry + ((int)this.LType).ToString() + ((int)this.ImageType).ToString() + "." + this.Guid;
            }
        }

        /// <summary>
        /// 获取查看路径参数
        /// </summary>
        public string ViewSrc
        {
            get
            {
                return this.Industry + ((int)this.LType).ToString() + ((int)this.ImageType).ToString()+this.UserId.ToString() + "." + this.Guid;
            }
        }

        /// <summary>
        /// 图片文件类型
        /// </summary>
        public LogoImageType ImageType;

        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreateDatetime;

        /// <summary>
        /// 描述
        /// </summary>
        public string Description;

        /// <summary>
        /// 保存logo数据
        /// </summary>
        /// <returns></returns>
        public int Save()
        {
            /* LogoSave
                @type char(1),
                @guid char(32),
                @uid int=0,
                @industry char(6),
                @title varchar(20),
                @imgType varchar(5),
                @enable char(1)='1',
                @desc varchar(500)=''
            */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@type",SqlDbType.Char,1,((int)LType).ToString()),
                Database.MakeInParam("@guid",SqlDbType.Char,32,Guid),
                Database.MakeInParam("@uid",SqlDbType.Int,UserId),
                Database.MakeInParam("@industry",SqlDbType.Char,6,Industry),
                Database.MakeInParam("@title",SqlDbType.VarChar,20,Title),
                Database.MakeInParam("@imgType",SqlDbType.Char,1,((int)ImageType).ToString()),
                Database.MakeInParam("@enable",SqlDbType.Char,1,Enabled?"1":"0"),
                Database.MakeInParam("@desc",SqlDbType.VarChar,300,Description)
            };

            int newId = 0;
            try
            {
                newId = Database.ExecuteNonQuery(CommandType.StoredProcedure, "LogoSave", prams);
            }
            catch
            {
                newId = -1;
            }

            return newId;
        }

        /// <summary>
        /// 增加分值
        /// </summary>
        public void AddScore()
        {
            AddScore(this.Guid);
        }

        /// <summary>
        /// 增加分值
        /// </summary>
        /// <param name="id">记录号</param>
        public static void AddScore(int id)
        {
            AddScore(id.ToString());
        }

        /// <summary>
        /// 增加分值
        /// </summary>
        /// <param name="guid">Guid</param>
        public static void AddScore(string guid)
        {
            /*
             LogoSet
                @action varchar(15),
                @id varchar(32)
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@action",SqlDbType.VarChar,15,LogoAction.AddScore.ToString()),
                Database.MakeInParam("@id",SqlDbType.VarChar,32,guid)
            };

            Database.ExecuteNonQuery(CommandType.StoredProcedure, "LogoSet", prams);
        }

        /// <summary>
        /// 切换可用状态
        /// </summary>
        public void SwitchEnabled()
        {
            SwitchEnabled(this.Guid);
        }

        /// <summary>
        /// 切换可用状态
        /// </summary>
        /// <param name="id">记录号</param>
        public static void SwitchEnabled(int id)
        {
            SwitchEnabled(id.ToString());
        }

        /// <summary>
        /// 切换可用状态
        /// </summary>
        /// <param name="guid">Guid</param>
        public static void SwitchEnabled(string guid)
        {
            /*
             LogoSet
                @action varchar(15),
                @id varchar(32)
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@action",SqlDbType.VarChar,15,LogoAction.SetEnabled.ToString()),
                Database.MakeInParam("@id",SqlDbType.VarChar,32,guid)
            };

            Database.ExecuteNonQuery(CommandType.StoredProcedure, "LogoSet", prams);
        }

        /// <summary>
        /// 获取logo数据
        /// </summary>
        /// <param name="id">记录号</param>
        /// <returns></returns>
        public static LogoBase Get(int id)
        {
            return Get(id.ToString());
        }

        /// <summary>
        /// 获取logo数据
        /// </summary>
        /// <param name="guid">Guid</param>
        /// <returns></returns>
        public static LogoBase Get(string guid)
        {
            /* LogoGet
              @id varchar(32)
            */

            if (guid.Length != 32)
            {
                return null;
            }

            LogoBase logo = null;

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.VarChar,32,guid)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "LogoGet", prams);
                /*[Id],Type, Guid, UserId, Industry, Title, Score, ImageType, CreateDatetime, Enabled,[Description],ComName*/
                if (reader.Read())
                {
                    logo = new LogoBase();
                    logo.Id = reader.GetInt32(0);
                    logo.LType = (LogoType)Convert.ToInt16(reader.GetString(1));
                    logo.Guid = reader.GetString(2);
                    logo.UserId = reader.GetInt32(3);
                    logo.Industry = reader.GetString(4);
                    logo.Title = reader.GetString(5);
                    logo.Score = reader.GetInt32(6);
                    logo.ImageType = (LogoImageType)Convert.ToInt16(reader.GetString(7));
                    logo.CreateDatetime = reader.GetDateTime(8);
                    logo.Enabled = reader.GetString(9) == "1" ? true : false;
                    logo.Description = reader.GetString(10);
                    logo.ComName = reader.GetString(11);
                }
                reader.Close();
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            return logo;
        }

        /// <summary>
        /// 读取指定Logo的对比列表
        /// </summary>
        /// <param name="type">对比类型</param>
        /// <param name="logoId">Logo Id或者Guid</param>
        /// <returns></returns>
        public static ArrayList GetComparesList(LogoCompareType type,string logoId)
        {
            ArrayList list = new ArrayList();
            /*
             LogoCompareList
            @type char(1),
            @logoId int=0
             */
            SqlParameter[] prams ={
                Database.MakeInParam("@type",SqlDbType.Char,1,((int)type).ToString()),
                Database.MakeInParam("@logoId",SqlDbType.VarChar,32,logoId)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "LogoCompareList", prams);
                while (reader.Read())
                {
                    /*[Id],Type,Guid, UserId,Industry, Title, Score, ImageType, CreateDatetime, Enabled,ComName*/
                    LogoBase logo = new LogoBase();
                    logo.Id = reader.GetInt32(0);
                    logo.LType = (LogoType)Convert.ToInt16(reader.GetString(1));
                    logo.Guid = reader.GetString(2);
                    logo.UserId = reader.GetInt32(3);
                    logo.Industry = reader.GetString(4);
                    logo.Title = reader.GetString(5);
                    logo.Score = reader.GetInt32(6);
                    logo.ImageType = (LogoImageType)Convert.ToInt16(reader.GetString(7));
                    logo.CreateDatetime = reader.GetDateTime(8);
                    logo.Enabled = reader.GetString(9) == "1" ? true : false;
                    logo.ComName = reader.GetString(10);
                    list.Add(logo);
                }
                reader.Close();
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            //如果是行业对比，并且对比数量不足，则随机抽取记录，填充列表
            if (list.Count < LogoUtil.LOGO_COMPARE_MAXCOUNT && type == LogoCompareType.IndustryCompare)
            {
                LogoBase sourceLogo = LogoBase.Get(logoId);

                if (sourceLogo != null)
                {
                    int[] sortNums ={ 0,11,12,21,22};
                    int sortNum = sortNums[new Random().Next(0, sortNums.Length)];//随机排序

                    int padCount = (LogoUtil.LOGO_COMPARE_MAXCOUNT - list.Count) * 10;//放大10倍后随机抽取
                    ArrayList padList = ListSample(new Pager(1, padCount * 10, sortNum), sourceLogo.Industry, true);
                    list.AddRange(LogoUtil.GetRandomList(padList, LogoUtil.LOGO_COMPARE_MAXCOUNT - list.Count));
                }
            }

            return list;

        }

        #region list functions

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="sta">指定可用性</param>
        /// <returns>ArrayList</returns>
        private static ArrayList List(LogoType type, Pager pager, int uid, string industry, int enabled,string exclude)
        {
            ArrayList list = new ArrayList();
            /*
             LogoList
            @type char(1),
            @uid int=0,
            @industry char(6)='000000',
            @pageindex int=1,
            @pagesize int=20,
            @sort int=0
             */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@type",SqlDbType.Char,1,((int)type).ToString()),
                Database.MakeInParam("@uid",SqlDbType.Int,uid),
                Database.MakeInParam("@industry",SqlDbType.Char,6,industry),
                Database.MakeInParam("@enabled",SqlDbType.Char,6,enabled),
                Database.MakeInParam("@exclude",SqlDbType.VarChar,32,String.IsNullOrEmpty(exclude)?"":exclude.Trim()),
                Database.MakeInParam("@pageindex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pagesize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "LogoList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);

                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id],Type,Guid, UserId,Industry, Title, Score, ImageType, CreateDatetime, Enabled,ComName*/
                            LogoBase logo = new LogoBase();
                            logo.Id = reader.GetInt32(0);
                            logo.LType = (LogoType)Convert.ToInt16(reader.GetString(1));
                            logo.Guid = reader.GetString(2);
                            logo.UserId = reader.GetInt32(3);
                            logo.Industry = reader.GetString(4);
                            logo.Title = reader.GetString(5);
                            logo.Score = reader.GetInt32(6);
                            logo.ImageType = (LogoImageType)Convert.ToInt16(reader.GetString(7));
                            logo.CreateDatetime = reader.GetDateTime(8);
                            logo.Enabled = reader.GetString(9) == "1" ? true : false;
                            logo.ComName = reader.GetString(10);
                            list.Add(logo);
                        }
                    }
                }
                reader.Close();
            }
            catch (Exception e)
            {
                throw e;
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
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(LogoType type, Pager pager, int uid, string industry, bool enabled)
        {
            return List(type, pager, uid, industry, enabled ? 1 : 0,"");
        }

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(LogoType type, Pager pager, int uid, string industry)
        {
            return List(type, pager, uid, industry, -1, "");
        }

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(LogoType type, Pager pager, int uid, bool enabled)
        {
            return List(type, pager, uid, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        ///  读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <returns></returns>
        public static ArrayList List(LogoType type, Pager pager, int uid)
        {
            return List(type, pager, uid, "", -1, "");
        }

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(LogoType type, Pager pager, string industry, bool enabled)
        {
            return List(type, pager, 0, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <returns></returns>
        public static ArrayList List(LogoType type, Pager pager, string industry)
        {
            return List(type, pager, 0, industry, -1, "");
        }

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(LogoType type, Pager pager, bool enabled)
        {
            return List(type, pager, 0, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Logo记录
        /// </summary>
        /// <param name="type">Logo类型</param>
        /// <param name="pager">分页对象</param>
        /// <returns></returns>
        public static ArrayList List(LogoType type, Pager pager)
        {
            return List(type, pager, 0, "", -1, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, int uid, string industry)
        {
            return List(LogoType.Record, pager, uid, industry, -1, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, int uid, string industry,bool enabled)
        {
            return List(LogoType.Record, pager, uid, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, int uid, bool enabled)
        {
            return List(LogoType.Record, pager, uid, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, int uid)
        {
            return List(LogoType.Record, pager, uid, "", -1, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, string industry, bool enabled)
        {
            return List(LogoType.Record, pager, 0, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, string industry)
        {
            return List(LogoType.Record, pager, 0, industry, -1, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager, bool enabled)
        {
            return List(LogoType.Record, pager, 0, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Record类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListRecord(Pager pager)
        {
            return List(LogoType.Record, pager, 0, "", -1, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid, string industry, bool enabled)
        {
            return List(LogoType.Sample, pager, uid, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid, string industry, bool enabled,string exclude)
        {
            return List(LogoType.Sample, pager, uid, industry, enabled ? 1 : 0, exclude);
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid, string industry)
        {
            return List(LogoType.Sample, pager, uid, industry, -1, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid, string industry, string exclude)
        {
            return List(LogoType.Sample, pager, uid, industry, -1, exclude);
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid, bool enabled)
        {
            return List(LogoType.Sample, pager, uid, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="enabled">指定可用性</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid, bool enabled, string exclude)
        {
            return List(LogoType.Sample, pager, uid, "", enabled ? 1 : 0, exclude);
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, int uid)
        {
            return List(LogoType.Sample, pager, uid, "", -1, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, string industry, bool enabled)
        {
            return List(LogoType.Sample, pager, 0, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, string industry, bool enabled, string exclude)
        {
            return List(LogoType.Sample, pager, 0, industry, enabled ? 1 : 0, exclude);
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, string industry)
        {
            return List(LogoType.Sample, pager, 0, industry, -1, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, string industry, string exclude)
        {
            return List(LogoType.Sample, pager, 0, industry, -1, exclude);
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager, bool enabled)
        {
            return List(LogoType.Sample, pager, 0, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Sample类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListSample(Pager pager)
        {
            return List(LogoType.Sample, pager, 0, "", -1, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid, string industry, bool enabled)
        {
            return List(LogoType.Upload, pager, uid, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid, string industry, bool enabled,string exclude)
        {
            return List(LogoType.Upload, pager, uid, industry, enabled ? 1 : 0, exclude);
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid, string industry)
        {
            return List(LogoType.Upload, pager, uid, industry, -1, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="industry">行业代码</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid, string industry, string exclude)
        {
            return List(LogoType.Upload, pager, uid, industry, -1, exclude);
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid, bool enabled)
        {
            return List(LogoType.Upload, pager, uid, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <param name="enabled">指定可用性</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid, bool enabled, string exclude)
        {
            return List(LogoType.Upload, pager, uid, "", enabled ? 1 : 0, exclude);
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="uid">用户ID</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, int uid)
        {
            return List(LogoType.Upload, pager, uid, "", -1, "");
        }


        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, string industry, bool enabled)
        {
            return List(LogoType.Upload, pager, 0, industry, enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="enabled">指定可用性</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, string industry, bool enabled, string exclude)
        {
            return List(LogoType.Upload, pager, 0, industry, enabled ? 1 : 0, exclude);
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, string industry)
        {
            return List(LogoType.Upload, pager, 0, industry, -1, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="industry">行业代码</param>
        /// <param name="exclude">要排除的Logo Id,Guid,或者用户Id</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, string industry, string exclude)
        {
            return List(LogoType.Upload, pager, 0, industry, -1, exclude);
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager, bool enabled)
        {
            return List(LogoType.Upload, pager, 0, "", enabled ? 1 : 0, "");
        }

        /// <summary>
        /// 读取Upload类型Logo记录
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <returns>ArrayList</returns>
        public static ArrayList ListUpload(Pager pager)
        {
            return List(LogoType.Upload, pager, 0, "", -1, "");
        }

        #endregion
    }
}
