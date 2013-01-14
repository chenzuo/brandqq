using System;
using System.Collections;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;

using BrandQQ.Util;
namespace BrandQQ.FlexLib.DBUtils
{
    public static class DBUtil
    {
        #region GetLogos
        public static ArrayList GetLogos(int uid, Pager pager)
        {
            return GetLogos(uid, -1, pager);
        }

        public static ArrayList GetLogos(int uid)
        {
            return GetLogos(uid, -1, new Pager(1,100));
        }

        public static ArrayList GetLogos(int uid,int count)
        {
            return GetLogos(uid, -1, new Pager(1, count));
        }

        public static ArrayList GetLogos(int uid, bool enable, Pager pager)
        {
            return GetLogos(uid, enable ? 1 : 0, pager);
        }

        private static ArrayList GetLogos(int uid, int enable, Pager pager)
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
                Database.MakeInParam("@uid",SqlDbType.Int,uid),
                Database.MakeInParam("@enable",SqlDbType.Int,enable),
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
                            /*[Id],Guid, UserId, Title, Remark, Enable, [Datetime]*/
                            Logo logo = new Logo();
                            logo.Id = reader.GetInt32(0);
                            logo.Guid = reader.GetString(1);
                            logo.UserId = reader.GetInt32(2);
                            logo.Title = reader.GetString(3);
                            logo.Remark = reader.GetString(4);
                            logo.Enable = (reader.GetString(5)=="1");
                            logo.Datetime = reader.GetDateTime(6);
                            list.Add(logo);
                        }
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

