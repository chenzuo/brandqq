<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    private string path = @"F:\BrandQQ\www\test\mails\";
    private StringBuilder emails = new StringBuilder();
    private ArrayList mailList=new ArrayList();
    private string line;
    private StreamReader reader;
    protected void Page_Load(object sender, EventArgs e)
    {
        foreach (string file in Directory.GetFiles(path))
        {
            reader = new StreamReader(file);
            while ((line = reader.ReadLine()) != null)
            {
                GetMails(line.Trim());
            }
            reader.Close();
        }

        Response.Write(emails.ToString());
    }

    private void GetMails(string content)
    {
        Regex reg = new Regex(@"(<{0,1})(([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)?)", RegexOptions.IgnoreCase | RegexOptions.Singleline);
        foreach (Match m in reg.Matches(content))
        {
            string email = m.Groups[2].Value.ToLower();
            if (!mailList.Contains(email) && !email.EndsWith("sinamail.sina.com.cn") && !email.EndsWith("foresight.net.cn") && email.Length<45)
            {
                mailList.Add(email);
                emails.AppendLine(email);
            }
        }
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
