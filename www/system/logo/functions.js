// JScript 文件

function setLogoEnabled(linkObj,guid)
{
    var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=setlogoenabled&guid="+guid,function(requestObj){
		if(requestObj.status==200)
		{
			linkObj.innerHTML=linkObj.innerHTML=="True"?"False":"True"
		}
	});
	ajaxRequest.Get();
}