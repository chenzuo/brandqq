// mybrandqq.js

//更改用户名字
function updateMyName(obj)
{
	if(obj.value.Trim()=="" || obj.value==obj.defaultValue)
	{
		obj.style.border="1px solid #F3F3F3";
		return;	
	}
	
	obj.readonly=true;
	var ajaxRequest=new AjaxRequest("/AjaxGetResponse.aspx?AjaxAction=updateMyName&name="+obj.value+"&rnd="+Math.random(),function(reqObj){
		if(reqObj.status==200)
		{
			if(reqObj.responseText.Trim()=="OK")
			{
				obj.style.border="1px solid #F3F3F3";
				obj.readonly=false;
				document.getElementById("formValid").className="validOk";
				document.getElementById("formValidMsg").innerHTML="修改成功";
			}
			else
			{
				obj.readonly=false;
				document.getElementById("formValid").className="validFailed";
				document.getElementById("formValidMsg").innerHTML="修改失败";
			}
		}
	});
	ajaxRequest.Get();
}

function updateMyPass(oForm)
{
    var v1=document.getElementById("formValid1");
    var v2=document.getElementById("formValid2");
    var msg1=document.getElementById("formValidMsg1");
    var msg2=document.getElementById("formValidMsg2");
    if(oForm.mypass.value.Trim().length<6)
    {
        v1.className="validFailed";
		msg1.innerHTML="密码至少需要6个字符";
		return;
    }
    
    if(oForm.mypass2.value.Trim().length<6)
    {
        v2.className="validFailed";
		msg2.innerHTML="密码至少需要6个字符";
		return;
    }
    
    if(oForm.mypass.value.Trim()!=oForm.mypass2.value.Trim())
    {
        v2.className="validFailed";
		msg2.innerHTML="两次输入的密码不一致！";
		return;
    }
    
    oForm.cmdUpdatePass.value="稍候...";
    oForm.cmdUpdatePass.disabled=true;
    
    var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj){
	    if(reqObj.status==200)
	    {
	        v1.className="validOk";
		    msg1.innerHTML="密码已更新，请注意查收邮件！";
	    }
	    else
	    {
	        v1.className="validFailed";
		    msg1.innerHTML="密码更新失败！";
		    oForm.cmdUpdatePass.disabled=false;
		    oForm.cmdUpdatePass.value="保存修改";
            
	    }
	});
	ajaxRequest.SetLocalForm(oForm);
	ajaxRequest.Post();
	return;
}

