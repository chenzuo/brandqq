// reg.js
function initForm()
{
	var oForm=document.getElementById("registerForm");
	var isValidEmail=true;
	oForm.email.onfocus=function()
	{
		document.getElementById("registerFormTip1").className="activeTip";
		document.getElementById("registerFormTip2").className="grayTip";
		document.getElementById("registerFormTip3").className="grayTip";
	};
	oForm.email.onblur=function()
	{
		if(!this.value.IsEmail())
		{
			document.getElementById("registerFormValid1").className="validFailed";
 			document.getElementById("registerFormMsg1").innerHTML="电子邮件地址不正确";
		}
		else
		{
			document.getElementById("registerFormValid1").className="validWaiting";
 			document.getElementById("registerFormMsg1").innerHTML="正在验证电子邮件地址是否可用...";
			
			var ajaxRequest=new AjaxRequest("/AjaxGetResponse.aspx?AjaxAction=checkEmail&email="+this.value+"&rnd="+Math.random(),function(reqObj){
				if(reqObj.status==200)
				{
					if(reqObj.responseText=="NOTEXISTS")
					{
						document.getElementById("registerFormValid1").className="validOk";
 						document.getElementById("registerFormMsg1").innerHTML="恭喜！电子邮件地址可以使用";
						isValidEmail=true;
					}
					else
					{
						document.getElementById("registerFormValid1").className="validFailed";
 						document.getElementById("registerFormMsg1").innerHTML="抱歉！电子邮件地址已经被使用";	
						isValidEmail=false;
					}
				}
			});
			ajaxRequest.Get();
			
		}
		document.getElementById("registerFormTip1").className="grayTip";
	}
	
	oForm.password.onfocus=function()
	{
		document.getElementById("registerFormTip1").className="grayTip";
		document.getElementById("registerFormTip2").className="activeTip";
		document.getElementById("registerFormTip3").className="grayTip";
	};
	oForm.password.onblur=function()
	{
		if(this.value.Trim().length<6)
		{
			document.getElementById("registerFormValid2").className="validFailed";
 			document.getElementById("registerFormMsg2").innerHTML="密码至少需要6个字符";
		}
		else if(this.value.Trim().ContainEmpty())
		{
			document.getElementById("registerFormValid2").className="validFailed";
 			document.getElementById("registerFormMsg2").innerHTML="密码中不能包含空格";
		}
		else
		{
			document.getElementById("registerFormValid2").className="validOk";
 			document.getElementById("registerFormMsg2").innerHTML="";
		}
		document.getElementById("registerFormTip2").className="grayTip";
	}
	
	oForm.password2.onfocus=function()
	{
		document.getElementById("registerFormTip1").className="grayTip";
		document.getElementById("registerFormTip2").className="grayTip";
		document.getElementById("registerFormTip3").className="activeTip";
	};
	oForm.password2.onblur=function()
	{
		if(this.value.Trim()=="" || this.value.Trim()!=oForm.password.value.Trim())
		{
			document.getElementById("registerFormValid3").className="validFailed";
 			document.getElementById("registerFormMsg3").innerHTML="两次输入的密码不一致";
		}
		else
		{
			document.getElementById("registerFormValid3").className="validOk";
 			document.getElementById("registerFormMsg3").innerHTML="";
		}
		document.getElementById("registerFormTip3").className="grayTip";
	}
	
	oForm.isAgree.onclick=function()
	{
		oForm.cmdSave.disabled=!this.checked;
	}
	
	oForm.onsubmit=function()
	{
		if(!this.email.value.IsEmail())
		{
			document.getElementById("registerFormValid1").className="validFailed";
 			document.getElementById("registerFormMsg1").innerHTML="电子邮件地址不正确";
			this.email.focus();
			return false;
		}
		
		if(!isValidEmail)
		{
			this.email.focus();
			return false;
		}
		
		if(!this.password.value.Trim().length>=6)
		{
			document.getElementById("registerFormValid2").className="validFailed";
 			document.getElementById("registerFormMsg2").innerHTML="密码至少需要6个字符";
			this.password.focus();
			return false;
		}
		
		if(this.password.value.Trim().ContainEmpty())
		{
			document.getElementById("registerFormValid2").className="validFailed";
 			document.getElementById("registerFormMsg2").innerHTML="密码中不能包含空格";
			this.password.focus();
			return false;
		}
		
		if(this.password2.value.Trim()=="" || this.password2.value.Trim()!=this.password.value.Trim())
		{
			document.getElementById("registerFormValid3").className="validFailed";
 			document.getElementById("registerFormMsg3").innerHTML="两次输入的密码不一致";
			this.password2.focus();
			return false;
		}
		
		if(!this.isAgree.checked)
		{
			alert("同意BrandQQ.com用户服务协议 才能提交您的信息");
			this.isAgree.focus();
			return false;
		}
		
		this.cmdSave.value="稍候...";
		this.cmdSave.disabled=true;
		
		var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj){
			if(reqObj.status==200)
			{
				//alert(reqObj.responseText);
				switch(reqObj.responseText.Trim())
				{
					case "EXISTS_EMAIL":
						document.getElementById("registerFormValid1").className="validFailed";
 						document.getElementById("registerFormMsg1").innerHTML="电子邮件地址已经被使用";
						oForm.cmdSave.value="创建用户";
						oForm.cmdSave.disabled=false;
						break;
					case "ERROR_PASS":
						document.getElementById("registerFormValid2").className="validFailed";
 						document.getElementById("registerFormMsg2").innerHTML="两次输入的密码不正确";
						oForm.cmdSave.value="创建用户";
						oForm.cmdSave.disabled=false;
						break;
					case "OK":
						location="/mybrandqq";
						break;
					default:
						oForm.cmdSave.value="创建用户";
						oForm.cmdSave.disabled=false;
						break;
				}
			}
			else
			{
				this.cmdSave.value="创建用户";
				this.cmdSave.disabled=false;
			}
		});
		ajaxRequest.SetLocalForm(this);
		ajaxRequest.Post();
		return false;
	}
}