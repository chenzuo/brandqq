<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    Company com=new Company();
    void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            foreach (string s in CompanyNature.Natures.Keys)
            {
                ComNature.Items.Add(new ListItem(CompanyNature.Natures[s].ToString(), s));
            }
        }
        
        if (Request["id"] != null)
        {
            int cid = Convert.ToInt32(Request["id"]);

            if (cid <= 0)
            {
                Response.Write("不存在企业资料 <a href=\"javascript:history.go(-1);\">返回</a>");
                Response.End();
            }

            com = Company.Get(cid);
            ComId.Value = Request["id"];
            ComName.Text = com.ComName;
            ComNature.SelectedValue = com.Nature;
            ComIndustry.SelectedValue = com.Industry;
            ComBusiType.SelectedValue = ((int)com.BusiType).ToString();
            ComRegion.SelectedValue = com.Region;
            ComYear.Text = com.Year.ToString();
            ComTurnoverLower.Text = com.Turnover.Lower.ToString();
            ComTurnoverUpper.Text = com.Turnover.Upper.ToString();
            ComEmployeeLower.Text = com.Employee.Lower.ToString();
            ComEmployeeUpper.Text = com.Employee.Upper.ToString();
            ComContact.Text = com.Contact;
            ComContactPos.Text = com.ContactPos;
            ComPhone.Text = com.Phone;
            ComFax.Text = com.Fax;
            ComWebsite.Text = com.Website;
        }

        if (Request.HttpMethod == "POST")
        {
            com.Id = Convert.ToInt32(Request.Form["ComId"]);
            com.ComName = Request.Form["ComName"];
            com.Nature = Request.Form["ComNature"].Trim();
            com.Industry = Request.Form["ComIndustry"].Trim();
            com.BusiType = (BusinessType)Convert.ToInt16(Request.Form["ComBusiType"]);
            com.Region = Request.Form["ComRegion"].Trim();
            com.Year = Convert.ToInt32(Request.Form["ComYear"]);
            com.Turnover = new IntRange(Convert.ToInt32(Request.Form["ComTurnoverLower"]), Convert.ToInt32(Request.Form["ComTurnoverUpper"]));
            com.Employee = new IntRange(Convert.ToInt32(Request.Form["ComEmployeeLower"]), Convert.ToInt32(Request.Form["ComEmployeeUpper"]));
            com.Contact = Request.Form["ComContact"];
            com.ContactPos = Request.Form["ComContactPos"];
            com.Phone = Request.Form["ComPhone"];
            com.Fax = Request.Form["ComFax"];
            com.Website = Request.Form["ComWebsite"];
            com.Save();
            Response.Redirect("company.aspx?id=" + com.Id.ToString());
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>User</title>
<link href="../skin/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript" src="../../jscript/AjaxRequest.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/AjaxResponse.js"></script>
<script language="javascript" type="text/javascript" src="../../jscript/tabContainor.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form runat="server" method="post" id="ComForm" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="default.aspx">基本帐户管理</a></li>
				<li><a href="companies.aspx">企业用户管理</a></li>
				<li class="active">企业资料</li>
			</ul>
		</div>
		
		<div class="body">
				<table width="100%" border="0" class="details">
				<tr>
					<th scope="row">企业名称：</th>
					<td><asp:TextBox ID="ComName" Columns="50" runat="server"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">企业性质：</th>
					<td>
                        <asp:ListBox ID="ComNature" Rows="1" runat="server"></asp:ListBox></td>
				</tr>
				<tr>
					<th scope="row">所属行业：</th>
					<td><BrandQQ:IndustrySelect runat="server" ID="ComIndustry" Name="ComIndustry" /></td>
				</tr>
				<tr>
					<th scope="row">生意模式：</th>
					<td>
					<asp:ListBox ID="ComBusiType" Rows="1" runat="server">
					    <asp:ListItem Text="未设置" Value="0" />
					    <asp:ListItem Text="B2B" Value="1" />
					    <asp:ListItem Text="B2C" Value="2" />
					</asp:ListBox></td>
				</tr>
				<tr>
					<th scope="row">所在地区：</th>
					<td><BrandQQ:RegionSelect ID="ComRegion" Name="ComRegion" FirstEmpty="false" runat="server" /></td>
				</tr>
				<tr>
					<th scope="row">创建年份：</th>
					<td>
                        <asp:TextBox ID="ComYear" runat="server" CssClass="num"></asp:TextBox>年</td>
				</tr>
				<tr>
					<th scope="row">年营业额：</th>
					<td><asp:TextBox ID="ComTurnoverLower" runat="server" CssClass="num"></asp:TextBox> - 
					<asp:TextBox ID="ComTurnoverUpper" runat="server" CssClass="num"></asp:TextBox> 万
					</td>
				</tr>
				<tr>
					<th scope="row">员 工 数：</th>
					<td><asp:TextBox ID="ComEmployeeLower" runat="server" CssClass="num"></asp:TextBox> - 
					<asp:TextBox ID="ComEmployeeUpper" runat="server" CssClass="num"></asp:TextBox> 人</td>
				</tr>
				<tr>
					<th scope="row">联 系 人：</th>
					<td><asp:TextBox ID="ComContact" runat="server" MaxLength="20"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">联系人职位：</th>
					<td><asp:TextBox ID="ComContactPos" runat="server" MaxLength="30"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">联系电话：</th>
					<td><asp:TextBox ID="ComPhone" runat="server"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">传真号码：</th>
					<td><asp:TextBox ID="ComFax" runat="server"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">网址：</th>
					<td><asp:TextBox ID="ComWebsite" Columns="50" runat="server"></asp:TextBox></td>
				</tr>
				</table>
			<div class="footer">
				<input name="cmdSaveCompany" type="submit" class="cmdConfirm" value="保存" />
				<input name="cmdCheckCompany" type="button" class="cmdGeneral" value="认证"<%Response.Write(com.IsChecked?" disabled='disabled'":" onclick=\"location='companyCheck.aspx?id="+com.Id.ToString()+"';\""); %> />
				<input name="cmdCompanyDetails" type="button" class="cmdGeneral" id="cmdCompanyDetails" value="查看明细" onclick="location='companyDetails.aspx?id=<%Response.Write(com.Id);%>';" />
				<asp:HiddenField ID="ComId" runat="server" />
			</div>

		</div>
	</div>
</form>
</body>
</html>
