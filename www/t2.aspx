<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="BrandQQ.Logo.Swf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        byte[] b1 = new byte[] {1,2,3,4,5,6};
        byte[] b2 = new byte[] { 7, 8 };
        //
        byte[] b3 = new byte[b1.Length+b2.Length];
        b1.CopyTo(b3, 0);
        b2.CopyTo(b3, b1.Length);
        Response.Write(BitConverter.ToString(b3));
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
