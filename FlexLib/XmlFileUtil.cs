using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;

namespace BrandQQ.FlexLib
{
    public static class XmlFileUtil
    {
        public static void AddCardTemplate(string style,string guid,string name,bool hasBack)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(HttpContext.Current.Server.MapPath("/flexLib/Xmls/CardTemplates.xml"));
            XmlNode tempNode = doc.DocumentElement.SelectSingleNode("Temps");

            foreach (XmlNode node in tempNode.SelectNodes("Temp"))
            {
                if (node.Attributes["guid"].Value.ToUpper() == guid.ToUpper())//ÒÑ´æÔÚ
                {
                    node.Attributes["style"].Value = style;
                    node.Attributes["name"].Value = name;
                    node.Attributes["back"].Value = hasBack ? "1" : "0";
                    doc.Save(HttpContext.Current.Server.MapPath("/flexLib/Xmls/CardTemplates.xml"));
                    return;
                }
            }

            XmlNode newTempNode = doc.CreateNode(XmlNodeType.Element, "Temp", String.Empty);

            XmlAttribute attr = doc.CreateAttribute("style");
            attr.Value = style;
            newTempNode.Attributes.Append(attr);

            attr = doc.CreateAttribute("guid");
            attr.Value = guid;
            newTempNode.Attributes.Append(attr);

            attr = doc.CreateAttribute("name");
            attr.Value = name;
            newTempNode.Attributes.Append(attr);

            attr = doc.CreateAttribute("back");
            attr.Value = hasBack ? "1" : "0";
            newTempNode.Attributes.Append(attr);

            tempNode.AppendChild(newTempNode);

            doc.Save(HttpContext.Current.Server.MapPath("/flexLib/Xmls/CardTemplates.xml"));
        }
    }
}
