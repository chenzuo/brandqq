using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// 表示一个分页信息
    /// </summary>
    public class Pager
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="idx">页码</param>
        /// <param name="size">页大小</param>
        public Pager(int idx, int size)
        {
            pageIndex = idx;
            pageSize = size;
            recordCount = 0;
            sortNum = 0;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="idx">页码</param>
        /// <param name="size">页大小</param>
        /// <param name="sort">排序</param>
        public Pager(int idx, int size,int sort)
        {
            pageIndex = idx;
            pageSize = size;
            sortNum = sort;
            recordCount = 0;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="idx">页码</param>
        /// <param name="size">页大小</param>
        /// <param name="sort">排序</param>
        /// <param name="mode">显示方式</param>
        /// <param name="str">图片或者文字数组</param>
        public Pager(int idx, int size,PagerDisplayMode mode,string[] str)
        {
            pageIndex = idx;
            pageSize = size;
            sortNum = 0;
            recordCount = 0;
            if (mode == PagerDisplayMode.IMAGE)
            {
                images = str;
            }
            else
            {
                text = str;
            }
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="idx">页码</param>
        /// <param name="size">页大小</param>
        /// <param name="sort">排序</param>
        /// <param name="mode">显示方式</param>
        /// <param name="str">图片或者文字数组</param>
        public Pager(int idx, int size, int sort,PagerDisplayMode mode, string[] str)
        {
            pageIndex = idx;
            pageSize = size;
            sortNum = sort;
            recordCount = 0;
            if (mode == PagerDisplayMode.IMAGE)
            {
                images = str;
            }
            else
            {
                text = str;
            }
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="idx">页码</param>
        /// <param name="size">页大小</param>
        /// <param name="sort">排序</param>
        /// <param name="method">提交方式</param>
        /// <param name="fid">表单ID或者链接前缀</param>
        public Pager(int idx, int size, PagerHttpMethod method, string fid_url)
        {
            pageIndex = idx;
            pageSize = size;
            sortNum = 0;
            recordCount = 0;
            if (method == PagerHttpMethod.GET)
            {
                prefixUrl = fid_url;
            }
            else
            {
                formId = fid_url;
            }

        }
        
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="idx">页码</param>
        /// <param name="size">页大小</param>
        /// <param name="sort">排序</param>
        /// <param name="method">提交方式</param>
        /// <param name="fid">表单ID或者链接前缀</param>
        public Pager(int idx, int size, int sort, PagerHttpMethod method, string fid_url)
        {
            pageIndex = idx;
            pageSize = size;
            sortNum = sort;
            recordCount = 0;
            if (method == PagerHttpMethod.GET)
            {
                prefixUrl = fid_url;
            }
            else
            {
                formId = fid_url;
            }

        }

        /// <summary>
        /// 获取总页数
        /// </summary>
        public int PageCount
        {
            get
            {
                if (recordCount == 0)
                {
                    return 0;
                }

                if (recordCount <= pageSize)
                {
                    return 1;
                }

                if (recordCount % pageSize == 0)
                {
                    return recordCount / pageSize;
                }
                else
                {
                    return ((int)(recordCount / pageSize)) + 1;
                }
            }
        }

        /// <summary>
        /// 设置或获取当前页
        /// </summary>
        public int PageIndex
        {
            get
            {
                return pageIndex;
            }
            set
            {
                pageIndex = value;
            }
        }

        /// <summary>
        /// 设置或获取页大小
        /// </summary>
        public int PageSize
        {
            get
            {
                return pageSize;
            }
            set
            {
                pageSize = value;
            }
        }

        /// <summary>
        /// 设置或获取记录数
        /// </summary>
        public int RecordCount
        {
            get
            {
                return recordCount;
            }
            set
            {
                recordCount = value;
            }
        }

        /// <summary>
        /// 排序标记
        /// </summary>
        public int SortNum
        {
            get
            {
                return sortNum;
            }
            set
            {
                sortNum = value;
            }
        }

        /// <summary>
        /// 设置分页按钮图片,依次为首页,上一页,下一页,末页
        /// </summary>
        public string[] Images
        {
            set
            {
                images = value;
            }
        }

        /// <summary>
        /// 设置分页链接文本,依次为首页,上一页,下一页,末页(默认:首页,上一页,下一页,末页)
        /// </summary>
        public string[] Text
        {
            set
            {
                text = value;
            }
        }

        /// <summary>
        /// 设置分页显示模式,text或image
        /// </summary>
        public PagerDisplayMode Mode
        {
            set
            {
                PagerDisplayMode = value;
            }
        }

        /// <summary>
        /// 设置提交方式
        /// </summary>
        public PagerHttpMethod Method
        {
            set
            {
                httpMethod = value;
            }
        }

        /// <summary>
        /// 设置GET方式时使用的URL
        /// </summary>
        public string PrefixUrl
        {
            set
            {
                prefixUrl = value.Trim();
                if (prefixUrl.IndexOf("?") == -1)
                {
                    prefixUrl += @"?";
                }
                else
                {
                    if (!prefixUrl.EndsWith("&amp;") && !prefixUrl.EndsWith("&"))
                    {
                        prefixUrl += @"&amp;";
                    }
                }
            }
        }

        /// <summary>
        /// 设置表单ID
        /// </summary>
        public string FormId
        {
            set
            {
                formId = value.Trim();
            }
        }

        /// <summary>
        /// 获取分页的HTML代码
        /// </summary>
        public string PagerHtml
        {
            get
            {
                if (PagerDisplayMode == PagerDisplayMode.IMAGE)
                {
                    return PagerHtmlImage();
                }
                else
                {
                    return PagerHtmlText();
                }
            }
        }

        private string PagerHtmlText()
        {
            StringBuilder html = new StringBuilder();
            if (text == null)
            {
                text = new string[] { "首页", "上一页", "下一页", "末页" };
            }

            int pCount = PageCount;
            if (pCount <= 1)
            {
                return "首页&nbsp;&nbsp;上一页&nbsp;&nbsp;下一页&nbsp;&nbsp;末页";
            }
            if (httpMethod == PagerHttpMethod.GET)
            {
                if (pageIndex == 1 && pCount > 1)
                {
                    html.Append(text[0] + "&nbsp;&nbsp;");
                    html.Append(text[1] + "&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex + 1).ToString() + ">" + text[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + pCount + ">" + text[3] + "</a>");
                }
                if (pageIndex > 1 && pageIndex < pCount)
                {
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=1>" + text[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex - 1).ToString() + ">" + text[1] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex + 1).ToString() + ">" + text[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + pCount + ">" + text[3] + "</a>");
                }

                if (pageIndex > 1 && pageIndex >= pCount)
                {
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=1>" + text[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex - 1).ToString() + ">" + text[1] + "</a>&nbsp;&nbsp;");
                    html.Append(text[2] + "&nbsp;&nbsp;");
                    html.Append(text[3]);
                }
            }
            else
            {
                if (pageIndex == 1 && pCount > 1)
                {
                    html.Append(text[0] + "&nbsp;&nbsp;");
                    html.Append(text[1] + "&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex + 1).ToString() + ");\">" + text[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + pCount + ");\">" + text[3] + "</a>");
                }
                if (pageIndex > 1 && pageIndex < pCount)
                {
                    html.Append("<a href=\"javascript:__doPager(1);\">" + text[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex - 1).ToString() + ");\">" + text[1] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex + 1).ToString() + ");\">" + text[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + pCount + ");\">" + text[3] + "</a>");
                }

                if (pageIndex > 1 && pageIndex >= pCount)
                {
                    html.Append("<a href=\"javascript:__doPager(1);\">" + text[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex - 1).ToString() + ");\">" + text[1] + "</a>&nbsp;&nbsp;");
                    html.Append(text[2] + "&nbsp;&nbsp;");
                    html.Append(text[3]);
                }

                html.Append("<input type=\"hidden\"  name=\"__PAGEINDEX\" id=\"__PAGEINDEX\" value=\"" + pageIndex + "\" />\n");

                html.Append("<script language=\"javascript\" type=\"text/javascript\">\n");
                html.Append("   function __doPager(p)\n");
                html.Append("   {");
                html.Append("       var __oForm=document.getElementById(\"" + formId + "\");\n");
                html.Append("       __oForm.__PAGEINDEX.value=p;\n");
                html.Append("       __oForm.submit();\n");
                html.Append("   }");
                html.Append("</script>\n");
            }
            return html.ToString();
        }

        private string PagerHtmlImage()
        {
            StringBuilder html = new StringBuilder();
            if (images == null)
            {
                return PagerHtmlText();
            }

            string[] imageHtml ={ "<img src=\"" + images[0] + "\" border=\"0\" vspace=\"2\" hspace=\"3\" align=\"absmiddle\" />",
                "<img src=\"" + images[1] + "\" border=\"0\" vspace=\"2\" hspace=\"3\" align=\"absmiddle\" />", 
                "<img src=\"" + images[2] + "\" border=\"0\" vspace=\"2\" hspace=\"3\" align=\"absmiddle\" />", 
                "<img src=\"" + images[3] + "\" border=\"0\" vspace=\"2\" hspace=\"3\" align=\"absmiddle\" />" };

            int pCount = PageCount;
            if (pCount <= 1)
            {
                return imageHtml[0] + "&nbsp;&nbsp;" + imageHtml[1] + "&nbsp;&nbsp;" + imageHtml[2] + "&nbsp;&nbsp;" + imageHtml[3];
            }
            if (httpMethod == PagerHttpMethod.GET)
            {
                if (pageIndex == 1 && pCount > 1)
                {
                    html.Append(imageHtml[0] + "&nbsp;&nbsp;");
                    html.Append(imageHtml[1] + "&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex + 1).ToString() + ">" + imageHtml[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + pCount + ">" + imageHtml[3] + "</a>");
                }
                if (pageIndex > 1 && pageIndex < pCount)
                {
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=1>" + imageHtml[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex - 1).ToString() + ">" + imageHtml[1] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex + 1).ToString() + ">" + imageHtml[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + pCount + ">" + imageHtml[3] + "</a>");
                }

                if (pageIndex > 1 && pageIndex >= pCount)
                {
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=1>" + imageHtml[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=" + prefixUrl + "PAGEINDEX=" + (pageIndex - 1).ToString() + ">" + imageHtml[1] + "</a>&nbsp;&nbsp;");
                    html.Append(imageHtml[2] + "&nbsp;&nbsp;");
                    html.Append(imageHtml[3]);
                }
            }
            else
            {
                if (pageIndex == 1 && pCount > 1)
                {
                    html.Append(imageHtml[0] + "&nbsp;&nbsp;");
                    html.Append(imageHtml[1] + "&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex + 1).ToString() + ");\">" + imageHtml[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + pCount + ");\">" + imageHtml[3] + "</a>");
                }

                if (pageIndex > 1 && pageIndex < pCount)
                {
                    html.Append("<a href=\"javascript:__doPager(1);\">" + imageHtml[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex - 1).ToString() + ");\">" + imageHtml[1] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex + 1).ToString() + ");\">" + imageHtml[2] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + pCount + ");\">" + imageHtml[3] + "</a>");
                }

                if (pageIndex > 1 && pageIndex >= pCount)
                {
                    html.Append("<a href=\"javascript:__doPager(1);\">" + imageHtml[0] + "</a>&nbsp;&nbsp;");
                    html.Append("<a href=\"javascript:__doPager(" + (pageIndex - 1).ToString() + ");\">" + imageHtml[1] + "</a>&nbsp;&nbsp;");
                    html.Append(imageHtml[2] + "&nbsp;&nbsp;");
                    html.Append(imageHtml[3]);
                }

                html.Append("<input type=\"hidden\" id=\"__PAGEINDEX\" name=\"__PAGEINDEX\" value=\"" + pageIndex + "\" />\n");

                html.Append("<script language=\"javascript\" type=\"text/javascript\">\n");
                html.Append("   function __doPager(p)\n");
                html.Append("   {");
                html.Append("       var __oForm=document.getElementById(\"" + formId + "\");\n");
                html.Append("       __oForm.__PAGEINDEX.value=p;\n");
                html.Append("       __oForm.submit();\n");
                html.Append("   }");
                html.Append("</script>\n");
            }
            return html.ToString();
        }

       
        private int pageSize;
        private int pageIndex;
        private int recordCount;
        private int sortNum;

        private string[] images;
        private string[] text;
        private PagerDisplayMode PagerDisplayMode;
        private PagerHttpMethod httpMethod;
        private string prefixUrl;
        private string formId;
    }

    /// <summary>
    /// 分页显示样式
    /// </summary>
    public enum PagerDisplayMode
    {
        /// <summary>
        /// 纯文字
        /// </summary>
        TEXT = 1,

        /// <summary>
        /// 图片
        /// </summary>
        IMAGE = 2
    }

    /// <summary>
    /// 提交方法
    /// </summary>
    public enum PagerHttpMethod
    {
        GET = 1,
        POST = 2
    }
}
