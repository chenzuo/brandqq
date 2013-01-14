using System;
using System.Collections;
using System.Text;
using System.IO;

namespace BrandQQ.Logo.Swf
{
    public class SwfTextRender:IBytes
    {
        #region base functions
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="w">movie宽度(px)</param>
        /// <param name="h">movie高度(px)</param>
        /// <param name="txt">文本内容</param>
        /// <param name="fName">字体名称</param>
        /// <param name="fSize">字体大小</param>
        public SwfTextRender(string txt, string fName, int fSize)
        {
            text = txt;
            fontName = fName;
            fontSize = fSize;
        }

        #endregion

        private string text;
        private string fontName;
        private int fontSize;

        private byte[] headerBytes = new byte[32] { 0x46, 0x57, 0x53, 0x08, 0x24, 0x00, 0x00, 0x00, 0x78, 0x00, 0x05, 0x5F, 0x00, 0x00, 0x0F, 0xA0, 0x00, 0x00, 0x0C, 0x01, 0x00, 0x44, 0x11, 0x00, 0x00, 0x00, 0x00, 0x43, 0x02, 0xFF, 0xFF, 0xFF };
        private byte[] endBytes = new byte[4] { 0x40, 0x00, 0x00, 0x00 };

        #region IBytes 成员

        public byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        #endregion
    }
    
    internal interface IBytes
    {
        byte[] GetBytes();
    }

    internal class Rect:IBytes
    {
        protected Rect() { }
        /// <summary>
        /// Construction
        /// </summary>
        /// <param name="width">x maximum position for rectangle in twips</param>
        /// <param name="height">y maximum position for rectangle in twips</param>
        public Rect(int width, int height)
        {
            rects = new int[4] { 0, 0, width, height };
        }

        /// <summary>
        /// Construction
        /// </summary>
        /// <param name="x">x minimum position for rectangle in twips</param>
        /// <param name="y">y minimum position for rectangle in twips</param>
        /// <param name="width">x maximum position for rectangle in twips</param>
        /// <param name="height">y maximum position for rectangle in twips</param>
        public Rect(int x, int y, int width, int height)
        {
            rects = new int[4] { x, y, width, height };
        }

        private int NBits;
        private int[] rects;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        #endregion
    }

    internal class DefineShape:IBytes
    {
        protected DefineShape() { }

        public DefineShape(int id, Rect rect, ShapeWithStyle shapes)
        {
            this.characterID = id;
            this.shapeBounds = rect;
            this.shapes = shapes;
        }

        private int characterID;
        private Rect shapeBounds;
        private ShapeWithStyle shapes;

        private byte TagType = 0x10;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            return new byte[0];
        }

