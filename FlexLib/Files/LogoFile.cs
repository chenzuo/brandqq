using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Drawing;
using System.Web;

using BrandQQ.Membership;
using BrandQQ.FlexLib;
using BrandQQ.FlexLib.DBUtils;
using BrandQQ.FlexLib.Files.Types;

namespace BrandQQ.FlexLib.Files
{
    /// <summary>
    /// 表示一个Logo文件
    /// <p><pre>
    /// 字段				类型			备注
    /// Signature:LOGO	string
    /// Version			uint		版本
    /// Guid			string(32)
    /// Uid				uint
    /// TitleBytes		uint
    /// Title			string		If TitleBytes>0
    /// RemarkBytes		uint
    /// Remark			String		If RemarkBytes>0
    /// Date			String(8)
    /// Rect			Rectangle
    /// SymbolBytes		uint
    /// Symbols			Array		If SymbolBytes>0
    /// TextBytes		uint
    /// Texts			Array		If TextBytes>0
    /// ThumbnailBytes	uint
    /// Thumbnail		Thumbnail	If ThumbnailBytes>0
    /// </pre>
    /// </p>
    /// </summary>
    public class LogoFile : IFile
    {
        public LogoFile(Stream stream)
        {
            reader = new FileReader(stream);
            reader.ReadBytes(4);//skip Signature
            reader.ReadBytes(4);//skip Version
            guid = reader.ReadGB2312(32);
            uid = (int)(reader.ReadUInt32());

            int len = (int)(reader.ReadUInt32());
            if (len > 0)
            {
                title = reader.ReadGB2312(len);
            }

            len = (int)(reader.ReadUInt32());
            if (len > 0)
            {
                remark = reader.ReadGB2312(len);
            }

            date = reader.ReadGB2312(8);

            rect = new RectangleF();
            rect.X = reader.ReadSingle();
            rect.Y = reader.ReadSingle();
            rect.Width = reader.ReadSingle();
            rect.Height = reader.ReadSingle();

            len = (int)(reader.ReadUInt32());//SymbolBytes
            if (len > 0)
            {
                reader.BaseStream.Seek(len, SeekOrigin.Current);//skip Symbols
            }

            len = (int)(reader.ReadUInt32());//TextBytes
            if (len > 0)
            {
                reader.BaseStream.Seek(len, SeekOrigin.Current);//skip Texts
            }

            len = (int)(reader.ReadUInt32());//ThumbnailBytes
            if (len > 0)
            {
                byte[] thumbnailBytes = new byte[len];
                reader.ReadBytes(len).CopyTo(thumbnailBytes, 0);
                thumbnail = new Thumbnail(thumbnailBytes,ThumbnailType.LogoThumbnail);
                thumbnail.Save(HttpContext.Current.Server.MapPath("/flexLib/Thumbnails/Logos/" + guid + ".png"));
            }
        }

        public string Title
        {
            get
            {
                return title;
            }
        }

        public string Remark
        {
            get
            {
                return remark;
            }
        }

        public string Date
        {
            get
            {
                return date;
            }
        }

        private string guid = "";
        private int uid = 0;
        private string title = "";
        private string remark = "";
        private string date = "";
        private RectangleF rect;
        private Thumbnail thumbnail;

        private FileReader reader;

        /// <summary>
        /// 缩略图尺寸
        /// </summary>
        public static readonly Size THUMBNAIL_SIZE = new Size(120, 90);
        

        #region IFile 成员

        public string Guid
        {
            get
            {
                return guid;
            }
        }

        public int Uid
        {
            get
            {
                return uid;
            }
        }

        public void Save()
        {
            string filePath = HttpContext.Current.Server.MapPath("/flexLib/Files/Logos/" + Guid + ".logo");
            Save(filePath);
        }

        public void Save(string fileName)
        {
            reader.BaseStream.Position = 0;
            File.WriteAllBytes(fileName, reader.ReadBytes((int)(reader.BaseStream.Length)));
            reader.Close();

            int uid = 0;
            if (Member.IsLogined)
            {
                uid = Member.Instance.Id;
            }
            DBUtil.SaveLogo(guid, uid, title, remark, "", true);

            MeberFlexInfo.Instance.LogoGuid = guid;
        }

        public void Close()
        {
            if (reader != null)
            {
                reader.Close();
            }
        }

        #endregion
    }
}
