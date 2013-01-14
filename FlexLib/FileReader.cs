using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace BrandQQ.FlexLib
{
    public class FileReader:BinaryReader
    {
        public FileReader(Stream stream)
            : base(stream)
        {
            littleEndian = true;
            stream.Position = 0;
        }

        public FileReader(Stream stream, bool isLittleEndian)
            : base(stream)
        {
            littleEndian = isLittleEndian;
            stream.Position = 0;
        }

        public override decimal ReadDecimal()
        {
            return base.ReadDecimal();
        }

        public override double ReadDouble()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(8);
                Array.Reverse(bytes);
                return BitConverter.ToDouble(bytes, 0);
            }
            return base.ReadDouble();
        }

        public override short ReadInt16()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(2);
                Array.Reverse(bytes);
                return BitConverter.ToInt16(bytes, 0);
            }
            return base.ReadInt16();
        }

        public override int ReadInt32()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(4);
                Array.Reverse(bytes);
                return BitConverter.ToInt32(bytes, 0);
            }
            return base.ReadInt32();
        }

        public override long ReadInt64()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(8);
                Array.Reverse(bytes);
                return BitConverter.ToInt64(bytes, 0);
            }
            return base.ReadInt64();
        }

        public override float ReadSingle()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(4);
                Array.Reverse(bytes);
                return BitConverter.ToSingle(bytes, 0);
            }
            return base.ReadSingle();
        }

        public override ushort ReadUInt16()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(2);
                Array.Reverse(bytes);
                return BitConverter.ToUInt16(bytes, 0);
            }
            return base.ReadUInt16();
        }

        public override uint ReadUInt32()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(4);
                Array.Reverse(bytes);
                return BitConverter.ToUInt32(bytes, 0);
            }
            return base.ReadUInt32();
        }

        public override ulong ReadUInt64()
        {
            if (littleEndian)
            {
                byte[] bytes = this.ReadBytes(8);
                Array.Reverse(bytes);
                return BitConverter.ToUInt64(bytes, 0);
            }
            return base.ReadUInt64();
        }

        public string ReadGB2312(int len)
        {
            byte[] bytes = this.ReadBytes(len);
            return Encoding.GetEncoding("GB2312").GetString(bytes);
        }

        private bool littleEndian;
    }
}
