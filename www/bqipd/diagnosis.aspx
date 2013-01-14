<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<BrandQQ:HtmlHeader ID="HtmlHeader1" Jscript="../jscript/AjaxRequest.js;../jscript/String.prototype.js;../jscript/Cookies.js;../jscript/bqipd.js?20080310"
    Css="../skin/style.css" Title="互联网推广在线诊断工具,网站在线诊断 "
    Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,互联网推广在线诊断" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务"
    runat="server" />
<body>

    <div id="FollowLayer" style="position:absolute; left:731px; top:117px; z-index:100; background: url(/images/bg_bqipd_follow.gif) no-repeat; width: 250px; height: 200px; visibility: hidden;">
		<form id="FollowForm" method="post">
		<input type="button" name="cmd" value="加入跟踪" class="cmdConfirm" style="margin:120px 80px 50px 90px;" />
		<input type="hidden" name="domain" value="" />
		<input type="hidden" name="AjaxAction" value="bqipdfollow" />
		</form>
	</div>
	
    <BrandQQ:PageHeader ID="PageHeader1" runat="server" />
    <div class="globalLayout">
        <div class="box1">
            <div class="inner">
                <h1>
                    互联网推广在线诊断(Beta)</h1>
                <h2><a href="seoinfo.aspx">需要知道网站SEO信息？</a>
                </h2>
                <div class="body">
                    <form id="BQIPDForm" action="" method="post" onsubmit="return getBQIPDResult(this);">
                        <h3 class="t2">请输入网站地址：</h3>
                        <div class="pad5">
                            <input type="text" name="u" size="30" maxlength="50" value="<%Response.Write(Request["d"]!=null?Request["d"].ToString():""); %>" onfocus="document.getElementById('TIP1').className='activeTip';" onblur="document.getElementById('TIP1').className='grayTip';" />
                        </div>
                        <div class="grayTip" id="TIP1">
                            要进行诊断的网站地址，如：www.brandqq.com<br/>
							a.brandqq.com和b.brandqq.com视为两个不同网站<br/>
							特别地，www.brandqq.com和brandqq.com视为同一网站

                        </div>
                        <br />
                        <h3 class="t2">请输入推广关键字：</h3>
                        <div class="pad5">
                            <input type="text" name="q" size="50" maxlength="50" value="<%Response.Write(Request["k"]!=null?Request["k"].ToString():""); %>"  onfocus="document.getElementById('TIP2').className='activeTip';" onblur="document.getElementById('TIP2').className='grayTip';"/>
                        </div>
                        <div class="grayTip" id="TIP2">
                            您在推广时使用的关键字组合，多个关键字请用空格分隔，如：品牌管理 中小企业<br/>
							每次诊断的结果会因关键字差异而不同
                        </div>
                        <br />
                        <div class="alignCenter pad5">
                            <input type="submit" name="cmdBtn" value="开始诊断" class="cmdConfirm" />
                            <input type="hidden" name="AjaxAction" value="bqipd" />
                        </div>
                        
                        <div id="ResultPannel"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
