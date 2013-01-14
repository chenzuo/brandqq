<%@ Page Language="C#" EnableViewState="false" %>

<script runat="server">

    protected void Page_Init(object sender, EventArgs e)
    {
        if (Request.QueryString["aspxerrorpath"] != null)
        {
            Response.Redirect("http://brandqq.brandmanager.com.cn" + Request.QueryString["aspxerrorpath"].Trim());
            Response.End();
        }
        else
        {
            try
            {
                string path = Request.QueryString.ToString().Replace("404%3b", "");
                path = Server.UrlDecode(path);
                //Response.Redirect("http://brandqq.brandmanager.com.cn"+u.);
                //Response.Write(path);
                Uri u = new Uri(path);
                Response.Redirect("http://brandqq.brandmanager.com.cn" + u.PathAndQuery);
                Response.End();
            }
            catch(Exception e1)
            {
                //Response.Write(e1.ToString());
                //Response.Redirect("http://brandqq.brandmanager.com.cn");
            }
        }
    }
</script>

