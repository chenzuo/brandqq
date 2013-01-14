<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="BrandQQ.Util" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
		int i=0;
        StringBuilder sql = new StringBuilder();
        foreach (string file in Directory.GetFiles(@"F:\BrandQQ\www\App_Data\logoData\symbols\110", "*.swf", SearchOption.AllDirectories))
        {
            string code = new FileInfo(file).Name.Replace(".swf", "");
            sql.AppendLine("INSERT INTO LogoSymbols (Guid, Title, CategoryCode, SymbolCode, Industries, Tags,RefTimes) VALUES ('" + Utility.NewGuid + "','','" + code.Substring(0, 6) + "','" + code + "','','',0)");
			i++;
        }
        Response.Write(sql.ToString()+"\n"+i.ToString());
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
