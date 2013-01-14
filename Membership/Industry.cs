using System;
using System.Collections;
using System.Text;
using System.Xml;

namespace BrandQQ.Membership
{
    
    /// <summary>
    /// ��ʾһ����ҵ
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
        /// ��ҵ����
        /// </summary>
        public string Name;

        /// <summary>
        /// ����
        /// </summary>
        public string Code;

        /// <summary>
        /// ͨ��������ģʽ
        /// </summary>
        public string BType;

        public ArrayList Children;
    }

}
