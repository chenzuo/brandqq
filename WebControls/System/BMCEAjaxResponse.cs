using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;

using BrandQQ.Membership;
using BrandQQ.BMCE;
using BrandQQ.Util;

namespace BrandQQ.WebControls.System
{
    /// <summary>
    /// ����Ajax����
    /// </summary>
    public class BMCEAjaxResponse:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            if (!Member.IsLogined)
            {
                Response.End();
            }

            if (!Member.Instance.IsSysUser)
            {
                Response.End();
            }

            string result="";
            if (Request["action"] != null)
            {
                switch (Request["action"].ToLower())
                {
                    case "deletenewpaper"://ɾ�����ʾ�
                        result=DeleteNewPaper();
                        break;
                    case "removeeditingpaperfile"://ɾ�����ʾ�
                        result = RemoveEditingPaperFile();
                        break;
                    case "updatepaperfilecalcmethod"://�����ʾ�Ʒַ�ʽ
                        result = UpdatePaperFileCalcMethod();
                        break;
                    case "updateanswerignore"://���´���ĺ��Թ���
                        result = UpdateAnswerIgnore();
                        break;

                    case "updatepaperconclusions"://�����ʾ��ļ��Ľ���
                        result = UpdatePaperConclusions();
                        break;

                    case "updatemoduleconclusions":
                        result = UpdateModuleConclusions();//�����ʾ��ļ��е�ģ�����
                        break;

                    case "publishpaperfile"://�����ʾ��ļ�
                        result = PublishPaperFile();
                        break;

                    case "deleteconsulsion"://ɾ������
                        result = DeleteConsulsion();
                        break;

                    case "deleteadditiveconclusion"://ɾ�����ӽ���
                        result = DeleteAdditiveConclusion();
                        break;

                    case "deletemodule"://ɾ��ģ��
                        result = DeleteModule();
                        break;
                    case "deletequestion"://ɾ����
                        result = DeleteQuestion();
                        break;
                    case "deleteanswer"://ɾ����
                        result = DeleteAnswer();
                        break;

                    case "addmoduletopaperfile"://���ģ�鵽�ʾ��ļ�
                        result = AddModuleToPaperFile();
                        break;
                    case "removemodulefrompaperfile"://���ʾ��ļ����Ƴ�ģ��
                        result = RemoveModuleFromPaperFile();
                        break;
                    case "updatepaperfilemodule"://�����ʾ��ļ��е�ģ��
                        result = UpdatePaperFileModule();
                        break;

                    case "updatequestionitemrange"://��������ѡ������Χ
                        result = UpdateQuestionItemRange();
                        break;

                    case "importresultdata"://������ļ����ݵ������ݿ�
                        result = ImportResultData();
                        break;

                    case "deletetempresult"://ɾ����ʱ����ļ�����״̬��¼
                        result = DeleteTempResult();
                        break;

                    default:
                        result = "";
                        break;
                }
            }

