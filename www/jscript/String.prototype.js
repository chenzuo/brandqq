// String.prototype.js
/*
String.prototype
*/

String.prototype.Trim=function()
{
    return this.replace(/^\s+/,"").replace(/\s+$/,"");
}

String.prototype.HtmlEncode=function()
{
    return this.replace(/\>/g,"&gt;").replace(/\</g,"&lt;");
}

String.prototype.UrlEncode=function()
{
    return encodeURI(this);
}

String.prototype.ClearHtml=function()
{
    return this.replace(/<p[^>]*>|<\/p>|<span[^>]*>|<\/span>|<br>|<br\s*\/>|<font[^>]*>|<\/font>|<body[^>]*>|<\/body>|\s*/gi,"");
}

String.prototype.ClearUBB=function()
{
    return this.replace(/[.+?]|\s*/gi,"");
}

String.prototype.ClearCode=function()
{
    return this.ClearHtml().ClearUBB();
}

String.prototype.IsInteger=function()
{
    var reg=/^\d{1,10}$/;
    return reg.test(this);
}

String.prototype.IsPositiveInteger=function()
{
    var reg=/^[1-9]{1}\d{0,9}$/;
    return reg.test(this);
}

String.prototype.IsChinese=function()
{
    var reg=/^[\u4e00-\u9fa5]+$/;
    return reg.test(this);
}

String.prototype.IsPhoneNumber=function()
{
    var reg=/^[0-9\-]{11,20}$/;
    return reg.test(this);
}

String.prototype.ContainChinese=function()
{
    var reg=/[^\x00-\xff]+/;
    return reg.test(this);
}

String.prototype.ContainEmpty=function()
{
    var reg=/\s+/;
    return reg.test(this);
}

String.prototype.ToInt=function()
{
    return this.replace(/[^0-9]*/g,"").replace(/^0+(\d+)/g,"$1");
}

String.prototype.IsPath=function()
{
    var reg=/^[a-z]\:[^\<\>\|\:\.\?\*\"]*/i;
    return reg.test(this);
}

String.prototype.IsEmail=function()
{
    var reg=/^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return reg.test(this);
}

String.prototype.IsUrl=function()
{
    var reg=/^((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return reg.test(this);
}

String.prototype.IsIp=function()
{
    var reg=/^(\d{1,3}\.){3}\d{1,3}$/;
    return reg.test(this);
}

String.prototype.StartWith=function(str)
{
    try
    {
        if(this.toLowerCase().substring(0,str.length)==str.toLowerCase())
        {
            return true;
        }
    }
    catch(e)
    {
        //
    }
    return false;
}

String.prototype.EndWith=function(str)
{
    try
    {
        var thisStr=this.toLowerCase();
        str=str.toLowerCase();
        if(thisStr.substring(thisStr.indexOf(str))==str)
        {
            return true;
        }
    }
    catch(e)
    {
        //
    }
    return false;
}
