<%@ Page Language="C#" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<script runat="server">
    private ResultFile result;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Member.TempInfo == null)
        {
            Response.Write("您的信息意外丢失，操作不能继续！");
            Response.End();
        }
        if (String.IsNullOrEmpty(Member.TempInfo.PaperSN) || String.IsNullOrEmpty(Member.TempInfo.Guid) || !ResultFile.ExistsFile(Member.TempInfo.ResultId))
        {
            MultiView.Visible = false;
            ErrorMessage.InnerHtml = "您的信息意外丢失，操作不能继续！";
        }
        
        if (!IsPostBack)
        {
            foreach (Industry indus in IndustryUtil.GetChildren("100000"))
            {
                ComIndustry.Items.Add(new ListItem(indus.Name, indus.Code));
            }

            foreach (Industry indus in IndustryUtil.GetChildren("110000"))
            {
                ComIndustry.Items.Add(new ListItem(indus.Name, indus.Code));
            }

            foreach (Industry indus in IndustryUtil.GetChildren("120000"))
            {
                ComIndustry.Items.Add(new ListItem(indus.Name, indus.Code));
            }

            foreach (Industry indus in IndustryUtil.GetChildren("130000"))
            {
                ComIndustry.Items.Add(new ListItem(indus.Name, indus.Code));
            }
            
            foreach (string s in CompanyNature.Natures.Keys)
            {
                ComNature.Items.Add(new ListItem(CompanyNature.Natures[s].ToString(), s));
            }

            for (int i = 0; i < Company.EmployeeCollection.Count; i++)
            {
                IntRange range = ((IntRange)Company.EmployeeCollection[i]);
                string txt;

                if (i == 0)
                {
                    txt = range.Upper.ToString()+"人以下";
                }
                else if (i == Company.EmployeeCollection.Count - 1)
                {
                    txt = Utility.NumberUnit(range.Lower.ToString(),5) + "人以上";
                }
                else
                {
                    string l, u;
                    if (range.Lower.ToString().Length < 5)
                    {
                        l = Utility.NumberUnit(range.Lower.ToString(), 4);
                    }
                    else
                    {
                        l = Utility.NumberUnit(range.Lower.ToString(), 5);
                    }

                    if (range.Upper.ToString().Length < 5)
                    {
                        u = Utility.NumberUnit(range.Upper.ToString(), 4);
                    }
                    else
                    {
                        u = Utility.NumberUnit(range.Upper.ToString(), 5);
                    }
                    txt = l + " - " + u + "人";
                }

                ComEmployee.Items.Add(new ListItem(txt, i.ToString()));
            }
            
            for (int i = 0; i < Company.TurnoverCollection.Count; i++)
            {
                IntRange range = ((IntRange)Company.TurnoverCollection[i]);

                string txt;

                if (i == 0)
                {
                    txt = Utility.NumberUnit(range.Upper.ToString() + "0000", 7) + "以下";
                }
                else if (i == Company.TurnoverCollection.Count - 1)
                {
                    txt = Utility.NumberUnit(range.Lower.ToString() + "0000", 9) + "以上";
                }
                else
                {
                    string l, u;
                    if (range.Lower.ToString().Length < 4)
                    {
                        l = Utility.NumberUnit(range.Lower.ToString() + "0000", 7);
                    }
                    else if (range.Lower.ToString().Length == 4)
                    {
                        l = Utility.NumberUnit(range.Lower.ToString() + "0000", 8);
                    }
                    else
                    {
                        l = Utility.NumberUnit(range.Lower.ToString() + "0000", 9);
                    }

                    if (range.Upper.ToString().Length < 4)
                    {
                        u = Utility.NumberUnit(range.Upper.ToString() + "0000", 7);
                    }
                    else if (range.Upper.ToString().Length == 4)
                    {
                        u = Utility.NumberUnit(range.Upper.ToString() + "0000", 8);
                    }
                    else
                    {
                        u = Utility.NumberUnit(range.Upper.ToString() + "0000", 9);
                    }
                    txt = l + " - " + u + "";
                }

                ComTurnover.Items.Add(new ListItem(txt, i.ToString()));
            }
        }
    }

    protected void NextButton_Click(object sender, EventArgs e)
    {
        if (!MultiView.Visible)
        {
            Response.Redirect(Member.IsLogined ? "/mybrandqq" : "/login.aspx");
            return;
        }
        
        if (MultiView.ActiveViewIndex > MultiView.Views.Count-1)
        {
            if (Member.IsLogined)
            {
                Response.Redirect("/mybrandqq");
            }
        }
        else
        {
            result = ResultFile.Load(Member.TempInfo.ResultId);
            
            switch (MultiView.ActiveViewIndex)
            {
                case 0://行业
                    result.UserInfo.Industry = ComIndustry.SelectedValue;
                    result.Save();
                    MultiView.ActiveViewIndex++;
                    break;
                case 1://性质
                    result.UserInfo.Nature = ComNature.SelectedValue;
                    result.Save();
                    MultiView.ActiveViewIndex++;
                    break;
                case 2://员工
                    result.UserInfo.Employee = ((IntRange)Company.EmployeeCollection[Convert.ToInt16(ComEmployee.SelectedValue)]);
                    result.Save();
                    MultiView.ActiveViewIndex++;
                    break;
                case 3://营业额
                    result.UserInfo.Turnover = ((IntRange)Company.TurnoverCollection[Convert.ToInt16(ComTurnover.SelectedValue)]);
                    result.Save();
                    MultiView.ActiveViewIndex++;
                    break;
                case 4://名称,联系人以及补充信息
                    result.UserInfo.Name = ComName.Text;
                    result.UserInfo.Contact = ComContact.Text;
                    result.UserInfo.Position = ComPosition.Text;
                    result.UserInfo.Phone = ComPhone.Text;
                    result.Save();
                    //MemberTempInfo.ResetResultId();//清除Cookie的RESULTID
                    MultiView.ActiveViewIndex++;
                    break;
                case 5://注册
                    if (Member.IsExistEmail(Email.Text.Trim()))
                    {
                        RegErrorMessage.InnerHtml = "<img src=\"/skin/blank.gif\" class=\"validFailed\" /> 该邮件地址已经被其他用户使用，请换一个试试！";
                    }
                    else if (Password.Text.Trim().Length < 6 || Password2.Text.Trim().Length < 6)
                    {
                        RegErrorMessage.InnerHtml = "<img src=\"/skin/blank.gif\" class=\"validFailed\" /> 密码至少需要6个字符！";
                    }
                    else if (Password.Text.Trim() != Password2.Text.Trim())
                    {
                        RegErrorMessage.InnerHtml = "<img src=\"/skin/blank.gif\" class=\"validFailed\" /> 两次输入的密码不一致！";
                    }
                    else
                    {
                        result.UserInfo.Email = Email.Text.Trim();
                        Member m = new Member();
                        m.Email = Email.Text.Trim();
                        m.Password = Password.Text.Trim();
                        m.Name = "";
                        m.LastIp = Request.UserHostAddress;
                        int newid = m.Save();
                        if (newid > 0)
                        {
                            result.UserInfo.Id = newid;

                            PaperFile paper = PaperFile.Load(new SerialNumber(Member.TempInfo.PaperSN));
                            ConclusionFile conFile = result.GetConclusion(paper);
                            
                            StringBuilder body = new StringBuilder();
                            body.AppendLine("尊敬的 " + Email.Text + " 您好！\n恭喜您成为BrandQQ用户，以下是您在BrandQQ.com的帐户信息:\n\n帐户:" + Email.Text.Trim() + "\n\n密码:" + Password.Text.Trim());
                            body.AppendLine("-----------------------\n");

                            body.AppendLine("感谢您参与BrandQQ品牌管理能力测试，现将本次测试结果的概要性总结发送给您。\n");

                            body.AppendLine("-----------------------");
                            body.AppendLine("本次测试得分：" + result.RelativeScore.ToString());
                            body.AppendLine("测试总结：");
                            body.AppendLine(conFile.Content);
                            if (!String.IsNullOrEmpty(conFile.Advice))
                            {
                                body.AppendLine(conFile.Advice);
                            }
                            body.AppendLine("\n\n特别提示：");

                            body.AppendLine("1、完整的分析报告，包括分7大模块的分析，在网上个人帐户里有保存；");
                            body.AppendLine("2、在您完善企业资料，免费成为BrandQQ的认证用户后，可以得到更为详尽的分题答案，并赠送价值3000元的完整版《中国企业品牌管理能力白皮书》 ；");
                            body.AppendLine("3、免费下载最新的摘要版《中国企业品牌管理能力白皮书》 http://www.brandqq.com/bmi \n");
                            body.AppendLine("-----------------------");
                    
                            body.AppendLine("\nBrandQQ http://www.brandqq.com\n\n");
                            body.AppendLine("BrandQQ快速反应中心 " + DateTime.Now.ToString());
                            
                            
                            BrandQQ.Util.Email.SendMail(Email.Text.Trim(), "欢迎您加入BrandQQ.com", body.ToString(),false, GeneralConfig.MailSenderInstance);

                            Company com = new Company();
                            com.Id = newid;
                            com.Industry = result.UserInfo.Industry;
                            com.Nature = result.UserInfo.Nature;
                            com.ComName = result.UserInfo.Name;
                            com.Contact = result.UserInfo.Contact;
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
                                Response.Redirect("/mybrandqq/bmceResultView.aspx?id=" + result.FileId.ToString());
                            }
                            else
                            {
                                ErrorMessage.InnerHtml = "尝试为您自动登录系统时失败，请<a href=/login.aspx>点击这里登录</a>";
                            }
                        }
                        else
                        {
                            ErrorMessage.InnerHtml = "尝试为您创建用户时失败，请<a href=/reg.aspx>点击这里创建用户</a>";
                        }
                        result.Save();
                    }
                    break;
            }
        }
    }
    
    
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="/jscript/String.prototype.js;/jscript/AjaxRequest.js;/jscript/reg.js" Css="/skin/style.css" Title="完成企业基本信息" Keywords="品牌管理,品牌能力,品牌定位与分析" Description="企业品牌管理自助平台" runat="server" />
<body>
    <BrandQQ:PageHeader ID="PageHeader" runat="server" />
    <form id="form1" runat="server">
    <div class="globalLayout">
        <div class="box1">
			<div class="inner">
				<h1>完成企业基本信息</h1>
				<h2>已经创建过BrandQQ用户？<a href="/login.aspx">点击这里登录</a></h2>
				<div class="body">
				    <div class="clrF00" id="ErrorMessage" runat="server"></div>
                    <asp:MultiView ID="MultiView" runat="server" ActiveViewIndex="0">
                        <asp:View ID="View1" runat="server">
                        
                            <div class="clientMsgWarning">如果您已经创建过BrandQQ帐户，您可以跳过下面的步骤，<a href="/login.aspx">直接登录</a>，您的测试结果不会因此而丢失！</div>
                        
                            <strong>请问贵公司是属于以下哪种行业?</strong> <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                                ErrorMessage="* 请选择行业" ControlToValidate="ComIndustry"></asp:RequiredFieldValidator><br />
                            
                            <div class="tabContainor grayTab">
	                        <div class="tabBox">
		                        <ul class="tabs" id="TABS">
			                        <li class="active" onclick="tabClick('10',this);">消费品</li>
			                        <li onclick="tabClick('11',this);">工业品</li>
			                        <li onclick="tabClick('12',this);">原材料</li>
			                        <li onclick="tabClick('13',this);">服务业</li>
		                        </ul>
	                        </div>
                        	
	                        <div class="body" id="CONTAINOR">
                        		<asp:RadioButtonList ID="ComIndustry" runat="server" />
	                        </div>
	                        
	                        <script language="javascript" type="text/javascript">
	                        function tabClick(code)
	                        {
	                            var oRows=document.getElementById("ComIndustry").rows;
	                            var tabsArray=document.getElementById("TABS").getElementsByTagName("li");
	                            
	                            for(var i=0;i<oRows.length;i++)
	                            {
	                                if(oRows[i].cells[0].childNodes[0].value.substring(0,2)==code)
	                                {
    	                                oRows[i].style.display="";
	                                }
	                                else
	                                {
	                                    oRows[i].cells[0].childNodes[0].checked=false;
	                                    oRows[i].style.display="none";
	                                }
	                            }
	                            
	                            for(var i=0;i<tabsArray.length;i++)
	                            {
	                                tabsArray[i].className="";
	                            }
	                            
	                            switch(code)
	                            {
	                                case "10":
	                                    tabsArray[0].className="active";
	                                    break;
                                    case "11":
                                        tabsArray[1].className="active";
                                        break;
                                    case "12":
                                        tabsArray[2].className="active";
                                        break;
                                    case "13":
                                        tabsArray[3].className="active";
                                        break;
	                            }
	                        }
	                        tabClick('10');
	                        </script>
                        </div>
                        <br />
                            
                        </asp:View>
                        
                        <asp:View ID="View2" runat="server">
                            <strong>请问贵公司的性质是属于以下哪一种情况?</strong> <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server"
                                ErrorMessage="* 请选择公司的性质" ControlToValidate="ComNature"></asp:RequiredFieldValidator><br />
                            <asp:RadioButtonList RepeatLayout="Flow" ID="ComNature" runat="server" />
                        </asp:View>
                        
                        <asp:View ID="View3" runat="server">
                            <strong>请问贵公司总共有多少员工? </strong><asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server"
                                ErrorMessage="* 请选择员工数范围" ControlToValidate="ComEmployee"></asp:RequiredFieldValidator><br />
                            <asp:RadioButtonList RepeatLayout="Flow" ID="ComEmployee" runat="server" />
                        </asp:View>
                        
                        <asp:View ID="View4" runat="server">
                            <strong>请问贵公司年营业额属于以下哪一种情况? </strong><asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server"
                                ErrorMessage="* 请选择年营业额范围" ControlToValidate="ComTurnover"></asp:RequiredFieldValidator><br />
                            <asp:RadioButtonList RepeatLayout="Flow" ID="ComTurnover" runat="server" />
                        </asp:View>
                        
                        <asp:View ID="View5" runat="server">
                            <div class="clientMsgWarning">BrandQQ尊重您的隐私，不会在未经您允许的情况下公开您的信息！<a href="/html/privacy.html" target="_blank">了解BrandQQ隐私声明</a></div>
                            <p class="lineheight35">
                            <strong>请输入您的公司名称以及联系信息</strong><br />
                            公司名称：<asp:TextBox ID="ComName" Columns="50" MaxLength="50" runat="server"></asp:TextBox> <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="ComName"></asp:RequiredFieldValidator><br />
                            联 系 人：<asp:TextBox ID="ComContact" MaxLength="10" runat="server"></asp:TextBox> <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="ComContact"></asp:RequiredFieldValidator><br />
                            部　　门：<asp:TextBox ID="ComPosition" MaxLength="15" runat="server"></asp:TextBox> <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" ControlToValidate="ComPosition"></asp:RequiredFieldValidator><br />
                            联系电话：<asp:TextBox ID="ComPhone" MaxLength="20" runat="server"></asp:TextBox> <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator4" runat="server" ErrorMessage="*" ControlToValidate="ComPhone"></asp:RequiredFieldValidator><asp:RegularExpressionValidator
                                ID="RegularExpressionValidator1" runat="server" ErrorMessage="格式:区号-号码,如:021-64481205" ValidationExpression="[0-9\-]{11,20}" ControlToValidate="ComPhone"></asp:RegularExpressionValidator><br />
                            </p>
                            <br />
                            
                        </asp:View>
                        
                        <asp:View ID="View6" runat="server">
                            <p class="lineheight35">
                            <strong>为了方便日后访问，请设定您的登录帐号和密码：</strong><br />
                            如果您曾经创建过用户，您可以直接<a href="/login.aspx">登录</a>，以便查看您的测试结果
                            </p>
                            <p class="lineheight35">
                            登录帐号：<asp:TextBox ID="Email" Columns="30" MaxLength="40" runat="server" onclick="if(!this.value.IsEmail()){this.value='';}">请输入您常用的邮件地址</asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*" ControlToValidate="Email"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator
                                ID="RegularExpressionValidator2" runat="server" ErrorMessage="邮件地址格式不符" ValidationExpression="^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$" ControlToValidate="Email"></asp:RegularExpressionValidator><br />
                            设置密码：<asp:TextBox TextMode="Password" ID="Password" MaxLength="20" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator6" runat="server" ErrorMessage="*" ControlToValidate="Password"></asp:RequiredFieldValidator><br />
                            确认密码：<asp:TextBox TextMode="Password" ID="Password2" MaxLength="20" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*" ControlToValidate="Password2"></asp:RequiredFieldValidator>
                            <br />
                            <p id="RegErrorMessage" class="clrF00" runat="server"></p>
                            
                            </p>
                        </asp:View>
                    </asp:MultiView>
                    <div>
                    <asp:Button ID="NextButton" runat="server" OnClick="NextButton_Click" Text=" 下一步 " CssClass="cmdConfirm" />
                    </div>
                </div>
			</div>
		</div>
    </div>
    </form>
    
    <BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
