<%@ Page Language="C#" %>
<%@ Import Namespace="BrandQQ.FlexLib" %>
<%@ Import Namespace="BrandQQ.FlexLib.GlyphUtils" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        SwfConverter converter;
        foreach (string file in Directory.GetFiles(@"F:\BrandQQ\www\flexLib\Thumbnails\CardTempSymbols", "*.swf", SearchOption.AllDirectories))
        {
            converter = new SwfConverter(file);
            File.WriteAllBytes(@"F:\BrandQQ\www\flexLib\Thumbnails\CardTempSymbols\" + new FileInfo(file).Name.Replace(".swf",".glyph"), converter.GetGlyph().GetBytes());
        }

        //foreach (string file in Directory.GetFiles(@"F:\BrandQQ\www\flexLib\Glyphs\LogoSymbols", "*.symbol", SearchOption.AllDirectories))
        //{
        //    //converter = new SwfConverter(file);
        //    //File.WriteAllBytes(@"F:\BrandQQ\www\flexLib\Glyphs\LogoSymbols\" + new FileInfo(file).Name.Replace(".swf", ".symbol"), converter.GetGlyph().GetBytes());
        //    //Response.Write(@"F:\BrandQQ\www\flexLib\Glyphs\LogoSymbols\" + new FileInfo(file).Name.Replace(".swf", ".symbol") + "<br/>");
        //    File.Move(file, file.Replace(".symbol",".glyph"));
        //}

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
