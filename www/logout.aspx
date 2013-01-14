<%@ Page Language="C#" %>
<%@ Import Namespace="BrandQQ.Membership" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Member.Logout();
        string referrer = "/";
        if (Request.UrlReferrer != null)
        {
            referrer = Request.UrlReferrer.ToString().ToLower();
            if (referrer.IndexOf("/mybrandqq") != -1)
            {
                referrer = "/";
            }
        }
        Response.Redirect(referrer);
        Response.Flush();
    }
</script>

