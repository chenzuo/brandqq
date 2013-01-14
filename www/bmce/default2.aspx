<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<script runat="server">
    private string _email = "";
    private string _comname = "";
    private string _ref = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Member.TempInfo != null)
        {
            if (Member.TempInfo.ResultId > 0)
            {
                Response.Redirect("questionnaire2.aspx");
                Response.End();
            }
        }

        if (Member.IsLogined)
        {
            _email = Member.Instance.Email;
            Company com = Company.Get(Member.Instance.Id);
            if (com != null)
            {
                _comname = com.ComName;
            }
        }
        else
        {
            if (Request["c"] != null && Request["e"] != null)
            {
                _email = Request["e"].Trim();
                _comname = Request["c"].Trim();
            }
        }

        if (Request.UrlReferrer != null)
        {
            _ref = Request.UrlReferrer.ToString();
        }
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="../jscript/String.prototype.js;../jscript/AjaxRequest.js;../jscript/Ubb2Html.js;../jscript/paperTest.js;../jscript/Cookies.js"
    Css="../skin/style.css" Title="品牌管理能力自测系统 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理"
    Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />
<body>
    <BrandQQ:PageHeader ID="PageHeader" runat="server" />
    <div class="globalLayout">
        <div class="box2">
            <div class="inner">
                <h1>
                    欢迎参与品牌管理能力自测</h1>
                <h2>
                    <a href="/help/bmce.aspx">查看帮助</a></h2>
                <div class="body font12 alignCenter">
                    <p>
                    花5分钟，对您的品牌管理能力做个全面评估！
                    </p>
                    <p>
                    生成书面分析报告（<a href="/help/bmce.aspx?t=8" target="_blank"><strong>样例</strong></a>），并获赠国内首份<strong>《中国企业品牌管理能力白皮书》</strong>（价值3000元）
                    </p>
                </div>
            </div>
        </div>
        <div>&nbsp;</div>
        <div class="alignCenter">
            <div class="box1">
                <div class="inner">
                    <div class="body" style="width:300px;margin:auto;">
                        <form method="post" action="questionnaire2.aspx" onsubmit="return submitStartForm(this);">
                            <div class="pad5">
                                电子邮件地址：<input type="text" size="35" maxlength="50" class="txt" name="email" value="<%Response.Write(_email); %>" /></div>
                            <div class="pad5">
                                贵公司的名称：<input size="35" maxlength="50" type="text" class="txt" name="comname" value="<%Response.Write(_comname); %>" /></div>
                            <div class="pad5 alignCenter">
                                <input type="image" src="../images/btn_bmce_start.jpg" alt="立即开始" />
                            </div>
                            <input type="hidden" name="refUrl" value="<%Response.Write(_ref); %>" />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
