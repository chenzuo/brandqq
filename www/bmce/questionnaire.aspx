<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    ResultFile resultFile;
    PaperFile paperFile;
    int FirstMid = 0;
    int FirstQid = 0;
    int success = 0;

    private string __paper_sn = "P100000000030";
    private string __result_id = "";
    
    void Page_Load(object sender,EventArgs e)
    {
        SerialNumber serial;
        string[] initInfo ={ };
        try
        {
            serial = new SerialNumber(__paper_sn);
            paperFile = PaperFile.Load(serial);

            PaperFileTitle.InnerHtml = paperFile.Title;
            PaperFileDescription.InnerHtml = Utility.UBB2Html(paperFile.Description);
            
            if (Request.Form["email"] != null && Request.Form["comname"] != null && Request.Form["refUrl"] != null)
            {
                initInfo = new string[] { Request.Form["email"].Trim(), Request.Form["comname"].Trim(), Request.Form["refUrl"].Trim() };
            }
            
            //创建问卷
            resultFile = ResultFile.Create(serial, initInfo);
            __result_id = resultFile.FileId.ToString();

            if (((int)resultFile.Status) > 1)
            {
                if (Member.IsLogined)
                {
                    Response.Redirect("/mybrandqq/bmceResultView.aspx?id=" + resultFile.FileId.ToString());
                }
            }
        }
        catch
        {
            success = 1;//创建问卷失败
        }

        if (resultFile == null || paperFile == null)
        {
            success = 2;//创建问卷失败
        }

        if (success == 0)
        {
            FirstMid = resultFile.LastModule.Id;
            FirstQid = resultFile.LastQuestion.Id;
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="../jscript/String.prototype.js;../jscript/AjaxRequest.js;../jscript/AjaxResponse.js;../jscript/Ubb2Html.js;../jscript/paperTest.js;../jscript/Cookies.js" Css="../skin/style.css" Title="品牌管理能力自测系统 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />

<body onload="ShowAlert();">
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	<div class="globalLayout">
	    
	    <div id="QuestionnaireAlert"></div>
	    
		<div class="box1">
			<div class="inner">
			    
				<h1 id="PaperFileTitle" runat="server"></h1>
				<h2><a href="/help/bmce.aspx" target="_blank">查看帮助</a></h2>
				<div class="body">
				<div id="StaticContent">
				    <p class="alignCenter" id="PaperFileDescription" runat="server"></p>
    				
				    <table border="0" cellpadding="0" cellspacing="0">
				    <tr>
				    <td><img id="LoadingStatusImage" src="../skin/blank.gif" class="valid" alt="Loading" width="16" height="16" /></td>
				    <td>当前进度：</td>
				    <td>
				    <div style="background:#F3F3F3;border:1px solid #999;width:400px;"><img id="ProgressBarImage" alt="进度" width="0" src="../skin/progressBar.gif" height="10" /></div>
				    </td>
				    </tr>
				    </table>
    				
				    <div class="alignCenter pad5">
				    <img id="ProgressDisplay" src="../skin/blank.gif" style="background:url(../images/bg_bmce_progress.gif) 0px 0px no-repeat;" width="750" height="50" alt="当前进度" />
				    </div>
				</div>
				<form id="questionnaireForm" method="post" action="">
				<div id="QuestionContainor"></div>
				<div class="alignCenter pad5">
					<input name="cmdStart" type="button" id="cmdStart" value="开始测试" class="cmdConfirm" onClick="nextQuestion('<%Response.Write(__paper_sn);%>',<%Response.Write(FirstMid);%>,<%Response.Write(FirstQid);%>,this);" />
					<input type="hidden" name="papersn" value="<%Response.Write(__paper_sn); %>" />
					<input type="hidden" name="resultid" value="<%Response.Write(__result_id); %>" />
				</div>
				</form>
				</div>
				<%if(success==0){
                  if (((int)resultFile.Status) > 1)
                  {
                      if(resultFile.UserInfo.Employee.Lower==IntRange.None.Lower)//未填写第一步信息
                      {%>
                      <script language="javascript" type="text/javascript">
                          initComInfoClip1();
                      </script>
                      <%}else{ %>
                      <script language="javascript" type="text/javascript">
                          initComInfoClip2();
                      </script>
                      <%} %>
                  <%}%>
				
				<%}else{%>
				<p style="line-height:50px;padding:30px;" class="alignCenter">
				
				<img src="/images/bmce_step_0.gif" alt="" /><br />
				<strong class="clrF00">很抱歉，创建问卷失败！</strong>
				</p>
				<%}%>
				
			</div>
		</div>
	</div>
	
	<%//初始定位到最后的问题
        if (success == 0 && resultFile.Status==ResultStatus.Cancled)
    { %>
   <script language="javascript" type="text/javascript">
       setProgress(<%Response.Write(resultFile.Percent[1]); %>,<%Response.Write(resultFile.Percent[0]); %>);
       nextQuestion('<%Response.Write(__paper_sn);%>',<%Response.Write(FirstMid);%>,<%Response.Write(FirstQid);%>,document.getElementById("questionnaireForm").cmdStart);
   </script>
	<%} %>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
