<%@ Page Language="C#" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Member.IsLogined)
        {
            Response.Redirect("/login.aspx");
            Response.End();
        }

        if (Request["papersn"] == null)
        {
            Response.Redirect("/mybrandqq");
            Response.End();
        }

        if (Member.TempInfo == null)
        {
            Response.Redirect("/mybrandqq");
            Response.End();
        }
        
        try
        {
            ResultFile.MoveTo(new SerialNumber(Request["papersn"]), Member.TempInfo.Guid, Member.Instance.Id);
        }
        catch
        {
            throw;
        }

        Response.Redirect("/mybrandqq");
        Response.End();
    }
</script>

