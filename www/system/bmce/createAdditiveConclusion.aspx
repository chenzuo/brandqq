<%@ Page Language="C#" ValidateRequest="false" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    PaperFile paper;
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["sn"] == null || Request["conid"] == null)
        {
            Response.Write("参数错误");
            Response.End();
        }

        try
        {
            paper = PaperFile.Load(new SerialNumber(Request["sn"].Trim()));
            
            for (int i = 1; i < paper.ModuleFiles.Count; i++)
            {
                CountLower.Items.Add(new ListItem(". " + i.ToString() + " .", i.ToString()));
                CountUpper.Items.Add(new ListItem(". " + i.ToString() + " .", i.ToString()));
            }

            foreach (ConclusionFile cf in paper.ConclusionFiles)
            {
                ListItem item = new ListItem("" + cf.Range.Lower.ToString() + "% - " + cf.Range.Upper.ToString() + "%", cf.Id.ToString());
                if (cf.Id == Convert.ToInt32(Request["conid"]))
                {
                    item.Selected = true;
                }
                ConclusionId.Items.Add(item);
            }
            
            ConclusionFile con=paper.GetConclusionFileById(Convert.ToInt32(Request["conid"]));

            if (con != null)
            {
                if (con.Additives != null)
                {
                    foreach (AdditiveConclusion addcon in con.Additives)
                    {
                        html.AppendLine("<tr id=\"ADDITIVECONCLUSION_" + addcon.Id.ToString() + "\">");
                        html.AppendLine("<td>" + con.Range.Lower.ToString() + " - " + con.Range.Upper.ToString() + "%</td>");
                        html.AppendLine("<td>包含" + addcon.LevelsCount.Lower.ToString() + " - " + addcon.LevelsCount.Upper.ToString() + "项 " + addcon.LevelsDescription + "</td>");
                        html.AppendLine("<td>" + addcon.Content + "</td>");
                        html.AppendLine("<td><a href=\"javascript:deleteAdditiveConclusion('" + paper.SN.ToString() + "'," + con.Id.ToString() + ",'" + addcon.Id.ToString() + "');\">删除</a></td>");
                        html.AppendLine("</tr>");
                    }
                }
            }
        }
        catch
        {
            Response.Write("加载问卷失败");
            Response.End();
        }
        
        if(Request.HttpMethod=="POST")
		{
            AdditiveConclusion addcon = new AdditiveConclusion();
            addcon.LevelsCount = new IntRange(Convert.ToInt16(Request.Form["CountLower"]), Convert.ToInt16(Request.Form["CountUpper"]));
            addcon.Levels = new ScoreLevel[Request.Form.GetValues("level").Length];
            for (int i = 0; i < Request.Form.GetValues("level").Length; i++)
            {
                addcon.Levels[i] = ((ScoreLevel)Convert.ToInt16(Request.Form.GetValues("level")[i]));
            }
            addcon.ConclusionId = Convert.ToInt32(Request.Form["ConclusionId"]);
            addcon.Content = Request.Form["content"].Trim();
            
            ConclusionFile conclusion = paper.GetConclusionFileById(addcon.ConclusionId);

            conclusion.AddAdditve(addcon);
            
            paper.Save();
            
            Response.Redirect("createAdditiveConclusion.aspx?sn=" + paper.SN.ToString() + "&conid=" + addcon.ConclusionId);
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
<form id="AdditiveConclusionForm" method="post" action="" runat="server">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="newPapers.aspx">待发布的新问卷</a></li>
				<li><a href="editingPapers.aspx">编辑中的问卷</a></li>
				<li><a href="publishedPapers.aspx">已发布的问卷</a></li>
				<li><a href="abrogatedPapers.aspx">废除的问卷</a></li>
				<li><a href="createPaper.aspx">新建空白问卷</a></li>
				<li class="active">问卷附加结论</li>
			</ul>
		</div>
		
		<div class="body">
		    <table width="100%" border="0" class="grid1">
		    <tr>
		        <th scope="col">分值</th>
		        <th scope="col">条件</th>
		        <th scope="col" style="width:70%;">内容</th>
		        <th scope="col">操作</th>
		    </tr>
		    <%Response.Write(html.ToString()); %>
		    </table>
		    <br />
			<table width="100%" border="0" class="grid1">
			    <tr>
			        <th scope="row">问卷：</th>
				    <td><%Response.Write("<a href=\"publishPaper.aspx?sn=" + paper.SN.ToString() + "\">" + paper.Title + "[" + paper.SN.ToString() + "]</a>");%></td>
			    </tr>
			    <tr>
			        <th scope="row">分值范围：</th>
				    <td>
				        <asp:DropDownList ID="ConclusionId" runat="server">
                        </asp:DropDownList>
				    </td>
			    </tr>
				<tr>
					<th scope="row">定义模块得分条件：</th>
					<td>
					包含<asp:DropDownList ID="CountLower" runat="server">
                        </asp:DropDownList> － <asp:DropDownList ID="CountUpper" runat="server">
                        </asp:DropDownList>项 
                        <input type="checkbox" id="level1" name="level" value="1" /><label for="level1">差</label>
                        <input type="checkbox" id="level2" name="level" value="2" /><label for="level2">一般</label>
                        <input type="checkbox" id="level3" name="level" value="3" /><label for="level3">良好</label>
                        <input type="checkbox" id="level4" name="level" value="4" /><label for="level4">优秀</label>
					</td>
				</tr>
				<tr>
					<th scope="row">结论内容：</th>
					<td><table width="90%" border="0">
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><textarea name="content" rows="6" style="width:80%;"></textarea></td>
						</tr>
					</table></td>
				</tr>
			</table>
			<div class="footer">
				<input name="Submit" type="submit" class="cmdConfirm" value="保存" />
				<input name="sn" type="hidden" value="<%Response.Write(paper.SN.ToString()); %>" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
