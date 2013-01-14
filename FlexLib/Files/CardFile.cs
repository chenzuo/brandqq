using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Web;
using System.Drawing;

using BrandQQ.Membership;
using BrandQQ.FlexLib;
using BrandQQ.FlexLib.DBUtils;
using BrandQQ.FlexLib.Files.Types;

namespace BrandQQ.FlexLib.Files
{
    /// <summary>
    /// 表示一个名片文件
    /// </summary>
    /// <p><pre>
    /// Signature		string		标志字段，Always “CARD”
    /// Version			uint		版本
    /// Guid			string(32)	Guid,空时使用‘?’补齐
    /// Uid				uint	
    /// NameBytes		uint	
    /// Name			string		If NameBytes>0
    /// Width			uint		300dpi下的象素宽度
    /// Height			uint		300dpi下的象素高度
    /// FrontFaceBytes	uint		存储FrontFace所用的字节数
    /// FrontFace		CardFace	If FrontFaceBytes>0
    /// BackFaceBytes	uint		存储BackFace所用的字节数
    /// BackFace		CardFace	If BackFaceBytes>0
    /// LogoFileBytes	uint	
    /// LogoFile		LogoFile	If LogoFileBytes>0
    /// </pre></p>
    public class CardFile : IFile
    {
        public CardFile(Stream stream)
        {
            reader = new FileReader(stream);
            reader.ReadBytes(4);
            reader.ReadBytes(4);
            guid = reader.ReadGB2312(32);
            uid = (int)(reader.ReadUInt32());

            int len = (int)(reader.ReadUInt32());
            if (len > 0)
            {
                name = reader.ReadGB2312(len);
            }

            width = reader.ReadUInt32();
            height = reader.ReadUInt32();

            byte[] faceBytes;
            byte[] readBytes;
            len = (int)(reader.ReadUInt32());//FrontFaceBytes
            if (len > 0)
            {
                faceBytes = new byte[len];
                readBytes = reader.ReadBytes(len);
                readBytes.CopyTo(faceBytes, 0);
                frontFace = new CardFace(faceBytes,FaceType.Front);
            }

            len = (int)(reader.ReadUInt32());//BackFaceBytes
            if (len > 0)
            {
                hasBack = true;
                faceBytes = new byte[len];
                readBytes = reader.ReadBytes(len);
                readBytes.CopyTo(faceBytes, 0);
                backFace = new CardFace(faceBytes, FaceType.Back);
            }

        }

        public string Name
        {
            get
            {
                return name;
            }
        }

        public uint Width
        {
            get
            {
                return width;
            }
        }

        public uint Height
        {
            get
            {
                return height;
            }
        }

        public bool HasBack
        {
            get
            {
                return hasBack;
            }
        }


        public CardFace FrontFace
        {
            get
            {
                return frontFace;
            }
        }

        public CardFace BackFace
        {
            get
            {
                return backFace;
            }
        }

        public Thumbnail FrontThumbnail
        {
            get
            {
                if (frontFace == null)
                {
                    return null;
                }

                if (frontFace.Thumbnail == null)
                {
                    return null;
                }

                return frontFace.Thumbnail;
            }
        }

        public Thumbnail BackThumbnail
        {
            get
            {
                if (backFace == null)
                {
                    return null;
                }

                if (backFace.Thumbnail == null)
                {
                    return null;
                }

                return backFace.Thumbnail;
            }
        }

        /// <summary>
        /// 作为模板文件保存
        /// </summary>
        /// <param name="fileName"></param>
        public void SaveAsTemp(string fileName)
        {
            reader.BaseStream.Position = 0;
            File.WriteAllBytes(fileName, reader.ReadBytes((int)(reader.BaseStream.Length)));
            reader.Close();
        }

        private string guid = "";
        private int uid = 0;
        private string name = "";
        private uint width = 0;
        private uint height = 0;
        private bool hasBack = false;

        private CardFace frontFace;
        private CardFace backFace;

        private FileReader reader;

        /// <summary>
        /// 缩略图尺寸
        /// </summary>
        public static readonly Size THUMBNAIL_SIZE = new Size(325, 200);



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
            string filePath = HttpContext.Current.Server.MapPath("/flexLib/Files/Cards/" + Guid + ".card");
            Save(filePath);
        }

        public void Save(string fileName)
        {
            //保存文件
            reader.BaseStream.Position = 0;
            File.WriteAllBytes(fileName, reader.ReadBytes((int)(reader.BaseStream.Length)));
            reader.Close();

            //保存缩略图
            string thumbnailPath = HttpContext.Current.Server.MapPath("/flexLib/Thumbnails/Cards/");
            if (FrontThumbnail != null)
            {
                FrontThumbnail.Save(thumbnailPath + "F//" + Guid + ".png");
            }
            if (BackThumbnail != null)
            {
                BackThumbnail.Save(thumbnailPath + "B//" + Guid + ".png");
            }

            //保存数据库记录
            int uid = 0;
            if (Member.IsLogined)
            {
                uid = Member.Instance.Id;
            }
            DBUtil.SaveCard(guid, uid, name,hasBack,true,"");

            MeberFlexInfo.Instance.CardGuid = guid;
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
