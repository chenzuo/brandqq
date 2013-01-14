<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string file = GeneralConfig.Instance.LogoDataSourcePath + "logoImShImages\\Error.png";
        if (Request["g"] != null || Request["s"] != null)
        {
            file = GeneralConfig.Instance.LogoDataSourcePath + "logoImShImages\\" + Request["s"].Trim() + "\\" + Request["g"].Trim() + ".png";
            if (!File.Exists(file))
            {
                file = GeneralConfig.Instance.LogoDataSourcePath + "logoImShImages\\Error.png";
            }
        }
        
        Response.Clear();
        Response.ContentType = "image/png";
        Response.WriteFile(file);
        Response.Flush();
        Response.Close();
    }
</script>

