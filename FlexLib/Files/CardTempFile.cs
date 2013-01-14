using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Web;

using BrandQQ.FlexLib;

namespace BrandQQ.FlexLib.Files
{
    public class CardTempFile : IFile
    {
        public CardTempFile(Stream stream)
        {
            reader = new FileReader(stream);
            int len = (int)(reader.ReadUInt32());
            if (len > 0)
            {
                style = reader.ReadGB2312(len);
            }

            Stream cardFileStream = new MemoryStream(reader.ReadBytes((int)(stream.Length - len - 4)));

            cardFile = new CardFile(cardFileStream);
        }

        public string Style
        {
            get
            {
                return style;
            }
        }

        public CardFile CardFile
        {
            get
            {
                return cardFile;
            }
        }

        private string style="";
        private CardFile cardFile;
        private FileReader reader;

        #region IFile ≥…‘±

        public string Guid
        {
            get 
            {
                return cardFile.Guid;
            }
        }

        public int Uid
        {
            get 
            {
                return cardFile.Uid;
            }
        }

        public void Save()
        {
            string filePath = HttpContext.Current.Server.MapPath("/flexLib/Files/CardTemps/" + Guid + ".card");
            Save(filePath);
        }

        public void Save(string fileName)
        {
            XmlFileUtil.AddCardTemplate(this.style, cardFile.Guid, cardFile.Name, cardFile.HasBack);
            cardFile.SaveAsTemp(fileName);

            string thumbnailPath = HttpContext.Current.Server.MapPath("/flexLib/Thumbnails/CardTemps/");
            if (cardFile.FrontThumbnail != null)
            {
                cardFile.FrontThumbnail.Save(thumbnailPath + "F//" + Guid+".png");
            }
            if (cardFile.BackThumbnail != null)
            {
                cardFile.BackThumbnail.Save(thumbnailPath + "B//" + Guid + ".png");
            }
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
