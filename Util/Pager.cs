using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.Util
{
    /// <summary>
    /// ��ʾһ����ҳ��Ϣ
    /// </summary>
    public class Pager
    {
        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="idx">ҳ��</param>
        /// <param name="size">ҳ��С</param>
        public Pager(int idx, int size)
        {
            pageIndex = idx;
            pageSize = size;
            recordCount = 0;
            sortNum = 0;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="idx">ҳ��</param>
        /// <param name="size">ҳ��С</param>
        /// <param name="sort">����</param>
        public Pager(int idx, int size,int sort)
        {
            pageIndex = idx;
            pageSize = size;
            sortNum = sort;
            recordCount = 0;
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="idx">ҳ��</param>
        /// <param name="size">ҳ��С</param>
        /// <param name="sort">����</param>
        /// <param name="mode">��ʾ��ʽ</param>
        /// <param name="str">ͼƬ������������</param>
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
        /// ���캯��
        /// </summary>
        /// <param name="idx">ҳ��</param>
        /// <param name="size">ҳ��С</param>
        /// <param name="sort">����</param>
        /// <param name="mode">��ʾ��ʽ</param>
        /// <param name="str">ͼƬ������������</param>
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
        /// ���캯��
        /// </summary>
        /// <param name="idx">ҳ��</param>
        /// <param name="size">ҳ��С</param>
        /// <param name="sort">����</param>
        /// <param name="method">�ύ��ʽ</param>
        /// <param name="fid">��ID��������ǰ׺</param>
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
        /// ���캯��
        /// </summary>
        /// <param name="idx">ҳ��</param>
        /// <param name="size">ҳ��С</param>
        /// <param name="sort">����</param>
        /// <param name="method">�ύ��ʽ</param>
        /// <param name="fid">��ID��������ǰ׺</param>
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
        /// ��ȡ��ҳ��
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
        /// ���û��ȡ��ǰҳ
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
        /// ���û��ȡҳ��С
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
        /// ���û��ȡ��¼��
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
        /// ������
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
        /// ���÷�ҳ��ťͼƬ,����Ϊ��ҳ,��һҳ,��һҳ,ĩҳ
        /// </summary>
        public string[] Images
        {
            set
            {
                images = value;
            }
        }

        /// <summary>
        /// ���÷�ҳ�����ı�,����Ϊ��ҳ,��һҳ,��һҳ,ĩҳ(Ĭ��:��ҳ,��һҳ,��һҳ,ĩҳ)
        /// </summary>
        public string[] Text
        {
            set
            {
                text = value;
            }
        }

        /// <summary>
        /// ���÷�ҳ��ʾģʽ,text��image
        /// </summary>
        public PagerDisplayMode Mode
        {
            set
            {
                PagerDisplayMode = value;
            }
        }

        /// <summary>
        /// �����ύ��ʽ
        /// </summary>
        public PagerHttpMethod Method
        {
            set
            {
                httpMethod = value;
            }
        }

        /// <summary>
        /// ����GET��ʽʱʹ�õ�URL
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
        /// ���ñ�ID
        /// </summary>
        public string FormId
        {
            set
            {
                formId = value.Trim();
            }
        }

        /// <summary>
        /// ��ȡ��ҳ��HTML����
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
                text = new string[] { "��ҳ", "��һҳ", "��һҳ", "ĩҳ" };
            }

            int pCount = PageCount;
            if (pCount <= 1)
            {
                return "��ҳ&nbsp;&nbsp;��һҳ&nbsp;&nbsp;��һҳ&nbsp;&nbsp;ĩҳ";
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
    /// ��ҳ��ʾ��ʽ
    /// </summary>
    public enum PagerDisplayMode
    {
        /// <summary>
        /// ������
        /// </summary>
        TEXT = 1,

        /// <summary>
        /// ͼƬ
        /// </summary>
        IMAGE = 2
    }

    /// <summary>
    /// �ύ����
    /// </summary>
    public enum PagerHttpMethod
    {
        GET = 1,
        POST = 2
    }
}
