/*
@ BQIPDAPI.js
@ BrandQQ 互联网推广诊断API
*/

/*
代理程序URL
请根据服务器情况选择适合的代理程序
如：LAMP架构，可选择php版本；Java的可选择jsp版本；.Net可选择aspx版本
*/
var PROXY_URL="BQIPDAPI.aspx";

/*
初始化一个异步请求
*/
AjaxRequest=function(reqUrl,callback){
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


/*
以GET方式发送异步请求
*/
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

/*
表示一个查询
参数：
	u:待查询的域名
	k:查询关键字
	cb:callback函数，形式：function(BQIPDResult result)
返回值：无
示例：
	var query=new BQIPDQuery("domain.com","keywords",function(result){});
*/
BQIPDQuery=function(u,k,cb)
{
	//属性：待查询的域名
	this.url=u;

	//属性：查询关键字
	this.keywords=k;

	//属性：回调函数
	this.callback=cb;
};

/*
异步执行查询
参数：无
返回值：无
示例：
	var query=new BQIPDQuery("domain.com","keywords",function(result){});
	query.Run();
*/
BQIPDQuery.prototype.Run=function()
{
	var call=this.callback;
	var ajaxRequest=new AjaxRequest(PROXY_URL+"?domain="+this.url+"&keywords="+this.keywords,function(reqObj)
		{if(reqObj.status==200)
			{
				var rst=new BQIPDResult(reqObj.responseXML);
				call(rst);
			}
		}
	);
	ajaxRequest.Get();
};


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

/*
服务器响应的字符串表示
*/
BQIPDResult.prototype.toString=function()
{
	return this.html;
};

