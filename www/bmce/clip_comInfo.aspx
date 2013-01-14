<%@ Page Language="C#" %>

<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>

<script runat="server">

    private string _email;
    private string _comname;
    private string _step = "";
    private ResultFile result;
    private string _bmi = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Member.TempInfo == null)
        {
            Response.Write("您的信息意外丢失，操作不能继续！");
            Response.End();
        }
        if (String.IsNullOrEmpty(Member.TempInfo.PaperSN) || String.IsNullOrEmpty(Member.TempInfo.Guid) || !ResultFile.ExistsFile(Member.TempInfo.ResultId))
        {
            Response.Write("您的信息意外丢失，操作不能继续！");
            Response.End();
        }

        if (Request["step"] != null)
        {
            _step = Request["step"].Trim();
        }


        if (_step == "2")
        {
            result = ResultFile.Load(Member.TempInfo.ResultId);

            if (result == null)
            {
                Response.Write("您的信息意外丢失，操作不能继续！");
                Response.End();
            }

            _bmi = result.RelativeScore.ToString();
            _email = result.UserInfo.Email;
            _comname = result.UserInfo.Name;
        }
    }
</script>
<p>&nbsp;</p>

<%if(_step=="1"){ %>

<div class="pad5">
    接下来请完成您的企业资料，如果您已经创建过BrandQQ帐户，则可以跳过以下步骤，<a href="/login.aspx">直接登录到MyBrandQQ</a>
</div>

<div class="pad5">
    请问贵公司是属于以下哪种行业?
    <select id="IndustrySelect1" onchange="if(this.selectedIndex>0){changeIndustrySelect(this.options[this.selectedIndex].value)};">
        <option value="">请选择...</option>
        <option value="100000">消费品</option>
        <option value="110000">工业品</option>
        <option value="120000">原材料</option>
        <option value="130000">服务业</option>
    </select>
    
    <select name="comIndustry" id="IndustrySelect2"><option value=""> ← 请先选择大类 </option></select>
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid1" /><span id="formTips1"></span>
    <div style="display:none;">
        <BrandQQ:IndustrySelect ID="IndustrySelect" Name="IndustrySelect" runat="server" FirstEmpty="false" />
    </div>
</div>

<div class="pad5">
    请问贵公司的性质是属于以下哪一种情况?
    <select name="comNature" id="comNature">
        <option value="">请选择...</option>
        <option value="A">私营企业</option>
        <option value="B">集体企业</option>
        <option value="C">国有企业</option>
        <option value="D">合资企业</option>
        <option value="E">外资独资企业</option>
        <option value="F">政府机关</option>
        <option value="G">事业单位</option>
        <option value="H">其他</option>
    </select>
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid2" /><span id="formTips2"></span>
</div>
<div class="pad5">
    请问贵公司总共有多少员工?
    <BrandQQ:EmployeeSelect ID="EmployeeSelect" FirstEmpty="true" Name="comEmployee" runat="server" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid3" /><span id="formTips3"></span>
</div>
<div class="pad5">
    请问贵公司年营业额属于以下哪一种情况?
    <BrandQQ:TurnoverSelect ID="TurnoverSelect" FirstEmpty="true" Name="comTurnover" runat="server" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid4" /><span id="formTips4"></span>
</div>

<%}else if(_step=="2"){ %>


<div class="pad5 alignCenter">
<div style="margin:0px auto 30px auto;width:350px;height:100px;border:3px solid #CCC;padding:10px;">
<p style="color:#C20;font-weight:bold;font-size:16px;">经评估，贵公司的品牌管理能力指数</p>
<p style="color:#C20;font-size:30px;font-weight:bold;font-family:Arial Black;">BMI=<%Response.Write(_bmi); %>分</p>
<p>(请完成您的联系信息，获取详细报告)</p>
</div>
</div>

<div class="pad5">
    <strong>最后一步，请填写您的联系信息，并设置您的帐户！</strong>
</div>

<div class="pad5">
    公司名称：
    <input size="50" maxlength="50" type="text" class="txt" name="comname" value="<%Response.Write(_comname); %>" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid1" /><span id="formTips1"></span>
</div>
<div class="pad5">
    联 系 人：
    <input maxlength="10" type="text" class="txt" name="contact" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid2" /><span id="formTips2"></span>
</div>
<div class="pad5">
    联系电话：
    <input maxlength="15" type="text" class="txt" name="phone" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid3" /><span id="formTips3"></span>
</div>
<div class="pad5 clientMsgNotice">
    请设定您的登录邮件和密码，BrandQQ为您创建独立的帐户，欢迎您随时回来：</div>


<div class="pad5">
    邮件地址：
    <input type="text" size="30" maxlength="50" class="txt" name="email" value="<%Response.Write(_email); %>" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid4" /><span id="formTips4"></span>
</div>
<div class="pad5">
    登录密码：
    <input maxlength="20" type="password" class="txt" name="password" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid5" /><span id="formTips5"></span>
</div>
<div class="pad5">
    确认密码：
    <input maxlength="20" type="password" class="txt" name="password2" />
    <img src="../skin/blank.gif" alt="验证" class="valid" id="formValid6" /><span id="formTips6"></span>
</div>
<%} %>