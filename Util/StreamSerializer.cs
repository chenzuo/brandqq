using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace BrandQQ.Util
{
    /// <summary>
    /// �ṩ�����л��ͷ����л�����
    /// </summary>
    public sealed class StreamSerializer
    {
        /// <summary>
        /// ���л�һ������
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
        /// �����л�һ������
        /// </summary>
        /// <param name="fileName">�ļ���</param>
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
        /// �����л�һ������
        /// </summary>
        /// <param name="fileName">�ļ���</param>
        /// <param name="lockFile">�Ƿ������ļ�</param>
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
