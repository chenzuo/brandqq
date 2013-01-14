<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BQIPD" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    private StringBuilder html = new StringBuilder();
    private Pager pager = new Pager(1, 20);
    
    private string url = "";
    private void Page_Load(object sender, EventArgs e)
    {
        pager.Method = PagerHttpMethod.GET;
        pager.PrefixUrl = "./";

        if (Request["PAGEINDEX"] != null)
        {
            try
            {
                pager.PageIndex = Convert.ToInt16(Request["PAGEINDEX"]);
            }
            catch
            {
            }
        }

        if (Request["d"] != null)
        {
            url = Request["d"].Trim().ToLower();
            pager.PrefixUrl = "./?d=" + url;
        }

        ArrayList list = BQIPDRecords.List(pager, url);
        
        foreach (BQIPDQueryResult result in list)
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td><a href=\"./?d=" + result.Domain.Host + "\">" + result.Domain.Host + "</a></td>");
            html.AppendLine("<td>" + Regex.Replace(result.Keywords,"\\s+","<br/>") + "</td>");
            html.AppendLine("<td>" + result.QueryDate.ToShortDateString() + "</td>");
            html.AppendLine("<td>" + result.PageRank.ToString() + "</td>");
            html.AppendLine("<td>" + result.BaiduRecords.ToString() + "</td>");
            html.AppendLine("<td>" + result.GoogleRecords.ToString() + "</td>");
            html.AppendLine("<td>" + result.YahooRecords.ToString() + "</td>");
            html.AppendLine("<td>" + result.BaiduRank.ToString() + "</td>");
            html.AppendLine("<td>" + result.GoogleRank.ToString() + "</td>");
            html.AppendLine("<td>" + result.YahooRank.ToString() + "</td>");
            html.AppendLine("<td>" + result.AlexaRank.ToString() + "</td>");
            html.AppendLine("<td>" + result.AlexaLinkIn.ToString() + "</td>");
            html.AppendLine("<td><strong>" + BQIPDConclusion.GetGenaralScore(result) + "</strong></td>");
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

</head>

<body class="frmBody">
<form id="logoListForm" method="post">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li class="active">诊断记录</li>
			</ul>
		</div>
		
		<div class="body">
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">域名</th>
					<th scope="col">关键字</th>
					<th scope="col">日期</th>
					<th scope="col">PR</th>
					<th scope="col">Baidu(R)</th>
					<th scope="col">Google(R)</th>
					<th scope="col">Yahoo(R)</th>
					<th scope="col">Baidu(K)</th>
					<th scope="col">Google(K)</th>
					<th scope="col">Yahoo(K)</th>
					<th scope="col">Alexa</th>
					<th scope="col">LinkIn</th>
					<th scope="col">得分</th>
				</tr>
				<%Response.Write(html.ToString()); %>
			</table>
			<div class="footer">
	            <%Response.Write("记录数：" + pager.RecordCount + " 页数：" + pager.PageIndex + "/" + pager.PageCount + " | " + pager.PagerHtml); %>
            </div>
		</div>
	</div>
</form>
</body>
</html>
