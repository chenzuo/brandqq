using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace BrandQQ.Util
{
    /// <summary>
    /// 提供流序列化和反序列化功能
    /// </summary>
    public sealed class StreamSerializer
    {
        /// <summary>
        /// 序列化一个对象
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="fileName"></param>
        public static bool Save(object obj,string fileName)
        {
            bool bln = false;
            FileStream fs = null;
            try
            {
                fs = new FileStream(fileName, FileMode.Create, FileAccess.Write, FileShare.None);
                BinaryFormatter formatter = new BinaryFormatter();
                formatter.Serialize(fs, obj);
                bln = true;
            }
            catch
            {
                //
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }
            return bln;
        }

        /// <summary>
        /// 反序列化一个对象
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <returns></returns>
        public static Object Load(string fileName)
        {
            Object obj = new Object();
            FileStream fs = null;

            try
            {
                fs = new FileStream(fileName, FileMode.Open, FileAccess.ReadWrite, FileShare.Read);
                BinaryFormatter formatter = new BinaryFormatter();
                obj = formatter.Deserialize(fs);
                fs.Dispose();
            }
            catch
            {
                //
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }

            return obj;
        }

        /// <summary>
        /// 反序列化一个对象
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="lockFile">是否锁定文件</param>
        /// <returns></returns>
        public static Object Load(string fileName, bool lockFile)
        {
            Object obj = new Object();
            FileStream fs = null;

            try
            {
                fs = new FileStream(fileName, FileMode.Open, FileAccess.Read, lockFile ? FileShare.None : FileShare.Read);
                BinaryFormatter formatter = new BinaryFormatter();
                obj = formatter.Deserialize(fs);
                fs.Dispose();
            }
            catch
            {
                //
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }

            return obj;
        }
    }
}
