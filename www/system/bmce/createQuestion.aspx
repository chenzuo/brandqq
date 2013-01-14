<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    Question question = new Question();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            question = Question.Get(Convert.ToInt32(Request["id"]));
        }
		if (Request["pid"] != null)
        {
            question.ParentId=Convert.ToInt32(Request["pid"]);
        }
        
        if(Request.HttpMethod=="POST")
		{
            Question q = new Question();
            q.Id = Convert.ToInt32(Request.Form["questionid"]);
            q.ParentId = Convert.ToInt32(Request.Form["mid"]);
            q.Title = Request.Form["title"];
            q.OrderNum = Convert.ToInt32(Request.Form["ordernum"]);
            q.IsMulti = Request.Form["ismulti"] == "1" ? true : false;
            q.Save();

            if (!String.IsNullOrEmpty(Request.Form["backurl"]))
            {
                Response.Redirect(Request.Form["backurl"]);
            }
            else
            {
                Response.Redirect("questions.aspx");
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
				<li><a href="questions.aspx">已有问题管理</a></li>
				<li class="active">新建问题</li>
			</ul>
		</div>
		
		<div class="body" id="AjaxDataContainor">
			<table width="100%" border="0" class="details">
				<tr>
					<th scope="row">所属模块记录号：</th>
					<td><input name="mid" type="text" class="num" value="<%Response.Write(question.ParentId); %>" /></td>
				</tr>
				<tr>
					<th scope="row">标题：</th>
					<td><input type="text" name="title" size="50" value="<%Response.Write(question.Title); %>" /></td>
				</tr>
				<tr>
					<th scope="row">序号：</th>
					<td><input name="ordernum" type="text" class="num" value="<%Response.Write(question.OrderNum); %>" /></td>
				</tr>
				<tr>
					<th scope="row">&nbsp;</th>
					<td><input type="checkbox" name="ismulti" value="1" id="ismulti"<%Response.Write(question.IsMulti?" checked=\"checked\"":""); %> />
					<label for="ismulti">是否多选题</label></td>
				</tr>
			</table>
			<div class="footer">
				<input name="Submit" type="submit" class="cmdConfirm" value="保存" />
				<input name="Submit" type="button" value="添加答案"<%Response.Write(question.Id>0?" class=\"cmdGeneral\" ":" disabled=\"disabled\""); %>  onclick="location='createAnswer.aspx?pid='+this.form.questionid.value;"/>
				<input name="questionid" type="hidden" id="questionid" value="<%Response.Write(question.Id); %>" />
				<input name="backurl" type="hidden" id="backurl" value="<%Response.Write(Request["backurl"]!=null?Request["backurl"]:""); %>" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
