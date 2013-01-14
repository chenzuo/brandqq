<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls.Utility" Assembly="BrandQQ.WebControls" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    StringBuilder html2 = new StringBuilder();
   	PaperFile paperFile;
    int totalWeight=0;
    int totalScore = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (String.IsNullOrEmpty(Request["sn"]))
        {
            Response.Write("错误的输入参数");
            Response.End();
        }

        try
        {
            SerialNumber serial = new SerialNumber(Request["sn"]);
            if (!PaperFile.Exists(serial))
            {
                Paper.CreateFile(serial);
            }
            
            paperFile = PaperFile.Load(serial);
            
            //初始化页面
            PaperSN.Text = paperFile.SN.ToString();
			PaperTitle.Text=paperFile.Title;
			PaperUpdate.Text=paperFile.PublishedDate.ToString();
            PaperCalcMethod.SelectedValue = ((int)paperFile.CalcMethod).ToString();
            PaperDescription.Text = paperFile.Description;

            int midx = 0;
            
            foreach (ModuleFile mf in paperFile.ModuleFiles)
            {
                totalWeight += mf.Weight;
                totalScore += mf.Score;
                html.AppendLine("<div class=\"box1\">");
                html.AppendLine("	<div id=\"MODULE_TITLE_" + mf.Id.ToString() + "\" class=\"pad5\" onclick=\"switchShow(1," + mf.Id.ToString() + ");\" style=\"cursor:pointer;width:100%;\"><strong>模块[" + mf.OrderNum.ToString() + "]：" + mf.Title + " (总分：" + mf.Score.ToString() + ")</strong></div>");
                html.AppendLine(" <div id=\"MODULE_" + mf.Id.ToString() + "\" style=\"display:none;\">");
                html.AppendLine("	<div class=\"pad5\" id=\"MODULE_SETPANNEL_" + mf.Id.ToString() + "\">");
				html.AppendLine("		<table width=\"100%\" border=\"0\" class=\"grid2\">");
				html.AppendLine("			<tr>");
                html.AppendLine("			<td width=\"50%\">权重：<input type=\"text\" class=\"unEditable\" size=\"8\" id=\"module" + mf.Id.ToString() + "_weight\" value=\"" + mf.Weight.ToString() + "\" onfocus=\"this.className='editable';\" onblur=\"this.className='unEditable';\" /></td>");
                html.AppendLine("			<td>排序：" + mf.OrderNum.ToString() + "");
                //if (midx == 0)
                //{
                //    html.AppendLine("			<img src=\"../skin/blank.gif\" class=\"sortDown1\" />");
                //}
                //else if (midx == paperFile.ModuleFiles.Count-1)
                //{
                //    html.AppendLine("			<img src=\"../skin/blank.gif\" class=\"sortUp1\" />");
                //}
                //else
                //{
                //    html.AppendLine("			<img src=\"../skin/blank.gif\" class=\"sortUp1\" />");
                //    html.AppendLine("			<img src=\"../skin/blank.gif\" class=\"sortDown1\" />");
                //}
                html.AppendLine("			</td>");
				html.AppendLine("			</tr>");
				html.AppendLine("			<tr>");
                html.AppendLine("			<td>");
                html.AppendLine("			差：<input type=\"text\" class=\"unEditable\" size=\"2\" id=\"module" + mf.Id.ToString() + "_level1\" value=\"" + mf.Levels[0].ToString() + "\" onfocus=\"this.className='editable';\" onblur=\"this.className='unEditable';\" />");
                html.AppendLine("			 一般：<input type=\"text\" class=\"unEditable\" size=\"2\" id=\"module" + mf.Id.ToString() + "_level2\" value=\"" + mf.Levels[1].ToString() + "\" onfocus=\"this.className='editable';\" onblur=\"this.className='unEditable';\" />");
                html.AppendLine("			 良好：<input type=\"text\" class=\"unEditable\" size=\"2\" id=\"module" + mf.Id.ToString() + "_level3\" value=\"" + mf.Levels[2].ToString() + "\" onfocus=\"this.className='editable';\" onblur=\"this.className='unEditable';\" />");
                html.AppendLine("			 优秀：<input type=\"text\" class=\"unEditable\" size=\"2\" id=\"module" + mf.Id.ToString() + "_level4\" value=\"" + mf.Levels[3].ToString() + "\" onfocus=\"this.className='editable';\" onblur=\"this.className='unEditable';\" />");
                html.AppendLine("			(％)</td>");
                html.AppendLine("			<td>");
                html.AppendLine("			<input type=\"button\" class=\"cmd\" value=\"更新\" onclick=\"updateModule('" + paperFile.SN.ToString() + "'," + mf.Id.ToString() + ",this);\"/>");
                html.AppendLine("			<input type=\"button\" class=\"cmd\" value=\"移除模块\" onclick=\"removeModule('" + paperFile.SN.ToString() + "'," + mf.Id.ToString() + ");\" />");
                html.AppendLine("			</td>");
				html.AppendLine("			</tr>");
				html.AppendLine("		</table>");
				html.AppendLine("	</div>");

                html.AppendLine("	<div class=\"pad5\"><img src=\"../skin/+.gif\" alt=\"展开/隐藏\" style=\"cursor:pointer;\" onclick=\"switchShow(3," + mf.Id.ToString() + ",this);\" />包含的问题：");
                html.AppendLine("	<table width=\"100%\" border=\"0\" class=\"grid2\" id=\"MODULE_QUESTIONS_" + mf.Id.ToString() + "\" style=\"display:none;\">");
                foreach (QuestionFile qf in mf.Questions)
				{
					html.AppendLine("		<tr>");
                    html.AppendLine("			<td class=\"highLight\">问题[" + qf.OrderNum.ToString() + "]：" + qf.Title + " <img src=\"../skin/blank.gif\" class=\"" + (qf.IsMulti ? "check" : "radio") + "\" /></td>");
					html.AppendLine("		</tr>");
                    //如果是多选题
                    if (qf.IsMulti)
                    {
                        html.AppendLine("		<tr>");
                        html.AppendLine("			<td class=\"alignRight\">设置问题的选项数...............");
                        html.AppendLine("			必选项数：<select id=\"question" + qf.Id.ToString() + "_itemsLower\">");
                        for (int i = 0; i <= qf.Answers.Count; i++)
                        {
                            html.AppendLine("			<option value=\"" + i.ToString() + "\"" + ((qf.ItemRange.Lower == i || (qf.ItemRange.Lower == IntRange.None.Lower && i==1)) ? " selected" : "") + ">" + i.ToString() + "</option>");
                        }
                        html.AppendLine("			</select>");

                        html.AppendLine("			可选项数：<select id=\"question" + qf.Id.ToString() + "_itemsUpper\"><option value=\"-1\">全部</option>");
                        for (int i = 1; i <= qf.Answers.Count; i++)
                        {
                            html.AppendLine("			<option value=\"" + i.ToString() + "\"" + (qf.ItemRange.Upper == i ? " selected" : "") + ">" + i.ToString() + "</option>");
                        }
                        html.AppendLine("			</select>");
                        html.AppendLine("			<input type=\"button\" class=\"cmd\" value=\"确定\" onclick=\"updateQuestionItemRange('" + paperFile.SN.ToString() + "','" + qf.Id.ToString() + "',this);\" />");
                    
                        html.AppendLine("			</td>");
                        html.AppendLine("		</tr>");
                    }
                    
					html.AppendLine("		<tr>");
					html.AppendLine("			<td>");
					html.AppendLine("				<div>");
                        foreach (AnswerFile af in qf.Answers)
						{
                            html.AppendLine("					<div>" + af.Title + " [" + af.OrderNum.ToString() + "][" + af.Score.ToString() + "分]" + (af.Only ? "<img src=\"../skin/key.gif\" />" : "") + " ....................");
                            html.AppendLine("				    忽略规则：<select id=\"answer" + af.Id.ToString() + "_ignoreType\" onchange=\"changeAnswerIgnoreType('" + paperFile.SN.ToString() + "'," + mf.Id.ToString() + "," + qf.Id.ToString() + "," + af.Id.ToString() + ",this.options[this.selectedIndex].value);\">");
                            html.AppendLine("				    <option value=\"0\""+(af.Ignore==IgnoreType.None?" selected":"")+">无</option>");
                            html.AppendLine("				    <option value=\"1\"" + (af.Ignore == IgnoreType.Question ? " selected" : "") + ">问题</option>");
                            html.AppendLine("				    <option value=\"2\"" + (af.Ignore == IgnoreType.Module ? " selected" : "") + ">模块</option>");
                            html.AppendLine("				    </select> <input type=\"button\" id=\"cmdAnswer" + af.Id.ToString() + "_ignoreSave\" class=\"cmd\" value=\"确定\" onclick=\"updateAnswerIgnore('" + paperFile.SN.ToString() + "'," + mf.Id.ToString() + "," + qf.Id.ToString() + "," + af.Id.ToString() + ",this);\" />");
                            html.AppendLine("				    <ul class=\"pad5\" id=\"answer" + af.Id.ToString() + "_ignorecontainor\">");
                            
                            if (af.Ignore == IgnoreType.Question)
                            {
                                foreach (QuestionFile ig in af.Parent.Parent.Questions)
                                {
                                    if (ig.OrderNum > af.Parent.OrderNum)
                                    {
                                        html.AppendLine("				    <li><input type=\"checkbox\" name=\"answer" + af.Id.ToString() + "_ignores\" id=\"answer_ignores_" + ig.Id + "\" value=\"" + ig.Id + "\"" + (af.IgnoreCollection.Contains(ig) ? " checked=\"checked\"" : "") + " /><label for=\"answer_ignores_" + ig.Id + "\">" + ig.Title + "</label></li>");
                                    }
                                }
                            }
                            if (af.Ignore == IgnoreType.Module)
                            {
                                foreach (ModuleFile ig in af.Parent.Parent.Parent.ModuleFiles)
                                {
                                    if (ig.OrderNum >= af.Parent.Parent.OrderNum)
                                    {
                                        html.AppendLine("				    <li><input type=\"checkbox\" name=\"answer" + af.Id.ToString() + "_ignores\" id=\"answer_ignores_" + ig.Id + "\" value=\"" + ig.Id + "\"" + (af.IgnoreCollection.Contains(ig) ? " checked=\"checked\"" : "") + " /><label for=\"answer_ignores_" + ig.Id + "\">" + ig.Title + "</label></li>");
                                    }
                                 }
                            }
                            
                            html.AppendLine("				    </ul>");
                            html.AppendLine("				    </div>");
						}
                    html.AppendLine("				</div>");
					html.AppendLine("			</td>");
					html.AppendLine("		</tr>");
				}
				html.AppendLine("	</table>");
				html.AppendLine("	</div>");

                html.AppendLine("	<div class=\"pad5\"><img src=\"../skin/+.gif\" alt=\"展开/隐藏\" style=\"cursor:pointer;\" onclick=\"switchShow(4," + mf.Id.ToString() + ",this);\" />包含的结论：<a href=\"javascript:;\" onclick=\"updateModuleConclusions('" + paperFile.SN.ToString() + "'," + mf.Id.ToString() + ",this);\">[更新结论]</a>");
                html.AppendLine("	<table width=\"100%\" border=\"0\" class=\"grid1\" id=\"MODULE_CONCLUSIONS_" + mf.Id.ToString() + "\" style=\"display:none;\">");
				html.AppendLine("		<tr>");
				html.AppendLine("			<th scope=\"col\">分值范围</th>");
				html.AppendLine("			<th width=\"80%\" scope=\"col\">内容</th>");
				html.AppendLine("		</tr>");
                foreach (ConclusionFile cf in mf.Conclusions)
				{
					html.AppendLine("		<tr>");
                    html.AppendLine("			<td>" + cf.Range.Lower.ToString() + "% - " + cf.Range.Upper.ToString() + "%</td>");
                    html.AppendLine("			<td>" + cf.Content + "</td>");
					html.AppendLine("		</tr>");
				}
				html.AppendLine("	</table>");
				html.AppendLine("	</div>");
                html.AppendLine("  </div>");
				html.AppendLine("</div>");
                midx++;
            }

            //遍历问卷结论
            html2.AppendLine("	<div class=\"pad5\" id=\"PAPER_CONCLUSIONS\" style=\"display:none;\">");
            html2.AppendLine("	<table width=\"100%\" border=\"0\" class=\"grid1\">");
            html2.AppendLine("		<tr>");
            html2.AppendLine("			<th scope=\"col\">分值范围</th>");
            html2.AppendLine("			<th width=\"40%\" scope=\"col\">内容</th>");
            html2.AppendLine("			<th width=\"40%\" scope=\"col\">建议</th>");
            html2.AppendLine("			<th scope=\"col\">附加结论</th>");
            html2.AppendLine("		</tr>");
            foreach (ConclusionFile cf in paperFile.ConclusionFiles)
            {
                html2.AppendLine("		<tr>");
                html2.AppendLine("			<td>" + cf.Range.Lower.ToString() + " - " + cf.Range.Upper.ToString() + "%</td>");
                html2.AppendLine("			<td>" + cf.Content + "</td>");
                html2.AppendLine("			<td>" + cf.Advice + "</td>");
                html2.AppendLine("			<td><a href=\"createAdditiveConclusion.aspx?sn=" + paperFile.SN.ToString() + "&conid=" + cf.Id.ToString() + "\">附加[" + (cf.Additives == null ? "0" : cf.Additives.Count.ToString()) + "]...</a></td>");
                html2.AppendLine("		</tr>");
            }
            html2.AppendLine("	</table>");
            html2.AppendLine("	</div>");
        }
        catch
        {
            //throw;
            Response.Write("从指定位置加载问卷错误！");
            Response.End();
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
<form id="PaperForm" runat="server">
	<div class="tabContainor grayTab">
		<div class="tabBox">
			<ul class="tabs">
				<li><a href="newPapers.aspx">待发布的新问卷</a></li>
				<li><a href="editingPapers.aspx">编辑中的问卷</a></li>
				<li><a href="publishedPapers.aspx">已发布的问卷</a></li>
				<li><a href="abrogatedPapers.aspx">废除的问卷</a></li>
				<li><a href="createPaper.aspx">新建空白问卷</a></li>
				<li class="active">发布新问卷</li>
			</ul>
		</div>
		
		<div class="body">
			<table width="100%" border="0" class="grid2">
				<tr>
					<td width="50%">编号：<asp:Label ID="PaperSN" runat="server" Text=""></asp:Label></td>
					<td>
					计分方法：
                        <asp:ListBox ID="PaperCalcMethod" SelectionMode="Single" Rows="1" runat="server" onchange="updatePaperFileCalcMethod(this);">
                            <asp:ListItem Text="绝对分" Value="0" />
                            <asp:ListItem Text="相对分(100分制)" Value="1" />
                        </asp:ListBox>
                    绝对总分：<%Response.Write(totalScore); %>
                    </td>
				</tr>
                <tr>
                	<td>标题：<asp:Label ID="PaperTitle" runat="server" Text=""></asp:Label></td>
               		<td>更新：<asp:Label ID="PaperUpdate" runat="server" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="PaperDescription" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
			</table>
			
			<div class="pad5 box2" id="ModuleSelection" style="display:none;">
			    <div class="pad5">按照行业过滤：<BrandQQ:IndustrySelect ID="IndustrySelect" Name="IndustrySelect" FirstEmpty="true" runat="server" ClientChange="ajaxQueryModules(1);" /></div>
			    <ul class="pad5" id="ModuleSelectionBody"></ul>
			</div>
			
			<div class="footer">
			    <input type="button" name="cmdAddModule" id="cmdAddModule" value="添加模块" class="cmdGeneral" onclick="showModuleSelection(true);" />
			    <input type="button" name="cmdAddModuleCancle" id="cmdAddModuleCancle" value="取消" class="cmdCancle" onclick="showModuleSelection(false);" style="display:none;" />
			</div>
			
			<%Response.Write(totalWeight != 100 ? "<p class=\"pad5 clrF00\">模块权重总和为：" + totalWeight.ToString() + "，可能存在错误的分配</p>" : ""); %>
			
			<%Response.Write(html.ToString());%>
			<div class="pad5"><img src="../skin/+.gif" alt="展开/隐藏" style="cursor:pointer;" onclick="switchShow(5,0,this);" />问卷包含以下结论：<a href="javascript:;" onclick="updatePaperConclusions('<%Response.Write(paperFile.SN.ToString()); %>',this);">[更新结论]</a>
			<%Response.Write(html2.ToString());%>
			</div>
			
			<div class="footer">
			    <input type="button" id="cmdPublish" class="cmdConfirm" value="发布问卷" onclick="publishPaperFile('<%Response.Write(paperFile.SN.ToString()); %>',this);" />
			</div>
		</div>
	</div>
</form>
</body>
</html>
