<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    Module module = new Module();
    
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            module = Module.Get(Convert.ToInt32(Request["id"]));
            industry.SelectedValue = module.Industry;
        }
        
        
        if(Request.HttpMethod=="POST")
		{
            Module m = new Module();
            m.Id = Convert.ToInt32(Request.Form["moduleid"]);
            m.Industry = Request.Form["industry"];
            m.Title = Request.Form["title"];
            m.OrderNum = Convert.ToInt32(Request.Form["ordernum"]);
            m.Save();
            Response.Redirect("modules.aspx");
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
<form id="ModuleListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="modules.aspx">已有模块管理</a></li>
				<li class="active">新建模块</li>
			</ul>
		</div>
		
		<div class="body">
			<table width="100%" border="0" class="details">
				<tr>
					<th scope="row">所属行业：</th>
					<td><BrandQQ:IndustrySelect runat="server" ID="industry" Name="industry" /></td>
				</tr>
				<tr>
					<th scope="row">标题：</th>
					<td><input type="text" name="title" value="<%Response.Write(module.Title); %>"/></td>
				</tr>
				<tr>
					<th scope="row">顺序：</th>
					<td><input name="ordernum" type="text" class="num" value="<%Response.Write(module.OrderNum); %>" /></td>
				</tr>
			</table>
			<div class="footer">
			<input name="cmdSave" type="submit" class="cmdConfirm" id="cmdSave" value="保存">
			<input name="moduleid" type="hidden" id="moduleid" value="<%Response.Write(module.Id); %>" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
