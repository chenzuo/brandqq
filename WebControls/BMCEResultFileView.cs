using System;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.ComponentModel;

using BrandQQ.BMCE;
using BrandQQ.Membership;
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    [ToolboxData(@"<{0}:BMCEResultFileView runat='server' />")]
    public class BMCEResultFileView:Control
    {
        protected override void Render(HtmlTextWriter writer)
        {
            base.Render(writer);

            if (File.Exists(GeneralConfig.Instance.PaperResultTempSavePath + fileId+".rst"))
            {
                result = ResultFile.Load(fileId);

                if (result == null)
                {
                    writer.WriteLine("加载结果文件失败！");
                    return;
                }

                paper = PaperFile.Load(result.SN);

                if (String.IsNullOrEmpty(industry))
                {
                    industry = result.UserInfo.Industry;
                }

                if (showDetails>0 && (result.Status == ResultStatus.None || result.Status == ResultStatus.Cancled))
                {
                    if (Member.TempInfo == null)
                    {
                        Member.SetTempInfo();
                    }
                    MemberTempInfo.Set(result.SN.ToString(), result.FileId, result.LastModule.Id, result.LastQuestion.Id);
                    writer.WriteLine("<p style=\"line-height:100px;\" class=\"alignCenter\"><img src=\"/images/bmce_unfinish.jpg\" /><br/>该问卷尚未完成，请<a href=\"/bmce\">点击这里继续完成问卷</a></p>");
                    
                    return;
                }

                //显示图表
                string swfParams = "idx=" + result.RelativeScore.ToString() + "&";
                swfParams += "com=" + (String.IsNullOrEmpty(result.UserInfo.Name) ? "未设置" : HttpContext.Current.Server.UrlEncode(result.UserInfo.Name)) + "&";
                swfParams += "dt=" + result.Update.ToShortDateString() + "&";

                for (int i = 0; i < result.Modules.Count; i++)
                {
                    swfParams += "c" + (i + 1).ToString() + "=" + ((ResultModule)result.Modules[i]).RelativeScore.ToString() + "&";
                }

                writer.WriteLine("<div class=\"chart\">");
                writer.WriteLine("  <h1>品牌管理能力指数报告</h1>");
                writer.WriteLine("  <div class=\"alignCenter\">");
                writer.WriteLine("  <script>FlashPlayer('/images/charts/" + paper.SN.ToString() + ".swf?" + swfParams + "',680,450);</script>");
                writer.WriteLine("  </div>");
                writer.WriteLine("</div>");


                if (showDetails == 0)
                {
                    writer.WriteLine("<div class=\"result\">");
                    writer.WriteLine("  <h1>开始时间：" + result.Begin.ToString() + " 最后更新时间：" + result.Update.ToString() + " 当前状态:" + result.Status.ToString() + "<br/> 来源:" + result.RefUrl + "</h1>");
                    writer.WriteLine("  <div>企业资料：");

                    writer.WriteLine("      <ul id=\"COMINFO\" style=\"display:;\">");
                    writer.WriteLine("      <li><a href=\"../user/companyDetails.aspx?id=" + result.UserInfo.Id.ToString() + "\">查看企业明细信息</a></li>");
                    writer.WriteLine("      <li>所属行业：" + IndustryUtil.GetName(result.UserInfo.Industry) + "</li>");
                    writer.WriteLine("      <li>企业性质：" + CompanyNature.Get(result.UserInfo.Nature) + "</li>");
                    writer.WriteLine("      <li>员工规模：" + result.UserInfo.Employee.ToString() + " 人</li>");
                    writer.WriteLine("      <li>年营业额：" + result.UserInfo.Turnover.ToString() + " 万</li>");
                    writer.WriteLine("      <li>-------------------------------------</li>");
                    writer.WriteLine("      <li>初始名称：" + result.UserInfo.Name + "</li>");
                    writer.WriteLine("      <li>初始邮件：" + result.UserInfo.Email + "</li>");

                    if (result.UserInfo.Id > 0)
                    {
                        writer.WriteLine("      <li>注册邮件：" + Member.Get(result.UserInfo.Id).Email + "</li>");
                        Company com = Company.Get(result.UserInfo.Id);
                        if (com != null)
                        {
                            writer.WriteLine("      <li>注册名称：" + com.ComName + "</li>");
                        }
                    }

                    writer.WriteLine("      <li>联 系 人：" + result.UserInfo.Contact + "</li>");
                    writer.WriteLine("      <li>联系电话：" + result.UserInfo.Phone + "</li>");
                    writer.WriteLine("      <li>所在部门：" + result.UserInfo.Position + "</li>");
                    writer.WriteLine("      <li>意见建议：" + result.UserInfo.Remark + "</li>");
                    writer.WriteLine("      </ul>");
                    
                    writer.WriteLine("  </div>");
                    writer.WriteLine("</div>");
                }

                //问卷总结
                writer.WriteLine("<div class=\"paper\">");
                if (paper.CalcMethod == ScoreCalcMethod.Absolute)
                {
                    writer.WriteLine("  <h1>问卷：" + paper.Title + (!showScore ? "<img src=\"/skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />" : "[得分：" + result.RealScore.ToString() + "" + (showDetails == 0 ? "(相对分:" + result.RelativeScore.ToString() + ")" : "") + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />]") + "</h1>");
                }
                else
                {
                    writer.WriteLine("  <h1>问卷：" + paper.Title + (!showScore ? "<img src=\"/skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />" : "[得分：" + result.RelativeScore.ToString() + "" + (showDetails == 0 ? "(绝对分:" + result.RealScore.ToString() + ")" : "") + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />]") + "</h1>");
                }
                ConclusionFile conclusion = result.GetConclusion(paper);

                if (showDetails >= 0)
                {
                    writer.WriteLine("<div class=\"conclusion\">您于 " + result.Begin.ToString() + " 开始参与测试，在 " + result.Update.ToString() + " 完成了测试。<br/>");
                }

                writer.WriteLine("<div class=\"tag\"><img src=\"/skin/icon_c1.gif\" alt=\"总体评价\" /></div>");
                writer.WriteLine(conclusion == null ? "" : "　　" + Util.Utility.UBB2Html(conclusion.Content));

                if (conclusion.Additives != null)
                {
                    foreach (AdditiveConclusion addConclusion in conclusion.Additives)
                    {
                        writer.WriteLine("<p>" + "　　" + Util.Utility.UBB2Html(addConclusion.Content) + "</p>");
                    }
                }

                //行业结论
                if (!String.IsNullOrEmpty(industry))
                {
                    string industryConclusion = Conclusion.GetIndustryConclusion(industry);
                    if (!String.IsNullOrEmpty(industryConclusion))
                    {
                        writer.WriteLine("<p>" + "　　" + industryConclusion + "</p>");
                    }
                }

                //输出建议
                if (conclusion != null)
                {
                    if (!String.IsNullOrEmpty(conclusion.Advice))
                    {
                        writer.WriteLine("<p class=\"tag\"><img src=\"/skin/icon_c2.gif\" alt=\"建议\" /></p>");
                        writer.WriteLine("　　" + Util.Utility.UBB2Html(conclusion.Advice));
                    }
                }

                writer.WriteLine("</div>");
                writer.WriteLine("</div>");

                foreach (ResultModule module in result.Modules)
                {
                    if (showDetails==0)//显示细节
                    {
                        writer.WriteLine("<div class=\"module\">");
                        writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " [实际得分:" + module.RealScore.ToString() + " 相对分:" + module.RelativeScore.ToString() + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" />]</h1>");

                        writer.WriteLine("  <div class=\"question\">");
                        foreach (ResultQuestion question in module.Questions)
                        {
                            writer.WriteLine("  <h1>问题：" + question.Title + "</h1>");

                            writer.WriteLine("  <ul>");
                            foreach (ResultAnswer answer in question.Answers)
                            {
                                writer.WriteLine("  <li" + (answer.Checked ? " class=\"checked\"" : "") + ">" + answer.Title + "</li>");
                            }
                            writer.WriteLine("  </ul>");
                        }
                        writer.WriteLine("  </div>");

                        //输出模块结论
                        if (module.Score > 0)
                        {
                            writer.WriteLine("  <div class=\"conclusion\">");
                            writer.WriteLine("  <h1><img src=\"/skin/icon_c3.gif\" alt=\"建议\" /></h1>");
                            ConclusionFile cf = module.GetConclusion(paper);
                            if (cf != null)
                            {
                                writer.Write("　　" + Util.Utility.UBB2Html(cf.Content));
                            }
                            writer.WriteLine("  </div>");
                        }

                        writer.WriteLine("</div>");
                    }
                    else if (showDetails == 1 && module.Score > 0)//部分显示，忽略module.Score==0的模块
                    {
                        writer.WriteLine("<div class=\"module\">");
                        if (showScore)
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " [得分:" + (paper.CalcMethod == ScoreCalcMethod.Relative ? module.RelativeScore.ToString() : module.RealScore.ToString()) + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" />]</h1>");
                        }
                        else
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " <img src=\"/skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" /></h1>");
                        }

                        writer.WriteLine("  <div class=\"question\">");
                        foreach (ResultQuestion question in module.Questions)
                        {
                            writer.WriteLine("  <h1>问题：" + question.Title + "</h1>");
                            
                            writer.WriteLine("  <ul>");
                            int chkNum = 0;
                            foreach (ResultAnswer answer in question.Answers)
                            {
                                if (answer.Checked)
                                {
                                    writer.WriteLine("  <li>" + answer.Title + "</li>");
                                    chkNum++;
                                }
                            }
                            if (chkNum == 0)
                            {
                                writer.WriteLine("  <li>&lt;无答案&gt;</li>");
                            }
                            writer.WriteLine("  </ul>");
                        }
                        writer.WriteLine("  </div>");

                        //输出模块结论
                        if (module.Score > 0)
                        {
                            writer.WriteLine("  <div class=\"conclusion\">");
                            writer.WriteLine("  <h1><img src=\"/skin/icon_c3.gif\" alt=\"建议\" /></h1>");
                            ConclusionFile cf = module.GetConclusion(paper);
                            if (cf != null)
                            {
                                writer.Write("　　" + Util.Utility.UBB2Html(cf.Content));
                            }
                            writer.WriteLine("  </div>");
                        }

                        writer.WriteLine("</div>");
                    }
                    else if (showDetails == 2 && module.Score > 0)//大纲显示，忽略module.Score==0的模块
                    {
                        writer.WriteLine("<div class=\"module\">");
                        if (showScore)
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " [得分:" + (paper.CalcMethod == ScoreCalcMethod.Relative ? module.RelativeScore.ToString() : module.RealScore.ToString()) + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" />]</h1>");
                        }
                        else
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " <img src=\"/skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" /></h1>");
                        }

                        //输出模块结论
                        if (module.Score > 0)
                        {
                            writer.WriteLine("  <div class=\"conclusion\">");
                            writer.WriteLine("  <h1><img src=\"/skin/icon_c3.gif\" alt=\"建议\" /></h1>");
                            ConclusionFile cf = module.GetConclusion(paper);
                            if (cf != null)
                            {
                                writer.Write("　　" + Util.Utility.UBB2Html(cf.Content));
                            }
                            writer.WriteLine("  </div>");
                        }

                        writer.WriteLine("</div>");
                    }
                }

                if (showDetails > 0 && !disableFeedback)
                {
                    bool hasRemark = false;
                    if (result.UserInfo != null)
                    {
                        if (!String.IsNullOrEmpty(result.UserInfo.Remark))
                        {
                            hasRemark = true;
                        }
                    }

                    if (!hasRemark)
                    {
                        writer.WriteLine("<div id=\"RemarkPannel\">");
                        writer.WriteLine("<div>如果您对我们的测试有任何意见或者建议，以及任何其他的问题，请在下方给我们留言(300字)：</div>");
                        writer.WriteLine("<div>");
                        writer.WriteLine("<textarea name=\"Remark\" rows=\"5\" cols=\"50\"></textarea>");
                        writer.WriteLine("</div>");
                        writer.WriteLine("<div class=\"alignCenter\">");
                        writer.WriteLine("<input type=\"hidden\" name=\"ResultSN\" value=\""+result.SN.ToString()+"\" />");
                        writer.WriteLine("<input type=\"hidden\" name=\"ResultGuid\" value=\""+result.Guid+"\" />");
                        writer.WriteLine("<input type=\"hidden\" name=\"AjaxAction\" value=\"saveResultRemark\" />");
                        writer.WriteLine("<input type=\"button\" name=\"CmdSaveRemark\" value=\"保存留言\" class=\"cmdConfirm\" onclick=\"saveResultRemark(this);\" />");
                        writer.WriteLine("</div>");
                        writer.WriteLine("</div>");
                    }
                }

            }
            else
            {
                writer.WriteLine("未找到相关的结果文件！");
            }
        }

        private string GetModuleTitle(int mid)
        {
            string t = "贵公司品牌管理的 ";
            switch (mid)
            {
                case 45:
                    t += "品牌意识指数(AI)评价为：";
                    break;
                case 46:
                    t += "品牌战略指数(SI)评价为：";
                    break;
                case 47:
                    t += "品牌组织指数(OI)评价为：";
                    break;
                case 48:
                    t += "传播力指数(CI)评价为：";
                    break;
                case 49:
                    t += "产品力指数(PI)评价为：";
                    break;
                case 50:
                    t += "洞察力指数(II)评价为：";
                    break;
                case 51:
                    t += "监控力指数(TI)评价为：";
                    break;
                case 52:
                    t += "品牌评价";
                    break;
            }

            return t;
        }

        public int FileId
        {
            set
            {
                fileId = value;
            }
        }

        /// <summary>
        /// 显示细节控制，0:显示全部;1:显示问题和已选答案;2:仅显示模块及其评价
        /// </summary>
        public int ShowDetails
        {
            set
            {
                showDetails = value;
            }
        }

        /// <summary>
        /// 指示是否显示得分,false显示等级,true显示得分和等级
        /// </summary>
        public bool ShowScore
        {
            set
            {
                showScore = value;
            }
        }

        public string Industry
        {
            set
            {
                industry = value;
            }
        }

        public bool DisableFeedback
        {
            set
            {
                disableFeedback = value;
            }
        }

        private int fileId;
        private int showDetails=0;
        private bool showScore = true;
        private string industry="";

        private ResultFile result;
        private PaperFile paper;

        private bool disableFeedback = false;
    }
}
