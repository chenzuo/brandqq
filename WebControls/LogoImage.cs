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
    /// ���logoͼ��
    /// <para>���������ʽ��</para>
    /// <para>�������ȣ�41</para>
    /// <para>1-6:��ҵ����</para>
    /// <para>7:logo����</para>
    /// <para>8:ͼƬ����</para>
    /// <para>9:���</para>
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

            //�ж�ͼƬ����
            string imageType = id.Substring(7, 1);
            if (imageType != "1" && imageType != "2" && imageType != "3")
            {
                return;
            }
            imageType = ((LogoImageType)Convert.ToInt16(id.Substring(7, 1))).ToString();

            //�ж�logo����
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
                 path+= ".s";//����ͼ·��
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
