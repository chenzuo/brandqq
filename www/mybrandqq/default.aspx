<%@ Page Language="C#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.BQIPD" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;./mybrandqq.js" Css="/skin/style.css" Title="我的BrandQQ" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li class="active"><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li><a href="mylogos.aspx">我的Logo</a></li>
					</ul>
				</div>
<%
    Member m=Member.Get(Member.Instance.Id);
    Company com=Company.Get(Member.Instance.Id);
%>
				<div class="body">
					<h3>欢迎 <%Response.Write(String.IsNullOrEmpty(m.Name)?m.Email:m.Name); %> 登录</h3>
					<p><input name="myName" type="text" style="border:1px solid #F3F3F3;width:200px;" onblur="updateMyName(this);" onclick="this.style.border='1px solid #333';" value="<%Response.Write(String.IsNullOrEmpty(m.Name)?"单击此处修改您的名字":m.Name); %>" maxlength="10" />
					<img src="/skin/blank.gif" alt="验证" class="valid" id="formValid" /><span id="formValidMsg"></span>
					</p>
					
					<%Response.Write(com==null?"<p class='clrF00 lineheight50'>您尚未登记您的企业资料，<a href=mycompany.aspx>点击此处开始</a></p>":""); %>
					
					<h3 class="t1">以下是您的登录信息：</h3>
					
					<p style="line-height:30px;">
					注册日期：<%Response.Write(m.RegDate.ToShortDateString());%><br />
					总登录次数：<%Response.Write(m.LoginTimes);%><br />
					上次登录日期：<%Response.Write(m.LastLogin.ToShortDateString());%><br />
					</p>
					
					<h3 class="t2">我最近关注过的网站(互联网推广诊断)</h3>
					<ul>
					    
					<%
                        ArrayList domains = BQIPDRecords.GetUserFollows();
                        foreach (string domain in domains)
                        {
                            Response.Write("<li><a href=\"/bqipd/chart.aspx?" + domain + "\" target=\"_blank\">" + domain + " [点击查看]</a></li>");
                        }
					%>
					</ul>
				</div>
			</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
