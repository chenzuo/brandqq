using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib.DBUtils
{
    public class Logo
    {
        /*[Id],Guid, UserId, Title, Remark, Enable, [Datetime]*/

        public int Id=0;
        public string Guid="";
        public int UserId=0;
        public string Title="";
        public string Remark = "";
        public bool Enable=false;
        public DateTime Datetime=DateTime.Now;
        public string Texts = "";
    }

    public class BusinessCard
    {
        /*[Id],Guid, UserId, [Name], HasBack, Enable, [Datetime], Texts*/
        public int Id = 0;
        public string Guid = "";
        public int UserId = 0;
        public string Name = "";
        public bool HasBack = false;
        public bool Enable = false;
        public DateTime Datetime = DateTime.Now;
        public string Texts = "";
    }
}
