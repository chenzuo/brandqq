// Cookies.js
var BrandQQCookie={
    Save:function(name, value, expires, path, domain, secure)
    {
        var strCookie = name + "=" + value;
        if (expires){
            var curTime = new Date();
            curTime.setTime(curTime.getTime() + expires*24*60*60*1000);
            strCookie += "; expires=" + curTime.toGMTString();
        }
        strCookie +=  (path) ? "; path=" + path : ""; 
        strCookie +=  (domain) ? "; domain=" + domain : "";
        strCookie +=  (secure) ? "; secure" : "";
        
        document.cookie = strCookie;
    },
    Get:function(name)
    {
        var strCookies = document.cookie;
        var cookieName = name + "=";  // Cookie名称
        var valueBegin, valueEnd, value;
        valueBegin = strCookies.indexOf(cookieName);
        if (valueBegin == -1) return null;  // 没有此Cookie
        valueEnd = strCookies.indexOf(";", valueBegin);
        if (valueEnd == -1)
        valueEnd = strCookies.length;  // 最後一个Cookie
        value = strCookies.substring(valueBegin+cookieName.length,valueEnd);
        return value;
    },
    Exists:function(name)
    {
        if (BrandQQCookie.Get(name))
            return true;
        else
            return false;
    },
    Remove:function(name, path, domain)
    {
        var strCookie;
        if (BrandQQCookie.Exists(name)){
        strCookie = name + "="; 
        strCookie += (path) ? "; path=" + path : "";
        strCookie += (domain) ? "; domain=" + domain : "";
        strCookie += "; expires=Thu, 01-Jan-70 00:00:01 GMT";
        document.cookie = strCookie;
        }
    }
};