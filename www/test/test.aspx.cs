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
using System.Drawing;
using System.Drawing.Drawing2D;
public partial class test_test : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Drawing.Image img = System.Drawing.Image.FromFile(@"F:\BrandQQ\www\test\1.png");
        Graphics g = Graphics.FromImage(img);

        StringFormat sf = new StringFormat();
        sf.Alignment = StringAlignment.Near;
        sf.LineAlignment = StringAlignment.Near;
        GraphicsPath path = new GraphicsPath();
        path.AddString("m", new FontFamily("Arial Black"), 0, 200, new Point(0, 0), sf);

        PointF pp;
        byte pt;

        for (int i = 0; i < path.PathPoints.Length; i++)
        {
            pp = path.PathPoints[i];
            pt = path.PathTypes[i];

            if (pt == 0)
            {
                Response.Write("mc.moveTo(" + pp.X.ToString() + "," + pp.Y.ToString() + ");\n");
            }
            else if (pt == 1 || pt == 129)
            {
                Response.Write("mc.lineTo(" + pp.X.ToString() + "," + pp.Y.ToString() + ");\n");
            }
            else if (pt == 3)
            {
                if (i + 3 < path.PathPoints.Length)
                {
                    Response.Write("mc.curveTo(" + pp.X.ToString() + "," + pp.Y.ToString() + "," + path.PathPoints[i + 3].X.ToString() + "," + path.PathPoints[i + 3].Y.ToString() + ");\n");
                    i+=3;
                }
            }
            /*else if (pt >=131 )
            {
                Response.Write("mc.lineTo(" + pp.X.ToString() + "," + pp.Y.ToString() + ");\n");
            }*/

            //Response.Write(pt.ToString() + " " + pp.ToString() + "<br/>");
        }

        /*GraphicsPathIterator gPaths = new GraphicsPathIterator(path);

        GraphicsPath subpath = new GraphicsPath();
        bool isclose;

        PointF pp;

        while (gPaths.NextSubpath(subpath, out isclose) > 0)
        {
            for (int i = 0; i < subpath.PointCount; i++)
            {
                pp=subpath.po
				if(subpath.PathTypes[i]==0)
				{
                    Response.Write("mc.moveTo(22,73);");
				}

				else if(subpath.PathTypes[i]>128)
				{
                    Response.Write();
				}
				else if(subpath.PathTypes[i-1]==1 && subpath.PathTypes[i]==3)
				{
                    Response.Write();
				}
				else
				{
                    Response.Write();
				}
			   //Response.Write(subpath.PathTypes[i] + "(" + isclose.ToString() + ") " + subpath.PathPoints[i].ToString() + "<br/>");
            }
            //Response.Write("<hr/>");
            
        }

        foreach(PointF p in path.PathPoints)
		{
            g.FillRectangle(Brushes.Red, new RectangleF(p, new SizeF(1, 1)));
		}*/

        //Response.Write(str1+" | "+str2);

        //g.DrawPath(Pens.Black,path);
        
        //img.Save(@"F:\BrandQQ\www\test\2.png");
    }

    string str1 = "";
    string str2 = "";
}
