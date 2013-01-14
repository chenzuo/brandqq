using System;
using System.Collections;
using System.Text;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.Util;
using BrandQQ.Membership;

namespace BrandQQ.WebControls.Utility
{
    [ToolboxData(@"<{0}:IndustrySelect runat='server' />")]
    public class IndustrySelect : Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            if (style.ToLower() == "radio")
            {
                writer.WriteLine("<ul>");
                foreach (Industry indus in IndustryUtil.Industries)
                {
                    writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + indus.Code + "\" value=\"" + indus.Code + "\"" + (indus.Code == selectedValue ? " checked=\"checked\"" : "") + "/>");
                    writer.WriteLine("<label for=\"" + name + "_" + indus.Code + "\">" + indus.Name + "</label></li>");
                    if (indus.Children.Count > 0)
                    {
                        Loop(writer, indus.Children);
                    }
                }
                writer.WriteLine("</ul>");
            }
            else
            {
                writer.WriteLine("<select name=\"" + name + "\" id=\"" + name + "\"" + (onChangeFun != "" ? " onchange=\"" + onChangeFun + "\"" : "") + ">");
                if (firstEmpty)
                {
                    writer.WriteLine("<option value=\"\">......</option>");
                }
                foreach (Industry indus in IndustryUtil.Industries)
                {
                    writer.WriteLine("<option value=\"" + indus.Code + "\"" + (indus.Code == selectedValue ? " selected=\"selected\"" : "") + ">" + indus.Name + "</option>");
                    if (indus.Children.Count > 0)
                    {
                        Loop(writer, indus.Children);
                    }
                }
                writer.WriteLine("</select>");
            }
        }

        private void Loop(HtmlTextWriter writer, ArrayList arry)
        {
            if (style.ToLower() == "radio")
            {
                writer.WriteLine("<ul>");
                //int i = 1;
                foreach (Industry indus in arry)
                {
                    writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + indus.Code + "\" value=\"" + indus.Code + "\"" + (indus.Code == selectedValue ? " checked=\"checked\"" : "") + ">");
                    writer.WriteLine("<label for=\"" + name + "_" + indus.Code + "\">" + indus.Name + "</label></li>");
                    if (indus.Children.Count > 0)
                    {
                        Loop(writer, indus.Children);
                    }
                }
                writer.WriteLine("</ul>");
            }
            else
            {
                foreach (Industry indus in arry)
                {
                    writer.WriteLine("<option value=\"" + indus.Code + "\"" + (indus.Code == selectedValue ? " selected=\"selected\"" : "") + ">" + (indus.Code.EndsWith("00") ? "��|-" : "����|-") + "" + indus.Name + "</option>");
                    if (indus.Children.Count > 0)
                    {
                        Loop(writer, indus.Children);
                    }
                }
            }
        }

        [BrowsableAttribute(true)]
        [DescriptionAttribute("�ؼ�����")]
        [DefaultValueAttribute("�ؼ�����")]
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
        /// ������ʽ����ѡֵ:radio,dropdown(Ĭ��)
        /// </summary>
        public string Style
        {
            set
            {
                style = value;
            }
        }

        [BrowsableAttribute(true)]
        [DescriptionAttribute("Ĭ��ֵ")]
        [DefaultValueAttribute("Ĭ��ֵ")]
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

        public string ClientChange
        {
            set
            {
                onChangeFun = value;
            }
        }

        private string style="";
        private string name;
        private string selectedValue="";
        private bool firstEmpty;
        private string onChangeFun = "";

    }
}
