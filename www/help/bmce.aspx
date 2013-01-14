<%@ Page %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Css="/skin/style.css" Title="品牌管理能力自测系统使用帮助" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />
<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
	    <div class="box1">
				<div class="inner">
					<h1>品牌管理能力自测系统使用帮助</h1>
					<h2><a href="/bmce">立即开始</a></h2>
					<div class="body">
					<%Response.WriteFile("bmce_help.html");%>
					</div>
				</div>
		</div>
	</div>
	
	<script type="text/javascript" language="javascript">
	tabClick(<%Response.Write(Request["t"]!=null?Request["t"]:"1");%>);
	</script>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>