//初始化企业资料表单
function initCompanyForm(ischeck,indus,region,nature,tIndex,eIndex)
{
	var oForm=document.getElementById("CompanyForm");
	
	if(ischeck=="1")
	{
	    oForm.comName.readOnly=true;
	    oForm.comName.onclick=function(){document.getElementById("formValid1").className="validLockActive";};
	    document.getElementById("formValid1").className="validLock";
	    
	    var idx1=oForm.comNature.selectedIndex;
	    oForm.comNature.onchange=function(){this.selectedIndex=idx1;document.getElementById("formValid2").className="validLockActive";};
	    document.getElementById("formValid2").className="validLock";
	    
	    var idx2=oForm.comIndustry.selectedIndex;
	    oForm.comIndustry.onchange=function(){this.selectedIndex=idx2;document.getElementById("formValid3").className="validLockActive";};
	    document.getElementById("formValid3").className="validLock";
	    
	    var idx3=oForm.comRegion.selectedIndex;
	    oForm.comRegion.onchange=function(){this.selectedIndex=idx3;document.getElementById("formValid4").className="validLockActive";};
	    document.getElementById("formValid4").className="validLock";
	    
	    var idx4=oForm.comTurnover.selectedIndex;
	    oForm.comTurnover.onchange=function(){this.selectedIndex=idx4;document.getElementById("formValid6").className="validLockActive";};
	    document.getElementById("formValid6").className="validLock";
	    
	    var idx5=oForm.comEmployee.selectedIndex;
	    oForm.comEmployee.onchange=function(){this.selectedIndex=idx5;document.getElementById("formValid7").className="validLockActive";};
	    document.getElementById("formValid7").className="validLock";
	    
	    oForm.comPhone.readOnly=true;
	    oForm.comPhone.onclick=function(){document.getElementById("formValid10").className="validLockActive";};
	    document.getElementById("formValid10").className="validLock";

	}
	
	for(var i=0;i<oForm.comNature.options.length;i++)
	{
		if(oForm.comNature.options[i].value==nature)
		{
			oForm.comNature.options[i].selected=true;
			break;
		}
	}
	
	for(var i=0;i<oForm.comIndustry.options.length;i++)
	{
		if(oForm.comIndustry.options[i].value==indus)
		{
			oForm.comIndustry.options[i].selected=true;
			break;
		}
	}
	
	for(var i=0;i<oForm.comRegion.options.length;i++)
	{
		if(oForm.comRegion.options[i].value==region)
		{
			oForm.comRegion.options[i].selected=true;
			break;
		}
	}
	
	try
	{  
	    oForm.comTurnover.options[tIndex].selected=true;
	    oForm.comEmployee.options[eIndex].selected=true;
	}
	catch(e)
	{
	    //
	}
	
	//显示测试网址可用性
	oForm.comWebsite.onchange=function()
	{
	    
	}
	
	oForm.onsubmit=function()
	{
		if(this.comName.value.Trim()=="")
		{
		    displayCompanyFormValid(1,false,"企业名称不能为空！");
			this.comName.focus();
			return false;
		}
		
		if(this.comIndustry.selectedIndex==0)
		{
			displayCompanyFormValid(3,false,"请选择贵企业所属行业！");
			this.comIndustry.focus();
			return false;
		}
		
		if(this.comRegion.selectedIndex==0)
		{
			displayCompanyFormValid(4,false,"请选择贵企业所在地区！");
			this.comRegion.focus();
			return false;
		}
		
		if(!this.comYear.value.IsInteger())
		{
			displayCompanyFormValid(5,false,"企业创建年份应该用4位数字填写！");
			this.comYear.focus();
			return false;
		}
		
		if(this.comYear.value>new Date().getFullYear() || this.comYear.value<1800)
		{
			displayCompanyFormValid(5,false,"企业创建年份超出范围[1800-现在]！");
			this.comYear.focus();
			return false;
		}
		
		if(this.comContact.value.Trim()=="")
		{
			displayCompanyFormValid(8,false,"联系人不能为空！");
			this.comContact.focus();
			return false;
		}
		
		if(this.comPhone.value.Trim()=="")
		{
			displayCompanyFormValid(10,false,"联系电话不能为空！");
			this.comPhone.focus();
			return false;
		}
		
		this.comWebsite.value=this.comWebsite.value.replace("http://","");
		
		return true;
	};
}

function displayCompanyFormValid(index,valid,msg)
{
    document.getElementById("formValid"+index).className=valid?"validOk":"validFailed";
    document.getElementById("formValidMsg"+index).innerHTML=msg;
}

function saveResultRemark(objBtn)
{
    if(objBtn.form.Remark.value.Trim()=="")
    {
        objBtn.form.Remark.style.border="1px solid #F00";
        return;
    }
    
    var oPannel=document.getElementById("RemarkPannel");
    objBtn.disabled=true;
    objBtn.value="处理中...";
    var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj){
	    if(reqObj.status==200)
	    {
	        oPannel.innerHTML="您的留言已经成功保存，感谢您的参与！";
	    }
	    else
	    {
	        objBtn.disabled=false;
            objBtn.value="保存留言";
	    }
	});
	ajaxRequest.SetLocalForm(objBtn.form);
	ajaxRequest.Post();
}


