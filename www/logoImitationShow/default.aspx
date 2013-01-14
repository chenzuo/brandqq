<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod == "POST")
        {
            if (Request.Form["logotext"] == null || Request.Form["logostyle"] == null)
            {
                return;
            }

            string color = "";
            string styleId = Request.Form["logostyle"].Trim();
            string text = Request.Form["logotext"].Trim();
            
            if (!String.IsNullOrEmpty(Request.Form["logocolor"]))
            {
                color = Request.Form["logocolor"].Trim();
                if(color.Split('.').Length!=3)
                {
                    color = "";
                }
            }
                     
            
            LogoShowItem logo = new LogoShowItem();
            logo.StyleId = styleId;
            logo.Text = text;
            try
            {
                LogoImitation.CreateLogo(styleId, text, color, logo.Guid);
                logo.Save();

                LogoImage.Visible = true;
                LogoImage.ImageUrl = "LogoImage.aspx?g=" + logo.Guid + "&s=" + styleId;
            }
            catch
            {
                LogoImage.Visible = true;
                LogoImage.ImageUrl = "LogoImage.aspx";
            }
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader1" Jscript="../jscript/logoImitation.js;../jscript/String.prototype.js" Css="../skin/style.css" Title="Logo模仿秀 自助在线Logo设计 - BrandQQ - 中小企业品牌建设，品牌管理,品牌能力，在线品牌管理"
    Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,品牌管理能力指数" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务"
    runat="server" />
<body>
    <BrandQQ:PageHeader ID="PageHeader1" runat="server" />
    <div class="globalLayout">
        <form id="logoISForm" method="post" onsubmit="return makeLogoImitation(this);">
            <div class="box1">
                <div class="inner">
                    <h1>Logo模仿秀</h1>
                    <h2><a href="logos.aspx">查看最新的模仿秀作品</a>
                    </h2>
                    <div class="body">
                        <h3 class="t1">输入Logo文字</h3>
                        
                        <div class="alignCenter">
                        <asp:Image ID="LogoImage" runat="server" Visible="false" />
                        </div>
                        
                        <div><input type="text" name="logotext" maxlength="20" style="width:300px;height:22px;border:1px solid #333;font-size:16px;" />（限英文字母和数字，最多20个字符，如：BrandQQ）</div>
                        <br />
                        <h3 class="t2">选择Logo模仿的风格</h3>
                        <div style="height:260px;overflow-y:scroll;">
                            <table width="100%" border="0" cellspacing="0">
                                <%
                                    foreach (LogoStyle style in LogoImitation.Styles)
                                    {
                                        Response.Write("<tr onmouseover=\"this.style.backgroundColor='#F5F5F5';\" onmouseout=\"this.style.backgroundColor='';\" onclick=\"document.getElementById('logostyle_" + style.Id + "').checked=true;\">");
                                        Response.Write("<td style=\"width:230px;\">");
                                        Response.Write("<input type=\"radio\" id=\"logostyle_" + style.Id + "\" name=\"logostyle\" value=\"" + style.Id + "\" style=\"margin-bottom:20px;\" />");
                                        Response.Write("<label for=\"logostyle_" + style.Id + "\">");
                                        Response.Write("<img alt=\""+style.Name+"\" src=\"/logoImitationShow/logoimgs/" + style.Image + "\" style=\"width:200px;height:50px;\" />");
                                        Response.Write("</label>");
                                        Response.Write("</td>");
                                        Response.Write("<td><a href=\"logos.aspx?s=" + style.Id + "\">查看模仿作品</a></td>");
                                        Response.Write("<td>" + style.Description + "</td>");
                                        Response.Write("</tr>");
                                    }
                                 %>
                            </table>
                        </div>
                        
                        <br />
                        <h3 class="t3">定义颜色(RGB)　　　　　<a href="http://baike.baidu.com/view/17423.htm" target="_blank">什么是RGB颜色?</a></h3>
                        <input type="radio" checked="checked" name="colorselect" id="CS_0" value="0" onclick="if(this.checked){document.getElementById('COLORS').style.display='none';this.form.logocolor.value=''}" /><label for="CS_0">默认</label>
                        <input type="radio" name="colorselect" id="CS_1" value="1" onclick="if(this.checked){document.getElementById('COLORS').style.display=''}" /><label for="CS_1">自己定义颜色</label>
                        
                        <div id="COLORS" style="display:none;">
                            R:<input type="text" name="logoclr_r" size="5" style="border:1px solid #333;" 
                                onchange="if(!this.value.IsInteger()){this.value=''}else if(this.value>255 || this.value<0){this.value=0}" />
                            G:<input type="text" name="logoclr_g" size="5" style="border:1px solid #333;"
                                onchange="if(!this.value.IsInteger()){this.value=''}else if(this.value>255 || this.value<0){this.value=0}" />
                            B:<input type="text" name="logoclr_b" size="5" style="border:1px solid #333;"
                                onchange="if(!this.value.IsInteger()){this.value=''}else if(this.value>255 || this.value<0){this.value=0}" />
                            <div style="width:550px;">
                            <script language="javascript" type="text/javascript">colorTable();</script>
                            </div>
                        </div>
                        
                        <input type="hidden" name="logocolor" value="" />
                        
                        <br />
                        <div class="alignCenter pad5"><input type="submit" class="cmdConfirm" value="确定" /></div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
