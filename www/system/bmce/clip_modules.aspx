<%@ Page Language="C#" Inherits="BrandQQ.WebControls.System.SystemPageHeader" %>
<%@ Import Namespace="BrandQQ.Util" %>
<%@ Import Namespace="BrandQQ.BMCE" %>
<%@ Import Namespace="BrandQQ.Membership" %>
<script runat="server">
    StringBuilder html = new StringBuilder();
    string indus = "";
    Pager pager = new Pager(1, 10);
    void Page_Load(object sender, EventArgs e)
    {
        if (Request["indus"] != null)
        {
            indus = Request["indus"];

            if (!String.IsNullOrEmpty(indus))
            {
                indus = "M" + indus;
            }
        }

        if (Request["page"] != null)
        {
            pager.PageIndex = Convert.ToInt16(Request["page"]);
        }

        foreach (Module obj in Module.List(indus, pager))
        {
            html.AppendLine("<li><input type=\"checkbox\" id=\"mid" + obj.Id.ToString() + "\" value=\"" + obj.Id.ToString() + "\" onclick=\"addItem(this);\" /><label for=\"mid" + obj.Id.ToString() + "\">" + obj.Title + " ...............[行业：" + IndustryUtil.GetName(obj.Industry) + "] [排序：" + obj.OrderNum.ToString() + "]</label></li>");
        }
        
        //分页
        html.AppendLine("<li class=\"alignRight\">分页：");
        for (int i = 1; i <= pager.PageCount;i++ )
        {
            html.Append("<a href=\"javascript:ajaxQueryModules(" + i.ToString() + ");\">" + i.ToString() + "</a> ");
        }
        html.AppendLine("</li>");
        
        Response.Write(html.ToString());
    }
</script>