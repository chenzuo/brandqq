<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    private Pager pager = new Pager(1, 20, PagerHttpMethod.POST, "ResultListForm");
    StringBuilder html = new StringBuilder();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["__pageindex"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request.Form["__pageindex"]);
        }

        foreach(SimpleResultStatusRecord sta in Result.StatusList(ResultStatus.UnStored,pager))
        {
            html.AppendLine("<tr>");
            html.AppendLine("<td>");
            html.AppendLine("<input type=\"checkbox\" name=\"staId\" value=\"" + sta.Id.ToString() + "\" />");
            html.AppendLine("<a href=\"specimensView.aspx?id=" + sta.Id.ToString() + "\">" + sta.PaperTitle + "</a>");
            html.AppendLine("</td>");

            if (sta.ComId <= 0)
            {
                html.AppendLine("<td>&lt;非注册用户&gt;</td>");
            }
            else
            {
                html.AppendLine("<td><a href=\"../user/company.aspx?id=" + sta.ComId.ToString() + "\">(" + sta.ComId.ToString() + ")" + (String.IsNullOrEmpty(sta.ComName) ? "&lt;未设置&gt;" : sta.ComName) + "</a></td>");
            }
            html.AppendLine("<td>"+sta.Begin.ToString()+"</td>");
            html.AppendLine("<td>" + sta.Update.ToString() + "</td>");
            html.AppendLine("<td><img src=\"../skin/blank.gif\" class=\"resultSta_"+sta.Status.ToString()+"\"/></td>");
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
<script language="javascript" type="text/javascript" src="functions.js?2007-11-22"></script>
</head>

<body class="frmBody">
<form id="ResultListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
			    <li class="active" title="非注册用户的测试结果">临时样本</li>
				<li><a href="specimens.aspx">有效样本</a></li>
			</ul>
		</div>
		
		<div class="body">
		    <div class="header">
		    选择：<a href="javascript:selectResults(1);">已完成</a> , 
		    <a href="javascript:selectResults(0);">未完成</a> , 
		    <a href="javascript:selectResults(-1);">反选</a>
		    </div>
			<table width="100%" border="0" class="grid1" id="ResultListTable">
				<tr>
					<th scope="col">问卷(点击查看结果)</th>
					<th scope="col">企业</th>
					<th scope="col">测试日期</th>
					<th scope="col">最后更新</th>
					<th scope="col">当前状态</th>
				</tr>
				<%Response.Write(html.ToString());%>
			</table>
			<div class="footer">
	            <%Response.Write("记录数：" + pager.RecordCount + " 页数：" + pager.PageCount + " | " + pager.PagerHtml); %>
            </div>
            <div class="footer">
	            <input type="button" name="cmdImportResult" value="导入样本" disabled="disabled" class="cmdConfirm" />
	            <input type="button" name="cmdDeleteResult" value="删除样本" disabled="disabled" class="cmdConfirm" />
	            <input type="hidden" name="currentSelected" value="" />
            </div>
		</div>
	</div>
</form>
</body>
</html>
