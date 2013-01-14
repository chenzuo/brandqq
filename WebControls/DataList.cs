using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.ComponentModel;
using System.IO;

using BrandQQ.BMCE;
using BrandQQ.Membership;
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    [ToolboxData(@"<{0}:DataList runat='server' />")]
    
    public class DataList:Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            base.Render(writer);


            switch (type.ToLower())
            {
                case "company":
                    CompanyList(writer);
                    break;
                case "company2":
                    CompanyList2(writer);
                    break;
                case "resultstatus":
                    ResultStatusList(writer);
                    break;
                case "userresultstatus":
                    ResultStatusListByUser(writer);
                    break;
                case "resultstatusstored":
                    ResultStatusListByStatus(writer,ResultStatus.Stored);
                    break;
                case "resultstatusunstored":
                    ResultStatusListByStatus(writer, ResultStatus.UnStored);
                    break;
                case "resultstatuscancled":
                    ResultStatusListByStatus(writer, ResultStatus.Cancled);
                    break;
                case "resultstatusfinished":
                    ResultStatusListByStatus(writer, ResultStatus.Finished);
                    break;
            }
        }

        /// <summary>
        /// 企业用户简明列表
        /// </summary>
        /// <param name="writer"></param>
        private void CompanyList(HtmlTextWriter writer)
        {
            if (isCheckedCompany > -1)
            {
                foreach (Company com in Company.List(isCheckedCompany > 0 ? true : false, new Pager(page, count)))
                {
                    writer.WriteLine("<li>" + MakeComLink(com.ComName, (String.IsNullOrEmpty(com.Website) ? "" : com.Website)) + "</li>");
                }
            }
            else
            {
                foreach (Company com in Company.List(new Pager(page, count)))
                {
                    writer.WriteLine("<li>" + MakeComLink(com.ComName, (String.IsNullOrEmpty(com.Website) ? "" : com.Website)) + "</li>");
                }
            }
        }

        /// <summary>
        /// 企业用户详细列表
        /// </summary>
        /// <param name="writer"></param>
        private void CompanyList2(HtmlTextWriter writer)
        {
            foreach (Company com in Company.List(isCheckedCompany > 0 ? true : false, industryCode, new Pager(page, count)))
            {
                //{0}:Id,{1}:name(link),{2}:website
                writer.WriteLine(String.Format(repeatTemplate, new string[] { com.Id.ToString(), MakeComLink(com.ComName, (String.IsNullOrEmpty(com.Website) ? "" : com.Website)), String.IsNullOrEmpty(com.Website) ? "" : com.Website }));
            }
        }

        private string MakeComLink(string name, string url)
        {
            /*if (!String.IsNullOrEmpty(url))
            {
                if (!url.ToLower().Trim().StartsWith("http://"))
                {
                    url = "http://" + url;
                }
                return "<a href=\"" + url + "\" target=\"_blank\">" + name + "</a>";
            }
            else
            {
                return name;
            }*/
			return name;
        }

        /// <summary>
        /// 测试结果记录
        /// <para>{0:Id},{1:guid},{2:paperSN},{3:paperTitle},{4:ComId},{5:comName},{6:begin},{7:update},{8:status}</para>
        /// </summary>
        /// <param name="writer"></param>
        private void ResultStatusList(HtmlTextWriter writer)
        {
            foreach (SimpleResultStatusRecord status in Result.StatusList(new Pager(page, count)))
            {
                writer.WriteLine(String.Format(repeatTemplate, new string[] { status.Id.ToString(), status.Guid, status.PaperSN.ToString(), status.PaperTitle, status.ComId.ToString(), status.ComName, status.Begin.ToShortDateString(), status.Update.ToString(), status.Status.ToString() }));
            }
        }

        /// <summary>
        /// 测试结果记录，指定用户的
        /// <para>{0:Id},{1:guid},{2:paperSN},{3:paperTitle},{4:ComId},{5:comName},{6:begin},{7:update},{8:status}</para>
        /// </summary>
        /// <param name="writer"></param>
        private void ResultStatusListByUser(HtmlTextWriter writer)
        {
            foreach (SimpleResultStatusRecord status in Result.StatusList(Member.Instance.Guid, new Pager(page, count)))
            {
                writer.WriteLine(String.Format(repeatTemplate, new string[] { status.Id.ToString(), status.Guid, status.PaperSN.ToString(), status.PaperTitle,status.ComId.ToString(), status.ComName, Util.Utility.DateTimeName(status.Begin), status.Update.ToString(), status.Status.ToString() }));
            }
        }

        /// <summary>
        /// 带状态参数的效样本记录
        /// <para>{0:Id},{1:guid},{2:paperSN},{3:paperTitle},{4:ComId},{5:comName},{6:begin},{7:update},{8:status}</para>
        /// </summary>
        /// <param name="writer"></param>
        private void ResultStatusListByStatus(HtmlTextWriter writer,ResultStatus sta)
        {
            foreach (SimpleResultStatusRecord status in Result.StatusList(sta, new Pager(page, count)))
            {
                writer.WriteLine(String.Format(repeatTemplate, new string[] { status.Id.ToString(), status.Guid, status.PaperSN.ToString(), status.PaperTitle, status.ComId.ToString(), status.ComName, status.Begin.ToShortDateString(), status.Update.ToString(), status.Status.ToString() }));
            }
        }

        public string Type
        {
            set
            {
                type = value;
            }
        }

        public int ComId
        {
            set
            {
                comId = value;
            }
        }

        /// <summary>
        /// 指示是否通过确认的企业，-1:不设置;1:已确认;0:未确认
        /// </summary>
        public int IsCheckedCompany
        {
            set
            {
                isCheckedCompany = value;
            }
        }

        public string IndustryCode
        {
            set
            {
                industryCode = value;
            }
        }

        public new int Page
        {
            set
            {
                page = value;
            }
        }

        public int Count
        {
            set
            {
                count = value;
            }
        }

        public string RepeatTemplate
        {
            set
            {
                repeatTemplate = value;
            }
        }
        private int comId=0;
        private string type;
        private int isCheckedCompany = -1;
        private string industryCode = "";

        private int count=0;
        private int page = 1;
        private string repeatTemplate="";
    }
}
