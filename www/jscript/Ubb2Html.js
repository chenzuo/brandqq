// Ubb2Html.js
//显示SWF动画
function FlashPlayer()
{
    var src="";
    var width="550";
    var height="400";
    switch(arguments.length)
    {
        case 1:
            src=arguments[0].toString();
            break;
            
        case 2:
            src=arguments[0].toString();
            width=arguments[1].toString();
            break;
            
        case 3:
            src=arguments[0].toString();
            width=arguments[1].toString();
            height=arguments[2].toString();
            break;
    }
    
    if(src=="")
    {
        return;
    }
    
    document.write("<embed src=\""+src+"\" width=\""+width+"\" height=\""+height+"\" quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\" menu=\"false\"></embed>");
}

///显示FLV视频
function FlvPlayer()
{
    var src="";
    var width="550";
    var height="400";
    switch(arguments.length)
    {
        case 1:
            src=arguments[0].toString();
            break;
            
        case 2:
            src=arguments[0].toString();
            width=arguments[1].toString();
            break;
            
        case 3:
            src=arguments[0].toString();
            width=arguments[1].toString();
            height=arguments[2].toString();
            break;
    }
    
    if(src=="")
    {
        return;
    }
    
    document.write("<embed src=\"/images/FLVPlayer.swf?sk=/images/FLVPlayerSkin.swf&amp;flv="+src+"\" width=\""+width+"\" height=\""+height+"\" quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\" menu=\"false\"></embed>");
}

//显示各种视频格式
function VIDEOPlayer()
{
    var src="";
    var width="550";
    var height="400";
    switch(arguments.length)
    {
        case 1:
            src=arguments[0].toString();
            break;
            
        case 2:
            src=arguments[0].toString();
            width=arguments[1].toString();
            break;
            
        case 3:
            src=arguments[0].toString();
            width=arguments[1].toString();
            height=arguments[2].toString();
            break;
    }
    
    if(src=="")
    {
        return;
    }
    
    if(getPalyerType(src)=="MP")
    {
        document.write("<object classid=\"clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6\" id=\"Mediaplayer\" width=\""+width+"\" height=\""+height+"\">");
        document.write("<param name=\"URL\" value=\""+src+"\">");
        document.write("<param name=\"rate\" value=\"1\">");
        document.write("<param name=\"balance\" value=\"0\">");
        document.write("<param name=\"currentPosition\" value=\"0\">");
        document.write("<param name=\"playCount\" value=\"1\">");
        document.write("<param name=\"autoStar\"t value=\"-1\">");
        document.write("<param name=\"currentMarker\" value=\"0\">");
        document.write("<param name=\"volume\" value=\"100\">");
        document.write("<param name=\"mute\" value=\"0\">");
        document.write("<param name=\"uiMode\" value=\"full\">");
        document.write("<param name=\"stretchToFit\" value=\"0\">");
        document.write("<param name=\"windowlessVideo\" value=\"0\">");
        document.write("<param name=\"enabled\" value=\"-1\">");
        document.write("<param name=\"enableContextMenu\" value=\"-1\">");
        document.write("<param name=\"fullScreen\" value=\"0\">");
        document.write("<param name=\"enableErrorDialogs value=\"0\">");
        document.write("</object>");
    }
    else if(getPalyerType(src)=="RM")
    {
        document.write("<object classid=\"clsid:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA\" id=\"Realplay\" width=\""+width+"\" height=\""+height+"\">");
        document.write("<param name=\"AUTOSTART\" value=\"0\">");
        document.write("<param name=\"SHUFFLE\" value=\"0\">");
        document.write("<param name=\"PREFETCH\" value=\"0\">");
        document.write("<param name=\"NOLABELS\" value=\"0\">");
        document.write("<param name=\"LOOP\" value=\"0\">");
        document.write("<param name=\"SRC\" value=\""+src+"\">");
        document.write("<param name=\"NUMLOOP\" value=\"0\">");
        document.write("<param name=\"CENTER\" value=\"0\">");
        document.write("<param name=\"MAINTAINASPECT\" value=\"0\">");
        document.write("<param name=\"BACKGROUNDCOLOR\" value=\"#000000\">");
        document.write("</object>");
    }
    else if(getPalyerType(src)=="QT")
    {
        document.write("<object classid=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\" id=\"Quicktime\" width=\""+width+"\" height=\""+height+"\">");
        document.write("<param name=\"_ExtentX\" value=\"0\">");
        document.write("<param name=\"_ExtentY\" value=\"0\">");
        document.write("<PARAM name=\"SRC\" VALUE=\""+ src+ "\">");
        document.write("</object>");
    }
}

//显示各种音频格式
function AUDIOPlayer(src)
{
    if(src=="")
    {
        return;
    }
    if(getPalyerType(src)=="MP")
    {
        document.write("<object classid=\"clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6\" id=\"Mediaplayer\" width=\"350\" height=\"68\">");
        document.write("<param name=\"URL\" value=\""+src+"\">");
        document.write("<param name=\"rate\" value=\"1\">");
        document.write("<param name=\"balance\" value=\"0\">");
        document.write("<param name=\"currentPosition\" value=\"0\">");
        document.write("<param name=\"playCount\" value=\"1\">");
        document.write("<param name=\"autoStar\"t value=\"-1\">");
        document.write("<param name=\"currentMarker\" value=\"0\">");
        document.write("<param name=\"volume\" value=\"100\">");
        document.write("<param name=\"mute\" value=\"0\">");
        document.write("<param name=\"uiMode\" value=\"full\">");
        document.write("<param name=\"stretchToFit\" value=\"0\">");
        document.write("<param name=\"windowlessVideo\" value=\"0\">");
        document.write("<param name=\"enabled\" value=\"-1\">");
        document.write("<param name=\"enableContextMenu\" value=\"-1\">");
        document.write("<param name=\"fullScreen\" value=\"0\">");
        document.write("<param name=\"enableErrorDialogs value=\"0\">");
        document.write("</object>");
    }
    else if(getPalyerType(src)=="RM")
    {
        document.write(src);
    }
    else if(getPalyerType(src)=="QT")
    {
        document.write(src);
    }
}

//获取音/视频格式
//return:MP,RM,QT
function getPalyerType(src)
{
    src=src.toLowerCase();
    if(src.EndWith(".wmv") || src.EndWith(".asf") || src.EndWith(".wm") || src.EndWith(".wma") || src.EndWith(".wmd") || src.EndWith(".mpg") || src.EndWith(".mpeg") || src.EndWith(".mp3"))
    {
        return "MP";
    }
    else if(src.EndWith(".rm") || src.EndWith(".rmvb"))
    {
        return "RM";
    }
    else if(src.EndWith(".mov") || src.EndWith(".qt"))
    {
        return "QT";
    }
    return "";
}
