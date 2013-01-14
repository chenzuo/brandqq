<%@ Page %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js" Css="/skin/style.css" Title="我的BrandQQ" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		<form method="post" id="UserForm" action="">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li class="active"><a href="mybmce.aspx">测试记录</a></li>
						<li><a href="mylogos.aspx">我的Logo</a></li>
					</ul>
				</div>
				
				<div class="body">
					<p>以下是您的测试记录，对于其中未完成的测试，您可以在空闲时继续测试。</p>
					
					<table width="100%" border="0" class="grid1">
						<tr>
							<th scope="col">测试问卷</th>
							<th scope="col">测试日期</th>
							<th scope="col">最后更新</th>
							<th scope="col">当前状态</th>
						</tr>
						<%//{0:Id},{1:guid},{2:paperSN},{3:paperTitle},{4:ComId},{5:comName},{6:begin},{7:update},{8:status} %>
						<BrandQQ:DataList ID="ResultStatusList" Count="20" Type="userresultstatus" RepeatTemplate="<tr><td><a href='bmceResultView.aspx?id={0}'>{3}</a></td><td>{6}</td><td>{7}</td><td><img src='../skin/blank.gif' class='resultSta_{8}' /></td></tr>" runat="server" />
						
					</table>
				</div>
			</div>
		</form>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
