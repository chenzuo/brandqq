<%@ Page Language="C#" ValidateRequest="false" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    Conclusion conclusion = new Conclusion();
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            conclusion = Conclusion.Get(Convert.ToInt32(Request["id"]));
        }
		
		if (Request["t"] != null)
        {
            conclusion.Type = (ConclusionType)Convert.ToInt16(Request["t"]);
        }
        
        if (Request["tid"] != null)
        {
            conclusion.TypeId = Convert.ToInt16(Request["tid"]);
        }
        
        if(Request.HttpMethod=="POST")
		{
            Conclusion c = new Conclusion();
            c.Id = Convert.ToInt32(Request.Form["conclusionid"]);
            c.Type = (ConclusionType)Convert.ToInt32(Request.Form["type"]);
            c.TypeId = Convert.ToInt32(Request.Form["typeid"]);
            c.Range = new IntRange(Convert.ToInt32(Request.Form["lower"]), Convert.ToInt32(Request.Form["upper"]));
            c.Content = Request.Form["content"];
            c.Advice = Request.Form["advice"];
            c.Save();
			
			if (!String.IsNullOrEmpty(Request.Form["backurl"]))
            {
                Response.Redirect(Request.Form["backurl"]);
            }
            else
            {
				if(c.Type==ConclusionType.P)
				{
                	Response.Redirect("conclusions1.aspx");
				}
				else
				{
					Response.Redirect("conclusions2.aspx");
				}
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
<script language="javascript" type="text/javascript" src="../../jscript/UbbToolBar.js"></script>
<script language="javascript" type="text/javascript" src="functions.js"></script>
</head>

<body class="frmBody">
<form id="ConclusionForm" method="post" action="">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="conclusions1.aspx">已有问卷结论</a></li>
				<li><a href="conclusions2.aspx">已有模块结论</a></li>
				<li class="active">新建结论</li>
			</ul>
		</div>
		
		<div class="body" id="AjaxDataContainor">
			<table width="100%" border="0" class="details">
				<tr>
					<th scope="row">结论类型：</th>
					<td><input type="radio" name="type" value="1" id="type1"<%Response.Write(conclusion.Type==ConclusionType.P?" checked=\"checked\"":""); %> onClick="document.getElementById('TypeTag').innerHTML='问卷';" />
					<label for="type1">问卷结论</label>
					<input type="radio" name="type" value="2" id="type2"<%Response.Write(conclusion.Type==ConclusionType.M?" checked=\"checked\"":""); %> onClick="document.getElementById('TypeTag').innerHTML='模块';" />
					<label for="type2">模块结论</label>
					</td>
				</tr>
				<tr>
					<th scope="row"><span id="TypeTag"><%Response.Write(conclusion.Type == ConclusionType.M ? " 模块" : "问卷"); %></span>记录号：</th>
					<td><input type="text" name="typeid" value="<%Response.Write(conclusion.TypeId); %>" /></td>
				</tr>
				
				<tr>
					<th scope="row">分值范围：</th>
					<td><input name="lower" type="text" class="num" value="<%Response.Write(conclusion.LowerScore.ToString()); %>" />%(包含) - 
					<input name="upper" type="text" class="num" value="<%Response.Write(conclusion.UpperScore.ToString()); %>" />%
					</td>
				</tr>
				<tr>
					<th scope="row">结论内容：</th>
					<td><table width="90%" border="0">
						<tr>
							<td>
							<script language="javascript" type="text/javascript">
							var ubbToolBar1=new UBBToolBar("CONCLUSION_CONTENT");
							</script></td>
						</tr>
						<tr>
							<td><textarea id="CONCLUSION_CONTENT" name="content" rows="10" style="width:100%;"><%Response.Write(conclusion.Content); %></textarea></td>
						</tr>
					</table></td>
				</tr>
				
				<tr>
					<th scope="row">建议：</th>
					<td><table width="90%" border="0">
						<tr>
							<td>
							<script language="javascript" type="text/javascript">
							var ubbToolBar2=new UBBToolBar("CONCLUSION_ADVICE");
							</script>
							</td>
						</tr>
						<tr>
							<td><textarea id="CONCLUSION_ADVICE" name="advice" rows="10" style="width:100%;"><%Response.Write(conclusion.Advice); %></textarea></td>
						</tr>
					</table></td>
				</tr>
			</table>
			<div class="footer">
				<input name="Submit" type="submit" class="cmdConfirm" value="保存" />
				<input name="conclusionid" type="hidden" id="conclusionid" value="<%Response.Write(conclusion.Id); %>" />
				<input name="backurl" type="hidden" id="backurl" value="<%Response.Write(Request["backurl"]!=null?Request["backurl"]:""); %>" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
