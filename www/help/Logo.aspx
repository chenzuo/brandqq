<%@ Page %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Css="/skin/style.css" Jscript="/jscript/Ubb2Html.js" Title="BrandQQ Logo在线设计使用帮助" 
Keywords="免费的，好用的Logo在线设计" Description="企业品牌管理自助平台,Logo在线设计" runat="server" />
<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
	    <div class="box1">
				<div class="inner">
					<h1>BrandQQ Logo在线设计使用帮助</h1>
					<h2></h2>
					<div class="body">
					<%Response.WriteFile("logo_help.html");%>
					</div>
				</div>
		</div>
	</div>
		
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>