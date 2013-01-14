using System;
using System.Collections;
using System.Text;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.Util;
using BrandQQ.Membership;

namespace BrandQQ.WebControls.Utility
{
    [ToolboxData(@"<{0}:EmployeeSelect runat='server' />")]
    public class EmployeeSelect : Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            if (style.ToLower() == "radio")
            {
                writer.WriteLine("<ul>");
                for (int i = 0; i < Company.EmployeeCollection.Count; i++)
                {
                    IntRange range = ((IntRange)Company.EmployeeCollection[i]);
                    if (i == 0)
                    {
                        writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + i.ToString() + "\" value=\"" + i.ToString() + "\"/>");
                        writer.WriteLine("<label for=\"" + name + "_" + i.ToString() + "\">" + range.Upper.ToString() + "������</label></li>");
                    }
                    else if (i == Company.EmployeeCollection.Count - 1)
                    {
                        writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + i.ToString() + "\" value=\"" + i.ToString() + "\"/>");
                        writer.WriteLine("<label for=\"" + name + "_" + i.ToString() + "\">" + Util.Utility.NumberUnit(range.Lower.ToString(), 5) + "������</label></li>");
                    }
                    else
                    {
                        string l, u;
                        if (range.Lower.ToString().Length < 5)
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString(), 4);
                        }
                        else
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString(), 5);
                        }

                        if (range.Upper.ToString().Length < 5)
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString(), 4);
                        }
                        else
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString(), 5);
                        }
                        writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + i.ToString() + "\" value=\"" + i.ToString() + "\">");
                        writer.WriteLine("<label for=\"" + name + "_" + i.ToString() + "\">" + l + " - " + u + "��</option>");
                    }
                }
                writer.WriteLine("</ul>");
            }
            else
            {
                writer.WriteLine("<select name=\"" + name + "\" id=\"" + name + "\">");
                if (firstEmpty)
                {
                    writer.WriteLine("<option value=\"-1\">��ѡ��</option>");
                }

                for (int i = 0; i < Company.EmployeeCollection.Count; i++)
                {
                    IntRange range = ((IntRange)Company.EmployeeCollection[i]);
                    if (i == 0)
                    {
                        writer.WriteLine("<option value=\"" + i.ToString() + "\">" + range.Upper.ToString() + "������</option>");
                    }
                    else if (i == Company.EmployeeCollection.Count - 1)
                    {
                        writer.WriteLine("<option value=\"" + i.ToString() + "\">" + Util.Utility.NumberUnit(range.Lower.ToString(), 5) + "������</option>");
                    }
                    else
                    {
                        string l, u;
                        if (range.Lower.ToString().Length < 5)
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString(), 4);
                        }
                        else
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString(), 5);
                        }

                        if (range.Upper.ToString().Length < 5)
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString(), 4);
                        }
                        else
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString(), 5);
                        }
                        writer.WriteLine("<option value=\"" + i.ToString() + "\">" + l + " - " + u + "��</option>");
                    }
                }
                writer.WriteLine("</select>");
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

        public string Style
        {
            set
            {
                style = value;
            }
        }

        public bool FirstEmpty
        {
            set
            {
                firstEmpty = value;
            }
        }

        private string style="";
        private string name;
        private string selectedValue = "";
        private bool firstEmpty;

    }
}
