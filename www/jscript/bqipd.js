// bqipd.js

onload=function()
{
    if(BrandQQCookie.Exists("BRANDQQ_BQIPD_DOMAIN") && BrandQQCookie.Exists("BRANDQQ_BQIPD_KEYWORDS"))
    {
        var oForm=document.getElementById("BQIPDForm");
        oForm.u.value=BrandQQCookie.Get("BRANDQQ_BQIPD_DOMAIN");
        oForm.q.value=decodeURI(BrandQQCookie.Get("BRANDQQ_BQIPD_KEYWORDS"));
        getBQIPDResult(oForm);
    }
};

function getBQIPDResult(oForm)
{
    var url=oForm.u.value.Trim().toLowerCase().replace("http://","");
    var keywords=oForm.q.value.Trim();
    oForm.u.value=url;
    if(url=="")
    {
        alert("请输入网址！");
        oForm.u.focus();
        return false;
    }
    
    if(!url.IsUrl())
    {
        alert(url+ "的格式不可用！");
        oForm.u.focus();
        return false;
    }
    
    if(url.IsIp())
    {
        alert("不接受IP地址形式！");
        oForm.u.focus();
        return false;
    }
    
    if(keywords=="")
    {
        alert("请输入关键字！");
        oForm.q.focus();
        return false;
    }
    
    var oPannel=document.getElementById("ResultPannel");
    oPannel.innerHTML="<img src='/skin/loading.gif'/> 正在进行诊断，这可能需要1分钟左右，请耐心等候...";
    oForm.cmdBtn.disabled=true;
    oForm.cmdBtn.value="正在诊断...";
    
    var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj)
        {
            var result=new BQIPDResult(reqObj.responseXML);
            oPannel.style.border="1px solid #FFCC00";
            oPannel.style.padding="10px";
            oPannel.style.backgroundColor="#FFFEFB";
            oPannel.style.lineHeight="170%";
            oPannel.innerHTML=result.getHtml();
            oForm.cmdBtn.disabled=false;
            oForm.cmdBtn.value="开始诊断";
            
            BrandQQCookie.Save("BRANDQQ_BQIPD_DOMAIN",url);
            BrandQQCookie.Save("BRANDQQ_BQIPD_KEYWORDS",encodeURI(keywords));
			
			showFollow();
        }
    );
    ajaxRequest.SetLocalForm(oForm);
    ajaxRequest.Post();
    
    return false;
}

function showFollow()
{
	var obj=document.getElementById("FollowLayer");	
	var oForm=document.getElementById("FollowForm");
	
	var pos=fetchOffset(document.getElementById("BQIPDForm"));
	
	obj.style.visibility="visible";
	obj.style.top=(pos.T+25)+"px";
	obj.style.left=(pos.L+500)+"px";
	
	oForm.domain.value=BrandQQCookie.Get("BRANDQQ_BQIPD_DOMAIN");
	oForm.cmd.onclick=function()
	{
		var ajaxRequest=new AjaxRequest("/AjaxPostResponse.aspx",function(reqObj)
			{
				if(reqObj.status==200 && reqObj.responseText.Trim()=="OK")
				{
					oForm.cmd.value="查看记录";
					oForm.cmd.onclick=function()
					{
					    BrandQQCookie.Remove("BRANDQQ_BQIPD_DOMAIN");
					    BrandQQCookie.Remove("BRANDQQ_BQIPD_KEYWORDS");
						location="/mybrandqq";
					};
				}
				else
				{
				    oForm.cmd.value="请先登录";
					oForm.cmd.onclick=function()
					{
						location="/login.aspx";
					};
				}
			}
		);
		ajaxRequest.SetLocalForm(oForm);
		ajaxRequest.Post();
	};
}

function fetchOffset(obj)
{
	var l=obj.offsetLeft;
	var t=obj.offsetTop;
	while((obj=obj.offsetParent)!=null)
	{
		l+=obj.offsetLeft;
		t+=obj.offsetTop;
	}
	return {'L':l,'T':t};
}

