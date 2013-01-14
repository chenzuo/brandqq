using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Data;
using System.Data.SqlClient;

using BrandQQ.Util;

namespace BrandQQ.Util.ModuleEval
{
    /// <summary>
    /// BrandQQ¸÷Ä£¿éÆÀ¹À
    /// </summary>
    public class MEvaluation
    {
        private MEvaluation() { }

        public static void DoEval(string m, short usab, short frid, short func, string evaluation)
        {
            /*
             BrandQQModuleEvalSave
            @module varchar(10),
            @usab smallint,
            @frid smallint,
            @func smallint,
            @eval varchar(250),
            @ip varchar(20)
             */

            evaluation = HttpContext.Current.Server.HtmlEncode(evaluation);

            SqlParameter[] prams ={
                Database.MakeInParam("@module",SqlDbType.VarChar,10,m),
                Database.MakeInParam("@usab",SqlDbType.SmallInt,usab),
                Database.MakeInParam("@frid",SqlDbType.SmallInt,frid),
                Database.MakeInParam("@func",SqlDbType.SmallInt,func),
                Database.MakeInParam("@eval",SqlDbType.VarChar,250,evaluation),
                Database.MakeInParam("@ip",SqlDbType.VarChar,20,HttpContext.Current.Request.UserHostAddress)
            };

            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "BrandQQModuleEvalSave", prams);
            }
            catch
            {
                //
            }
        }

        public static ArrayList List(Pager pager, string m)
        {
            /* BrandQQModuleEvalList
             * @m varchar(20)='',
             * @pageindex int=1,
             * @pagesize int=20,
             * @sort int=0
             */


            ArrayList list = new ArrayList();
            SqlParameter[] prams ={
                Database.MakeInParam("@m",SqlDbType.VarChar,20,m),
                Database.MakeInParam("@pageIndex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pageSize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;
            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "BrandQQModuleEvalList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);

                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id], ModuleName, Usability, Friendliness, Functionality, 
	Evaluation, SourceIp, [Datetime]*/
                            MEvaluation me = new MEvaluation();
                            me.Id = reader.GetInt32(0);
                            me.Name = reader.GetString(1);
                            me.Usability = reader.GetInt16(2);
                            me.Friendliness = reader.GetInt16(3);
                            me.Functionality = reader.GetInt16(4);
                            me.Evaluation = reader.GetString(5);
                            me.SourceIp = reader.GetString(6);
                            me.Date = reader.GetDateTime(7);
                            list.Add(me);
                        }
                    }
                }

                reader.Close();
            }
            catch (Exception e)
            {
                throw new Exception("Member.List: +" + e.ToString());
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

        public short Usability
        {
            get
            {
                return usability;
            }
            set
            {
                usability = value;
            }
        }

        public short Friendliness
        {
            get
            {
                return friendliness;
            }
            set
            {
                friendliness = value;
            }
        }

        public short Functionality
        {
            get
            {
                return functionality;
            }
            set
            {
                functionality = value;
            }
        }


        public string Evaluation
        {
            get
            {
                return evaluation;
            }
            set
            {
                evaluation = value;
            }
        }

        public string SourceIp
        {
            get
            {
                return sourceIp;
            }
            set
            {
                sourceIp = value;
            }
        }

        public DateTime Date
        {
            get
            {
                return datetime;
            }
            set
            {
                datetime = value;
            }
        }

        private int id;
        private string name;
        private short usability;
        private short friendliness;
        private short functionality;
        private string evaluation;
        private string sourceIp;
        private DateTime datetime;
    }
}
