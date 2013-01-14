using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// 表示一封电子邮件的模板
    /// </summary>
    public struct MailTemplate
    {
        public string Title;
        public string Body;
        public bool IsHtml;
    }
}
