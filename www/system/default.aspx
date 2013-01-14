﻿<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>BrandQQ Management System</title>
<link href="skin/style.css" rel="stylesheet" type="text/css" />
<base target="MainFrame" />

</head>

<body scroll="no">
	<div id="TopContainor" class="clear">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="180"><img src="skin/logo.gif" alt="logo" width="180" height="60" /></td>
				<td valign="bottom">
					<div class="alignRight pad5"><a href="javascript:;" class="whiteLink" onclick="refreshMainFrame();">刷新窗口</a> <a href="javascript:;" class="whiteLink">安全退出</a></div>
					<table border="0" cellpadding="0" cellspacing="0" id="Menus">
						<tr align="center">
							<td nowrap="nowrap" class="active" onclick="globalMenuClick(this,0,'sys/');">系统管理</td>
							<td nowrap="nowrap" onclick="globalMenuClick(this,1,'user/');">用户管理</td>
							<td nowrap="nowrap" onclick="globalMenuClick(this,2,'bmce/newPapers.aspx');">自测系统</td>
							<td nowrap="nowrap" onclick="globalMenuClick(this,3,'logo/?type=1');">Logo系统</td>
							<td nowrap="nowrap" onclick="globalMenuClick(this,4,'slogan/');">Slogan系统</td>
							<td nowrap="nowrap" onclick="globalMenuClick(this,5,'orientation/');">定位系统</td>
							<td nowrap="nowrap" onclick="globalMenuClick(this,6,'bqipd/');">推广诊断系统</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="LeftContainor" class="floatLeft">
		<div id="LeftContainorTitle">当前操作：系统管理</div>
		<ul style="display:block;">
			<li class="active" onclick="subMenuClick(this,'sys/');">系统配置</li>
			<li onclick="subMenuClick(this,'sys/users.aspx');">系统用户管理</li>
		</ul>
		
		<ul style="display:none;">
			<li class="active" onclick="subMenuClick(this,'user/');">用户管理</li>
		</ul>
		
		<ul style="display:none;">
			<li onclick="subMenuClick(this,'bmce/newPapers.aspx');">问卷管理</li>
			<li onclick="subMenuClick(this,'bmce/modules.aspx');">模块管理</li>
			<li onclick="subMenuClick(this,'bmce/questions.aspx');">问题管理</li>
			<li onclick="subMenuClick(this,'bmce/answers.aspx');">答案管理</li>
			<li onclick="subMenuClick(this,'bmce/conclusions1.aspx');">结论管理</li>
			<li class="hr"></li>
			<li onclick="subMenuClick(this,'bmce/specimensTemp.aspx');">样本管理</li>
			<li onclick="subMenuClick(this,'bmce/');">指数发布</li>
			<li class="hr"></li>
			<li onclick="subMenuClick(this,'bmce/bmiDownloads.aspx');">BMI下载</li>
		</ul>
		
		<ul style="display:none;">
			<li class="active" onclick="subMenuClick(this,'logo/?type=1');">Logo作品管理</li>
			<li onclick="subMenuClick(this,'logo/?type=2');">行业Logo管理</li>
			<li onclick="subMenuClick(this,'logo/?type=3');">上传Logo管理</li>
		</ul>
		
		<ul style="display:none;">
			<li class="active" onclick="subMenuClick(this,'');">诊断记录维护</li>
			<li class="active" onclick="subMenuClick(this,'');">SEO信息图片记录</li>
		</ul>
		
		<ul style="display:none;">
			<li class="active" onclick="subMenuClick(this,'');">定位系统</li>
		</ul>
		
		<ul style="display:none;">
			<li class="active" onclick="subMenuClick(this,'bqipd/');">推广诊断系统</li>
		</ul>
		
	</div>
	<div id="MainContainor" class="floatRight">
		<iframe id="MainFrame" name="MainFrame" frameborder="0" scrolling="auto"></iframe>
	</div>
</body>
<script language="javascript" type="text/javascript">
	var oTop=document.getElementById("TopContainor");
	var oLeft=document.getElementById("LeftContainor");
	var oLeftTitle=document.getElementById("LeftContainorTitle");
	var oMain=document.getElementById("MainContainor");
	var oFrame=document.getElementById("MainFrame");
	var Top_Height=60;
	var Left_Width=180;
	
	oTop.style.height=Top_Height+"px";
	oLeft.style.width=Left_Width+"px";
	
	resizeFrame();
	
	window.onresize=resizeFrame;
	
	function resizeFrame()
	{
		oLeft.style.height=(document.body.clientHeight-Top_Height)+"px";
		oMain.style.height=(document.body.clientHeight-Top_Height)+"px";
		oMain.style.width=(document.body.clientWidth-Left_Width)+"px";
		oFrame.style.width=(document.body.clientWidth-Left_Width)+"px";
		oFrame.style.height=(document.body.clientHeight-Top_Height)+"px";
	}
	
	function globalMenuClick(obj,i,url)
	{
		var objParent=obj.parentNode;
		for(var j=0;j<objParent.getElementsByTagName("TD").length;j++)
		{
			objParent.getElementsByTagName("TD")[j].className="";
		}
		obj.className="active";
		
		for(var j=0;j<oLeft.getElementsByTagName("UL").length;j++)
		{
			if(j!=i)
			{
				oLeft.getElementsByTagName("UL")[j].style.display="none";
			}
			else
			{
				oLeft.getElementsByTagName("UL")[j].style.display="block";
			}
		}
		
		oLeftTitle.innerHTML="当前操作："+obj.innerHTML;
		if(url!=null && url!="")
		{
			oFrame.src=url;
		}
	}
	
	function subMenuClick(obj,url)
	{
		var objParent=obj.parentNode;
		for(var j=0;j<objParent.getElementsByTagName("LI").length;j++)
		{
		    if(objParent.getElementsByTagName("LI")[j].className!="hr")
		    {
			    objParent.getElementsByTagName("LI")[j].className="none";
			}
		}
		obj.className="active";
		oFrame.src=url;
	}
	
	function refreshMainFrame()
	{
	    oFrame.contentWindow.location.reload();
	}
	
	//控制刷新事件，仅刷新主框架
	document.onkeypress=function()
	{
	    /*if(!document.all)//IE?
	    {
	        window.captureEvents(Event.KeyPress);
	        //alert(Event.which);
	    }
	    else
	    {
	        alert(event.keyCode);
	        if(key==116)//F5
	        {
	            oFrame.location.reload();
	        }
	    }*/
	}
</script>
</html>