        #endregion
    }

    internal class SolidFill:IBytes
    {
        public SolidFill(byte[] clr)
        {
            color = clr;
        }

        private readonly byte fillStyleType = 0x00;//solid fill
        private byte[] color;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            byte[] bytes=new byte[4];
            bytes[0] = fillStyleType;
            color.CopyTo(bytes, 1);
            return bytes;
        }

        #endregion
    }

    internal class LineStyle:IBytes
    {
        protected LineStyle() { }
        public LineStyle(ushort w, byte[] clr)
        {
            width = w;
            color = clr;
        }

        private ushort width;
        private byte[] color;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            byte[] bytes = new byte[5];
            BitConverter.GetBytes(width).CopyTo(bytes, 0);
            color.CopyTo(bytes, 2);
            return bytes;
        }

        #endregion
    }

    internal class ShapeWithStyle:IBytes
    {
        public ShapeWithStyle(FillStyleArray fills, LineStyleArray lines, ShapeRecordCollection shapes)
        {
            fillStyles = fills;
            lineStyles = lines;
            shapeCollection = shapes == null ? new ShapeRecordCollection() : shapes;
        }

        public void AddFill(SolidFill fill)
        {
            fillStyles.Add(fill);
        }

        public void AddLine(LineStyle line)
        {
            lineStyles.Add(line);
        }

        public void AddShape(ShapeRecord shape)
        {
            shapeCollection.Add(shape);
        }

        private FillStyleArray fillStyles = null;
        private LineStyleArray lineStyles = null;
        private ShapeRecordCollection shapeCollection = null;

        private uint numFillBits;
        private uint numLineBits;


        #region IBytes 成员

        public byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        #endregion
    }

    internal class FillStyleArray : CollectionBase
    {
        protected FillStyleArray() { }
        public FillStyleArray(SolidFill[] fills)
        {
            if (fills != null)
            {
                foreach (SolidFill f in fills)
                {
                    List.Add(f);
                }
            }
        }

        public void Add(SolidFill f)
        {
            List.Add(f);
        }

        private byte fillStyleCount;
        private ushort fillStyleCountExt;
        
    }

    internal class LineStyleArray : CollectionBase
    {
        protected LineStyleArray() { }
        public LineStyleArray(LineStyle[] lines)
        {
            if (lines != null)
            {
                foreach (LineStyle l in lines)
                {
                    List.Add(l);
                }
            }
        }

        public void Add(LineStyle line)
        {
            List.Add(line);
        }

        private byte lineStyleCount;
        private ushort lineStyleCountExt;
    }
    

    internal class ShapeRecordCollection:CollectionBase
    {
        public ShapeRecordCollection()
            :base()
        {
            
        }

        public void Add(ShapeRecord shape)
        {
            List.Add(shape);
        }
    }

    internal class ShapeRecord:IBytes
    {
        protected bool TypeFlag;

        #region IBytes 成员

        public virtual byte[] GetBytes()
        {
            return new byte[0];
        }

        #endregion
    }

    internal class StyleChangeRecord : ShapeRecord
    {
        protected StyleChangeRecord() : base() { }
        public StyleChangeRecord(int moveX, int moveY, ushort fStyle1):base()
        {
            moveDeltaX = moveX;
            moveDeltaY = moveY;
            fillStyle1 = fStyle1;
            TypeFlag = false;
        }

        private int moveDeltaX = int.MinValue;
        private int moveDeltaY = int.MinValue;
        private int fillStyle0 = int.MinValue;
        private int fillStyle1 = int.MinValue;


        public override byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }
    }

    internal class StraightEdgeRecord : ShapeRecord
    {
        protected StraightEdgeRecord() : base() { }
        public StraightEdgeRecord(int x, int y)
            : base()
        {
            deltaX = x;
            deltaY = y;
            TypeFlag = true;
        }

        private readonly bool straightFlag = true;
        private int deltaX;
        private int deltaY;

        public override byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }
    }

    internal class CurvedEdgeRecord : ShapeRecord
    {
        protected CurvedEdgeRecord() : base() { }
        public CurvedEdgeRecord(int cx, int cy, int ax, int ay)
            : base()
        {
            controlDeltaX = cx;
            controlDeltaY = cy;
            anchorDeltaX = ax;
            anchorDeltaY = ay;
            TypeFlag = true;
        }

        private readonly bool straightFlag = false;
        private int controlDeltaX;
        private int controlDeltaY;
        private int anchorDeltaX;
        private int anchorDeltaY;

        public override byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }
    }

    internal class EndShapeRecord : ShapeRecord
    {
        public EndShapeRecord()
            : base()
        {
            TypeFlag = false;
        }

        private readonly byte endOfShape = 0x00;

        public override byte[] GetBytes()
        {
            byte[] bytes=new byte[1];

        }
    }

    internal class PlaceObject2:IBytes
    {
        public PlaceObject2(int placeObjId,ushort d,int x,int y)
        {
            matrix = new float[3, 3] { 
                                        {1.0f, 0.0f, 0.0f}, 
                                        {0.0f, 1.0f, 0.0f}, 
                                        {0.0f, 0.0f, 1.0f} 
                                      };
            characterId = placeObjId;
            depth = d;
            matrix[0, 2] = (float)x;
            matrix[1, 2] = (float)y;
        }

        private int characterId;
        private ushort depth;
        private float[,] matrix;

        #region IBytes 成员

        public byte[] GetBytes()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        #endregion
    }

    internal class Utils
    {

    }


}
