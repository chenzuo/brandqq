<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="../jscript/String.prototype.js;../jscript/AjaxRequest.js;../jscript/Ubb2Html.js;../jscript/paperTest.js;../jscript/Cookies.js" Css="../skin/style.css" Title="指数发布(BMI) - 品牌管理指数 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,品牌管理能力指数" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />

<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	<div class="globalLayout">
	    <div class="leftLayout">
		    <div class="box1">
			    <div class="inner">
				    <h1>品牌管理指数</h1>
				    <h2></h2>
				    <div class="body">
				        <img src="/images/icon_bmi.jpg" alt="品牌管理指数" class="floatLeft" />
    				    <strong>品牌管理指数（BMI）</strong>是基于企业用户自主完成的品牌管理能力的自我评估问卷样本，经过信息验证、分析后产生的有关企业品牌管理能力的量化评估报告。
    				    <div class="clear"></div>
				    </div>
    				
			    </div>
		    </div>
		    
		    <div class="box1">
			    <div class="inner">
				    <h1>发布机构</h1>
				    <h2></h2>
				    <div class="body">
				        <img src="/images/icon_bmi_foresight.jpg" alt="迈迪品牌管理研究院" class="floatLeft" />
    				    <strong>“品牌管理指数（BMI）”</strong>由迈迪品牌管理研究院参照成熟企业的品牌管理体系，充分考虑到不同行业、不同类型企业的差异性而进行研发的成果；由迈迪品牌管理咨询公司提供专业支持。
				        <div class="clear"></div>
				    </div>
    				
			    </div>
		    </div>
		    
		    <div class="box1">
			    <div class="inner">
				    <h1>发布方式</h1>
				    <h2></h2>
				    <div class="body">
    				    <p><strong>1、周期</strong></p>
                        <p><strong>“品牌管理指数”</strong>按季度发布，在一个季度的时间内采集样本数据，并进行数据验证；在每季度结束后2周内综合样本数据并形成指数报告。</p>
                        <p><strong>2、形式</strong></p>
                        <p>品牌管理指数采用书面报告的形式对外发布。</p>

                        <p><strong>3、发布渠道</strong></p>
                        <p><a href="http://www.brandqq.com">BrandQQ(www.brandqq.com)</a></p>
                        <p>同步发布平台</p>
                        <ul style="margin-left:50px;">
                            <li><a href="http://www.foresight.net.cn" target="_blank">迈迪公司网站</a></li>
                            <li><a href="http://www.brandmanager.com.cn" target="_blank">品牌经理人网站</a></li>
                            <li><a href="http://www.vsharing.com" target="_blank">畅享网</a></li>
                        </ul>
				    </div>
    				
			    </div>
		    </div>
		</div>
		
		
		<div class="rightLayout">
		    <div class="box2">
				<div class="inner">
					<h1>下载</h1>
					<h2></h2>
					<div class="alignCenter lineheight25">
					    中国企业品牌管理能力白皮书<br />
					    品牌管理指数(<strong>第2期</strong>)
					</div>
					<div class="body">
					    <h3 class="t1">下载摘要版</h3>
					    <p class="alignCenter pad5">
					        <input type="button" class="crystal2" value="免费下载" onclick="window.open('download.aspx?id=200802b');" />
					    </p>
					    <p class="lineheight35">&nbsp;</p>
					    <h3 class="t2">下载完整版（价值：￥3000）</h3>
					    <p><img src="/images/warning.gif" alt="notice" /> 完整版需要认证用户身份</p>
					    <p class="alignCenter pad5">
					        <input type="button" class="crystal3" value="认证用户下载" onclick="window.open('download.aspx?id=200802f');" />
					    </p>
					    
					    <p><img src="/images/help.gif" alt="help" /> 如何获得认证？</p>
					    <p>1、免费<a href="../bmce">参加品牌管理能力测试</a></p>
					    <p>2、详实填写您的企业资料</p>
					    <p>3、创建一个BrandQQ帐户</p>
					    <p>完成以上3个步骤后，BrandQQ会依据您提供的联系信息和您取得联系，以认证您的用户身份！</p>
					</div>
				</div>
			</div>


			<div class="box2">
				<div class="inner">
					<h1>BMI 第1期</h1>
					<h2></h2>
					
					<div class="body">
					    <h3 class="t1"><a href="javascript:void(0);" onclick="window.open('download.aspx?id=200704b');">免费下载(摘要版)</a></h3>
						<h3 class="t1"><a href="javascript:void(0);" onclick="window.open('download.aspx?id=200704f');">免费下载(完整版，价值：￥3000)</a></h3>
					</div>
				</div>
			</div>


		</div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
</body>
</html>
