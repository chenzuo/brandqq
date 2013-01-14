using System;
using System.Collections;
using System.Text;
using System.Xml;

namespace BrandQQ.Membership
{
    
    /// <summary>
    /// 表示一个行业
    /// </summary>
    public class Industry
    {
        public Industry(XmlNode node)
        {
            Name = node.Attributes["name"].Value;
            Code = node.Attributes["code"].Value;
            BType = node.Attributes["btype"].Value;
            Children = new ArrayList();

            IndustryUtil.IndustryNames.Add(Code, Name);
            IndustryUtil.IndustryBTypes.Add(Code, BType);

            if (node.HasChildNodes)
            {
                foreach (XmlNode cNode in node.ChildNodes)
                {
                    Children.Add(new Industry(cNode));
                }
            }
        }

        /// <summary>
        /// 行业名称
        /// </summary>
        public string Name;

        /// <summary>
        /// 编码
        /// </summary>
        public string Code;

        /// <summary>
        /// 通常的生意模式
        /// </summary>
        public string BType;

        public ArrayList Children;
    }

}
