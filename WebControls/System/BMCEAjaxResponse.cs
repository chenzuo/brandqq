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
    /// 处理Ajax请求
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
                    case "deletenewpaper"://删除新问卷
                        result=DeleteNewPaper();
                        break;
                    case "removeeditingpaperfile"://删除新问卷
                        result = RemoveEditingPaperFile();
                        break;
                    case "updatepaperfilecalcmethod"://更新问卷计分方式
                        result = UpdatePaperFileCalcMethod();
                        break;
                    case "updateanswerignore"://更新答案项的忽略规则
                        result = UpdateAnswerIgnore();
                        break;

                    case "updatepaperconclusions"://更新问卷文件的结论
                        result = UpdatePaperConclusions();
                        break;

                    case "updatemoduleconclusions":
                        result = UpdateModuleConclusions();//更新问卷文件中的模块结论
                        break;

                    case "publishpaperfile"://发布问卷文件
                        result = PublishPaperFile();
                        break;

                    case "deleteconsulsion"://删除结论
                        result = DeleteConsulsion();
                        break;

                    case "deleteadditiveconclusion"://删除附加结论
                        result = DeleteAdditiveConclusion();
                        break;

                    case "deletemodule"://删除模块
                        result = DeleteModule();
                        break;
                    case "deletequestion"://删除答案
                        result = DeleteQuestion();
                        break;
                    case "deleteanswer"://删除答案
                        result = DeleteAnswer();
                        break;

                    case "addmoduletopaperfile"://添加模块到问卷文件
                        result = AddModuleToPaperFile();
                        break;
                    case "removemodulefrompaperfile"://从问卷文件中移除模块
                        result = RemoveModuleFromPaperFile();
                        break;
                    case "updatepaperfilemodule"://更新问卷文件中的模块
                        result = UpdatePaperFileModule();
                        break;

                    case "updatequestionitemrange"://更新问题选项数范围
                        result = UpdateQuestionItemRange();
                        break;

                    case "importresultdata"://将结果文件数据导入数据库
                        result = ImportResultData();
                        break;

                    case "deletetempresult"://删除临时结果文件及其状态记录
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
        /// 删除临时结果文件及其状态记录
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
                return @"ok,删除完成";
            }
            return @"failed,删除失败";
        }

        /// <summary>
        /// 将结果文件数据导入数据库SaveToDB
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
                return @"ok,导入完成";
            }
            return @"failed,导入失败";
        }

        /// <summary>
        /// 删除新问卷
        /// </summary>
        private string DeleteNewPaper()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Paper.Remove(pid);
                    return @"ok,删除完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,删除失败";
        }

        /// <summary>
        /// 删除编辑中的问卷文件，并将相应的问卷设置为新问卷状态
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
                    return @"ok,删除完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,删除失败";
        }

        /// <summary>
        /// 更新问卷计分方式
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

                    //设置对应问卷为编辑状态
                    Paper.SetStatus(pf, PaperStatus.Editing);

                    return @"ok,更新问卷计分方式完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,更新问卷计分方式失败";
        }

        /// <summary>
        /// 更新答案项的忽略规则
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
                    return @"ok,更新忽略规则完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,更新忽略规则失败";
        }

        /// <summary>
        /// 发布问卷
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
                    return @"ok,发布问卷完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,发布问卷失败";
        }

        /// <summary>
        /// 删除结论
        /// </summary>
        private string DeleteConsulsion()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Conclusion.Remove(pid);
                    return @"ok,删除完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,删除失败";
        }

        /// <summary>
        /// 删除模块
        /// </summary>
        private string DeleteModule()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Module.Remove(pid);
                    return @"ok,删除完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,删除失败";
        }

        /// <summary>
        /// 添加模块到问卷文件
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

                    //设置对应问卷为编辑状态
                    Paper.SetStatus(pf, PaperStatus.Editing);
                    return @"ok,添加模块完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,添加模块失败";
        }

        /// <summary>
        /// 从问卷文件中移除模块
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

                    //设置对应问卷为编辑状态
                    Paper.SetStatus(pf, PaperStatus.Editing);

                    return @"ok,移除模块完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,移除模块失败";
        }


        /// <summary>
        /// 更新问卷文件中的模块
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
                    //更新权重，得分等级
                    pf.UpdateModule(mid, weight, levels);

                    //检查问题和答案更新
                    ModuleFile module = pf[mid];
                    foreach (Question q in Question.List(mid))
                    {
                        module.AddQuestion(q);
                    }

                    pf.Save();

                    //设置对应问卷为编辑状态
                    Paper.SetStatus(pf, PaperStatus.Editing);

                    return @"ok,更新模块完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,更新模块失败";
        }

        /// <summary>
        /// 删除问题
        /// </summary>
        private string DeleteQuestion()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Question.MoveTo(pid,-1);
                    return @"ok,删除完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,删除失败";
        }


        /// <summary>
        /// 删除答案
        /// </summary>
        private string DeleteAnswer()
        {
            if (Request["param"] != null)
            {
                try
                {
                    int pid = Convert.ToInt32(Request["param"]);
                    Answer.MoveTo(pid, -1);
                    return @"ok,删除完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,删除失败";
        }

        /// <summary>
        /// 更新问题的选项数范围
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
                    return @"ok,更新完成";
                }
                catch
                {
                    //
                }
            }
            return @"failed,更新失败";
        }

        /// <summary>
        /// 更新问卷文件的结论
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
                    return @"ok,更新完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,更新失败";
        }

        /// <summary>
        /// 更新问卷文件中的模块结论
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
                        return "failed,模块不存在";
                    }

                    mf.Conclusions.Clear();
                    foreach (Conclusion con in Module.GetConclusions(mid))
                    {
                        mf.Conclusions.Add(ConclusionFile.Create(con));
                    }
                    mf.Conclusions.Sort(new ConclusionScoreRangeLowerComparer());
                    pf.Save();
                    return @"ok,更新完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,更新失败";
        }

        /// <summary>
        /// 删除附加结论
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
                    return @"ok,删除完成";
                }
                catch
                {
                    throw;
                }
            }
            return @"failed,删除失败";
        }
    }
}
