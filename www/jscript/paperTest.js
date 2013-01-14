// paperTest.js

var oQuestionContainor;
var oLoading;
var oProgress;
var selAnswers="";
var BARWIDTH=400;

//获取下一个问题
function nextQuestion(psn,mid,qid,oBtn)
{
	if(!checkForm(oBtn))
	{
		return;	
	}
	
	oLoading=document.getElementById("LoadingStatusImage");
    oProgress=document.getElementById("ProgressBarImage");
    
    oQuestionContainor=document.getElementById("QuestionContainor");
	
	oBtn.disabled=true;
	oLoading.className="validWaiting";
	
	var ajaxRequest=new AjaxRequest("../bmce/PaperTest.aspx?rnd="+Math.random()+"&selAnswer="+selAnswers,function(reqObj){
		if(reqObj.status==200)
		{
			oBtn.value="下一题";
			oBtn.disabled=false;
			oLoading.className="validComplete";
			
			oQuestionContainor.innerHTML=reqObj.responseText;
			
			if(oBtn.form.questionsCount)
			{
				setProgress(oBtn.form.questionsCount.value,oBtn.form.checkedQuestionsCount.value);
			}
			
			initEffect(oQuestionContainor);
			
			if(reqObj.responseText.indexOf("<!--over logined-->")!=-1)
			{
				/*oQuestionContainor.innerHTML="<p style=\"line-height:100px;\" class=\"alignCenter\"><img src=\"/images/bmce_finish.jpg\" /><br/>恭喜！您已经完成当前问卷的测试，请点击按钮查看您的测试结果</p>";
				oBtn.value="查看结果";
				oBtn.onclick=function()
				{
					
				}*/
				location="/mybrandqq/bmceResultView.aspx?id="+oBtn.form.resultid.value;
			}
			else if(reqObj.responseText.indexOf("<!--over-->")!=-1)
			{
			    initComInfoClip1();
			}
		}
	});
	ajaxRequest.Get();
}

//设置进度条
function setProgress(n,m)
{
    var oForm=document.getElementById("questionnaireForm");
    var oBar=document.getElementById("ProgressBarImage");
    var oDisp=document.getElementById("ProgressDisplay");
    var mArray=new Array(45,46,47,48,49,50,51,52);
    oBar.style.width=(m/n*BARWIDTH)+"px";
    oBar.title=parseInt(m/n*100)+"%";
    
    if(oForm.moduleId)
    {
        for(var i=0;i<mArray.length;i++)
        {
            if(oForm.moduleId.value==mArray[i])
            {
                if(i>=6)
                {
                    oDisp.style.backgroundPosition="0px -"+(i*50)+"px";
                }
                else
                {
                    oDisp.style.backgroundPosition="0px -"+((i+1)*50)+"px";
                }
            }
        }
    }
}


//提交答案前的检查
function checkForm(oBtn)
{
	var chkItems=0;
	if(oBtn.form.selAnswer)
	{
		selAnswers="";
		for(var i=0;i<oBtn.form.selAnswer.length;i++)
		{
			if(oBtn.form.selAnswer[i].checked)
			{
				chkItems++;
				selAnswers+=oBtn.form.selAnswer[i].value+",";
			}
		}
		
		var lower=0;
		var upper=0;
		if(oBtn.form.rangLower)
		{
			lower=parseInt(oBtn.form.rangLower.value);
		}
		if(oBtn.form.rangUpper)
		{
			upper=parseInt(oBtn.form.rangUpper.value);
		}
		
		if(chkItems==0)
		{
			alert("请选择一个答案，然后再答下一道题！");
			return false;
		}
		else if(lower>0 && chkItems<lower)
		{
			alert("该题至少应选择 "+lower+" 项！");
			return false;
		}
		else if(upper>1 && chkItems>upper)
		{
			alert("该题至多只能选择 "+upper+" 项，请重新选择！");
			return false;
		}
	}
	return true;
}

//问题的唯一项答案被选择时发生
function keyItemClick(obj)
{
    for(var i=0;i<obj.form.selAnswer.length;i++)
	{
		if(obj.form.selAnswer[i].value!=obj.value)
		{
		    obj.form.selAnswer[i].checked=false;
			obj.form.selAnswer[i].disabled=obj.checked;
		}
	}
}

//初始答案项的鼠标效果
function initEffect(obj)
{
    try{
        var oUl=obj.getElementsByTagName("UL")[0];
        for(var i=0;i<oUl.childNodes.length;i++)
        {
            var oLi=oUl.childNodes[i];
            oLi.onmouseover=function()
            {
                this.style.background="url(/images/bg_li_h25.gif) left top repeat-x";
            };
            oLi.onmouseout=function()
            {
                this.style.background="";
            };
            oLi.onclick=function()
            {
                var oItem=this.getElementsByTagName("INPUT")[0];
                oItem.click();
            }
        }
    }
    catch(e)
    {
        //
    }
}

