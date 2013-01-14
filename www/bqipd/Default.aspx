<%@ Page Language="c#" %>

<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader1" Jscript=""
    Css="../skin/style.css" Title="互联网推广在线诊断工具,网站在线诊断 " Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,互联网推广在线诊断"
    Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务" runat="server" />
<body>
    <BrandQQ:PageHeader ID="PageHeader1" runat="server" />
    <div class="globalLayout">
        <div class="leftLayout">
            <div class="box1">
                <div class="inner">
                    <h1>立即体验</h1>
                    <div class="body">
                        <a href="diagnosis.aspx">
                            <img src="/images/ads/bqipd.gif" alt="立即体验互联网推广诊断工具" title="立即体验" style="border:none;" />
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="box1">
                <div class="inner">
                    <h1>互联网推广诊断工具</h1>
					<h2></h2>
                    <div class="body">
                        <div class="pad5"><img src="/images/help.gif" alt="诊断什么" /> <strong style="color:#F60;">诊断什么？</strong></div>
                        <p style="text-indent:2em;">
                            互联网推广诊断工具综合考察被诊断网站的<a href="seoPages/pagerank.html" target="_blank" title="了解Pagerank">Google Pagerank</a>，
                            主流<a href="seoPages/records.html" target="_blank" title="如何获得搜索引擎收录？">搜索引擎的收录页面数</a>，
                            指定<a href="seoPages/keywords.html" target="_blank" title="怎样提高关键字排名？">关键字排名</a>，
                            Alexa排名以及<a href="seoPages/linkin.html" target="_blank" title="怎样增加反向链接数？">反向链接</a>和相关链接等多项指标，
                            使用BrandQQ的诊断模型，对网站进行推广现状进行诊断。
                        </p>

						<p></p>
						<p></p>


                        <div class="pad5"><img src="/images/help.gif" alt="得到什么" /> <strong style="color:#F60;">得到什么？</strong></div>
                        <div style="background-repeat:no-repeat;background-image:url(/images/ads/bqipd_seoimage_bg.gif);padding-left:90px;">
                            <p style="padding-left:15px;border-left:1px dotted #999;">
                                BrandQQ互联网推广诊断报告<br />
                                针对性的推广建议<br />
                                您还可以获得显示您网站SEO信息的图片！<br />
                                <a href="seoinfo.aspx">点击即可获得</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        
        
        
        <div class="rightLayout">
            <div class="box2">
                <div class="inner">
                    <h1>公众网站诊断结果范例</h1>
					<h2></h2>
                    <div class="body">
                        <ul>
	                        <li><a href="seopages/samples-1.html" target="_blank">Yahoo.cn 关键字：搜索</a></li>
	                        <li><a href="seopages/samples-2.html" target="_blank">sina.com.cn 关键字：新闻</a></li>
	                        <li><a href="seopages/samples-3.html" target="_blank">163.com  关键字：财经</a></li>
	                        <li><a href="seopages/samples-4.html" target="_blank">sohu.com  关键字：娱乐</a></li>
	                        <li><a href="seopages/samples-5.html" target="_blank">qq.com  关键字：汽车</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="box2">
                <div class="inner">
                    <h1>推广优化技巧</h1>
					<h2></h2>
                    <div class="body">
                        <ul>
	                        <li><a href="seopages/pagerank-1.html" target="_blank">PageRank 的基本概念</a></li>
	                        <li><a href="seopages/pagerank-2.html" target="_blank">PageRank是如何计算出来的？</a></li>
	                        <li><a href="seopages/pagerank-3.html" target="_blank">如何提高网站的PageRank？</a></li>
	                        <li><a href="seopages/pagerank-4.html" target="_blank">链接就是一切——链接引用的重要性</a></li>
	                        <li><a href="seopages/keywords-1.html" target="_blank">网站关键字密度</a></li>
	                        <li><a href="seopages/keywords-2.html" target="_blank">如何设置与选择网站关键字？</a></li>
	                        <li><a href="seopages/keywords-3.html" target="_blank">如何突出关键词？</a></li>
	                        <li><a href="seopages/records.html" target="_blank">让搜索引擎收录网站的办法</a></li>
	                        <li><a href="seopages/linkin-1.html" target="_blank">什么是反向链接？有哪些类型？</a></li>
	                        <li><a href="seopages/linkin-2.html" target="_blank">怎样增加反向链接？</a></li>
	                        <li><a href="seopages/linkin-3.html" target="_blank">链接诱饵：怎样获得反向链接</a></li>
	                        <li><a href="seopages/pagerank-4.html" target="_blank">链接就是一切——链接引用的重要性</a></li>
                        </ul>
                    </div>
                </div>
            </div>

			<div class="box3">
				<div class="inner">
					<h1>面向开发人员的API</h1>
					<div class="body">
						BrandQQ互联网推广诊断工具向互联网开发人员公开查询接口，<a href="/apis/bqipd/docs" target="_blank">点击获取API程序包</a>
					</div>
				</div>
			</div>


        </div>
    </div>
    <BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
