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
                    writer.WriteLine("���ؽ���ļ�ʧ�ܣ�");
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
                    writer.WriteLine("<p style=\"line-height:100px;\" class=\"alignCenter\"><img src=\"/images/bmce_unfinish.jpg\" /><br/>���ʾ���δ��ɣ���<a href=\"/bmce\">��������������ʾ�</a></p>");
                    
                    return;
                }

                //��ʾͼ��
                string swfParams = "idx=" + result.RelativeScore.ToString() + "&";
                swfParams += "com=" + (String.IsNullOrEmpty(result.UserInfo.Name) ? "δ����" : HttpContext.Current.Server.UrlEncode(result.UserInfo.Name)) + "&";
                swfParams += "dt=" + result.Update.ToShortDateString() + "&";

                for (int i = 0; i < result.Modules.Count; i++)
                {
                    swfParams += "c" + (i + 1).ToString() + "=" + ((ResultModule)result.Modules[i]).RelativeScore.ToString() + "&";
                }

                writer.WriteLine("<div class=\"chart\">");
                writer.WriteLine("  <h1>Ʒ�ƹ�������ָ������</h1>");
                writer.WriteLine("  <div class=\"alignCenter\">");
                writer.WriteLine("  <script>FlashPlayer('/images/charts/" + paper.SN.ToString() + ".swf?" + swfParams + "',680,450);</script>");
                writer.WriteLine("  </div>");
                writer.WriteLine("</div>");


                if (showDetails == 0)
                {
                    writer.WriteLine("<div class=\"result\">");
                    writer.WriteLine("  <h1>��ʼʱ�䣺" + result.Begin.ToString() + " ������ʱ�䣺" + result.Update.ToString() + " ��ǰ״̬:" + result.Status.ToString() + "<br/> ��Դ:" + result.RefUrl + "</h1>");
                    writer.WriteLine("  <div>��ҵ���ϣ�");

                    writer.WriteLine("      <ul id=\"COMINFO\" style=\"display:;\">");
                    writer.WriteLine("      <li><a href=\"../user/companyDetails.aspx?id=" + result.UserInfo.Id.ToString() + "\">�鿴��ҵ��ϸ��Ϣ</a></li>");
                    writer.WriteLine("      <li>������ҵ��" + IndustryUtil.GetName(result.UserInfo.Industry) + "</li>");
                    writer.WriteLine("      <li>��ҵ���ʣ�" + CompanyNature.Get(result.UserInfo.Nature) + "</li>");
                    writer.WriteLine("      <li>Ա����ģ��" + result.UserInfo.Employee.ToString() + " ��</li>");
                    writer.WriteLine("      <li>��Ӫҵ�" + result.UserInfo.Turnover.ToString() + " ��</li>");
                    writer.WriteLine("      <li>-------------------------------------</li>");
                    writer.WriteLine("      <li>��ʼ���ƣ�" + result.UserInfo.Name + "</li>");
                    writer.WriteLine("      <li>��ʼ�ʼ���" + result.UserInfo.Email + "</li>");

                    if (result.UserInfo.Id > 0)
                    {
                        writer.WriteLine("      <li>ע���ʼ���" + Member.Get(result.UserInfo.Id).Email + "</li>");
                        Company com = Company.Get(result.UserInfo.Id);
                        if (com != null)
                        {
                            writer.WriteLine("      <li>ע�����ƣ�" + com.ComName + "</li>");
                        }
                    }

                    writer.WriteLine("      <li>�� ϵ �ˣ�" + result.UserInfo.Contact + "</li>");
                    writer.WriteLine("      <li>��ϵ�绰��" + result.UserInfo.Phone + "</li>");
                    writer.WriteLine("      <li>���ڲ��ţ�" + result.UserInfo.Position + "</li>");
                    writer.WriteLine("      <li>������飺" + result.UserInfo.Remark + "</li>");
                    writer.WriteLine("      </ul>");
                    
                    writer.WriteLine("  </div>");
                    writer.WriteLine("</div>");
                }

                //�ʾ��ܽ�
                writer.WriteLine("<div class=\"paper\">");
                if (paper.CalcMethod == ScoreCalcMethod.Absolute)
                {
                    writer.WriteLine("  <h1>�ʾ�" + paper.Title + (!showScore ? "<img src=\"/skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />" : "[�÷֣�" + result.RealScore.ToString() + "" + (showDetails == 0 ? "(��Է�:" + result.RelativeScore.ToString() + ")" : "") + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />]") + "</h1>");
                }
                else
                {
                    writer.WriteLine("  <h1>�ʾ�" + paper.Title + (!showScore ? "<img src=\"/skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />" : "[�÷֣�" + result.RelativeScore.ToString() + "" + (showDetails == 0 ? "(���Է�:" + result.RealScore.ToString() + ")" : "") + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + result.GetLevel(paper).ToString() + "\" />]") + "</h1>");
                }
                ConclusionFile conclusion = result.GetConclusion(paper);

                if (showDetails >= 0)
                {
                    writer.WriteLine("<div class=\"conclusion\">���� " + result.Begin.ToString() + " ��ʼ������ԣ��� " + result.Update.ToString() + " ����˲��ԡ�<br/>");
                }

                writer.WriteLine("<div class=\"tag\"><img src=\"/skin/icon_c1.gif\" alt=\"��������\" /></div>");
                writer.WriteLine(conclusion == null ? "" : "����" + Util.Utility.UBB2Html(conclusion.Content));

                if (conclusion.Additives != null)
                {
                    foreach (AdditiveConclusion addConclusion in conclusion.Additives)
                    {
                        writer.WriteLine("<p>" + "����" + Util.Utility.UBB2Html(addConclusion.Content) + "</p>");
                    }
                }

                //��ҵ����
                if (!String.IsNullOrEmpty(industry))
                {
                    string industryConclusion = Conclusion.GetIndustryConclusion(industry);
                    if (!String.IsNullOrEmpty(industryConclusion))
                    {
                        writer.WriteLine("<p>" + "����" + industryConclusion + "</p>");
                    }
                }

                //�������
                if (conclusion != null)
                {
                    if (!String.IsNullOrEmpty(conclusion.Advice))
                    {
                        writer.WriteLine("<p class=\"tag\"><img src=\"/skin/icon_c2.gif\" alt=\"����\" /></p>");
                        writer.WriteLine("����" + Util.Utility.UBB2Html(conclusion.Advice));
                    }
                }

                writer.WriteLine("</div>");
                writer.WriteLine("</div>");

                foreach (ResultModule module in result.Modules)
                {
                    if (showDetails==0)//��ʾϸ��
                    {
                        writer.WriteLine("<div class=\"module\">");
                        writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " [ʵ�ʵ÷�:" + module.RealScore.ToString() + " ��Է�:" + module.RelativeScore.ToString() + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" />]</h1>");

                        writer.WriteLine("  <div class=\"question\">");
                        foreach (ResultQuestion question in module.Questions)
                        {
                            writer.WriteLine("  <h1>���⣺" + question.Title + "</h1>");

                            writer.WriteLine("  <ul>");
                            foreach (ResultAnswer answer in question.Answers)
                            {
                                writer.WriteLine("  <li" + (answer.Checked ? " class=\"checked\"" : "") + ">" + answer.Title + "</li>");
                            }
                            writer.WriteLine("  </ul>");
                        }
                        writer.WriteLine("  </div>");

                        //���ģ�����
                        if (module.Score > 0)
                        {
                            writer.WriteLine("  <div class=\"conclusion\">");
                            writer.WriteLine("  <h1><img src=\"/skin/icon_c3.gif\" alt=\"����\" /></h1>");
                            ConclusionFile cf = module.GetConclusion(paper);
                            if (cf != null)
                            {
                                writer.Write("����" + Util.Utility.UBB2Html(cf.Content));
                            }
                            writer.WriteLine("  </div>");
                        }

                        writer.WriteLine("</div>");
                    }
                    else if (showDetails == 1 && module.Score > 0)//������ʾ������module.Score==0��ģ��
                    {
                        writer.WriteLine("<div class=\"module\">");
                        if (showScore)
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " [�÷�:" + (paper.CalcMethod == ScoreCalcMethod.Relative ? module.RelativeScore.ToString() : module.RealScore.ToString()) + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" />]</h1>");
                        }
                        else
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " <img src=\"/skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" /></h1>");
                        }

                        writer.WriteLine("  <div class=\"question\">");
                        foreach (ResultQuestion question in module.Questions)
                        {
                            writer.WriteLine("  <h1>���⣺" + question.Title + "</h1>");
                            
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
                                writer.WriteLine("  <li>&lt;�޴�&gt;</li>");
                            }
                            writer.WriteLine("  </ul>");
                        }
                        writer.WriteLine("  </div>");

                        //���ģ�����
                        if (module.Score > 0)
                        {
                            writer.WriteLine("  <div class=\"conclusion\">");
                            writer.WriteLine("  <h1><img src=\"/skin/icon_c3.gif\" alt=\"����\" /></h1>");
                            ConclusionFile cf = module.GetConclusion(paper);
                            if (cf != null)
                            {
                                writer.Write("����" + Util.Utility.UBB2Html(cf.Content));
                            }
                            writer.WriteLine("  </div>");
                        }

                        writer.WriteLine("</div>");
                    }
                    else if (showDetails == 2 && module.Score > 0)//�����ʾ������module.Score==0��ģ��
                    {
                        writer.WriteLine("<div class=\"module\">");
                        if (showScore)
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " [�÷�:" + (paper.CalcMethod == ScoreCalcMethod.Relative ? module.RelativeScore.ToString() : module.RealScore.ToString()) + " <img src=\"../skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" />]</h1>");
                        }
                        else
                        {
                            writer.WriteLine("  <h1>" + GetModuleTitle(module.Id) + " <img src=\"/skin/blank.gif\" class=\"scoreLevel_" + module.GetLevel(paper).ToString() + "\" /></h1>");
                        }

                        //���ģ�����
                        if (module.Score > 0)
                        {
                            writer.WriteLine("  <div class=\"conclusion\">");
                            writer.WriteLine("  <h1><img src=\"/skin/icon_c3.gif\" alt=\"����\" /></h1>");
                            ConclusionFile cf = module.GetConclusion(paper);
                            if (cf != null)
                            {
                                writer.Write("����" + Util.Utility.UBB2Html(cf.Content));
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
                        writer.WriteLine("<div>����������ǵĲ������κ�������߽��飬�Լ��κ����������⣬�����·�����������(300��)��</div>");
                        writer.WriteLine("<div>");
                        writer.WriteLine("<textarea name=\"Remark\" rows=\"5\" cols=\"50\"></textarea>");
                        writer.WriteLine("</div>");
                        writer.WriteLine("<div class=\"alignCenter\">");
                        writer.WriteLine("<input type=\"hidden\" name=\"ResultSN\" value=\""+result.SN.ToString()+"\" />");
                        writer.WriteLine("<input type=\"hidden\" name=\"ResultGuid\" value=\""+result.Guid+"\" />");
                        writer.WriteLine("<input type=\"hidden\" name=\"AjaxAction\" value=\"saveResultRemark\" />");
                        writer.WriteLine("<input type=\"button\" name=\"CmdSaveRemark\" value=\"��������\" class=\"cmdConfirm\" onclick=\"saveResultRemark(this);\" />");
                        writer.WriteLine("</div>");
                        writer.WriteLine("</div>");
                    }
                }

            }
            else
            {
                writer.WriteLine("δ�ҵ���صĽ���ļ���");
            }
        }

        private string GetModuleTitle(int mid)
        {
            string t = "��˾Ʒ�ƹ���� ";
            switch (mid)
            {
                case 45:
                    t += "Ʒ����ʶָ��(AI)����Ϊ��";
                    break;
                case 46:
                    t += "Ʒ��ս��ָ��(SI)����Ϊ��";
                    break;
                case 47:
                    t += "Ʒ����ָ֯��(OI)����Ϊ��";
                    break;
                case 48:
                    t += "������ָ��(CI)����Ϊ��";
                    break;
                case 49:
                    t += "��Ʒ��ָ��(PI)����Ϊ��";
                    break;
                case 50:
                    t += "������ָ��(II)����Ϊ��";
                    break;
                case 51:
                    t += "�����ָ��(TI)����Ϊ��";
                    break;
                case 52:
                    t += "Ʒ������";
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
        /// ��ʾϸ�ڿ��ƣ�0:��ʾȫ��;1:��ʾ�������ѡ��;2:����ʾģ�鼰������
        /// </summary>
        public int ShowDetails
        {
            set
            {
                showDetails = value;
            }
        }

        /// <summary>
        /// ָʾ�Ƿ���ʾ�÷�,false��ʾ�ȼ�,true��ʾ�÷ֺ͵ȼ�
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
