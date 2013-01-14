using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.Util;

namespace BrandQQ.WebControls.Utility
{
    [ToolboxData(@"<{0}:RegionSelect runat='server' />")]
    public class RegionSelect:Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            writer.WriteLine("<select name=\""+name+"\">");
            if (firstEmpty)
            {
                writer.WriteLine("<option value=\"\">请选择...</option>");
            }
            foreach (string s in Region.Regions.Keys)
            {
                writer.WriteLine("<option value=\"" + s + "\"" + (s == selectedValue ? " selected=\"selected\"" : "") + ">" + Region.Regions[s] + "</option>");
            }
            writer.WriteLine("</select>");
        }

        [BrowsableAttribute(true)]
        [DescriptionAttribute("控件名称")]
        [DefaultValueAttribute("控件名称")]
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

        [BrowsableAttribute(true)]
        [DescriptionAttribute("默认值")]
        [DefaultValueAttribute("默认值")]
        public string SelectedValue
        {
            set
            {
                selectedValue = value;
            }
        }

        public bool FirstEmpty
        {
            set
            {
                firstEmpty = value;
            }
        }


        private string name;
        private string selectedValue="";
        private bool firstEmpty=false;

    }
}
