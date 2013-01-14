// UbbToolBar.js
function UBBToolBar(objId)
{
    document.write("<div id=\"UBBTOOLBAR_"+objId+"\"></div>");
    this.ToolBar=document.getElementById("UBBTOOLBAR_"+objId);
    
    this.TOOL_B=this.CreateTool("B",0);
    this.TOOL_B.onclick=function()
    {
        document.getElementById(objId).value+="[B][/B]";
    };
    this.ToolBar.appendChild(this.TOOL_B);
    
    this.TOOL_I=this.CreateTool("I",-20);
    this.TOOL_I.onclick=function()
    {
        document.getElementById(objId).value+="[I][/I]";
    };
    this.ToolBar.appendChild(this.TOOL_I);
    
    this.TOOL_U=this.CreateTool("U",-40);
    this.TOOL_U.onclick=function()
    {
        document.getElementById(objId).value+="[U][/U]";
    };
    this.ToolBar.appendChild(this.TOOL_U);
    
    this.TOOL_L=this.CreateTool("L",-60);
    this.TOOL_L.onclick=function()
    {
        document.getElementById(objId).value+="[LEFT][/LEFT]";
    };
    this.ToolBar.appendChild(this.TOOL_L);
    
    this.TOOL_C=this.CreateTool("C",-80);
    this.TOOL_C.onclick=function()
    {
        document.getElementById(objId).value+="[CENTER][/CENTER]";
    };
    this.ToolBar.appendChild(this.TOOL_C);
    
    this.TOOL_R=this.CreateTool("R",-100);
    this.TOOL_R.onclick=function()
    {
        document.getElementById(objId).value+="[RIGHT][/RIGHT]";
    };
    this.ToolBar.appendChild(this.TOOL_R);
    
    this.TOOL_IMG=this.CreateTool("IMG",-120);
    this.TOOL_IMG.title="支持3种格式:\n[IMG]图片地址[/IMG]\n[IMG,宽度]图片地址[/IMG]\n[IMG,宽度,高度]图片地址[/IMG]";
    this.TOOL_IMG.onclick=function()
    {
        document.getElementById(objId).value+="[IMG][/IMG]";
    };
    this.ToolBar.appendChild(this.TOOL_IMG);
    
    this.TOOL_SWF=this.CreateTool("SWF",-140);
    this.TOOL_SWF.onclick=function()
    {
        document.getElementById(objId).value+="[SWF][/SWF]";
    };
    this.ToolBar.appendChild(this.TOOL_SWF);
    
    this.TOOL_FLV=this.CreateTool("FLV",-160);
    this.TOOL_FLV.onclick=function()
    {
        document.getElementById(objId).value+="[FLV][/FLV]";
    };
    this.ToolBar.appendChild(this.TOOL_FLV);
    
    this.TOOL_VIDEO=this.CreateTool("VIDEO",-180);
    this.TOOL_VIDEO.onclick=function()
    {
        document.getElementById(objId).value+="[VIDEO][/VIDEO]";
    };
    this.ToolBar.appendChild(this.TOOL_VIDEO);
    
    this.TOOL_AUDIO=this.CreateTool("AUDIO",-200);
    this.TOOL_AUDIO.onclick=function()
    {
        document.getElementById(objId).value+="[AUDIO][/AUDIO]";
    };
    this.ToolBar.appendChild(this.TOOL_AUDIO);
    
    this.TOOL_LINK=this.CreateTool("LINK",-220);
    this.TOOL_LINK.onclick=function()
    {
        document.getElementById(objId).value+="[URL=链接]文字[/URL]";
    };
    this.ToolBar.appendChild(this.TOOL_LINK);
}

UBBToolBar.prototype.CreateTool=function(name,ypos)
{
    var oImage=document.createElement("IMG");
    oImage.src="../skin/blank.gif";
    oImage.style.cursor="pointer";
    oImage.ondrag=function(){return false;};
    oImage.className="ubb_"+name;
    
    oImage.onmouseover=function()
    {
        this.style.backgroundPosition="-22px "+ypos+"px";
    };
    
    oImage.onmouseout=function()
    {
        this.style.backgroundPosition="0px "+ypos+"px";
    };
    
    return oImage;
}

UBBToolBar.prototype.ShowTip=function(obj,str)
{
    if(document.getElementById("UBB_TOOLBAR_TIP"))
    {
        document.getElementById("UBB_TOOLBAR_TIP").innerHTML=str.replace("\n","<br/>");
    }
    else
    {
        var oTip=document.createElement("DIV");
        oTip.id="UBB_TOOLBAR_TIP";
        oTip.style.position="absolute";
        
    }
}