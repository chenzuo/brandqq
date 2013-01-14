using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib
{
    public interface IBytes
    {
        byte[] GetBytes();
        void WriteTo(FileWriter writer);
    }
}
