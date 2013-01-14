using System;
using System.Collections;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using BrandQQ.Util;

namespace BrandQQ.Membership
{
    /// <summary>
    /// ��ʾһ����ҵ�û�
    /// </summary>
    public class Company:Member
    {
        /// <summary>
        /// ���캯��
        /// </summary>
        public Company()
            : base()
        {
            this.busiType = BusinessType.None;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="id">�����û���¼��</param>
        public Company(int id)
            : base()
        {
            this.Id = id;
            this.busiType = BusinessType.None;
            this.turnover = IntRange.None;
            this.employee = IntRange.None;
        }

        #region methods

        /// <summary>
        /// ������ҵ�û�����
        /// </summary>
        public new bool Save()
        {
            /* CompanySave
             * @id int=0,
             * @name varchar(100)='',
             * @indus char(6)='',
             * @nature char(1)='',
             * @region char(4)='',
             * @contact varchar(20)='',
             * @contactpos varchar(30)='',
             * @phone varchar(30)='',
             * @fax varchar(30)='',
             * @t1 int=0,
             * @t2 int=0,
             * @e1 int=0,
             * @e2 int=0,
             * @year int=1900,
             * @web varchar(100)='',
             * @bType char(1)=''
             */
            bool bln = false;

            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,this.Id),
                Database.MakeInParam("@name",SqlDbType.VarChar,100,this.comName),
                Database.MakeInParam("@indus",SqlDbType.Char,6,this.industry),
                Database.MakeInParam("@nature",SqlDbType.Char,1,this.nature),
                Database.MakeInParam("@region",SqlDbType.Char,4,this.region),
                Database.MakeInParam("@contact",SqlDbType.VarChar,20,this.contact),
                Database.MakeInParam("@contactpos",SqlDbType.VarChar,20,this.contactPos),
                Database.MakeInParam("@phone",SqlDbType.VarChar,30,this.phone),
                Database.MakeInParam("@fax",SqlDbType.VarChar,30,this.fax),
                Database.MakeInParam("@t1",SqlDbType.Int,this.turnover.Lower),
                Database.MakeInParam("@t2",SqlDbType.Int,this.turnover.Upper),
                Database.MakeInParam("@e1",SqlDbType.Int,this.employee.Lower),
                Database.MakeInParam("@e2",SqlDbType.Int,this.employee.Upper),
                Database.MakeInParam("@year",SqlDbType.Int,this.year),
                Database.MakeInParam("@web",SqlDbType.VarChar,100,this.website),
                Database.MakeInParam("@bType",SqlDbType.Char,1,this.busiType==BusinessType.None?((int)IndustryUtil.GetBusiType(this.industry)).ToString():((int)this.busiType).ToString())                
            };

            try
            {
                Database.ExecuteNonQuery(CommandType.StoredProcedure, "CompanySave", prams);
                bln = true;
            }
            catch
            {
                throw;
            }

            return bln;
        }

        /// <summary>
        /// ����ҵ�û�������֤
        /// </summary>
        /// <param name="cid">�û���¼��</param>
        public static void Check(int cid)
        {
            Check(cid, true);
        }

