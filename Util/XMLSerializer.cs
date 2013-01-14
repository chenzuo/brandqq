using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml.Serialization;

namespace BrandQQ.Util
{
    /// <summary>
    /// �ṩXML���л��ͷ����л�����
    /// </summary>
    public sealed class XMLSerializer
    {
        /// <summary>
        /// ��һ��XML�ļ����з����л�һ������
        /// </summary>
        /// <param name="type"></param>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static Object Load(Type type, string filename)
        {
            FileStream fs = null;
            try
            {
                fs = new FileStream(filename, FileMode.Open,FileAccess.Read,FileShare.ReadWrite);
                XmlSerializer serializer = new XmlSerializer(type);
                return serializer.Deserialize(fs);
            }
            catch(Exception e)
            {
                throw e;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }
        }

        /// <summary>
        /// ���л�һ������
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="filename"></param>
        public static void Save(Object obj, string filename)
        {
            FileStream fs = null;
            try
            {
                XmlSerializer serializer = new XmlSerializer(obj.GetType());
                fs = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.ReadWrite);
                serializer.Serialize(fs, obj);
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }
        }
    }
}
