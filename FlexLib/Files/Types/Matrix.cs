using System;
using System.Collections.Generic;
using System.Text;

namespace BrandQQ.FlexLib.Files.Types
{
    public class Matrix
    {
        private Matrix() { }
        public Matrix(byte[] matrix)
        {
            if (matrix.Length != 24)
            {
                throw new Exception("Out of range");
            }
        }

        public float A;
        public float B;
        public float C;
        public float D;
        public float Tx;
        public float Ty;
    }
}
