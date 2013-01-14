<%@ Page Language="c#" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Register TagPrefix="BrandQQ" Namespace="BrandQQ.WebControls" Assembly="BrandQQ.WebControls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<BrandQQ:HtmlHeader ID="HtmlHeader1" Jscript=""
    Css="../skin/style.css" Title="互联网推广在线诊断工具,网站在线诊断"
    Keywords="中小企业品牌建设，品牌管理,品牌能力，在线品牌管理,互联网推广在线诊断" Description="BrandQQ是迈迪品牌管理公司推出的面向中小企业的品牌管理自助平台，提供在线的品牌管理自助服务"
    runat="server" />
<body>
    <BrandQQ:PageHeader ID="PageHeader1" runat="server" />
    <div class="globalLayout">
        <div class="box1">
            <div class="inner">
                <h1>
                    网站SEO信息图片显示</h1>
                <h2><a href="./">互联网推广在线诊断</a>
                </h2>
                <div class="body">
                    <div class="pad5">将下面的例子的HTML代码或者论坛帖图代码放到您网站的合适地方就可以随时了解到您网站的Pagerank，搜索引擎结果数，Alexa排名等详尽的SEO信息了！</div>
                    <table border="0" width="100%">
                    <tr>
                        <td colspan="2">样式一</td>
                    </tr>
                    <tr>
                        <td><img src="seoimage.aspx" alt="网站SEO信息图片" width="242" height="242" /></td>
                        <td>
                        HTML代码：<br />&lt;img src="http://www.brandqq.com/bqipd/seoimage.aspx"/&gt;<br />
                        论坛帖图代码：<br />[img]http://www.brandqq.com/bqipd/seoimage.aspx[/img]
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">样式二</td>
                    </tr>
                    <tr>
                        <td><img src="seoimage.aspx?pra1" alt="网站SEO信息图片" width="242" height="160" /></td>
                        <td>
                        HTML代码：<br />&lt;img src="http://www.brandqq.com/bqipd/seoimage.aspx?pra1"/&gt;<br />
                        论坛帖图代码：<br />[img]http://www.brandqq.com/bqipd/seoimage.aspx?pra1[/img]
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">样式三</td>
                    </tr>
                    <tr>
                        <td><img src="seoimage.aspx?p1" alt="网站SEO信息图片" width="135" height="76" /></td>
                        <td>
                        HTML代码：<br />&lt;img src="http://www.brandqq.com/bqipd/seoimage.aspx?p1"/&gt;<br />
                        论坛帖图代码：<br />[img]http://www.brandqq.com/bqipd/seoimage.aspx?p1[/img]
                        </td>
                    </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <BrandQQ:PageFooter ID="PageFooter1" runat="server" />
</body>
</html>
