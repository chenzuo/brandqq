<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="System.Xml" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    void Page_Load(object sender, EventArgs e)
    {
        XmlDocument doc = new XmlDocument();
        doc.Load(GeneralConfig.Instance.BMIDownloadConfigFile);
        foreach (XmlNode node in doc.DocumentElement.SelectNodes("Item"))
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td>"+node.Attributes["id"].Value+"</td>");
            html.AppendLine("<td>" + node.SelectSingleNode("title").FirstChild.Value + "</td>");
            html.AppendLine("<td>" + (node.Attributes["id"].Value.ToLower().EndsWith("b")?"摘要版":"完整版") + "</td>");
            html.AppendLine("<td>" + node.Attributes["login"].Value + "</td>");
            html.AppendLine("<td>" + node.Attributes["check"].Value + "</td>");
            html.AppendLine("<td>" + node.Attributes["downloads"].Value + "</td>");
            html.AppendLine("</tr>");
        }
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>BMCE</title>
<link href="../skin/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript" src="../../jscript/AjaxRequest.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/AjaxResponse.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/tabContainor.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form id="PaperListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li class="active">BMI下载</li>
			</ul>
		</div>
		
		<div class="body">            
            <table width="100%" border="0" class="grid1">
	            <tr>
		            <th scope="col">下载编号</th>
		            <th scope="col">文件名</th>
		            <th scope="col">版本</th>
		            <th scope="col">登录下载</th>
		            <th scope="col">认证下载</th>
		            <th scope="col">下载人次</th>
	            </tr>
	            <%Response.Write(html.ToString()); %>
            </table>
		</div>
	</div>
</form>
</body>
</html>
