// logoImitation.js
// logo模仿秀功能脚本

function makeLogoImitation(oForm)
{
    if(oForm.logotext.value.Trim()=="")
    {
        alert("请输入Logo文字！");
        oForm.logotext.focus();
        return false;
    }
    
    if(oForm.logotext.value.ContainChinese())
    {
        alert("Logo文字只能使用英文字符或数字");
        oForm.logotext.focus();
        return false;
    }
    
    var checkStyle=false;
    for(var i=0;i<oForm.logostyle.length;i++)
    {
        if(oForm.logostyle[i].checked)
        {
            checkStyle=true;
            break;
        }
    }
    
    if(!checkStyle)
    {
        alert("必须选择一个要模仿的样式！");
        return false;
    }
    
    if(oForm.logoclr_r.value.Trim()=="" || oForm.logoclr_g.value.Trim()=="" || oForm.logoclr_b.value.Trim()=="")
    {
        oForm.logocolor.value="";
    }
    else
    {
        oForm.logocolor.value=oForm.logoclr_r.value.Trim()+"."+oForm.logoclr_g.value.Trim()+"."+oForm.logoclr_b.value.Trim();
    }
    return true;
}

function setColor(r,g,b)
{
    var oForm=document.getElementById("logoISForm");
    oForm.logoclr_r.value=r;
    oForm.logoclr_g.value=g;
    oForm.logoclr_b.value=b;
}

function colorTable()
{
    var clrs=new Array("00","51","102","153","204","255");
    for(var i=0;i<clrs.length;i++)
    {
        for(var j=0;j<clrs.length;j++)
        {
            for(var k=0;k<clrs.length;k++)
            {
                document.write("<span style=\"padding:0px 2px 0px 2px;cursor:pointer;border:1px solid #000;background-color:RGB("+clrs[i]+","+clrs[j]+","+clrs[k]+");\" onclick=\"setColor("+clrs[i]+","+clrs[j]+","+clrs[k]+");\">&nbsp;</span> ");
            }
        }
    }
}

