<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Logo" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader1" Jscript="" Css="../skin/style.css" Title="自助在线Logo设计 - BrandQQ - 中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,品牌管理能力指数" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader1" runat="server" />
	<div class="globalLayout">
	    <div class="leftLayout">
		    <div class="box1">
			    <div class="inner">
				    <h1>欢迎进入Logo系统</h1>
				    <h2></h2>
				    <div class="body">
    				    <a href="flex" target="_blank">
					    <img src="../images/ads/logoSys.jpg" alt="在线Logo设计" style="border:none;" />
					    </a>
				    </div>
    				
			    </div>
		    </div>
		    
		    <div class="box1">
			    <div class="inner">
				    <h1>最新Logo作品</h1>
				    <h2><a href="logolist">更多</a></h2>
				    <div class="body" style="text-align:center;">
				        <ul class="logoThumbnailList">
				            <BrandQQ:LogoList ID="LogoList" Enabled="true" Count="9"
				                RepeatTemplate="<li class='logo'><a href='logoview?{4}{3}{7}{2}.{1}'><img style='border:none' src='img?{4}{3}{7}.{1}' width='120' height='90' alt='{5},{9}'/><br/>{5}</a></li>" runat="server" />
				            <li class="clear"/>
				        </ul>
				        <div class="clear"></div>
				    </div>
			    </div>
		    </div>
		    
    	</div>
		
		
		<div class="rightLayout">
		    <div class="box1">
				<div class="inner">
					<h1>火爆的Logo模仿秀</h1>
					<h2><a href="../logoImitationShow">进入</a></h2>
					<div class="body alignCenter">
					    <a href="../logoImitationShow">
					    <img src="/images/ads/logoImSh.gif" alt="Logo模仿秀" style="border:none;" />
					    </a>
					</div>
				</div>
			</div>
			
		    <div class="box3">
				<div class="inner">
					<h1>Logo ABC</h1>
					<h2>更多</h2>
					<div class="body">
					    <ul>
							<li><a href="http://www.foresight.net.cn/brandlib/read.aspx?id=441" target="_blank">如何让人记住你的品牌--符号?</a></li>
							<li><a href="http://www.foresight.net.cn/brandlib/read.aspx?id=442" target="_blank">如何让人记住你的品牌--名字?</a></li>
							<li><a href="http://www.foresight.net.cn/brandlib/read.aspx?id=443" target="_blank">如何让人记住你的品牌--颜色?</a></li>
							<li><a href="http://www.foresight.net.cn/brandlib/read.aspx?id=444" target="_blank">如何让人永久记住你的品牌?</a></li>
						</ul>
					</div>
				</div>
			</div>
			
			<div class="box2">
				<div class="inner">
					<h1>使用帮助</h1>
					<h2>更多</h2>
					<div class="body">
					    <p><a href="/help/logo.aspx">查看视频演示</a></p>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
