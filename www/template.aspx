<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>BrandQQ Management System</title>
<link href="skin/style.css" rel="stylesheet" type="text/css" />
</head>

<body>
	<div id="PageHeader" class="clear">
    	<div class="logo"><img src="skin/logo.gif" alt="logo" width="180" height="60" /></div>
		<div id="GlobalMenuContainor">
			<div class="topMenu"><a href="login.aspx">登录</a> <a href="reg.aspx">创建新用户</a></div>
			<ul class="globalMenu">
				<li><a href="/">品牌自测</a></li>
				<li class="active2">我的BrandQQ</li>
			</ul>
		</div>
		<div class="clearLine"></div>
	</div>
	<div class="clearLine"></div>
	
	<div class="globalLayout">
		<form method="post" id="Form" action="">
			<div class="tabContainor grayTab">
				<div class="tabBox">
					<ul class="tabs">
						<li><a href="./">用户首页</a></li>
						<li><a href="myaccount.aspx">基本帐户</a></li>
						<li><a href="mycompany.aspx">企业资料</a></li>
						<li><a href="mybmce.aspx">测试记录</a></li>
						<li class="active">分享</li>
					</ul>
				</div>
				
				<div class="body">
				    
					<div>分享给：
						<input name="textfield" type="text" size="60" maxlength="300" />
						<span class="font12">请输入Email地址，多个地址之间用分号隔开</span></div>
					
					<div>我的留言：</div>
					<div style="padding:5px 20px;">
						<textarea name="textfield2" rows="5"></textarea>
					</div>
					<div class="pad5 alignCenter"></div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="clearLine"></div>
	<div id="Copyright">
		&copy; 2002-2007 BrandQQ.com 迈迪品牌管理 All Rights Reserved
	</div>
</body>
</html>
