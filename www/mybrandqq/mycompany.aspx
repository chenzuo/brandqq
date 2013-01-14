<%@ Page Language="C#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<script runat="server">
Company com;
void Page_Load(object sender,EventArgs e)
{
    com=Company.Get(Member.Instance.Id);
    if(com==null)
    {
        com=new Company();
    }

    if (Request.HttpMethod == "POST")
    {
        com = new Company();
        com.Id = Member.Instance.Id;
        com.ComName = Server.HtmlEncode(Request.Form["comName"].Trim());
        com.Nature = Request.Form["comNature"];
        com.Industry = Request.Form["comIndustry"];
        com.Region = Request.Form["comRegion"];
        com.Year = Convert.ToInt16(Request.Form["comYear"]);
        com.Turnover = ((IntRange)Company.TurnoverCollection[Convert.ToInt16(Request.Form["comTurnover"])]);
        com.Employee = ((IntRange)Company.EmployeeCollection[Convert.ToInt16(Request.Form["comEmployee"])]);
        com.Contact = Server.HtmlEncode(Request.Form["comContact"]);
        com.ContactPos = Server.HtmlEncode(Request.Form["comContactPos"]);
        com.Phone = Server.HtmlEncode(Request.Form["comPhone"]);
        com.Fax = Server.HtmlEncode(Request.Form["comFax"]);
        com.Website = Server.HtmlEncode(Request.Form["comWebsite"]);
        com.Save();
        Response.Redirect("mycompany.aspx");
    }
}
</script>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;./mybrandqq.js" Css="/skin/style.css" Title="我的BrandQQ" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body onload="initCompanyForm('<%Response.Write(com.IsChecked?"1":"0");%>','<%Response.Write(com.Industry);%>','<%Response.Write(com.Region);%>','<%Response.Write(com.Nature);%>',<%Response.Write(com.TurnoverIndexValue);%>,<%Response.Write(com.EmployeeIndexValue);%>);">
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
		
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li class="active"><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li><a href="mylogos.aspx">我的Logo</a></li>
					</ul>
				</div>
				
				<div class="body">
				    <form method="post" id="CompanyForm" action="">
					<h3>企业名称：<%Response.Write(String.IsNullOrEmpty(com.ComName) ? "&lt;未设置&gt;" : com.ComName); %></h3>
					<div class="clientMsgNotice">请填写以下信息，当您的企业信息得到有效验证后，会有部分资料不能修改(<img src="/skin/blank.gif" class="validLock" />)。</div>
					<p class="lineheight50">您的企业信息验证状态：
					<%Response.Write(com.IsChecked ? "<img src=\"/skin/blank.gif\" alt=\"企业资料有效性验证：已验证\" class=\"validOk\"/>已验证！" : "<img src=\"/skin/blank.gif\" alt=\"企业资料有效性验证：未验证\" class=\"validFailed\"/>未验证！"); %></p>
					
					<div class="clientMsgWarning">BrandQQ尊重您的隐私，不会在未经您允许的情况下公开您的信息！<a href="/html/privacy.html" target="_blank">了解BrandQQ隐私声明</a></div>
					
					
					<table width="100%" border="0" class="details lineheight35">
					<tr>
						<th scope="row">企业名称：</th>
						<td>
						<input name="comName" type="text" id="comName" size="50" maxlength="80" value="<%Response.Write(com.ComName);%>" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid1" /><span id="formValidMsg1"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">企业性质：</th>
						<td>
						<select name="comNature" id="comNature">
							<option value="A">私营企业</option>
							<option value="B">集体企业</option>
							<option value="C">国有企业</option>
							<option value="D">合资企业</option>
							<option value="E">外资独资企业</option>
							<option value="F">政府机关</option>
							<option value="G">事业单位</option>
							<option value="H">其他</option>
						</select>
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid2" /><span id="formValidMsg2"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">所属行业：</th>
						<td>
						<BrandQQ:IndustrySelect ID="IndustrySelect" Name="comIndustry" runat="server" FirstEmpty="true" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid3" /><span id="formValidMsg3"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">所在地区：</th>
						<td>
						<BrandQQ:RegionSelect ID="RegionSelect" FirstEmpty="true" Name="comRegion" runat="server" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid4" /><span id="formValidMsg4"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">创建年份：</th>
						<td>
						<input name="comYear" type="text" id="comYear" maxlength="4" class="num" value="<%Response.Write(com.Year);%>" />
						年 <img src="/skin/blank.gif" alt="验证" class="valid" id="formValid5" /><span id="formValidMsg5"></span></td>
					</tr>
					<tr>
						<th scope="row">年营业额：</th>
						<td>
						<BrandQQ:TurnoverSelect ID="TurnoverSelect" Name="comTurnover" runat="server" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid6" /><span id="formValidMsg6"></span>
					    </td>
					</tr>
					<tr>
						<th scope="row">员 工 数：</th>
						<td>
						<BrandQQ:EmployeeSelect ID="EmployeeSelect" Name="comEmployee" runat="server" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid7" /><span id="formValidMsg7"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">联 系 人：</th>
						<td>
						<input name="comContact" type="text" id="comContact" maxlength="20" value="<%Response.Write(com.Contact);%>" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid8" /><span id="formValidMsg8"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">联系人部门：</th>
						<td>
						<input name="comContactPos" type="text" id="comContactPos" maxlength="20" value="<%Response.Write(com.ContactPos);%>" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid9" /><span id="formValidMsg9"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">联系电话：</th>
						<td>
						<input name="comPhone" type="text" id="comPhone" maxlength="15" value="<%Response.Write(com.Phone);%>" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid10" /><span id="formValidMsg10"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">传真号码：</th>
						<td>
						<input name="comFax" type="text" id="comFax" maxlength="15" value="<%Response.Write(com.Fax);%>" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid11" /><span id="formValidMsg11"></span>
						</td>
					</tr>
					<tr>
						<th scope="row">网址：</th>
						<td>
						http://<input name="comWebsite" type="text" id="comWebsite" maxlength="100" size="40" value="<%Response.Write(com.Website);%>" />
						<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid12" /><span id="formValidMsg12"></span>
						</td>
					</tr>
					</table>
					
					<div class="footer">
						<input name="cmdSaveCompany" type="submit" id="cmdSaveCompany" value="保存修改" class="cmdConfirm" />
						<input name="comId" type="hidden" value="<%Response.Write(Member.Instance.Id);%>" />
						<input name="AjaxAction" type="hidden" value="saveCompany" />
					</div>
					</form>
				</div>
			</div>
		
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
