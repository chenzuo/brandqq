using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.IO;

using BrandQQ.FlexLib;

namespace BrandQQ.FlexLib.Files.Types
{
    public class CardFace
    {
        public CardFace(byte[] bytes,FaceType type)
        {
            faceBytes = bytes;
            faceType = type;

            Stream stream = new MemoryStream(faceBytes);
            FileReader reader = new FileReader(stream);
            reader.ReadBytes(4);//skip Tag 'FACE'
            bgColor = reader.ReadUInt32();
            hasLogo = reader.ReadBoolean();

            byte[] dataBytes;
            byte[] readBytes;
            int len;

            if (hasLogo)
            {
                reader.ReadBytes(16);//skip LogoRect

                logoDepth = reader.ReadUInt32();//LogoDepth

                len = (int)(reader.ReadUInt32());//LogoMatrixBytes
                if (len > 0)
                {
                    logoMatrix = new Matrix(reader.ReadBytes(24));
                }

                len = (int)(reader.ReadUInt32());//LogoColorTransBytes
                if (len > 0)
                {
                    logoColorTrans = new ColorTransform(reader.ReadBytes(32));
                }
            }

            len = (int)(reader.ReadUInt32());//SymbolBytes
            if (len > 0)
            {
                symbols = new SymbolCollection(reader.ReadBytes(len));
            }

            len = (int)(reader.ReadUInt32());//TextBytes
            if (len > 0)
            {
                texts = new TextCollection(reader.ReadBytes(len));
            }

            len = (int)(reader.ReadUInt32());//ThumbnailBytes
            if (len > 0)
            {
                dataBytes=new byte[len];
                readBytes = reader.ReadBytes(len);
                readBytes.CopyTo(dataBytes,0);
                thumbnail = new Thumbnail(dataBytes,ThumbnailType.CardThumbnail);
            }

            stream.Close();
            reader.Close();
        }

        public FaceType FaceType
        {
            get
            {
                return faceType;
            }
        }

        public Thumbnail Thumbnail
        {
            get
            {
                return thumbnail;
            }
        }

        private byte[] faceBytes;
        private FaceType faceType;

        private const string Tag = "FACE";
        private uint bgColor;
        private bool hasLogo;
        //private RectangleF logoRect;
        private uint logoDepth;
        private Matrix logoMatrix;
        private ColorTransform logoColorTrans;
        private SymbolCollection symbols;
        private TextCollection texts;
        private Thumbnail thumbnail;
    }
}
