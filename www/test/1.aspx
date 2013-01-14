<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="BrandQQ.FlexLib" %>
<%@ Import Namespace="BrandQQ.FlexLib.Files" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Stream stream = File.OpenRead(@"F:\BrandQQ\www\flexLib\Files\CardTemps\C929EB52D1E9B8FA333E95236A572816.card");
        CardFile card = new CardFile(stream);
        Response.Write(card.Width.ToString());
        stream.Close();
    }

    private void UpdateLogoSymbolSubCates()
    {
        StringBuilder xml;
        string code, cate;
        FileInfo info;
        XmlDocument doc = new XmlDocument();
        doc.Load(@"F:\BrandQQ\www\flexLib\Xmls\LogoSymbolCategories.xml");
        foreach (XmlNode node1 in doc.DocumentElement.SelectNodes("Category"))
        {
            foreach (XmlNode node2 in node1.SelectNodes("Category"))
            {
                //Response.Write("INSERT INTO LogoSymbolCategories (Name, Code) VALUES 
                //('" + node2.Attributes["name"].Value + "','" + node2.Attributes["code"].Value + "')");
                xml = new StringBuilder();
                xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
                xml.AppendLine("<Symbols>");

                cate = node2.Attributes["code"].Value;

                foreach (string file in Directory.GetFiles(@"F:\BrandQQ\www\App_Data\logoData\symbols\" + cate.Substring(0, 3) + "\\" + cate, "*.swf"))
                {
                    info = new FileInfo(file);
                    code = info.Name.Replace(info.Extension, "");
                    xml.AppendLine("<Symbol code=\"" + code + "\" title=\"" + code + "\" />");
                }
                xml.AppendLine("</Symbols>");

                File.WriteAllText(@"F:\BrandQQ\www\flexLib\Xmls\LogoSymbolCategories\" + cate + ".xml", xml.ToString(), Encoding.UTF8);
                Response.Write(@"F:\BrandQQ\www\flexLib\Xmls\LogoSymbolCategories\" + cate + ".xml ......OK!<br/>");
            }
        }
    }
</script>
