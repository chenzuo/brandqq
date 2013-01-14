// logoFunctions.js

function addScore(guid,scoreObj,btnObj)
{
    if(BrandQQCookie.Exists("BRANDQQLOGO."+guid))
    {
        return;
    }
    var score=0;
    
    if(scoreObj)
    {
        score=scoreObj.innerHTML.ToInt();
    }
    
    var ajaxRequest=new AjaxRequest("/AjaxGetResponse.aspx?AjaxAction=addlogoscore&g="+guid+"&s="+score,function(reqObj){
        if(reqObj.status==200)
        {
            if(scoreObj)
            {
                scoreObj.innerHTML=reqObj.responseText;
            }
            if(btnObj)
            {
                obj.className="goodLogo2";
                obj.onclick=function(){};
            }
            BrandQQCookie.Save("BRANDQQLOGO."+guid,guid,7);
        }
    });
    ajaxRequest.Get();
}
