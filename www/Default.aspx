<%@ Page Language="c#" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader" Jscript="jscript/Ubb2Html.js" Css="skin/style.css" Title="面向中小企业的品牌管理自助平台 - BrandQQ" Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />
<body>
	<BrandQQ:PageHeader ID="PageHeader" runat="server" />
	
	<div class="globalLayout">
	    <script language="javascript" type="text/javascript">
	        FlashPlayer("images/topBanner.swf?2008-3-10",800,160);
	    </script>
	</div>
	
	<div class="globalLayout">
		<div class="leftLayout">
		    <div class="box1">
                <div class="inner">
                    <h1>互联网推广诊断(<span style="font-weight:bold;color:#F00;">New</span>)</h1>
                    <h2><a href="bqipd/">了解更多</a></h2>
                    <div class="body">
                        <a href="bqipd/diagnosis.aspx">
                            <img src="/images/ads/bqipd.gif" alt="立即体验互联网推广诊断工具" title="立即体验" style="border:none;" />
                        </a>
                    </div>
                </div>
            </div>
		
		
		    <div class="box1">
				<div class="inner">
					<h1>Logo设计</h1>
					<h2><a href="logo">了解更多</a></h2>
					<div class="body">
					    <a href="logo/flex" target="_blank">
							<img src="images/ads/logoSys.jpg" alt="BrandQQ免费在线Logo设计" style="border:none;" />
					    </a>
					    <div class="alignRight"><a href="help/logo.aspx" target="_blank">观看视频演示</a></div>
					</div>
				</div>
			</div>
			
			<div class="box1">
				<div class="inner">
					<h1>品牌管理能力自测系统</h1>
					<h2><a href="/bmce">立即开始</a></h2>
					<div class="body">
					    <a href="/bmce"><img src="/images/icon_bmce.gif" alt="品牌管理能力自测" align="left" border="0" style="margin-right:20px;" /></a>
					    <p>用<img src="/images/num_5.gif" alt="5" style="margin-bottom:-5px;" />分钟时间<br />就可以得到<img src="/images/num_3.gif" alt="3" style="margin-bottom:-5px;" />
					    <img src="/images/num_+.gif" alt="+" style="margin-bottom:-5px;" /><br />
					    <img src="/images/num_+2.gif" alt="+" style="margin-bottom:-3px;" /> 一份完整的评估指数<br />
					    <img src="/images/num_+2.gif" alt="+" style="margin-bottom:-3px;" /> 一套系统分析报告<br />
					    <img src="/images/num_+2.gif" alt="+" style="margin-bottom:-3px;" /> 多元提升建议方案</p>
					    　　
					    <div class="clearLine"></div>
					    <p class="alignRight"><img src="/images/help.gif" alt="Help" /> <a href="/html/about.html">关于BrandQQ</a> | <a href="/help/bmce.aspx">如何开始？使用帮助</a></p>
					    <!--ul>
					        <li class="floatLeft">
					        
					        </li> 
					        <li class="floatRight" style="background:url(/images/icon_bmce_s3.gif) no-repeat;line-height:35px;padding-left:35px;margin-right:10px;">专业支持</li> 
					        <li class="floatRight" style="background:url(/images/icon_bmce_s2.gif) no-repeat;line-height:35px;padding-left:35px;margin-right:10px;">系统模块</li> 
					        <li class="floatRight" style="background:url(/images/icon_bmce_s1.gif) no-repeat;line-height:35px;padding-left:35px;">多元指数报告</li>
					    </ul>
					    
					    <div class="clearLine"></div-->
					    
					</div>
				</div>
			</div>
			
			
			<div class="box1">
				<div class="inner">
					<h1>BrandQQ即将推出</h1>
					<h2></h2>
					<div class="body">
			            <img src="/images/icon_m2.gif" alt="企业品牌管理现状诊断" style="margin:2px;border:1px dotted #DDD;background:url(/images/icon_m_bg.gif) 0px 0px no-repeat;background-color:#F3F3F3;" onmouseover="showModuleDesc(1,this);" onmouseout="hideModuleDesc(this);" />
			            <img src="/images/icon_m3.gif" alt="企业品牌定位" style="margin:2px;border:1px solid #FFF;background:url(/images/icon_m_bg.gif) 0px 0px no-repeat;" onmouseover="showModuleDesc(2,this);" onmouseout="hideModuleDesc(this);" />
				        <img src="/images/icon_m4.gif" alt="企业品牌宣传口号" style="margin:2px;border:1px solid #FFF;background:url(/images/icon_m_bg.gif) 0px 0px no-repeat;" onmouseover="showModuleDesc(3,this);" onmouseout="hideModuleDesc(this);" />
			            <img src="/images/icon_m6.gif" alt="企业品牌手册" style="margin:2px;border:1px solid #FFF;background:url(/images/icon_m_bg.gif) 0px 0px no-repeat;" onmouseover="showModuleDesc(5,this);" onmouseout="hideModuleDesc(this);" />
			            
				        <div id="ModuleDescriptionPannel" style="border:1px solid #EEE;padding:5px;color:#666;background-color:#F7F7F7;"></div>
				        
			            <div id="ModuleDescription1" style="display:none;">
                            品牌现状诊断系统是基于品牌管理能力自测系统，进一步细化评估体系，更全面更系统的，站在企业角度给到实际分析成果。
			            </div>
			            <div id="ModuleDescription2" style="display:none;">
			                消费者选择您的品牌的理由是什么? 我们这套系统就能通过简单而科学的方法给到你答案。
			            </div>
			            <div id="ModuleDescription3" style="display:none;">
			                一个好的口号，也许能让企业一夜成名。通过这套系统也许能给到你一个对生意有直接帮助的响亮的答案。
			            </div>
			            <div id="ModuleDescription4" style="display:none;">
			                Logo是什么？就是一个标志。
                            我想通过最简单，最省钱的方法获得我想要的品牌标识。这里告诉你做logo其实很简单。
			            </div>
			            <div id="ModuleDescription5" style="display:none;">
			                品牌传播的“红宝书”，是基于品牌定位衍生产品。通过这套系统让企业最直观的感受到品牌形象。
			            </div>
					</div>
				</div>
			</div>
			
			
		</div>
		
		<div class="rightLayout">
			<div class="box2">
				<div class="inner">
					<h1>最新加入的企业</h1>
					<h2><a href="users/companies.aspx">更多</a></h2>
					<div class="body">
					<ul>
					<BrandQQ:DataList ID="CompanyList" IsCheckedCompany="1" Type="company" Count="19" runat="server" />
					</ul>
					</div>
				</div>
			</div>
			
			<!--div class="box0">
            <a href="http://www.foresight.net.cn/ppzx" target="_blank"><img src="/images/ads/ppzx.jpg" alt="品牌知行" style="border:none;" /></a>
            </div-->

			<div class="box2">
	            <div class="inner">
		            <h1>相关新闻</h1>
		            <h2></h2>
		            <div class="body">
			            <ul>
				            <li>
					            <a href="http://www.foresight.net.cn/newsletter/read.aspx?id=384" target="_blank">
					            中国第一个中小企业品牌管理自助平台！
					            </a>
				            </li>
				            <li>
					            <a href="http://www.foresight.net.cn/newsletter/read.aspx?id=384" target="_blank">
					            企业品牌管理自测系统（08版）闪亮上线
					            </a>
				            </li>
			            </ul>
		            </div>
	            </div>
            </div>

            <div class="box2">
	            <div class="inner">
		            <h1>合作伙伴</h1>
		            <h2></h2>
		            <div class="body alignCenter">
			            <ul>
							<li>
								<a href="http://www.vsharing.com/" target="_blank">
								<img src="/images/vsharing_logo_230_30.gif" title="畅享网 - 热爱分享，享受成长" alt="畅享网 - 热爱分享，享受成长" style="border:1px solid #999;margin:3px;" />
								</a>
							</li>
							<li>
								<a href="http://www.comr.com.cn/" target="_blank">
								<img src="/images/cmor_logo_230_30.gif" title="中智库玛" alt="中智库玛" style="border:1px solid #999;margin:3px;" />
								</a>
							</li>
							<li>
								<a href="http://www.51poll.com/" target="_blank">
								<img src="/images/51poll_logo_230_30.gif" title="库玛调查-中国最大样本-在线调查门户" alt="库玛调查-中国最大样本-在线调查门户" style="border:1px solid #999;margin:3px;" />
								</a>
							</li>
							<li>
								<a href="http://www.rapidoo.com/" target="_blank">
								<img src="/images/rapidoo_logo_230_30.gif" title="都市直通车——中国第一家专业的搭顺风车信息网" alt="都市直通车——中国第一家专业的搭顺风车信息网" style="border:1px solid #999;margin:3px;" />
								</a>
							</li>
							<li>
								<a href="http://www.foresight.net.cn/" target="_blank">
								<img src="/images/foresight_logo_230_30.gif" title="上海迈迪品牌管理咨询有限公司" alt="上海迈迪品牌管理咨询有限公司" style="border:1px solid #999;margin:3px;" />
								</a>
							</li>
							<li>
								<a href="http://bbs.brandmanager.com.cn/" target="_blank">
								<img src="/images/bmbbs_logo_230_30.gif" title="品牌经理人社区" alt="品牌经理人社区" style="border:1px solid #999;margin:3px;" />
								</a>
							</li>
			            </ul>
		            </div>
	            </div>
            </div>
			
		</div>
		<div class="clearLine"></div>
	</div>
	
	<BrandQQ:PageFooter ID="PageFooter" runat="server" />
	
	<script language="javascript" type="text/javascript">
	    document.getElementById("ModuleDescriptionPannel").innerHTML=document.getElementById("ModuleDescription1").innerHTML;
	    function showModuleDesc(idx,obj)
	    {
	        document.getElementById("ModuleDescriptionPannel").innerHTML=document.getElementById("ModuleDescription"+idx).innerHTML;
	        obj.style.border="1px dotted #DDD";
	        obj.style.backgroundColor="#F3F3F3";
	    }
	    
	    function hideModuleDesc(obj)
	    {
	        obj.style.border="1px solid #FFF";
	        obj.style.backgroundColor="";
	    }
    </script>
</body>
</html>
