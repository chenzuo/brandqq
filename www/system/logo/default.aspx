<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    private string[] menuStyles =new string[3];
    private LogoType logoType;
    private void Page_Load(object sender, EventArgs e)
    {
        try
        {
            logoType = (LogoType)Convert.ToInt16(Request["type"]);
        }
        catch
        {
            Response.Write("Error parameters");
            Response.End();
        }

        switch (logoType)
        {
            case LogoType.Record:
                menuStyles[0] = " class=\"active\"";
                break;
            case LogoType.Sample:
                menuStyles[1] = " class=\"active\"";
                break;
            case LogoType.Upload:
                menuStyles[2] = " class=\"active\"";
                break;
        }

        LogoList.Pager.PageSize = 10;
        LogoList.Pager.Method = PagerHttpMethod.POST;
        LogoList.Pager.FormId = "logoListForm";
        LogoList.Type = logoType;

        if (Request.Form["__pageindex"] != null)
        {
            LogoList.Pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        StringBuilder html = new StringBuilder();
        html.AppendLine("<tr>");
        html.AppendLine("<td>{0}</td>");
        html.AppendLine("<td><a href=\"/logo/logoview?{4}{3}{7}{2}.{1}\" target=\"_blank\"><img style='border:none' src='/logo/img?{4}{3}{7}.{1}' width='120' height='90' alt='{9}'/></a></td>");
        html.AppendLine("<td><a href=\"../user/company.aspx?id={2}\">{9}</a><br/>{5}<br/>{8}</td>");
        html.AppendLine("<td>{6}</td>");
        html.AppendLine("<td><a href=\"javascript:;\" onclick=\"setLogoEnabled(this,'{1}');\">{10}</a></td>");
        html.AppendLine("<td>删除</td>");
        html.AppendLine("</tr>");
        
        LogoList.RepeatTemplate = html.ToString();
        
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
<form id="logoListForm" method="post" action="./?type=<%Response.Write(((int)logoType).ToString()); %>">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li<%Response.Write(menuStyles[0]); %>><a href="./?type=1">用户Logo作品</a></li>
				<li<%Response.Write(menuStyles[1]); %>><a href="./?type=2">行业Logo管理</a></li>
				<li<%Response.Write(menuStyles[2]); %>><a href="./?type=3">上传Logo管理</a></li>
			</ul>
		</div>
		
		<div class="body">
		    <div class="header">
	            <%if (logoType == LogoType.Sample){ %>
	                <a href="uploadLogo.aspx">上传行业Logo</a>
	            <%} %>
            </div>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col">记录号</th>
					<th scope="col">图片</th>
					<th scope="col">企业/标题/时间</th>
					<th scope="col">分值</th>
					<th scope="col">状态</th>
					<th scope="col">操作</th>
				</tr>
				<BrandQQ:LogoList ID="LogoList" runat="server"  />
			</table>
			<div class="footer">
	            <%Response.Write("记录数：" + LogoList.Pager.RecordCount + " 页数：" + LogoList.Pager.PageIndex +"/"+ LogoList.Pager.PageCount+ " | " + LogoList.Pager.PagerHtml); %>
            </div>
		</div>
	</div>
</form>
</body>
</html>
