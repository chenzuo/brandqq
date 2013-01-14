<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    StringBuilder html2 = new StringBuilder();
   	PaperFile paperFile;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (String.IsNullOrEmpty(Request["sn"]))
        {
            Response.Write("错误的输入参数");
            Response.End();
        }

        try
        {
            SerialNumber serial = new SerialNumber(Request["sn"]);
            paperFile = PaperFile.Load(serial);

        }
        catch
        {
            throw;
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
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="newPapers.aspx">待发布的新问卷</a></li>
				<li><a href="editingPapers.aspx">编辑中的问卷</a></li>
				<li><a href="publishedPapers.aspx">已发布的问卷</a></li>
				<li><a href="abrogatedPapers.aspx">废除的问卷</a></li>
				<li><a href="createPaper.aspx">新建空白问卷</a></li>
				<li class="active">预览问卷</li>
			</ul>
		</div>
		
		<div class="body">
			<h1 class="alignCenter"><%Response.Write(paperFile.Title + " [总分：" + paperFile.Score + "]"); %></h1>
			<div class="pad5"><%Response.Write(paperFile.Description); %></div>
            <%foreach(ModuleFile mf in paperFile.ModuleFiles){%>
			<table width="100%" border="0" class="grid1">
				<tr>
					<th scope="col" class="alignLeft"><%Response.Write("[" + mf.Id.ToString() + "] " + mf.Title); %></th>
				</tr>
				<%foreach(QuestionFile qf in mf.Questions){%>
				<tr>
					<td><strong><%Response.Write("[" + qf.Id.ToString() + "] " + qf.Title); %> 
					<%if(qf.IsMulti && qf.ItemRange.Upper!=IntRange.None.Upper){ %>
					[最多选<%Response.Write(qf.ItemRange.Upper.ToString()); %>项]
					<%} %>
					</strong></td>
				</tr>
				<tr>
					<td>
					<UL>
					<%foreach(AnswerFile af in qf.Answers){%>
						<li>
						<%if(qf.IsMulti){%>
						<input type="checkbox"/>
						<%}else{%>
						<input type="radio" name="a_<%Response.Write(qf.Id.ToString()); %>" />
						<%}%>
						<%Response.Write("[" + af.Id.ToString() + "] " + af.Title + (af.Only ? " [唯一项]" : ""));
        if (af.Ignore != IgnoreType.None)
        {
            Response.Write(" 忽略" + af.Ignore.ToString() + "：");
            foreach (object obj in af.IgnoreCollection)
            {
                Response.Write(af.Ignore == IgnoreType.Module ? ((ModuleFile)obj).Id + "," : ((QuestionFile)obj).Id + ",");
            }
        }
           %>
						</li>
					<%}%>
					</UL>
					</td>
				</tr>
				<%}%>
				<tr>
					<td><strong>模块结论：</strong></td>
				</tr>
				<%foreach (ConclusionFile cf in mf.Conclusions){%>
			    <tr><td><%Response.Write(cf.Content); %></td></tr>
			    <%} %>
			</table><br />
			<%}%>
			
			
		</div>
	</div>
</body>
</html>
