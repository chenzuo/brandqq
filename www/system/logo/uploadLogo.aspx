<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    private void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod == "POST")
        {
            saveLogo();
        }
    }

    private void saveLogo()
    {
        LogoBase logo = LogoBase.Create(LogoType.Sample);
        logo.Guid = Utility.NewGuid;
        logo.UserId = Member.Instance.Id;
        logo.Title = LogoTitle.Text;
        logo.Description = LogoDescription.Text;
        logo.Enabled = LogoEnabled.Checked;
        try
        {
            logo.Score = Convert.ToInt32(LogoScore.Text);
        }
        catch
        {
            logo.Score = 0;
        }

        logo.Industry = Request.Form["LogoIndustry"];

        HttpPostedFile logoFile = LogoFile.PostedFile;

        if (logoFile.ContentType.ToLower() != "image/png"
            && logoFile.ContentType.ToLower() != "image/jpg"
            && logoFile.ContentType.ToLower() != "image/jpeg"
            && logoFile.ContentType.ToLower() != "image/pjpeg"
            && logoFile.ContentType.ToLower() != "image/gif")
        {
            return;
        }
        
        if (logoFile.ContentLength > 1024 * 300)
        {
            return;
        }

        if (logoFile.ContentType.ToLower() == "image/png")
        {
            logo.ImageType = LogoImageType.Png;
        }
        else if (logoFile.ContentType.ToLower() == "image/jpg" 
            || logoFile.ContentType.ToLower() == "image/jpeg"
            || logoFile.ContentType.ToLower() == "image/pjpeg")
        {
            logo.ImageType = LogoImageType.Jpg;
        }
        else if (logoFile.ContentType.ToLower() == "image/gif")
        {
            logo.ImageType = LogoImageType.Gif;
        }
        else
        {
            logo.ImageType = LogoImageType.Jpg;
        }

        string filePath = GeneralConfig.Instance.LogoDataSourcePath + "LogoSamples\\" + logo.Industry + "\\" + logo.Guid;

        LogoUtil.CreateThumbnail(logoFile.InputStream, filePath);

        logo.Save();

        Response.Redirect("./?type=2");
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
<form id="logoListForm" method="post" action="" runat="server">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="./?type=1">用户Logo作品</a></li>
				<li><a href="./?type=2">行业Logo管理</a></li>
				<li><a href="./?type=3">上传Logo管理</a></li>
				<li class="active">上传行业Logo</li>
			</ul>
		</div>
		
		<div class="body">
		    <table width="100%" border="0" class="details">
				<tr>
					<th scope="row">所属行业：</th>
					<td><BrandQQ:IndustrySelect runat="server" ID="LogoIndustry" Name="LogoIndustry" /></td>
				</tr>
				<tr>
					<th scope="row">标题：</th>
					<td>
                        <asp:TextBox ID="LogoTitle" runat="server"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">图片文件：</th>
					<td>
                        <asp:FileUpload ID="LogoFile" runat="server" />(120*90或等比)</td>
				</tr>
				<tr>
					<th scope="row">描述：</th>
					<td>
                        <asp:TextBox ID="LogoDescription" runat="server" Columns="50" MaxLength="200"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">默认分值：</th>
					<td>
                        <asp:TextBox ID="LogoScore" MaxLength="6" runat="server"></asp:TextBox></td>
				</tr>
				<tr>
					<th scope="row">初始状态：</th>
					<td>
                        <asp:CheckBox ID="LogoEnabled" runat="server" Checked="true" Text="可用/不可用" />
                    </td>
				</tr>
			</table>
			<div class="footer"><asp:Button ID="Button1" runat="server" CssClass="cmdConfirm" Text="保存" /></div>
		</div>
		
	</div>
</form>
</body>
</html>
