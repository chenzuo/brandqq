<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    Answer answer = new Answer();
    
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            answer = Answer.Get(Convert.ToInt32(Request["id"]));
        }
        
        if (Request["pid"] != null)
        {
            answer.ParentId = Convert.ToInt32(Request["pid"]);
        }
        
        if(Request.HttpMethod=="POST")
		{
            Answer a = new Answer();
            a.Id = Convert.ToInt32(Request.Form["answerid"]);
            a.ParentId = Convert.ToInt32(Request.Form["qid"]);
            a.Title = Request.Form["title"];
            a.OrderNum = Convert.ToInt32(Request.Form["ordernum"]);
            a.Score = Convert.ToInt32(Request.Form["score"]);
            a.Only = Request.Form["isonly"] == "1" ? true : false;
            a.Save();
            
            if (!String.IsNullOrEmpty(Request.Form["backurl"]))
            {
                Response.Redirect(Request.Form["backurl"]);
            }
            else
            {
                Response.Redirect("answers.aspx");
            }
		}
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
<form id="QuestionListForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="answers.aspx">已有答案管理</a></li>
				<li class="active">新建答案</li>
			</ul>
		</div>
		
		<div class="body" id="AjaxDataContainor">
			<table width="100%" border="0" class="details">
				<tr>
					<th scope="row">所属问题编号：</th>
					<td><input name="qid" type="text" class="num" value="<%Response.Write(answer.ParentId); %>" /></td>
				</tr>
				<tr>
					<th scope="row">标题：</th>
					<td><input type="text" name="title" size="50" value="<%Response.Write(answer.Title); %>" /></td>
				</tr>
				<tr>
					<th scope="row">序号：</th>
					<td><input name="ordernum" type="text" class="num" value="<%Response.Write(answer.OrderNum); %>" /></td>
				</tr>
				<tr>
					<th scope="row">分值：</th>
					<td><input name="score" type="text" class="num" value="<%Response.Write(answer.Score); %>" /></td>
				</tr>
				<tr>
					<th scope="row">&nbsp;</th>
					<td><input type="checkbox" name="isonly" value="1" id="isonly"<%Response.Write(answer.Only?" checked=\"checked\"":""); %> />
					<label for="isonly">是否唯一项(即选择该项，则其他项不可选)</label></td>
				</tr>
			</table>
			<div class="footer">
				<input name="Submit" type="submit" class="cmdConfirm" value="保存" />
				<input name="answerid" type="hidden" id="answerid" value="<%Response.Write(answer.Id); %>" />
				<input name="backurl" type="hidden" id="backurl" value="<%Response.Write(Request["backurl"]!=null?Request["backurl"]:""); %>" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
