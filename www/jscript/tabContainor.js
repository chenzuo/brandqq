// tabContainor.js
/**
	操作Tab容器
*/

function tabClick(obj)
{
	var objParent=obj.parentNode;
	for(var j=0;j<objParent.getElementsByTagName("LI").length;j++)
	{
		objParent.getElementsByTagName("LI")[j].className="";
	}	
	obj.className="active";
}

function loadTabContent(url)
{
	var oContainor=document.getElementById("AjaxDataContainor");
	if(url.indexOf("?")==-1)
	{
		url=url+"?rnd="+Math.random();
	}
	else
	{
		url=url+"&rnd="+Math.random();
	}
	var ajax=new AjaxRequest(url,function(objReq){
								oContainor.innerHTML=objReq.responseText;
							});
	ajax.Get();
}