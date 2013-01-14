// login.js
////初始化登录表单
function initForm()
{
	var oForm=document.getElementById("loginForm");
	
	oForm.email.onchange=function()
	{
		if(!this.value.IsEmail())
		{
			document.getElementById("loginFormValid1").className="validFailed";
 			document.getElementById("loginFormMsg1").innerHTML="电子邮件地址不正确";
		}
		else
		{
			document.getElementById("loginFormValid1").className="validOk";
 			document.getElementById("loginFormMsg1").innerHTML="";
		}
	};
	
	oForm.password.onchange=function()
	{
		if(this.value.Trim().length<6)
		{
			document.getElementById("loginFormValid2").className="validFailed";
 			document.getElementById("loginFormMsg2").innerHTML="密码至少需要6个字符";
		}
		else
		{
			document.getElementById("loginFormValid2").className="validOk";
 			document.getElementById("loginFormMsg2").innerHTML="";
		}
	};
	
	oForm.onsubmit=function()
	{
		if(!this.email.value.IsEmail())
		{
			document.getElementById("loginFormValid1").className="validFailed";
 			document.getElementById("loginFormMsg1").innerHTML="电子邮件地址不正确";
			this.email.focus();
			return false;
		}
		
		if(this.password.value.Trim()=="" || this.password.value.Trim().length<6)
		{
			document.getElementById("loginFormValid2").className="validFailed";
 			document.getElementById("loginFormMsg2").innerHTML="密码至少需要6个字符";
			this.password.focus();
			return false;
		}
		
		
		this.cmdLogin.value="稍候...";
		this.cmdLogin.disabled=true;
		
		var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj){
			if(reqObj.status==200)
			{
				if(reqObj.responseText.Trim()=="OK")
				{
				    if(oForm.ref.value.Trim()!="" && oForm.ref.value.toLowerCase().Trim().StartWith("http://www.brandqq.com"))
				    {
				        location=oForm.ref.value;
				    }
				    else
				    {
					    location="/mybrandqq";
					}
				}
				else
				{
				    oForm.getPassEmail.value=oForm.email.value;
					document.getElementById("loginFormValid1").className="validFailed";
 					document.getElementById("loginFormMsg1").innerHTML="电子邮件地址或者密码不正确";
					oForm.cmdLogin.value="登录";
					oForm.cmdLogin.disabled=false;
				}
			}
			else
			{
			    alert(reqObj.responseText);
				oForm.cmdLogin.value="登录";
				oForm.cmdLogin.disabled=false;
			}
		});
		ajaxRequest.SetLocalForm(this);
		ajaxRequest.Post();
		return false;
	};
	
	oForm.getPassEmail.onchange=function()
	{
	    if(!this.value.IsEmail())
		{
			document.getElementById("loginFormValid3").className="validFailed";
 			document.getElementById("loginFormMsg3").innerHTML="电子邮件地址不正确";
 			oForm.cmdSendPass.disabled=true;
		}
		else
		{
			document.getElementById("loginFormValid3").className="validOk";
 			document.getElementById("loginFormMsg3").innerHTML="";
 			oForm.cmdSendPass.disabled=false;
		}
	};
	
	oForm.cmdSendPass.onclick=function()
	{
	    if(!this.form.getPassEmail.value.IsEmail())
		{
			document.getElementById("loginFormValid3").className="validFailed";
 			document.getElementById("loginFormMsg3").innerHTML="电子邮件地址不正确";
 			return;
		}
		
		document.getElementById("loginFormValid3").className="validWaiting";
 		document.getElementById("loginFormMsg3").innerHTML="正在发送邮件！";
 		this.disabled=true;
		var ajaxRequest=new AjaxRequest("/AjaxGetResponse.aspx?AjaxAction=chkGetPassEmail&email="+this.form.getPassEmail.value,function(reqObj){
		    if(reqObj.status==200)
		    {
		        if(reqObj.responseText=="OK")
		        {
		            document.getElementById("loginFormValid3").className="validOk";
 		            document.getElementById("loginFormMsg3").innerHTML="邮件已经发送，请按照邮件中的指示重新设置您的密码！";
		        }
		        else
		        {
		            document.getElementById("loginFormValid3").className="validFailed";
 		            document.getElementById("loginFormMsg3").innerHTML="可能您的邮件地址错误或者不存在，邮件发送失败！";
 		            oForm.cmdSendPass.disabled=false;
		        }
		    }
		    else
		    {
		        document.getElementById("loginFormValid3").className="validFailed";
 		        document.getElementById("loginFormMsg3").innerHTML="可能您的邮件地址错误或者不存在，邮件发送失败！";
 		        oForm.cmdSendPass.disabled=false;
		    }
		});
		ajaxRequest.Get();
	};
}

//初始化重置密码表单
function initResetPassForm()
{
    var oForm=document.getElementById("resetPassForm");
    oForm.onsubmit=function()
    {
        if(this.password.value.Trim().length<6)
        {
            document.getElementById("formValid1").className="validFailed";
 		    document.getElementById("formValidMsg1").innerHTML="密码至少需要6个字符！";
 		    return false;
        }
        if(this.password2.value.Trim().length<6)
        {
            document.getElementById("formValid2").className="validFailed";
 		    document.getElementById("formValidMsg2").innerHTML="密码至少需要6个字符！";
 		    return false;
        }
        if(this.password.value.Trim()!=this.password2.value.Trim())
        {
            document.getElementById("formValid2").className="validFailed";
 		    document.getElementById("formValidMsg2").innerHTML="两次输入的密码不一致,请重新输入！";
 		    return false;
        }
        
        var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj){
            if(reqObj.status==200)
            {
                if(reqObj.responseText=="OK")
                {
                    alert("密码已成功设置,请登录!");
                    location="login.aspx";
                }
                else
                {
                    document.getElementById("formValid1").className="validFailed";
 		            document.getElementById("formValidMsg1").innerHTML="重置密码时发生错误,密码未重置！";
                }
            }
            else
            {
                document.getElementById("formValid1").className="validFailed";
 		        document.getElementById("formValidMsg1").innerHTML="重置密码时发生错误,密码未重置！";
            }
        });
        ajaxRequest.SetLocalForm(this);
        ajaxRequest.Post();
        return false;
    };
}