//在页面上部显示测试说明
function ShowAlert()
{
    var oAlert=document.getElementById("QuestionnaireAlert");
    
    
    if(!BrandQQCookie.Exists("BrandQQ_BMCE_Show_Alert"))
    {
        var oContent=document.createElement("DIV");
        oContent.style.background="URL(/images/bg_bmce_alert.gif) left top no-repeat";
        oContent.style.height="108px";
        oContent.style.padding="5px 10px 5px 20px";
        oContent.style.fontSize="14px";
        oContent.style.color="#333";
        oContent.style.lineHeight="25px";
        oContent.style.textAlign="left";
        oContent.innerHTML="花费 <strong>5</strong> 分钟时间，对您的品牌管理能力做一次全面评估!<br/>";
        oContent.innerHTML+="您将得到：<strong>一份完整的评估指数，一套系统分析报告，多元提升建议方案</strong>！<br/>";
        
        var oP=document.createElement("P");
        oP.style.textAlign="right";
        oP.style.paddingTop="5px";
        oP.innerHTML="<img src=\"/images/help.gif\" alt=\"关闭提示\" /> <a href=\"/help/bmce.aspx\" target=\"_blank\">查看帮助</a> &nbsp;&nbsp; ";
        
        var oLink=document.createElement("A");
        oLink.href="javascript:;";
        oLink.innerHTML="<img src=\"/images/btn_close.gif\" alt=\"关闭提示\" style=\"border:none;\" /> 我知道了，别再提醒我！";
        oLink.onclick=function()
        {
            oAlert.innerHTML="";
            BrandQQCookie.Save("BrandQQ_BMCE_Show_Alert","1",360);
        };
        
        oP.appendChild(oLink);
        oContent.appendChild(oP);
        oAlert.appendChild(oContent);
    }
}

function ShowComInfoAlert(bln)
{
    
    var pannelHeight=1;
    var oAlert=document.getElementById("QuestionnaireAlert");
    oAlert.innerHTML="";
    if(arguments.length>0)
    {
        return;
    }
    var oContent=document.createElement("DIV");
    oContent.style.background="URL(/images/bg_bmce_alert2.gif) left top no-repeat";
    oContent.style.height=pannelHeight+"px";
    oContent.style.overflow="hidden";
    oContent.style.padding="5px 10px 5px 20px";
    oContent.style.fontSize="14px";
    oContent.style.color="#333";
    oContent.style.lineHeight="25px";
    oContent.style.textAlign="left";
    oContent.innerHTML="<strong>完整,如实填写企业资料的好处：</strong><br/>";
    oContent.innerHTML+="(我们尊重您的隐私，不会在未经您允许的情况下公开您的信息！<a href=\"/html/privacy.html\" target=\"_blank\">了解BrandQQ隐私声明</a>)<br/>";
    oContent.innerHTML+="● 您得到的评估结果将更加准确，BrandQQ给您的提升建议也将更具有针对性！<br/>";
    oContent.innerHTML+="● 更容易成为BrandQQ的认证用户！<br/>";
    oContent.innerHTML+="● 获得 <strong style=\"color:#F00;\">价值3000元</strong> 的《中国企业品牌管理能力白皮书》！ <a href=\"/bmi\" target=\"_blank\">关于白皮书...</a><br/>";
    oContent.innerHTML+="● 有机会获得BrandQQ免费赠送的书籍《品牌知行》！ <a href=\"http://www.foresight.net.cn/ppzx\" target=\"_blank\">关于此书...</a><br/>";
    oAlert.appendChild(oContent);
    
    var interval=setInterval(function(){
        if(pannelHeight<190)
        {
            pannelHeight+=10;
            oContent.style.height=pannelHeight+"px";
        }
        else
        {
            clearInterval(interval);
        }
    },20);
}

function initComInfoClip1()
{
    var oBar=document.getElementById("ProgressBarImage");
    var oDisp=document.getElementById("ProgressDisplay");
    oBar.style.width=(0.98*BARWIDTH)+"px";
    oDisp.style.backgroundPosition="0px -350px";
    oLoading=document.getElementById("LoadingStatusImage");
    oQuestionContainor=document.getElementById("QuestionContainor");
    oLoading.className="validWaiting";
    var oForm=document.getElementById("questionnaireForm");
    var ajaxRequest=new AjaxRequest("/bmce/clip_comInfo.aspx?step=1&rnd="+Math.random(),function(reqObj){
        if(reqObj.status==200)
        {
            oLoading.className="validComplete";
            oQuestionContainor.innerHTML=reqObj.responseText;
            setTimeout(ShowComInfoAlert,2000);
            oForm.cmdStart.value="下一步";         
            oForm.cmdStart.onclick=function()
            {
                submitComInfo1(oForm);
            };
        }
    });
    ajaxRequest.Get();
}

