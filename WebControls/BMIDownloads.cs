using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Xml;

using BrandQQ.Membership;
using BrandQQ.Util;

namespace BrandQQ.WebControls
{
    public class BMIDownloads:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            string p1 = "<center><div style=\"margin:50px auto;width:550px;line-height:30px;text-align:center;border:1px solid #999;background-color:#F3F3F3;\">";
            string p2 = "</div></center>";
            if (Request["id"] != null)
            {
                string mime = "";
                string fileName = "";
                string fileTitle = "";
                int downloads = 0;
                bool login = false;
                bool check = false;
                XmlDocument doc = new XmlDocument();
                XmlNode currentNode=null;
                doc.Load(GeneralConfig.Instance.BMIDownloadConfigFile);
                foreach (XmlNode node in doc.DocumentElement.SelectNodes("Item"))
                {
                    if (node.Attributes["id"].Value.ToLower() == Request["id"].ToLower().Trim())
                    {
                        currentNode = node;
                        mime = node.Attributes["mime"].Value.Trim();
                        fileName = node.SelectSingleNode("file").FirstChild.Value.Trim();
                        fileTitle = node.SelectSingleNode("title").FirstChild.Value.Trim();
                        login = Convert.ToBoolean(node.Attributes["login"].Value);
                        check = Convert.ToBoolean(node.Attributes["check"].Value);
                        downloads = Convert.ToInt32(node.Attributes["downloads"].Value);
                        break;
                    }
                }

                if (currentNode!=null)
                {
                    if (login && !Member.IsLogined)
                    {
                        Response.Write(p1 + "您当前处于未登录状态，不能下载！<br/><a href=\"/reg.aspx\">创建用户</a> <a href=\"/login.aspx\">登录</a>" + p2);//未登录不能下载
                        Response.End();
                    }

                    if (check)
                    {
                        if (!Member.IsLogined)
                        {
                            Response.Write(p1 + "您当前处于未登录状态，不能下载！<br/><a href=\"/reg.aspx\">创建用户</a> <a href=\"/login.aspx\">登录</a>" + p2);//未登录不能下载
                            Response.End();
                        }

                        Company com=Company.Get(Member.Instance.Id);
                        if (com==null)
                        {
                            Response.Write(p1 + "您当前还不是BrandQQ的认证用户，不能下载！<br/><a href=\"/mybrandqq/mycompany.aspx\">完善企业资料</a>" + p2);//未验证不能下载
                            Response.End();
                        }

                        if (!com.IsChecked)
                        {
                            Response.Write(p1 + "您当前还不是BrandQQ的认证用户，不能下载！<br/><a href=\"/mybrandqq/mycompany.aspx\">完善企业资料</a>" + p2);//未验证不能下载
                            Response.End();
                        }
                    }

                    //更新下载计数
                    downloads++;
                    lock (doc)
                    {
                        currentNode.Attributes["downloads"].Value = downloads.ToString();
                        doc.Save(GeneralConfig.Instance.BMIDownloadConfigFile);
                    }

                    //输出文件
                    Response.HeaderEncoding = Encoding.Default;
                    Response.ContentType = mime;
                    Response.AddHeader("Content-Disposition", "attachment;filename=\"" + fileTitle + "\"");
                    Response.WriteFile(GeneralConfig.Instance.BMIDownloadPath + fileName);
                    Response.Flush();
                    Response.Close();
                }
            }
            else
            {
                Response.Write(p1 + "错误的请求" + p2);//错误的请求
                Response.End();
            }
        }
    }
}