            return list;
        }

        #endregion

        #region SaveLogo
        public static int SaveLogo(string guid, int uid, string title, string remark, string texts, bool enable)
        {
            Logo logo = new Logo();
            logo.Guid = guid;
            logo.UserId = uid;
            logo.Title = title;
            logo.Remark = remark;
            logo.Texts = texts;
            logo.Enable = enable;
            return SaveLogo(logo);
        }

        public static int SaveLogo(Logo logo)
        {
            /* LogoSave
                @guid char(32),
                @uid int=0,
                @title varchar(50),
                @remark varchar(500)='',
                @texts varchar(1000)='',
                @enable char(1)='1'
                        */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@guid",SqlDbType.Char,32,logo.Guid),
                Database.MakeInParam("@uid",SqlDbType.Int,logo.UserId),
                Database.MakeInParam("@title",SqlDbType.VarChar,30,logo.Title),
                Database.MakeInParam("@remark",SqlDbType.VarChar,500,logo.Remark),
                Database.MakeInParam("@texts",SqlDbType.VarChar,1000,logo.Texts),
                Database.MakeInParam("@enable",SqlDbType.Char,1,logo.Enable?"1":"0")
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

        #endregion

        #region GetLogo
        public static Logo GetLogo(int id)
        {
            return GetLogo(id.ToString());
        }
        public static Logo GetLogo(string id)
        {
            /* LogoGet
              @id varchar(32)
            */
            Logo logo = new Logo();

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.VarChar,32,id)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "LogoGet", prams);
                /*[Id],Guid, UserId, Title, Remark, Enable, [Datetime], Texts*/
                if (reader.Read())
                {
                    logo.Id = reader.GetInt32(0);
                    logo.Guid = reader.GetString(1);
                    logo.UserId = reader.GetInt32(2);
                    logo.Title = reader.GetString(3);
                    logo.Remark = reader.GetString(4);
                    logo.Enable = reader.GetString(5)=="1";
                    logo.Datetime = reader.GetDateTime(6);
                    logo.Texts = reader.GetString(7);
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
        #endregion

        #region GetCards
        public static ArrayList GetCards(int uid)
        {
            return GetCards(uid, -1, -1, new Pager(1, 100));
        }

        public static ArrayList GetCards(int uid, Pager pager)
        {
            return GetCards(uid, -1, -1, pager);
        }

        public static ArrayList GetCards(int uid,int count)
        {
            return GetCards(uid, -1, -1, new Pager(1, count));
        }

        public static ArrayList GetCards(int uid,bool enable, Pager pager)
        {
            return GetCards(uid, enable?1:0, -1, pager);
        }

        public static ArrayList GetCards(int uid, bool enable,bool hasBack, Pager pager)
        {
            return GetCards(uid, enable ? 1 : 0, hasBack ? 1 : 0, pager);
        }

        private static ArrayList GetCards(int uid, int enable, int hasBack, Pager pager)
        {
            ArrayList list = new ArrayList();
            /*
             BusinessCardList
            @uid int=0,
            @enabled int=-1,
            @hasback int=-1,
            @pageindex int=1,
            @pagesize int=20,
            @sort int=0
             */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@uid",SqlDbType.Int,uid),
                Database.MakeInParam("@enable",SqlDbType.Int,enable),
                Database.MakeInParam("@hasback",SqlDbType.Int,hasBack),
                Database.MakeInParam("@pageindex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pagesize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "BusinessCardList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);

                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id],Guid, UserId, [Name], HasBack, Enable, [Datetime]*/
                            BusinessCard card = new BusinessCard();
                            card.Id = reader.GetInt32(0);
                            card.Guid = reader.GetString(1);
                            card.UserId = reader.GetInt32(2);
                            card.Name = reader.GetString(3);
                            card.HasBack = (reader.GetString(4) == "1");
                            card.Enable = (reader.GetString(5) == "1");
                            card.Datetime = reader.GetDateTime(6);
                            list.Add(card);
                        }
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

            return list;
        }
        #endregion

        #region SaveCard
        public static int SaveCard(string guid,int uid,string name,bool hasBack,bool enable,string texts)
        {
            BusinessCard card = new BusinessCard();
            card.Guid = guid;
            card.UserId = uid;
            card.Name = name;
            card.HasBack = hasBack;
            card.Enable = enable;
            card.Texts = texts;
            return SaveCard(card);
        }

        public static int SaveCard(BusinessCard card)
        {
            /* BusinessCardSave
                @guid char(32),
                @uid int=0,
                @name varchar(50)='',
                @hasBack char(1)='0',
                @enable char(1)='1',
                @texts varchar(1000)=''
                        */
            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@guid",SqlDbType.Char,32,card.Guid),
                Database.MakeInParam("@uid",SqlDbType.Int,card.UserId),
                Database.MakeInParam("@name",SqlDbType.VarChar,30,card.Name),
                Database.MakeInParam("@hasBack",SqlDbType.Char,1,card.HasBack?"1":"0"),
                Database.MakeInParam("@enable",SqlDbType.Char,1,card.Enable?"1":"0"),
                Database.MakeInParam("@texts",SqlDbType.VarChar,1000,card.Texts)
            };

            int newId = 0;
            try
            {
                newId = Database.ExecuteNonQuery(CommandType.StoredProcedure, "BusinessCardSave", prams);
            }
            catch
            {
                newId = -1;
            }

            return newId;
        }

        #endregion

        #region GetCard
        public static BusinessCard GetCard(int id)
        {
            return GetCard(id.ToString());
        }

        public static BusinessCard GetCard(string id)
        {
            /* BusinessCardGet
              @id varchar(32)
            */
            BusinessCard card = new BusinessCard();

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.VarChar,32,id)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "BusinessCardGet", prams);
                /*[Id],Guid, UserId, [Name], HasBack, Enable, [Datetime], Texts*/
                if (reader.Read())
                {
                    card.Id = reader.GetInt32(0);
                    card.Guid = reader.GetString(1);
                    card.UserId = reader.GetInt32(2);
                    card.Name = reader.GetString(3);
                    card.HasBack = reader.GetString(4)=="1";
                    card.Enable = reader.GetString(5) == "1";
                    card.Datetime = reader.GetDateTime(6);
                    card.Texts = reader.GetString(7);
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

            return card;
        }
        #endregion
    }
}
