using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using System.Windows;
using System.Windows.Media;

public partial class test_test2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        FormattedText ft = new FormattedText("迈迪", System.Globalization.CultureInfo.CurrentCulture, System.Windows.FlowDirection.LeftToRight, new Typeface(new FontFamily("方正平和简体"), FontStyles.Normal, FontWeights.Normal, FontStretches.Normal), 36, Brushes.Black);
        Geometry g= ft.BuildGeometry(new Point(0, 0));
        foreach(PathFigure path in g.GetOutlinedPathGeometry().Figures)
        {
            foreach (PathSegment ps in path.Segments)
            {
                Response.Write(ps.
                LocalValueEnumerator le = ps.GetLocalValueEnumerator();
                while (le.MoveNext())
                {
                    Response.Write(le.Current.Property.Name + "<br/>");
                }
                Response.Write("<br/>");
            }
        }
    }
}
