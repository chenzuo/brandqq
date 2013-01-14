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

using BrandQQ.Logo.FontGlyph;


public partial class test_2 : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        Glyph glyph = new Glyph("Arial Black", "00", "BrandQQ",144);
        Response.ContentType = "text/xml";
        Response.Write(glyph.GetXML());
		//Response.Write(glyph.ToString());
        Response.Flush();
    }

}
