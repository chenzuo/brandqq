using System;
using System.Collections;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using BrandQQ.Util;

namespace BrandQQ.Logo
{
    public class LogoSymbol
    {

        public LogoSymbol()
        {
            Guid = Utility.NewGuid;
            Title = "";
            Code = "";
            CategoryCode = "";
            Industries = "";
            Tags = "";
        }

        #region list functions
        /// <summary>
        /// 读取图形列表
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="cateCode">分类代码</param>
        /// <param name="indusCodes">行业代码</param>
        /// <param name="keyword">关键字</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(Pager pager,string cateCode,string indusCodes,string keyword)
        {
            ArrayList list = new ArrayList();
            /*
             LogoSymbolList
                @cate varchar(18)='',
                @indus varchar(50)='',
                @keyword varchar(20)='',
                @pageindex int=1,
                @pagesize int=20,
                @sort int=0
             */

            SqlParameter[] prams ={
                Database.MakeReturnValueParam("@returnValue"),
                Database.MakeInParam("@cate",SqlDbType.VarChar,18,cateCode),
                Database.MakeInParam("@indus",SqlDbType.VarChar,50,indusCodes),
                Database.MakeInParam("@keyword",SqlDbType.VarChar,20,keyword.Length>20?keyword.Substring(0,20):keyword),
                Database.MakeInParam("@pageindex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pagesize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;

            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "LogoSymbolList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);

                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id], Guid, Title, CategoryCode, SymbolCode, Industries, Tags*/
                            LogoSymbol obj = new LogoSymbol();
                            obj.Id = reader.GetInt32(0);
                            obj.Guid = reader.GetString(1);
                            obj.Title = reader.GetString(2);
                            obj.CategoryCode = reader.GetString(3);
                            obj.Code = reader.GetString(4);
                            obj.Industries = reader.GetString(5);
                            obj.Tags = reader.GetString(6);
                            list.Add(obj);
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
        /// 读取图形列表
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="cateCode">分类代码</param>
        /// <param name="indusCodes">行业代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(Pager pager, string cateCode, string indusCodes)
        {
            return List(pager, cateCode, indusCodes, "");
        }
        /// <summary>
        /// 读取图形列表
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <param name="cateCode">分类代码</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(Pager pager, string cateCode)
        {
            return List(pager, cateCode, "", "");
        }
        /// <summary>
        /// 读取图形列表
        /// </summary>
        /// <param name="pager">分页对象</param>
        /// <returns>ArrayList</returns>
        public static ArrayList List(Pager pager)
        {
            return List(pager, "", "", "");
        }
        #endregion

        #region properties

        public int Id;
        public string Guid;
        public string Title;
        public string Code;
        public string CategoryCode;
        public string Industries;
        public string Tags;

        #endregion
    }
}
