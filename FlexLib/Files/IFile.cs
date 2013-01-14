using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib.Files
{
    public interface IFile
    {
        string Guid
        {
            get;
        }

        int Uid
        {
            get;
        }

        void Save();
        void Save(string fileName);

        void Close();
    }
}