function initComInfoClip2()
{
    var oBar=document.getElementById("ProgressBarImage");
    var oDisp=document.getElementById("ProgressDisplay");
    oBar.style.width=(0.98*BARWIDTH)+"px";
    oDisp.style.backgroundPosition="0px -350px";
    oLoading=document.getElementById("LoadingStatusImage");
    oQuestionContainor=document.getElementById("QuestionContainor");
    oLoading.className="validWaiting";
    var oForm=document.getElementById("questionnaireForm");
    var ajaxRequest=new AjaxRequest("/bmce/clip_comInfo.aspx?step=2&rnd="+Math.random(),function(reqObj){
        if(reqObj.status==200)
        {
            oLoading.className="validComplete";
            oQuestionContainor.innerHTML=reqObj.responseText;
            
            ShowComInfoAlert(false);
            
            //隐藏静态的内容
            document.getElementById("StaticContent").innerHTML="";
            
            oForm.comname.onblur=function()
            {
                if(this.value.Trim()=="")
                {
                    document.getElementById("formValid1").className="validFailed";
                    document.getElementById("formTips1").innerHTML="请输入公司名称！";
                }
                else
                {
                    document.getElementById("formValid1").className="";
                    document.getElementById("formTips1").innerHTML="";
                }
            };
            
            oForm.contact.onblur=function()
            {
                if(this.value.Trim()=="")
                {
                    document.getElementById("formValid2").className="validFailed";
                    document.getElementById("formTips2").innerHTML="请输入联系人的姓名！";
                }
                else
                {
                    document.getElementById("formValid2").className="";
                    document.getElementById("formTips2").innerHTML="";
                }
            };
            
            oForm.phone.onblur=function()
            {
                if(!this.value.Trim().IsPhoneNumber())
                {
                    document.getElementById("formValid3").className="validFailed";
                    document.getElementById("formTips3").innerHTML="请输入联系电话，格式如：021-64481205,021-64481205-220,13888888888";
                }
                else
                {
                    document.getElementById("formValid3").className="";
                    document.getElementById("formTips3").innerHTML="";
                }
            };
            
            oForm.email.onblur=function()
            {
                if(!this.value.IsEmail())
                {
                    document.getElementById("formValid4").className="validFailed";
                    document.getElementById("formTips4").innerHTML="邮件地址格式错误！";
                }
                else
                {
                    document.getElementById("formValid4").className="";
                    document.getElementById("formTips4").innerHTML="";
                }
            };
            
            oForm.password.onblur=function()
            {
                if(this.value.Trim().length<6)
                {
                    document.getElementById("formValid5").className="validFailed";
                    document.getElementById("formTips5").innerHTML="请设置登录密码,至少6个字符！";
                }
                else
                {
                    document.getElementById("formValid5").className="";
                    document.getElementById("formTips5").innerHTML="";
                }
            };
            
            oForm.password2.onblur=function()
            {
                if(this.value.Trim().length<6)
                {
                    document.getElementById("formValid6").className="validFailed";
                    document.getElementById("formTips6").innerHTML="请确认上边输入的密码！";
                }
                else if(this.value.Trim()!=oForm.password.value.Trim())
                {
                    document.getElementById("formValid6").className="validFailed";
                    document.getElementById("formTips6").innerHTML="两次输入的密码不一致！";
                }
                else
                {
                    document.getElementById("formValid6").className="";
                    document.getElementById("formTips6").innerHTML="";
                }
            };
            
            
            oForm.cmdStart.value="完成";      
            oForm.cmdStart.disabled=false;   
            oForm.cmdStart.onclick=function()
            {
                submitComInfo2(oForm);
            };
        }
    });
    ajaxRequest.Get();
}