function InitShareMyBMCEResultForm()
{
    var oForm=document.getElementById("MyShareForm");
    
    oForm.maillist.onchange=function()
    {
        CheckShareMailList(this);
    };
    
    oForm.mymail.onchange=function()
    {
        if(!this.value.Trim().IsEmail())
        {
            document.getElementById("formValid3").className="validFailed";
            document.getElementById("formValidMsg3").innerHTML="邮件地址不正确！";
        }
        document.getElementById("formValid3").className="validOk";
        document.getElementById("formValidMsg3").innerHTML="";
    };
    
    oForm.message.onchange=function()
    {
        if(this.value.Trim().length>300)
        {
            document.getElementById("formValid2").className="validFailed";
            document.getElementById("formValidMsg2").innerHTML="留言内容不应该超过300字！";
            return;
        }
    }
    
    oForm.onsubmit=function()
    {
        if(!CheckShareMailList(this.maillist))
        {
            return false;
        }
        
        if(this.message.value.Trim().length>300)
        {
            document.getElementById("formValid2").className="validFailed";
            document.getElementById("formValidMsg2").innerHTML="留言内容不应该超过300字！";
            return false;
        }
        
        if(!this.mymail.value.Trim().IsEmail())
        {
            document.getElementById("formValid3").className="validFailed";
            document.getElementById("formValidMsg3").innerHTML="邮件地址不正确！";
            return false;
        }
        
        if(this.maillist.value.toLowerCase().indexOf(this.mymail.value.Trim().toLowerCase())!=-1)
        {
            document.getElementById("formValid1").className="validFailed";
            document.getElementById("formValidMsg1").innerHTML="不能包含您自己的Email！";
            return false;
        }
        
        this.CmdSend.disabled=true;
        this.CmdSend.value="稍候...";
        document.getElementById("MESSAGE").innerHTML="<img src=\"../skin/blank.gif\" alt=\"验证\" class=\"validWaiting\" /> 正在发送...";
        var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj){
		    
		    if(reqObj.status==200)
		    {
		        oForm.maillist.value="";
		        oForm.message.value="";
		        oForm.CmdSend.style.display="none";
		        document.getElementById("MESSAGE").innerHTML="<img src=\"../skin/blank.gif\" alt=\"验证\" class=\"validOk\" /> 分享已经成功发送！";
		        document.getElementById("MESSAGE").innerHTML+=" <a href=bmceResultView.aspx?id="+oForm.result.value.split(",")[2]+">返回到测试结果</a>";
		    }
		    else
		    {
		        oForm.CmdSend.disabled=false;
                oForm.CmdSend.value="发送分享";
		    }
		});
		ajaxRequest.SetLocalForm(this);
		ajaxRequest.Post();
        
        return false;
    };
}

function CheckShareMailList(obj)
{
    if(obj.value.Trim()=="")
    {
        document.getElementById("formValid1").className="validFailed";
        document.getElementById("formValidMsg1").innerHTML="邮件地址不能为空！";
        obj.focus();
        return false;
    }
    
    if(obj.value.Trim().indexOf(";")==-1 && !obj.value.Trim().IsEmail())
    {
        document.getElementById("formValid1").className="validFailed";
        document.getElementById("formValidMsg1").innerHTML="邮件地址不正确！";
        obj.focus();
        return false;
    }
    
    var mailCount=0;
    for(var i=0;i<obj.value.Trim().split(";").length;i++)
    {
        if(obj.value.Trim().split(";")[i]!="")
        {
            mailCount++;
            if(!(obj.value.Trim().split(";")[i]).IsEmail())
            {
                document.getElementById("formValid1").className="validFailed";
                document.getElementById("formValidMsg1").innerHTML="存在错误的邮件地址！";
                obj.focus();
                return false;
            }
        }
        
        if(mailCount>10)
        {
            document.getElementById("formValid1").className="validFailed";
            document.getElementById("formValidMsg1").innerHTML="最多允许10个地址！";
            obj.focus();
            return false;
        }
    }
    document.getElementById("formValid1").className="validOk";
    document.getElementById("formValidMsg1").innerHTML="";
    return true;
}