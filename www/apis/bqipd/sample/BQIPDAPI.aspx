<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>

<%
/*
BQIPDAPI.aspx
'BQIPD API 

Input parameters (Method:GET)
   domain:the url which one you want to query
   keywords:the keywords which you want to use
*/
%>

<script runat="server">
    void Page_Load(object s, EventArgs e)
    {
        if (Request["domain"] == null || Request["keywords"] == null)
        {
            return;
        }

        string domain = Request["domain"].Trim();
        string keywords = Request["keywords"].Trim();


        WebRequest request = WebRequest.Create("http://www.brandqq.com/AjaxPostResponse.aspx");
        request.Method = "POST";
        request.ContentType = "application/x-www-form-urlencoded";
        
        byte[] data = Encoding.UTF8.GetBytes("AjaxAction=bqipd&u=" + domain + "&q=" + keywords);

        Stream dataStream = request.GetRequestStream();
        dataStream.Write(data, 0, data.Length);
        dataStream.Close();
        

        WebResponse response = request.GetResponse();

        StreamReader reader = new StreamReader(response.GetResponseStream());
        string xml = reader.ReadToEnd();
        reader.Close();
        
        Response.ContentEncoding = Encoding.UTF8;
        Response.ContentType = "text/xml";
        Response.Write(xml);
        Response.End();
    }
</script>