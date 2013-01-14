// JScript 文件
var AjaxRequest=function(reqUrl,callback){
    this.requestUrl=reqUrl;
    this.requestCallBack=callback;
    this.AlertWindow=null;
    this.LocalForm=null;
    this.RequestObject=null;
    this.initialize();
};

AjaxRequest.prototype.initialize=function()
{
    if(!!(window.attachEvent && !window.opera))
    {
        this.RequestObject=new ActiveXObject("Microsoft.XMLHTTP");
    }
    else
    {
        this.RequestObject=new XMLHttpRequest();
    }
    
    if(this.RequestObject==null)
    {
        alert("由于您的浏览器限制，某些功能将不可用！请使用IE,Firefox或Netscape浏览");
        return;
    }
};

AjaxRequest.prototype.SetLocalForm=function(oForm)
{
    if(typeof oForm=="object")
    {
        this.LocalForm=oForm;
    }
};

AjaxRequest.prototype.Post=function()
{
    if(this.LocalForm==null)
    {
        alert("使用POST方式，必须设置Form，调用方法SetLocalForm(oForm)！");
        return;
    }
    
    if(this.LocalForm!=null)
    {
        var objReq=this.RequestObject;
        var reqCall=this.requestCallBack;
        this.RequestObject.onreadystatechange=function()
        {
			if(objReq.readyState==4)
    		{
            	reqCall(objReq);
			}
        }
		
        this.RequestObject.open("POST",this.requestUrl,true);
        this.RequestObject.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        this.RequestObject.send(this.GetFormData());
    }
};

AjaxRequest.prototype.Get=function()
{
    var objReq=this.RequestObject;
	var reqCall=this.requestCallBack;
	this.RequestObject.onreadystatechange=function()
	{
		if(objReq.readyState==4)
    	{
			reqCall(objReq);
		}
	}
	
	this.RequestObject.open("GET",this.requestUrl,true);
	this.RequestObject.send(null);
};

AjaxRequest.prototype.GetFormData=function()
{
    var dataString="rnd="+Math.random()+"&";
    for(var i=0;i<this.LocalForm.elements.length;i++)
    {
        var el=this.LocalForm.elements[i];
        var elName=el.name+"";
        var elTagName= el.tagName.toLowerCase();
        
        if(elName!="")
        {
            if(elTagName == "input") 
            {
                var elType=el.type.toLowerCase();
                if(elType == "radio" || elType == "checkbox")
                {
                    if(el.checked)
                    {
                        dataString = dataString + elName + "=" + encodeURIComponent(el.value)+"&";
                    }
                }
                else if(elType == "text" || elType == "hidden" || elType == "password") 
                {
                    dataString = dataString + elName + "=" + encodeURIComponent(el.value)+"&";
                }
            }
            else if(elTagName == "select")
            {
                if(el.options)
                {
                    for(var i=0;i<el.options.length;i++)
                    {
                        if(el.options[i].selected)
                        {
                            dataString = dataString + elName + "="+encodeURIComponent(el.options[i].value)+"&";
                        }
                    }
                }
            }
            else if(elTagName == "textarea") 
            {
                dataString = dataString + elName + "=" + encodeURIComponent(el.value)+"&";
            }  
        }
    }
    //document.write(dataString);
    return dataString;
};

AjaxRequest.prototype.Alert=function(msg,blnclose,w,h)
{
    if(this.AlertWindow==null)
    {
        var pageWidth=document.body.offsetWidth+16;
	    var pageHeight=document.body.scrollHeight+18;
	        
        this.AlertWindow=document.createElement("DIV");
        this.AlertWindow.style.position="absolute";
        this.AlertWindow.id="ForumEditorPopWindow";
        this.AlertWindow.style.left="0";
        this.AlertWindow.style.top="0";
        this.AlertWindow.style.width=pageWidth+"px";   
        this.AlertWindow.style.height=pageHeight+"px";
        
        this.AlertWindow.TitleBar=document.createElement("DIV");
        this.AlertWindow.TitleBar.style.width=w+"px";
        this.AlertWindow.TitleBar.style.height=h+"px";
        this.AlertWindow.TitleBar.style.margin=""+(pageHeight-h)/2+"px auto";
        this.AlertWindow.TitleBar.className="popTitle";
        
        this.AlertWindow.TitleBar.CloseButton=document.createElement("DIV");
        this.AlertWindow.TitleBar.CloseButton.innerHTML="关闭";
        this.AlertWindow.TitleBar.CloseButton.className="popButton";
        this.AlertWindow.TitleBar.CloseButton.style.display="none";
        this.AlertWindow.TitleBar.appendChild(this.AlertWindow.TitleBar.CloseButton);
        
        this.AlertWindow.MessageBox=document.createElement("DIV");
        this.AlertWindow.MessageBox.style.width=w+"px";
        this.AlertWindow.MessageBox.style.height=h+"px";
        this.AlertWindow.MessageBox.style.margin=""+(pageHeight-w)/2+"px auto";
        this.AlertWindow.MessageBox.className="popBody";
        
        this.AlertWindow.appendChild(this.AlertWindow.TitleBar);
        this.AlertWindow.appendChild(this.AlertWindow.MessageBox);
    }
    
    if(blnclose)
    {
        this.AlertWindow.TitleBar.CloseButton.style.display="block";
    }
        
    this.AlertWindow.innerHTML=msg;
    this.MaskSelectElements(true);
    document.body.appendChild(this.AlertWindow);
};



AjaxRequest.prototype.MaskSelectElements=function(visible)
{
    if(document.all)
    {
        var selEles=document.getElementsByTagName("SELECT");
        for(var i=0;i<selEles.length;i++)
        {
            selEles[i].style.visibility=visible?"hidden":"visible";
        }
    }
};
