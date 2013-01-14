<%@ Page Language="C#" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<script runat="server">

    private ResultFile result;
    private int step = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Member.TempInfo == null)
        {
            throw new Exception("您的信息意外丢失，操作不能继续！");
        }
        
        if (String.IsNullOrEmpty(Member.TempInfo.PaperSN) || String.IsNullOrEmpty(Member.TempInfo.Guid) || !ResultFile.ExistsFile(Member.TempInfo.ResultId))
        {
            throw new Exception("您的信息意外丢失，操作不能继续！");
        }

        result = ResultFile.Load(Member.TempInfo.ResultId);

        if (result == null)
        {
            throw new Exception("您的信息意外丢失，操作不能继续！");
        }

        if (Request.Form["email"] != null)
        {
            step = 2;
        }

        if (step==1)
        {
            WizardHandle1();
        }
        else if (step==2)
        {
            WizardHandle2();
        }
        else
        {
            throw new Exception("错误参数！");
        }
    }

    private void WizardHandle1()
    {
        try
        {
            string[] param=Request["params"].Trim().Split(',');
            result.UserInfo.Industry = param[0];
            result.UserInfo.Nature = param[1];
            result.UserInfo.Employee = ((IntRange)Company.EmployeeCollection[Convert.ToInt16(param[2])]);
            result.UserInfo.Turnover = ((IntRange)Company.TurnoverCollection[Convert.ToInt16(param[3])]);
            result.Save();
        }
        catch
        {
            throw;
        }
    }

    private void WizardHandle2()
    {
        if (Request.Form["comname"] != null && Request.Form["contact"] != null && Request.Form["phone"] != null &&
            Request.Form["email"] != null && Request.Form["password"] != null)
        {
            if (String.IsNullOrEmpty(result.UserInfo.Contact) || String.IsNullOrEmpty(result.UserInfo.Phone))
            {
                //result.UserInfo.Name = Server.HtmlEncode(Request.Form["comname"]);
                result.UserInfo.Contact = Server.HtmlEncode(Request.Form["contact"]);
				result.UserInfo.Position="";
                result.UserInfo.Phone = Server.HtmlEncode(Request.Form["phone"]);
                //result.UserInfo.Email = Server.HtmlEncode(Request.Form["email"]);
                result.Save();
            }

            string email = Request.Form["email"].Trim();
            string pass = Request.Form["password"].Trim();
            if (Member.IsExistEmail(email))
            {
                Response.Write(@"该邮件地址已经被其他人使用，请换一个试试！");
                return;
            }

            Member m = new Member();
            m.Email = email;
            m.Password = pass;
            m.Name = "";
            m.LastIp = Request.UserHostAddress;
            int newid = m.Save();
            if (newid > 0)
            {
                result.UserInfo.Id = newid;
                result.Save();

                PaperFile paper = PaperFile.Load(new SerialNumber(Member.TempInfo.PaperSN));
                ConclusionFile conFile = result.GetConclusion(paper);

                StringBuilder body = new StringBuilder();
                body.AppendLine("尊敬的 " + email.Split('@')[0] + " 您好！\n恭喜您成为BrandQQ用户，以下是您在BrandQQ.com的帐户信息:\n\n帐户:" + email + "\n\n密码:" + pass);
                body.AppendLine("-----------------------\n");

                body.AppendLine("感谢您参与BrandQQ品牌管理能力测试，现将本次测试结果的概要性总结发送给您。\n");

                body.AppendLine("-----------------------");
                body.AppendLine("您的品牌管理能力指数 BMI=" + result.RelativeScore.ToString()+" 分\n");
                body.AppendLine("BrandQQ总体评估：");
                body.AppendLine("　　"+conFile.Content);

                if (conFile.Additives!=null)
                {
                    foreach (AdditiveConclusion addConclusion in conFile.Additives)
                    {
                        body.AppendLine("　　" + Utility.UBB2Html(addConclusion.Content));
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
                body.AppendLine("3、免费下载最新的摘要版《中国企业品牌管理能力白皮书》 http://www.brandqq.com/bmi \n");
                body.AppendLine("-----------------------");

                body.AppendLine("\nBrandQQ http://www.brandqq.com\n\n");
                body.AppendLine("BrandQQ快速反应中心 " + DateTime.Now.ToString());


                BrandQQ.Util.Email.SendMail(email, "欢迎您加入BrandQQ.com", body.ToString(), false, GeneralConfig.MailSenderInstance);

                Company com = new Company();
                com.Id = newid;
                com.Industry = result.UserInfo.Industry;
                com.Nature = result.UserInfo.Nature;
                com.ComName = result.UserInfo.Name;
                com.Contact = "";
                com.ContactPos = result.UserInfo.Position;
                com.Employee = result.UserInfo.Employee;
                com.Turnover = result.UserInfo.Turnover;
                com.Region = "";
                com.Phone = result.UserInfo.Phone;
                com.Website = "";
                com.Year = 0;
                com.Fax = "";
                com.BusiType = IndustryUtil.GetBusiType(result.UserInfo.Industry);

                com.Save();

                if (Member.Login(m))
                {
                    Response.Write(@"OK");
                    Response.End();
                    return;
                }
                else
                {
                    Response.Write("尝试为您自动登录系统时失败，请<a href=/login.aspx>点击这里登录</a>");
                    Response.End();
                    return;
                }
            }
            else
            {
                throw new Exception("create account failed");
            }
        }
        else
        {
            throw new Exception("Error parameters");
        }
    }
</script>
