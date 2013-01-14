using System;
using System.Collections;
using System.Text;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.Util;
using BrandQQ.Membership;

namespace BrandQQ.WebControls.Utility
{
    [ToolboxData(@"<{0}:TurnoverSelect runat='server' />")]
    public class TurnoverSelect : Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            if (style.ToLower() == "radio")
            {
                writer.WriteLine("<ul>");
                for (int i = 0; i < Company.TurnoverCollection.Count; i++)
                {
                    IntRange range = ((IntRange)Company.TurnoverCollection[i]);
                    if (i == 0)
                    {
                        writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + i.ToString() + "\" value=\"" + i.ToString() + "\">");
                        writer.WriteLine("<label for=\"" + name + "_" + i.ToString() + "\">" + Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 7) + "����</label></li>");
                    }
                    else if (i == Company.TurnoverCollection.Count - 1)
                    {
                        writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + i.ToString() + "\" value=\"" + i.ToString() + "\">");
                        writer.WriteLine("<label for=\"" + name + "_" + i.ToString() + "\">" + Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 9) + "����</label></li>");
                    }
                    else
                    {
                        string l, u;
                        if (range.Lower.ToString().Length < 4)
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 7);
                        }
                        else if (range.Lower.ToString().Length == 4)
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 8);
                        }
                        else
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 9);
                        }

                        if (range.Upper.ToString().Length < 4)
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 7);
                        }
                        else if (range.Upper.ToString().Length == 4)
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 8);
                        }
                        else
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 9);
                        }
                        writer.WriteLine("<li><input type=\"radio\" name=\"" + name + "\" id=\"" + name + "_" + i.ToString() + "\" value=\"" + i.ToString() + "\">");
                        writer.WriteLine("<label for=\"" + name + "_" + i.ToString() + "\">" + l + " - " + u + "</label></li>");
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

                for (int i = 0; i < Company.TurnoverCollection.Count; i++)
                {
                    IntRange range = ((IntRange)Company.TurnoverCollection[i]);
                    if (i == 0)
                    {
                        writer.WriteLine("<option value=\"" + i.ToString() + "\">" + Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 7) + "����</option>");
                    }
                    else if (i == Company.TurnoverCollection.Count - 1)
                    {
                        writer.WriteLine("<option value=\"" + i.ToString() + "\">" + Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 9) + "����</option>");
                    }
                    else
                    {
                        string l, u;
                        if (range.Lower.ToString().Length < 4)
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 7);
                        }
                        else if (range.Lower.ToString().Length == 4)
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 8);
                        }
                        else
                        {
                            l = Util.Utility.NumberUnit(range.Lower.ToString() + "0000", 9);
                        }

                        if (range.Upper.ToString().Length < 4)
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 7);
                        }
                        else if (range.Upper.ToString().Length == 4)
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 8);
                        }
                        else
                        {
                            u = Util.Utility.NumberUnit(range.Upper.ToString() + "0000", 9);
                        }
                        writer.WriteLine("<option value=\"" + i.ToString() + "\">" + l + " - " + u + "</option>");
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

        public bool FirstEmpty
        {
            set
            {
                firstEmpty = value;
            }
        }

        public string Style
        {
            set
            {
                style = value;
            }
        }

        private string style = "";
        private string name;
        private string selectedValue = "";
        private bool firstEmpty;

    }
}
