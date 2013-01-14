<%@ Page Language="C#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Util" %>
<script runat="server">
    string comName = "";
    void Page_Load(object s,EventArgs e)
    {
        if(Request.QueryString!=null)
        {
            string query = Request.QueryString.ToString().Trim();
            int resultId = 0;
            string sn = "";
            string guid1 = "";
            string guid2 = "";
            
            try
            {
                sn = query.Substring(0, 13);
                guid1 = query.Substring(13, 15);
                guid2 = query.Substring(query.Length-17, 17);
                resultId = Convert.ToInt32(query.Replace(sn, "").Replace(guid1, "").Replace(guid2, ""));
            }
            catch
            {
                //
            }

            if (resultId == 0)
            {
                Response.Write("错误的参数");
                Response.End();
            }
            
            
            SimpleResultStatusRecord status = Result.GetResultStatus(resultId);
            if (status == null)
            {
                Response.Write("未找到相关记录");
                Response.End();
            }

            ResultFile result = ResultFile.Load(resultId);
            comName = result.UserInfo.Name;
            BMCEResultFileView.FileId = resultId;
            
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/Ubb2Html.js;mybrandqq.js" Css="/skin/style.css" Title="分享的品牌管理能力测试结果" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />

<body>
<BrandQQ:PageHeader ID="PageHeader" runat="server" />
<h2 class="alignCenter pad5"><%Response.Write(comName); %> 分享的品牌管理能力测试结果</h2>

<div class="globalLayout alignLeft">
    <div class="ResultView">
        <BrandQQ:BMCEResultFileView DisableFeedback="true" ShowDetails="2" ShowScore="false" ID="BMCEResultFileView" runat="server" />
    </div>
    <br />
    <div>
        图例：<img src="../../skin/blank.gif" class="scoreLevel_A" />优秀&nbsp;&nbsp;&nbsp;&nbsp;
        <img src="../../skin/blank.gif" class="scoreLevel_B" />良好&nbsp;&nbsp;&nbsp;&nbsp;
        <img src="../../skin/blank.gif" class="scoreLevel_C" />一般&nbsp;&nbsp;&nbsp;&nbsp;
        <img src="../../skin/blank.gif" class="scoreLevel_D" />差&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
</div>

	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