            Response.Write(result);
            Response.End();
        }

        /// <summary>
        /// ɾ����ʱ����ļ�����״̬��¼
        /// </summary>
        /// <returns></returns>
        private string DeleteTempResult()
        {
            if (Request["staId"] != null)
            {
                foreach (string sid in Request["staId"].Split(','))
                {
                    if (!String.IsNullOrEmpty(sid))
                    {
                        ResultFile.Delete(Convert.ToInt32(sid));
                    }
                }
                return @"ok,ɾ�����";
            }
            return @"failed,ɾ��ʧ��";
        }

        /// <summary>
        /// ������ļ����ݵ������ݿ�SaveToDB
        /// </summary>
        /// <returns></returns>
        private string ImportResultData()
        {
            if (Request["staId"] != null)
            {
                foreach(string sid in Request["staId"].Split(','))
                {
                    if (!String.IsNullOrEmpty(sid))
                    {
                        SimpleResultStatusRecord status = Result.GetResultStatus(Convert.ToInt32(sid));
                        string path = GeneralConfig.Instance.PaperResultTempSavePath + status.Id.ToString() + ".rst";
                        ResultFile result = ResultFile.Load(path);
                        result.SaveToDB();
                        result.Status = ResultStatus.Stored;
                        result.Save();
                        Result.SaveResultStatus(result);
                    }
                }
                return @"ok,�������";
            }
            return @"failed,����ʧ��";
        }

        /// <summary>
        /// ɾ�����ʾ�
        /// </summary>
        private string DeleteNewPaper()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Paper.Remove(pid);
                    return @"ok,ɾ�����";
                }
                catch
                {
                    //
                }
            }
            return @"failed,ɾ��ʧ��";
        }

        /// <summary>
        /// ɾ���༭�е��ʾ��ļ���������Ӧ���ʾ�����Ϊ���ʾ�״̬
        /// </summary>
        /// <returns></returns>
        private string RemoveEditingPaperFile()
        {
            if (Request["param"] != null)
            {
                try
                {
                    SerialNumber sn = new SerialNumber(Request["param"]);
                    PaperFile.Remove(sn);
                    return @"ok,ɾ�����";
                }
                catch
                {
                    //
                }
            }
            return @"failed,ɾ��ʧ��";
        }

        /// <summary>
        /// �����ʾ�Ʒַ�ʽ
        /// </summary>
        /// <returns></returns>
        private string UpdatePaperFileCalcMethod()
        {
            if (Request["param"] != null && Request["sn"] != null)
            {
                try
                {
                    ScoreCalcMethod method = (ScoreCalcMethod)Convert.ToInt16(Request["param"]);
                    string sn = Request["sn"];

                    PaperFile pf = PaperFile.Load(new SerialNumber(sn));
                    pf.CalcMethod = method;
                    pf.Save();

                    //���ö�Ӧ�ʾ�Ϊ�༭״̬
                    Paper.SetStatus(pf, PaperStatus.Editing);

                    return @"ok,�����ʾ�Ʒַ�ʽ���";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,�����ʾ�Ʒַ�ʽʧ��";
        }

        /// <summary>
        /// ���´���ĺ��Թ���
        /// </summary>
        /// <returns></returns>
        private string UpdateAnswerIgnore()
        {
            if (Request["sn"] != null && Request["mid"] != null && Request["qid"] != null && Request["aid"] != null && Request["igtype"] != null && Request["param"] != null)
            {
                try
                {
                    SerialNumber sn = new SerialNumber(Request["sn"]);
                    int mid = Convert.ToInt32(Request["mid"]);
                    int qid = Convert.ToInt32(Request["qid"]);
                    int aid = Convert.ToInt32(Request["aid"]);
                    

                    IgnoreType igtype = (IgnoreType)Convert.ToInt16(Request["igtype"]);
                    PaperFile pf = PaperFile.Load(sn);

                    AnswerFile af = pf[mid][qid][aid];

                    if (af != null)
                    {
                        af.Ignore = igtype;
                        if (igtype == IgnoreType.None)
                        {
                            af.IgnoreCollection.Clear();
                        }
                        else
                        {
                            string ids = Request["param"].Trim();
                            if (!String.IsNullOrEmpty(ids))
                            {
                                af.AddIgnoreObject(igtype, ids.IndexOf(',') == -1 ? new string[] { ids } : ids.Split(','));
                            }
                        }
                    }

                    pf.Save();
                    return @"ok,���º��Թ������";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,���º��Թ���ʧ��";
        }

        /// <summary>
        /// �����ʾ�
        /// </summary>
        /// <returns></returns>
        private string PublishPaperFile()
        {
            if (Request["sn"] != null)
            {
                try
                {
                    SerialNumber sn = new SerialNumber(Request["sn"]);
                    Paper.SetStatus(sn, PaperStatus.Published);
                    return @"ok,�����ʾ����";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,�����ʾ�ʧ��";
        }

        /// <summary>
        /// ɾ������
        /// </summary>
        private string DeleteConsulsion()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Conclusion.Remove(pid);
                    return @"ok,ɾ�����";
                }
                catch
                {
                    //
                }
            }
            return @"failed,ɾ��ʧ��";
        }

        /// <summary>
        /// ɾ��ģ��
        /// </summary>
        private string DeleteModule()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Module.Remove(pid);
                    return @"ok,ɾ�����";
                }
                catch
                {
                    //
                }
            }
            return @"failed,ɾ��ʧ��";
        }

        /// <summary>
        /// ���ģ�鵽�ʾ��ļ�
        /// </summary>
        /// <returns></returns>
        private string AddModuleToPaperFile()
        {
            if (Request["param"] != null && Request["sn"] != null)
            {
                try
                {
                    string[] mids = Request["param"].Split(',');
                    string sn = Request["sn"];

                    PaperFile pf = PaperFile.Load(new SerialNumber(sn));
                    foreach (string mid in mids)
                    {
                        pf.AddModule(Convert.ToInt32(mid));
                    }
                    
                    pf.Save();

                    //���ö�Ӧ�ʾ�Ϊ�༭״̬
                    Paper.SetStatus(pf, PaperStatus.Editing);
                    return @"ok,���ģ�����";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,���ģ��ʧ��";
        }

        /// <summary>
        /// ���ʾ��ļ����Ƴ�ģ��
        /// </summary>
        /// <returns></returns>
        private string RemoveModuleFromPaperFile()
        {
            if (Request["sn"] != null && Request["mid"] != null)
            {
                try
                {
                    string sn = Request["sn"];
                    int mid = Convert.ToInt32(Request["mid"]);
                    PaperFile pf = PaperFile.Load(new SerialNumber(sn));

                    pf.RemoveModule(mid);
                    pf.Save();

                    //���ö�Ӧ�ʾ�Ϊ�༭״̬
                    Paper.SetStatus(pf, PaperStatus.Editing);

                    return @"ok,�Ƴ�ģ�����";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,�Ƴ�ģ��ʧ��";
        }


        /// <summary>
        /// �����ʾ��ļ��е�ģ��
        /// </summary>
        /// <returns></returns>
        private string UpdatePaperFileModule()
        {
            if (Request["param"] != null && Request["sn"] != null && Request["mid"] != null)
            {
                try
                {
                    string[] prams = Request["param"].Split(',');
                    int weight=Convert.ToInt16(prams[0]);
                    int[] levels=new int[]{Convert.ToInt16(prams[1]),Convert.ToInt16(prams[2]),Convert.ToInt16(prams[3]),Convert.ToInt16(prams[4])};

                    string sn = Request["sn"];
                    int mid = Convert.ToInt32(Request["mid"]);

                    PaperFile pf = PaperFile.Load(new SerialNumber(sn));
                    //����Ȩ�أ��÷ֵȼ�
                    pf.UpdateModule(mid, weight, levels);

                    //�������ʹ𰸸���
                    ModuleFile module = pf[mid];
                    foreach (Question q in Question.List(mid))
                    {
                        module.AddQuestion(q);
                    }

                    pf.Save();

                    //���ö�Ӧ�ʾ�Ϊ�༭״̬
                    Paper.SetStatus(pf, PaperStatus.Editing);

                    return @"ok,����ģ�����";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,����ģ��ʧ��";
        }

        /// <summary>
        /// ɾ������
        /// </summary>
        private string DeleteQuestion()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Question.MoveTo(pid,-1);
                    return @"ok,ɾ�����";
                }
                catch
                {
                    //
                }
            }
            return @"failed,ɾ��ʧ��";
        }


        /// <summary>
        /// ɾ����
        /// </summary>
        private string DeleteAnswer()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Answer.MoveTo(pid, -1);
                    return @"ok,ɾ�����";
                }
                catch
                {
                    //
                }
            }
            return @"failed,ɾ��ʧ��";
        }

        /// <summary>
        /// ���������ѡ������Χ
        /// </summary>
        /// <returns></returns>
        private string UpdateQuestionItemRange()
        {
            if (Request["sn"] != null && Request["qid"] != null && Request["param"] != null)
            {
                try
                {
                    string sn = Request["sn"].Trim();
                    int qid = Convert.ToInt32(Request["qid"]);
                    int l = Convert.ToInt16(Request["param"].Split(',')[0]);
                    int u = Convert.ToInt16(Request["param"].Split(',')[1]);
                    PaperFile pf = PaperFile.Load(new SerialNumber(sn));
                    pf.UpdateQuestionItemsRange(qid, new BrandQQ.Util.IntRange(l,u));
                    return @"ok,�������";
                }
                catch
                {
                    //
                }
            }
            return @"failed,����ʧ��";
        }

        /// <summary>
        /// �����ʾ��ļ��Ľ���
        /// </summary>
        /// <returns></returns>
        private string UpdatePaperConclusions()
        {
            if (Request["sn"] != null)
            {
                try
                {
                    SerialNumber sn = new SerialNumber(Request["sn"].Trim());
                    PaperFile pf = PaperFile.Load(sn);
                    
                    foreach (Conclusion con in Paper.GetConclusions(sn))
                    {
                        if (!pf.ContainsConclusion(con.Id))
                        {
                            pf.ConclusionFiles.Add(ConclusionFile.Create(con));
                        }
                        else
                        {
                            ConclusionFile cf=pf.GetConclusionFileById(con.Id);
                            cf.Range = con.Range;
                            cf.Content = con.Content;
                            cf.Advice = con.Advice;
                        }
                    }
                    pf.Save();
                    return @"ok,�������";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,����ʧ��";
        }

        /// <summary>
        /// �����ʾ��ļ��е�ģ�����
        /// </summary>
        /// <returns></returns>
        private string UpdateModuleConclusions()
        {
            if (Request["sn"] != null && Request["mid"]!=null)
            {
                try
                {
                    SerialNumber sn = new SerialNumber(Request["sn"].Trim());
                    PaperFile pf = PaperFile.Load(sn);
                    int mid = Convert.ToInt32(Request["mid"]);

                    ModuleFile mf = pf[mid];
                    if (mf == null)
                    {
                        return "failed,ģ�鲻����";
                    }

                    mf.Conclusions.Clear();
                    foreach (Conclusion con in Module.GetConclusions(mid))
                    {
                        mf.Conclusions.Add(ConclusionFile.Create(con));
                    }
                    mf.Conclusions.Sort(new ConclusionScoreRangeLowerComparer());
                    pf.Save();
                    return @"ok,�������";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,����ʧ��";
        }

        /// <summary>
        /// ɾ�����ӽ���
        /// </summary>
        /// <returns></returns>
        private string DeleteAdditiveConclusion()
        {
            if (Request["sn"] != null && Request["conid"] != null && Request["addconid"] != null)
            {
                try
                {
                    SerialNumber sn = new SerialNumber(Request["sn"].Trim());
                    PaperFile pf = PaperFile.Load(sn);
                    ConclusionFile cf = pf.GetConclusionFileById(Convert.ToInt32(Request["conid"]));

                    cf.RemoveAdditive(Request["addconid"]);

                    pf.Save();
                    return @"ok,ɾ�����";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,ɾ��ʧ��";
        }
    }
}
