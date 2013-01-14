using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.IO;//临时调试
using BrandQQ.Membership;
using BrandQQ.BMCE;
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    /// <summary>
    /// 处理客户端提交的问卷
    /// </summary>
    public class PaperTestResponse:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            string selAnswers = "";

            if (Request["selAnswer"] != null)
            {
                selAnswers = Request["selAnswer"];
                if (selAnswers.EndsWith(","))
                {
                    selAnswers = selAnswers.Substring(0, selAnswers.Length - 1);
                }
            }

            StringBuilder html = new StringBuilder();

            MemberTempInfo info = Member.TempInfo;
            if (info==null)
            {
                Response.Write("可能您的浏览器禁止使用Cookie，问卷无法加载.!");
                Response.End();
            }

            if (String.IsNullOrEmpty(info.PaperSN) || info.ModuleId == 0 || info.QuestionId == 0 || info.ResultId<=0)
            {
                Response.Write("可能您的浏览器禁止使用Cookie，问卷无法加载!");
                Response.End();
            }

            ResultFile result = ResultFile.Load(info.ResultId);
            PaperFile paper = PaperFile.Load(new SerialNumber(info.PaperSN));

            //如果当前问卷已完成
            if (info.ModuleId == -1 && info.QuestionId == -1)
            {
                //设置状态为完成
                result.Status = ResultStatus.Finished;
                result.Save();
                SendMail(paper, result);
                //输出完成标记
                Response.Write(Member.IsLogined ? "<!--over logined-->" : "<!--over-->");
                Response.End();
            }

            
            ModuleFile module = paper[info.ModuleId];
            QuestionFile question = module[info.QuestionId];

            //如果提交答案
            if (selAnswers != "")
            {
                //当前答案的忽略规则
                IgnoreType currentAnswerIgnoreType = IgnoreType.None;
                foreach (string s in selAnswers.Split(','))
                {
                    try
                    {
                        int aid = Convert.ToInt32(s);
                        AnswerFile answerFile = question[aid];

                        currentAnswerIgnoreType = answerFile.Ignore;

                        //跳过忽略的问题或模块
                        if (answerFile.Ignore == IgnoreType.Question)
                        {
                            foreach (QuestionFile ig in answerFile.IgnoreCollection)
                            {
                                question = ig;
                            }
                        }
                        else if (answerFile.Ignore == IgnoreType.Module)
                        {
                            foreach (ModuleFile ig in answerFile.IgnoreCollection)
                            {
                                module = ig;
                            }
                        }
                        result.LastModule = result[module.Id];
                        result.LastQuestion = result[module.Id][question.Id];
                        result.Update = DateTime.Now;
                        result[info.ModuleId][info.QuestionId][aid].Checked = true;
                        
                    }
                    catch
                    {
                        //
                    }
                }
                
                result.Status = ResultStatus.Cancled;
                result.Save();

                //依据忽略规则，定位下一个模块或问题
                if (currentAnswerIgnoreType == IgnoreType.Module)//忽略模块，则直接定位到下一个模块
                {
                    module = module.Next;
                    if (module == null)//无下一个模块
                    {
                        //设置状态为完成
                        result.Status = ResultStatus.Finished;
                        result.Save();
                        SendMail(paper, result);
                        //输出完成标记
                        Response.Write(Member.IsLogined ? "<!--over logined-->" : "<!--over-->");
                        Response.End();
                    }
                    else
                    {
                        question = (QuestionFile)module.Questions[0];//设置当前问题为模块的第一个问题
                        MemberTempInfo.Set(module.Id, question.Id);
                    }
                }
                else//无忽略或者忽略问题
                {
                    question = question.Next;
                    if (question == null)
                    {
                        module = module.Next;
                        if (module == null)
                        {
                            //设置状态为完成
                            result.Status = ResultStatus.Finished;
                            result.Save();
                            SendMail(paper, result);
                            //输出完成标记
                            Response.Write(Member.IsLogined ? "<!--over logined-->" : "<!--over-->");
                            Response.End();

                        }
                        else
                        {
                            question = (QuestionFile)module.Questions[0];//设置当前问题为模块的第一个问题
                            MemberTempInfo.Set(module.Id, question.Id);
                        }
                    }
                    else
                    {
                        MemberTempInfo.Set(question.Parent.Id, question.Id);
                    }
                }
            }

            
            html.AppendLine("<div class=\"title2\">" + question.Title + " ");

            if (question.IsMulti)
            {
                html.Append("[多选");
                if (question.ItemRange.Upper>0)
                {
                    html.Append(" 至多 " + question.ItemRange.Upper.ToString() + " 项");
                    html.AppendLine("<input type=\"hidden\" name=\"rangLower\" value=\"" + question.ItemRange.Lower.ToString() + "\" />");
                    html.AppendLine("<input type=\"hidden\" name=\"rangUpper\" value=\"" + question.ItemRange.Upper.ToString() + "\" />");
                }
                html.Append("]");
            }

            html.Append("</div>");

            html.AppendLine("<ul>");

            foreach (AnswerFile answer in question.Answers)
            {
                html.AppendLine("<li>");

                if (question.IsMulti)
                {
                    html.AppendLine("<input type=\"checkbox\" id=\"selAnswer_" + answer.Id.ToString() + "\" name=\"selAnswer\" value=\"" + answer.Id.ToString() + "\"" + (answer.Only ? " onclick=\"keyItemClick(this);\"" : "") + "/><label for=\"selAnswer_" + answer.Id.ToString() + "\">" + answer.Title + "</label>");
                }
                else
                {
                    html.AppendLine("<input type=\"radio\" id=\"selAnswer_" + answer.Id.ToString() + "\" name=\"selAnswer\" value=\"" + answer.Id.ToString() + "\"" + (answer.Only ? " onclick=\"keyItemClick(this);\"" : "") + "/><label for=\"selAnswer_" + answer.Id.ToString() + "\">" + answer.Title + "</label>");
                }
                html.AppendLine("</li>");
            }
            html.AppendLine("</ul>");

            html.AppendLine("<input type=\"hidden\" name=\"moduleId\" value=\"" + module.Id + "\" />");
            html.AppendLine("<input type=\"hidden\" name=\"questionId\" value=\"" + question.Id + "\" />");
            html.AppendLine("<input type=\"hidden\" name=\"questionsCount\" value=\"" + result.Percent[1] + "\" />");
            html.AppendLine("<input type=\"hidden\" name=\"checkedQuestionsCount\" value=\"" + result.Percent[0] + "\" />");

            Response.Write(html.ToString());


        }

        private void SendMail(PaperFile paper, ResultFile result)
        {
            if (!Member.IsLogined)
            {
                return;
            }
            StringBuilder body = new StringBuilder();
            ConclusionFile conFile = result.GetConclusion(paper);
            body.AppendLine("尊敬的 " + Member.Instance.Email.Split('@')[0] + " ，您好！\n");
            body.AppendLine("感谢您参与BrandQQ品牌管理能力测试，现将本次测试结果的概要性总结发送给您。\n");

            body.AppendLine("-----------------------");
            body.AppendLine("您的品牌管理能力指数 BMI=" + result.RelativeScore.ToString() + " 分\n");
            body.AppendLine("BrandQQ总体评估：");
            body.AppendLine("　　" + conFile.Content);

            if (conFile.Additives != null)
            {
                foreach (AdditiveConclusion addConclusion in conFile.Additives)
                {
                    body.AppendLine("　　" + Util.Utility.UBB2Html(addConclusion.Content));
                }
            }

            if (!String.IsNullOrEmpty(result.UserInfo.Industry))
            {
                string industryConclusion = Conclusion.GetIndustryConclusion(result.UserInfo.Industry);
                if (!String.IsNullOrEmpty(industryConclusion))
                {
                    body.AppendLine("　　" + industryConclusion);
                }
            }

            if (!String.IsNullOrEmpty(conFile.Advice))
            {
                body.AppendLine("\n\nBrandQQ建议：");
                body.AppendLine(conFile.Advice);
            }

            body.AppendLine("\n\n特别提示：");

            body.AppendLine("1、完整的分析报告，包括分7大模块的分析，在网上个人帐户里有保存；");
            body.AppendLine("2、在您完善企业资料，免费成为BrandQQ的认证用户后，可以得到更为详尽的分题答案，并赠送价值3000元的完整版《中国企业品牌管理能力白皮书》 ；");
            body.AppendLine("3、免费下载最新的摘要版《中国企业品牌管理能力白皮书》 http://brandqq.brandmanager.com.cn/bmi \n");
            body.AppendLine("-----------------------");
            body.AppendLine("您在BrandQQ的登录帐户是：" + Member.Instance.Email + "（如果您忘记密码，可以在http://brandqq.brandmanager.com.cn/login.aspx找回）");

            body.AppendLine("\nBrandQQ http://brandqq.brandmanager.com.cn\n\n");
            body.AppendLine("BrandQQ快速反应中心 "+DateTime.Now.ToString());

            Email.SendMail(Member.Instance.Email, "您在BrandQQ的品牌管理能力测试结果("+DateTime.Now.ToShortDateString()+")", body.ToString(), false, GeneralConfig.MailSenderInstance);
        }
    }
}