        /// <summary>
        ///  ����ҵ�û�������֤
        /// </summary>
        /// <param name="cid">�û���¼��</param>
        /// <param name="isCheck">��֤״̬</param>
        public static void Check(int cid,bool isCheck)
        {
            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,cid),
                Database.MakeInParam("@check",SqlDbType.Char,1,isCheck?"1":"0")
            };

            Database.ExecuteNonQuery(CommandType.StoredProcedure, "CompanyCheck", prams);
        }

        /// <summary>
        /// ��ȡ��ҵ�û�����
        /// </summary>
        /// <param name="id">�û���¼��</param>
        /// <returns></returns>
        public new static Company Get(int id)
        {
            /* CompanyGet
             * @id int
             */
            Company obj = null;
            
            SqlParameter[] prams ={
                Database.MakeInParam("@id",SqlDbType.Int,id)
            };

            SqlDataReader reader = null;
            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "CompanyGet", prams);
                if (reader.Read())
                {
                    /* [Id],[Name],Industry,Nature,Region,Contact,ContactPos,Phone,Fax,TurnoverLower,TurnoverUpper,
                     * EmployeeLower,EmployeeUpper,CreatedYear,Website,BusiType,IsChecked*/
                    obj = new Company();
                    obj.Id = reader.GetInt32(0);
                    obj.ComName = reader.GetString(1);
                    obj.Industry = reader.GetString(2);
                    obj.Nature = reader.GetString(3);
                    obj.Region = reader.GetString(4);
                    obj.Contact = reader.GetString(5);
                    obj.ContactPos = reader.GetString(6);
                    obj.Phone = reader.GetString(7);
                    obj.Fax = reader.GetString(8);
                    obj.Turnover = new IntRange(reader.GetInt32(9), reader.GetInt32(10));
                    obj.Employee = new IntRange(reader.GetInt32(11), reader.GetInt32(12));
                    obj.Year = reader.GetInt32(13);
                    obj.Website = reader.GetString(14);
                    obj.BusiType = (BusinessType)Convert.ToInt16(reader.GetString(15));
                    obj.IsChecked = reader.GetString(16) == "1" ? true : false;
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

            return obj;
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        public new static ArrayList List(Pager pager)
        {
            return List("", "", IntRange.None, IntRange.None,-1, pager);
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="isCheck">�Ƿ񾭹�ȷ�ϵ���ҵ</param>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        public static ArrayList List(bool isCheck,Pager pager)
        {
            return List("", "", IntRange.None, IntRange.None, isCheck?1:0, pager);
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="name">���ƹؼ���</param>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        public new static ArrayList List(string indus, Pager pager)
        {
            return List(indus, "", IntRange.None, IntRange.None, -1, pager);
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="isCheck">�Ƿ񾭹�ȷ�ϵ���ҵ</param>
        /// <param name="indus">��ҵ���</param>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        public static ArrayList List(bool isCheck, string indus, Pager pager)
        {
            return List(indus, "", IntRange.None, IntRange.None, isCheck ? 1 : 0, pager);
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="indus">��ҵ���</param>
        /// <param name="name">���ƹؼ���</param>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        public new static ArrayList List(string indus, string name, Pager pager)
        {
            return List(indus, name, IntRange.None, IntRange.None,-1, pager);
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="tur">Ӫҵ�Χ</param>
        /// <param name="emp">Ա������Χ</param>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        public static ArrayList List(IntRange tur, IntRange emp, Pager pager)
        {
            return List("", "", tur, emp,-1, pager);
        }

        /// <summary>
        /// ��ȡ��ҵ�û���¼
        /// </summary>
        /// <param name="indus">��ҵ���</param>
        /// <param name="name">���ƹؼ���</param>
        /// <param name="tur">Ӫҵ�Χ</param>
        /// <param name="emp">Ա������Χ</param>
        /// <param name="pager">��ҳ</param>
        /// <returns></returns>
        private static ArrayList List(string indus, string name,IntRange tur,IntRange emp,int check, Pager pager)
        {
            /* CompanyList
             * @name varchar(100)='',
             * @indus varchar(6)='',
             * @check int=-1,
             * @pageindex int=1,
             * @pagesize int=20,
             * @sort int=0
             */

            ArrayList list = new ArrayList();
            SqlParameter[] prams ={
                Database.MakeInParam("@name",SqlDbType.VarChar,100,name),
                Database.MakeInParam("@indus",SqlDbType.Char,6,indus),
                Database.MakeInParam("@check",SqlDbType.Int,check),
                Database.MakeInParam("@pageIndex",SqlDbType.Int,pager.PageIndex),
                Database.MakeInParam("@pageSize",SqlDbType.Int,pager.PageSize),
                Database.MakeInParam("@sort",SqlDbType.Int,pager.SortNum)
            };

            SqlDataReader reader = null;
            try
            {
                reader = Database.ExecuteReader(CommandType.StoredProcedure, "CompanyList", prams);

                if (reader.Read())
                {
                    pager.RecordCount = reader.GetInt32(0);

                    if (reader.NextResult())
                    {
                        while (reader.Read())
                        {
                            /*[Id],[Name],Industry,Nature,Region,Contact,ContactPos,Phone,Fax,TurnoverLower,TurnoverUpper,
                             * EmployeeLower,EmployeeUpper,CreatedYear,Website,BusiType,IsChecked*/
                            Company obj = new Company();
                            obj.Id = reader.GetInt32(0);
                            obj.ComName = reader.IsDBNull(1) ? "" : reader.GetString(1);
                            obj.Industry = reader.IsDBNull(2) ? "" : reader.GetString(2);
                            obj.Nature = reader.IsDBNull(3) ? "" : reader.GetString(3);
                            obj.Region = reader.IsDBNull(4) ? "" : reader.GetString(4);
                            obj.Contact = reader.IsDBNull(5) ? "" : reader.GetString(5);
                            obj.ContactPos = reader.IsDBNull(6) ? "" : reader.GetString(6);
                            obj.Phone = reader.IsDBNull(7) ? "" : reader.GetString(7);
                            obj.Fax = reader.IsDBNull(8) ? "" : reader.GetString(8);
                            obj.Turnover = (reader.IsDBNull(9) || reader.IsDBNull(10)) ? IntRange.None : new IntRange(reader.GetInt32(9), reader.GetInt32(10));
                            obj.Employee = (reader.IsDBNull(11)||reader.IsDBNull(12))  ? IntRange.None : new IntRange(reader.GetInt32(11), reader.GetInt32(12));
                            obj.Year = reader.IsDBNull(13) ? 1900 : reader.GetInt32(13);
                            obj.Website = reader.IsDBNull(14) ? "" : reader.GetString(14);
                            obj.BusiType = (BusinessType)Convert.ToInt16(reader.GetString(15));
                            obj.IsChecked=reader.GetString(16)=="1"?true:false;
                            list.Add(obj);
                        }
                    }
                }
                reader.Close();
            }
            catch(Exception e)
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

        #endregion

        #region properties

        /// <summary>
        /// ��ȡ��������ҵ����
        /// </summary>
        public string ComName
        {
            get
            {
                return comName;
            }
            set
            {
                comName = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ҵ����
        /// </summary>
        public string Nature
        {
            get
            {
                return nature;
            }
            set
            {
                nature = value;
            }
        }

        /// <summary>
        /// ��ȡ������������ҵ���
        /// </summary>
        public string Industry
        {
            get
            {
                return industry;
            }
            set
            {
                industry = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ҵ�������
        /// </summary>
        public int Year
        {
            get
            {
                return year;
            }
            set
            {
                year = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ҵӪҵ�Χ
        /// </summary>
        public IntRange Turnover
        {
            get
            {
                return turnover;
            }
            set
            {
                turnover = value;
            }
        }

        /// <summary>
        /// ��ȡӪҵ���Ӧ�ļ�������ֵ
        /// </summary>
        public int TurnoverIndexValue
        {
            get
            {
                for(int i=0;i<TurnoverCollection.Count;i++)
                {
                    if (((IntRange)TurnoverCollection[i]).Lower == this.turnover.Lower && ((IntRange)TurnoverCollection[i]).Upper == this.turnover.Upper)
                    {
                        return i;
                    }
                }
                return 0;
            }
        }

        /// <summary>
        /// ��ȡ��������ҵԱ������Χ
        /// </summary>
        public IntRange Employee
        {
            get
            {
                return employee;
            }
            set
            {
                employee = value;
            }
        }

        /// <summary>
        /// ��ȡԱ������Ӧ�ļ�������ֵ
        /// </summary>
        public int EmployeeIndexValue
        {
            get
            {
                for (int i = 0; i < EmployeeCollection.Count; i++)
                {
                    if (((IntRange)EmployeeCollection[i]).Lower == this.employee.Lower && ((IntRange)EmployeeCollection[i]).Upper == this.employee.Upper)
                    {
                        return i;
                    }
                }
                return 0;
            }
        }

        /// <summary>
        /// ��ȡ��������ϵ��
        /// </summary>
        public string Contact
        {
            get
            {
                return contact;
            }
            set
            {
                contact = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ϵ��ְλ
        /// </summary>
        public string ContactPos
        {
            get
            {
                return contactPos;
            }
            set
            {
                contactPos = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ϵ�绰
        /// </summary>
        public string Phone
        {
            get
            {
                return phone;
            }
            set
            {
                phone = value;
            }
        }

        /// <summary>
        /// ��ȡ�����ô������
        /// </summary>
        public string Fax
        {
            get
            {
                return fax;
            }
            set
            {
                fax = value;
            }
        }

        /// <summary>
        /// ��ȡ������������������
        /// </summary>
        public string Region
        {
            get
            {
                return region;
            }
            set
            {
                region = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ַ
        /// </summary>
        public string Website
        {
            get
            {
                return website;
            }
            set
            {
                website = value;
            }
        }

        /// <summary>
        /// ��ȡ����������ģʽ��ͨ��������Industry����ƶ�
        /// </summary>
        public BusinessType BusiType
        {
            get
            {
                return busiType;
            }
            set
            {
                busiType = value;
            }
        }

        /// <summary>
        /// ��ȡ��������ҵ�Ƿ񾭹����
        /// </summary>
        public bool IsChecked
        {
            get
            {
                return isChecked;
            }
            set
            {
                isChecked = value;
            }
        }

        /// <summary>
        /// �����ҵ�����Ƿ���д����
        /// </summary>
        public bool InfoFilled
        {
            get
            {
                if (isChecked)
                {
                    return true;
                }

                if (!String.IsNullOrEmpty(comName) && !String.IsNullOrEmpty(nature) && !String.IsNullOrEmpty(industry)
                     && !String.IsNullOrEmpty(contact) && !String.IsNullOrEmpty(phone) && turnover.Lower>0
                     && employee.Lower > 0)
                {
                    return true;
                }

                return false;
            }
        }

        /// <summary>
        /// ��ҵԱ����ѡ���
        /// </summary>
        public static ArrayList EmployeeCollection
        {
            get
            {
                ArrayList list = new ArrayList();
                list.Add(new IntRange(0, 50));
                list.Add(new IntRange(50, 100));
                list.Add(new IntRange(100, 200));
                list.Add(new IntRange(200, 300));
                list.Add(new IntRange(300, 400));
                list.Add(new IntRange(400, 500));
                list.Add(new IntRange(500, 600));
                list.Add(new IntRange(600, 800));
                list.Add(new IntRange(800, 1000));
                list.Add(new IntRange(1000, 2000));
                list.Add(new IntRange(2000, 3000));
                list.Add(new IntRange(3000, 5000));
                list.Add(new IntRange(5000, 10000));
                list.Add(new IntRange(10000, 50000));
                list.Add(new IntRange(50000, 100000));
                return list;
            }
        }

        /// <summary>
        /// ��ҵԱ����ѡ���
        /// </summary>
        public static ArrayList TurnoverCollection
        {
            get
            {
                ArrayList list = new ArrayList();
                list.Add(new IntRange(0, 500));
                list.Add(new IntRange(500, 1000));
                list.Add(new IntRange(1000, 3000));
                list.Add(new IntRange(3000, 10000));
                list.Add(new IntRange(10000, 30000));
                list.Add(new IntRange(30000, 100000));
                list.Add(new IntRange(100000, 500000));
                list.Add(new IntRange(500000, 1000000));
                list.Add(new IntRange(1000000, 2000000));
                list.Add(new IntRange(2000000, 5000000));
                list.Add(new IntRange(5000000, 10000000));
                list.Add(new IntRange(10000000, 20000000));
                return list;
            }
        }

        #endregion

        #region fields
        private string comName;
        private string nature;
        private string industry;
        private int year;
        private IntRange turnover;
        private IntRange employee;
        private string contact;
        private string contactPos;
        private string phone;
        private string fax;
        private string region;
        private string website;
        private BusinessType busiType;
        private bool isChecked;
        #endregion

    }
}
