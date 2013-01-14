<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>

<script runat="server">
    StringBuilder html = new StringBuilder();
    PaperFile pf=null;
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["sn"] != null && Request["aid"] != null && Request["igType"] != null && Request["mid"] != null && Request["qid"] != null)
        {
            try
            {
                SerialNumber sn = new SerialNumber(Request["sn"]);
                pf = PaperFile.Load(sn);
                IgnoreType igType = (IgnoreType)Convert.ToInt16(Request["igType"]);
                int aid = Convert.ToInt32(Request["aid"]);
                int mid = Convert.ToInt32(Request["mid"]);
                int qid = Convert.ToInt32(Request["qid"]);

                AnswerFile af = pf[mid][qid][aid];

                if (af == null)
                {
                    Response.Write("Null");
                    Response.End();
                }
                
                if (igType == IgnoreType.Module)
                {
                    foreach (ModuleFile mf in pf.ModuleFiles)
                    {
                        if (pf[mid][qid].IsLast)//最后一道题
                        {
                            if (mf.OrderNum > pf[mid].OrderNum)
                            {
                                html.AppendLine("<li><input type=\"checkbox\" name=\"answer" + aid.ToString() + "_ignores\" id=\"answer_ignore_" + mf.Id.ToString() + "\" value=\"" + mf.Id.ToString() + "\"" + (af.IgnoreCollection.Contains(mf) ? " checked=\"checked\"" : "") + " /><label for=\"answer_ignore_" + mf.Id.ToString() + "\">" + mf.Title + "</label></li>");
                            }
                        }
                        else
                        {
                            if (mf.OrderNum >= pf[mid].OrderNum)
                            {
                                html.AppendLine("<li><input type=\"checkbox\" name=\"answer" + aid.ToString() + "_ignores\" id=\"answer_ignore_" + mf.Id.ToString() + "\" value=\"" + mf.Id.ToString() + "\"" + (af.IgnoreCollection.Contains(mf) ? " checked=\"checked\"" : "") + " /><label for=\"answer_ignore_" + mf.Id.ToString() + "\">" + mf.Title + "</label></li>");
                            }
                        }
                    }
                }
                else if (igType == IgnoreType.Question)
                {
                    foreach (QuestionFile qf in pf[mid].Questions)
                    {
                        if (qf.OrderNum > pf[mid][qid].OrderNum)
                        {
                            html.AppendLine("<li><input type=\"checkbox\" name=\"answer" + aid.ToString() + "_ignores\" id=\"answer_ignore_" + qf.Id.ToString() + "\" value=\"" + qf.Id.ToString() + "\"" + (af.IgnoreCollection.Contains(qf) ? " checked=\"checked\"" : "") + " /><label for=\"answer_ignore_" + qf.Id.ToString() + "\">" + qf.Title + "</label></li>");
                        }
                    }
                }
            }
            catch
            {
                //
            }
        }

        Response.Write(html.ToString() == "" ? "<li>该答案无可忽略的项目</li>" : html.ToString());
    }
</script>