using System;
using System.Collections;
using System.Text;
using System.Web.UI;
using System.IO;

using BrandQQ.Util;
using BrandQQ.Logo;

namespace BrandQQ.WebControls
{
    /// <summary>
    /// 输出logo图形
    /// <para>输入参数格式：</para>
    /// <para>参数长度：41</para>
    /// <para>1-6:行业代码</para>
    /// <para>7:logo类型</para>
    /// <para>8:图片类型</para>
    /// <para>9:点号</para>
    /// <para>10-41:GUID</para>
    /// </summary>
    public class LogoImage:Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            string id = "";//industry+type+imagetype.guid
            if (!String.IsNullOrEmpty(Request.QueryString.ToString()))
            {
                id = Request.QueryString.ToString().Trim();
            }

            if (id.Length != 41 || id.Split('.').Length!=2)
            {
                return;
            }
            
            string path = GeneralConfig.Instance.LogoDataSourcePath;

            //判断图片类型
            string imageType = id.Substring(7, 1);
            if (imageType != "1" && imageType != "2" && imageType != "3")
            {
                return;
            }
            imageType = ((LogoImageType)Convert.ToInt16(id.Substring(7, 1))).ToString();

            //判断logo类型
            switch (id.Substring(6, 1))
            {
                case "1":
                    path += "LogoImages\\";
                    break;
                case "2":
                    path += "LogoSamples\\";
                    break;
                case "3":
                    path += "LogoUploads\\";
                    break;
            }

            path += id.Substring(0, 6)+"\\";
            path += id.Split('.')[1];

            if (id.Substring(6, 1) == "1")
            {
                 path+= ".s";//缩略图路径
            }

            if (File.Exists(path))
            {
                Response.ContentType = "image/" + imageType;
                Response.WriteFile(path);
                Response.Flush();
            }
            else
            {
                Response.Write(path);
            }
        }
    }
}
