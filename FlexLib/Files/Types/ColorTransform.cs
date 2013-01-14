using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib.Files.Types
{
    public class ColorTransform
    {
        private ColorTransform() { }

        public ColorTransform(byte[] clrTransform)
        {
            if (clrTransform.Length != 32)
            {
                throw new Exception("Out of range");
            }
        }

        public float AM;
        public float AO;
        public float RM;
        public float RO;
        public float GM;
        public float GO;
        public float BM;
        public float BO;
    }
}