//提交企业信息，注册信息
function submitComInfo1(oForm)
{
    if(oForm.comIndustry.options[oForm.comIndustry.selectedIndex].value=="")
    {
        document.getElementById("formValid1").className="validFailed";
        document.getElementById("formTips1").innerHTML="请选择行业！";
        return;
    }
    
    if(oForm.comNature.selectedIndex==0)
    {
        document.getElementById("formValid2").className="validFailed";
        document.getElementById("formTips2").innerHTML="请选择企业性质！";
        return;
    }
    
    if(oForm.comEmployee.selectedIndex==0)
    {
        document.getElementById("formValid3").className="validFailed";
        document.getElementById("formTips3").innerHTML="请选择员工数范围！";
        return;
    }
    
    if(oForm.comTurnover.selectedIndex==0)
    {
        document.getElementById("formValid4").className="validFailed";
        document.getElementById("formTips4").innerHTML="请选择年营业额范围！";
        return;
    }
    
    var oParams=new Array();
    oParams.push(oForm.comIndustry.options[oForm.comIndustry.selectedIndex].value);
    oParams.push(oForm.comNature.options[oForm.comNature.selectedIndex].value);
    oParams.push(oForm.comEmployee.options[oForm.comEmployee.selectedIndex].value);
    oParams.push(oForm.comTurnover.options[oForm.comTurnover.selectedIndex].value);
    
    oLoading.className="validWaiting";
    oForm.cmdStart.value="请稍候..."; 
    oForm.cmdStart.disabled=true;
    var ajaxRequest=new AjaxRequest("comInfoWizard.aspx?params="+oParams.toString(),function(reqObj){
        if(reqObj.status==200)
        {
            
            initComInfoClip2();
        }
    });
    ajaxRequest.Get();
}

function submitComInfo2(oForm)
{
    if(oForm.comname.value.Trim()=="")
    {
        document.getElementById("formValid1").className="validFailed";
        document.getElementById("formTips1").innerHTML="请输入公司名称！";
        return;
    }
    
    if(oForm.contact.value.Trim()=="")
    {
        document.getElementById("formValid2").className="validFailed";
        document.getElementById("formTips2").innerHTML="请输入联系人的姓名！";
        return;
    }
    
    if(!oForm.phone.value.Trim().IsPhoneNumber())
    {
        document.getElementById("formValid3").className="validFailed";
        document.getElementById("formTips3").innerHTML="请输入联系电话，格式如：021-64481205,021-64481205-220,13888888888";
        return;
    }
    
    if(!oForm.email.value.Trim().IsEmail())
    {
        document.getElementById("formValid4").className="validFailed";
        document.getElementById("formTips4").innerHTML="邮件地址格式错误！";
        return;
    }
    
    if(oForm.password.value.Trim().length<6)
    {
        document.getElementById("formValid5").className="validFailed";
        document.getElementById("formTips5").innerHTML="请设置登录密码,至少6个字符！";
        return;
    }
    
    if(oForm.password2.value.Trim().length<6 || oForm.password2.value.Trim()!=oForm.password.value.Trim())
    {
        document.getElementById("formValid6").className="validFailed";
        document.getElementById("formTips6").innerHTML="两次输入的密码不一致！";
        return;
    }
    
    oLoading.className="validWaiting";
    oForm.cmdStart.value="请稍候..."; 
    oForm.cmdStart.disabled=true;
    var ajaxRequest=new AjaxRequest("comInfoWizard.aspx?step=2",function(reqObj){
        if(reqObj.status==200)
        {
            oLoading.className="validComplete";
            if(reqObj.responseText.Trim()=="OK")
            {
                location="/mybrandqq/bmceResultView.aspx?id="+oForm.resultid.value;
            }
            else
            {
                document.getElementById("formValid4").className="validFailed";
                document.getElementById("formTips4").innerHTML=reqObj.responseText;
                oForm.cmdStart.value="继续";
                oForm.cmdStart.disabled=false;
            }
        }
        else
        {
            oQuestionContainor.innerHTML="<p class=\"lineheight50 pad5\">抱歉！BrandQQ尝试为您创建帐户时发生错误！</p>";
            oQuestionContainor.innerHTML+="请点击按钮继续创建帐户，以保存并查看您的测试结果！";
            
            oForm.cmdStart.disabled=false;
            oForm.cmdStart.value="继续"; 
            oForm.cmdStart.onclick=function()
            {
                location="/login.aspx";
            };
        }
    });
    ajaxRequest.SetLocalForm(oForm);
    ajaxRequest.Post();
}

function submitStartForm(oForm)
{
    if(!oForm.email.value.IsEmail())
    {
        alert("请填写Email地址，以便我们给您发送评估报告！");
        oForm.email.focus();
        return false;
    }
    
    if(oForm.comname.value.Trim()=="")
    {
        alert("请填写您的公司名称！");
        oForm.comname.focus();
        return false;
    }
    return true;
}

function changeIndustrySelect(seleValue)
{
    var oChild=document.getElementById("IndustrySelect2");
    var oProvider=document.getElementById("IndustrySelect");
    oChild.options.length=0;
    oChild.options.add(new Option("......",""));
    for(var i=0;i<oProvider.options.length;i++)
    {
        if(oProvider.options[i].value!=seleValue && oProvider.options[i].value.substring(0,2)==seleValue.substring(0,2))
        {
            oChild.options.add(new Option(oProvider.options[i].text,oProvider.options[i].value));
        }
    }
}