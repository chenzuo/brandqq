using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.UI;
using System.IO;//��ʱ����
using BrandQQ.Membership;
using BrandQQ.BMCE;
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    /// <summary>
    /// ����ͻ����ύ���ʾ�
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
                Response.Write("���������������ֹʹ��Cookie���ʾ��޷�����.!");
                Response.End();
            }

            if (String.IsNullOrEmpty(info.PaperSN) || info.ModuleId == 0 || info.QuestionId == 0 || info.ResultId<=0)
            {
                Response.Write("���������������ֹʹ��Cookie���ʾ��޷�����!");
                Response.End();
            }

            ResultFile result = ResultFile.Load(info.ResultId);
            PaperFile paper = PaperFile.Load(new SerialNumber(info.PaperSN));

            //�����ǰ�ʾ������
            if (info.ModuleId == -1 && info.QuestionId == -1)
            {
                //����״̬Ϊ���
                result.Status = ResultStatus.Finished;
                result.Save();
                SendMail(paper, result);
                //�����ɱ��
                Response.Write(Member.IsLogined ? "<!--over logined-->" : "<!--over-->");
                Response.End();
            }

            
            ModuleFile module = paper[info.ModuleId];
            QuestionFile question = module[info.QuestionId];

            //����ύ��
            if (selAnswers != "")
            {
                //��ǰ�𰸵ĺ��Թ���
                IgnoreType currentAnswerIgnoreType = IgnoreType.None;
                foreach (string s in selAnswers.Split(','))
                {
                    try
                    {
                        int aid = Convert.ToInt32(s);
                        AnswerFile answerFile = question[aid];

                        currentAnswerIgnoreType = answerFile.Ignore;

                        //�������Ե������ģ��
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

                //���ݺ��Թ��򣬶�λ��һ��ģ�������
                if (currentAnswerIgnoreType == IgnoreType.Module)//����ģ�飬��ֱ�Ӷ�λ����һ��ģ��
                {
                    module = module.Next;
                    if (module == null)//����һ��ģ��
                    {
                        //����״̬Ϊ���
                        result.Status = ResultStatus.Finished;
                        result.Save();
                        SendMail(paper, result);
                        //�����ɱ��
                        Response.Write(Member.IsLogined ? "<!--over logined-->" : "<!--over-->");
                        Response.End();
                    }
                    else
                    {
                        question = (QuestionFile)module.Questions[0];//���õ�ǰ����Ϊģ��ĵ�һ������
                        MemberTempInfo.Set(module.Id, question.Id);
                    }
                }
                else//�޺��Ի��ߺ�������
                {
                    question = question.Next;
                    if (question == null)
                    {
                        module = module.Next;
                        if (module == null)
                        {
                            //����״̬Ϊ���
                            result.Status = ResultStatus.Finished;
                            result.Save();
                            SendMail(paper, result);
                            //�����ɱ��
                            Response.Write(Member.IsLogined ? "<!--over logined-->" : "<!--over-->");
                            Response.End();

                        }
                        else
                        {
                            question = (QuestionFile)module.Questions[0];//���õ�ǰ����Ϊģ��ĵ�һ������
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
                html.Append("[��ѡ");
                if (question.ItemRange.Upper>0)
                {
                    html.Append(" ���� " + question.ItemRange.Upper.ToString() + " ��");
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
            body.AppendLine("�𾴵� " + Member.Instance.Email.Split('@')[0] + " �����ã�\n");
            body.AppendLine("��л������BrandQQƷ�ƹ����������ԣ��ֽ����β��Խ���ĸ�Ҫ���ܽᷢ�͸�����\n");

            body.AppendLine("-----------------------");
            body.AppendLine("����Ʒ�ƹ�������ָ�� BMI=" + result.RelativeScore.ToString() + " ��\n");
            body.AppendLine("BrandQQ����������");
            body.AppendLine("����" + conFile.Content);

            if (conFile.Additives != null)
            {
                foreach (AdditiveConclusion addConclusion in conFile.Additives)
                {
                    body.AppendLine("����" + Util.Utility.UBB2Html(addConclusion.Content));
                }
            }

            if (!String.IsNullOrEmpty(result.UserInfo.Industry))
            {
                string industryConclusion = Conclusion.GetIndustryConclusion(result.UserInfo.Industry);
                if (!String.IsNullOrEmpty(industryConclusion))
                {
                    body.AppendLine("����" + industryConclusion);
                }
            }

            if (!String.IsNullOrEmpty(conFile.Advice))
            {
                body.AppendLine("\n\nBrandQQ���飺");
                body.AppendLine(conFile.Advice);
            }

            body.AppendLine("\n\n�ر���ʾ��");

            body.AppendLine("1�������ķ������棬������7��ģ��ķ����������ϸ����ʻ����б��棻");
            body.AppendLine("2������������ҵ���ϣ���ѳ�ΪBrandQQ����֤�û��󣬿��Եõ���Ϊ�꾡�ķ���𰸣������ͼ�ֵ3000Ԫ�������桶�й���ҵƷ�ƹ���������Ƥ�顷 ��");
            body.AppendLine("3������������µ�ժҪ�桶�й���ҵƷ�ƹ���������Ƥ�顷 http://brandqq.brandmanager.com.cn/bmi \n");
            body.AppendLine("-----------------------");
            body.AppendLine("����BrandQQ�ĵ�¼�ʻ��ǣ�" + Member.Instance.Email + "��������������룬������http://brandqq.brandmanager.com.cn/login.aspx�һأ�");

            body.AppendLine("\nBrandQQ http://brandqq.brandmanager.com.cn\n\n");
            body.AppendLine("BrandQQ���ٷ�Ӧ���� "+DateTime.Now.ToString());

            Email.SendMail(Member.Instance.Email, "����BrandQQ��Ʒ�ƹ����������Խ��("+DateTime.Now.ToShortDateString()+")", body.ToString(), false, GeneralConfig.MailSenderInstance);
        }
    }
}