/*
表示一次查询的结果
参数：
	response：服务器响应返回
*/
BQIPDResult=function(response)
{
	var cdataNodeIndex=(document.all && navigator.appName!="Opera")?0:1;
		
	//响应内容XML
	this.xml=response;
	this.getGenaral=function()
	{
		if(response.getElementsByTagName("Genaral")[0]==null)
		{
			return {"score":0,"description":''};
		}
		
	    var s=response.getElementsByTagName("Genaral")[0].getAttribute("score");
	    var c=response.getElementsByTagName("Genaral")[0].childNodes[cdataNodeIndex].data;
	    
	    return {"score":s,"description":c};
	};
	
	this.getPagerank=function()
	{
		if(response.getElementsByTagName("PageRank")[0]==null)
		{
			return {"score":0,"description":''};
		}
	    var s=response.getElementsByTagName("PageRank")[0].getAttribute("score");
	    var c=response.getElementsByTagName("PageRank")[0].childNodes[cdataNodeIndex].data;
	    return {"score":s,"description":c};
	};
	
	this.getRecords=function()
	{
		if(response.getElementsByTagName("Records")[0]==null)
		{
			return {"score":0,"description":''};
		}
	    var s=response.getElementsByTagName("Records")[0].getAttribute("score");
	    var c=response.getElementsByTagName("Records")[0].childNodes[cdataNodeIndex].data;
	    return {"score":s,"description":c};
	};
	
	this.getKeyword=function()
	{
		if(response.getElementsByTagName("KeywordRank")[0]==null)
		{
			return {"score":0,"description":''};
		}
	    var s=response.getElementsByTagName("KeywordRank")[0].getAttribute("score");
	    var c=response.getElementsByTagName("KeywordRank")[0].childNodes[cdataNodeIndex].data;
	    return {"score":s,"description":c};
	};
	
	this.getAlexa=function()
	{
		if(response.getElementsByTagName("AlexaRank")[0]==null)
		{
			return {"score":0,"description":''};
		}
	    var s=response.getElementsByTagName("AlexaRank")[0].getAttribute("score");
	    var c=response.getElementsByTagName("AlexaRank")[0].childNodes[cdataNodeIndex].data;
	    return {"score":s,"description":c};
	};
	
	this.getLinkIn=function()
	{
		if(response.getElementsByTagName("LinkIn")[0]==null)
		{
			return {"score":0,"description":''};
		}
	    var s=response.getElementsByTagName("LinkIn")[0].getAttribute("score");
	    var c=response.getElementsByTagName("LinkIn")[0].childNodes[cdataNodeIndex].data;
	    return {"score":s,"description":c};
	};
	
	this.getHtml=function()
	{
	    var str="";
	    str+="<p style=\"font-size:16px;font-weight:bold;color:#F00;\">本次诊断得分："+this.getGenaral().score+"</p>";
        str+="<p style=\"font-size:14px;font-weight:bold;\">【综合评价】</p>";
        str+="<p style=\"text-indent:2em;line-height:160%;\">"+this.getGenaral().description+"</p>";
        
        if(this.getPagerank().description!="")
        {
            str+="<p style=\"font-size:14px;font-weight:bold;\">【Pagerank】</p>";
            str+="<p style=\"text-indent:2em;line-height:160%;\">"+this.getPagerank().description+"</p>";
        }
        
        if(this.getPagerank().description!="")
        {
            str+="<p style=\"font-size:14px;font-weight:bold;\">【搜索引擎收录】</p>";
            str+="<p style=\"text-indent:2em;line-height:160%;\">"+this.getRecords().description+"</p>";
        }
                
        if(this.getKeyword().description!="")
        {
            str+="<p style=\"font-size:14px;font-weight:bold;\">【关键字排名】</p>";
            str+="<p style=\"text-indent:2em;line-height:160%;\">"+this.getKeyword().description+"</p>";
        }
        
        if(this.getAlexa().description!="")
        {
            str+="<p style=\"font-size:14px;font-weight:bold;\">【网站Alexa排名】</p>";
            str+="<p style=\"text-indent:2em;line-height:160%;\">"+this.getAlexa().description+"</p>";
        }
        
        if(this.getLinkIn().description!="")
        {
            str+="<p style=\"font-size:14px;font-weight:bold;\">【反向链接】</p>";
            str+="<p style=\"text-indent:2em;line-height:160%;\">"+this.getLinkIn().description+"</p>";
        }
        return str;
	};
};
