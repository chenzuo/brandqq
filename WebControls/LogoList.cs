using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.Membership;
using BrandQQ.Util;
using BrandQQ.Logo;

namespace BrandQQ.WebControls
{
    [ToolboxData(@"<{0}:LogoList runat='server' />")]

    public class LogoList : Control
    {
        public LogoList()
        {
            pager = new Pager(1, 20);
            enabled = -1;
            logoType = LogoType.Record;
            userId = 0;
            industry = "";
            repeatTemplate = "";
        }

        protected override void Render(HtmlTextWriter writer)
        {
            base.Render(writer);

            ArrayList list;
            if (enabled == -1)
            {
                list = LogoBase.List(logoType, pager, userId, industry);
            }
            else
            {
                list = LogoBase.List(logoType, pager, userId, industry, enabled==1?true:false);
            }
            /*
             * format
             * {0}:Id
             * {1}:Guid
             * {2}:UserId
             * {3}:Ltype
             * {4}:Industry
             * {5}:Title
             * {6}:Score
             * {7}:ImageType
             * {8}:CreateDatetime
             * {9}:ComName
             * {10}:Enabled
             */
            foreach (LogoBase logo in list)
            {
                writer.WriteLine(String.Format(repeatTemplate, new string[]{
                        logo.Id.ToString(),
                        logo.Guid,
                        logo.UserId.ToString(),
                        ((int)logo.LType).ToString(),
                        logo.Industry,
                        logo.Title,
                        logo.Score.ToString().PadLeft(6,'0'),
                        ((int)logo.ImageType).ToString(),
                        logo.CreateDatetime.ToShortDateString(),
                        logo.ComName,
                        logo.Enabled.ToString()
                    }));
            }
        }

        public LogoType Type
        {
            set
            {
                logoType = value;
            }
        }

        public bool Enabled
        {
            set
            {
                enabled = value?1:0;
            }
        }

        public int UserId
        {
            set
            {
                userId = value;
            }
        }

        public string Industry
        {
            set
            {
                industry = value;
            }
        }

        public string RepeatTemplate
        {
            set
            {
                repeatTemplate = value;
            }
        }

        public Pager Pager
        {
            set
            {
                pager = value;
            }
            get
            {
                return pager;
            }
        }

        public int Count
        {
            set
            {
                pager.PageIndex = 1;
                pager.PageSize = value;
            }
        }

        public int Sort
        {
            set
            {
                pager.SortNum = value;
            }
        }

        private int enabled;//-1:none,1:true,0:false
        private LogoType logoType;
        private int userId;
        private string industry;

        private string repeatTemplate;
        private Pager pager;
    }
}
