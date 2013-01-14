<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            BMCEResultFileView.FileId = Convert.ToInt32(Request["id"]);
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
<script language="javascript" type="text/javascript" src="../../jscript/Ubb2Html.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form id="SpecimensListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
			    <li title="非注册用户的测试结果"><a href="specimensTemp.aspx">临时样本</a></li>
				<li><a href="specimens.aspx">有效样本</a></li>
				<li class="active">样本明细</li>
			</ul>
		</div>
		
		<div class="body ResultView">
		    
		    <BrandQQ:BMCEResultFileView ShowDetails="0" ID="BMCEResultFileView" runat="server" />
			
			<div class="footer">
	            
            </div>
		</div>
	</div>
</form>
</body>
</html>
