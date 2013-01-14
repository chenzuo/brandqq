// BMCE入口脚本

document.write("<form id=\"BRANDQQ_BMCE_FORM\" method=\"get\" action=\"http://www.brandqq.com/bmce\" target=\"_blank\" style=\"margin:0px;padding:0px;\">");
document.write("<p>电子邮件：<input name=\"e\" type=\"text\" maxlength=\"50\" size=\"25\" /></p>");
document.write("<p>公司名称：<input name=\"c\" type=\"text\" maxlength=\"50\" size=\"25\" /></p>");
document.write("<p><input name=\"cmd\" type=\"submit\" value=\"开始自测\" /></p>");
document.write("</form>");

var oForm=document.getElementById("BRANDQQ_BMCE_FORM");

oForm.onsubmit=function()
{
    var reg=/^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if(!reg.test(this.e.value))
    {
        alert("请输入电子邮件地址！");
        this.e.focus();
        return false;
    }
    
    if(this.c.value=="")
    {
        alert("请输入公司名称！");
        this.c.focus();
        return false;
    }
    
    return true;
};