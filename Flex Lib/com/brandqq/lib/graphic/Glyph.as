package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	import com.brandqq.IO.IByte;
	import flash.display.Graphics;
	import flash.geom.*;
	
	
	/**
	 * 表示一个轮廓数据
	 * @author mickeydream@hotmail.com
	 * 字段			类型			描述							备注
		Type		byte		Glyph表示的类型				1 图形
															2 文本
		Bytes		uint		存储Glyph所使用的全部字节数		不包含Type
		Rect		Rectangle	Glyph的外框矩形
		Segments	Array		Glyph包含的线段
	 */	
	public class Glyph implements IByte
	{
		/**
		 * 构造函数
		 * @param bytes
		 * @return 
		 * 
		 */		
		public function Glyph(bytes:ByteArray=null)
		{
			if(bytes!=null)
			{
				bytes.position=0;
				this.__type=bytes.readByte();
				this.__bytes=bytes.readUnsignedInt();
				this.__rect=new Rectangle();
				this.__rect.x=bytes.readFloat();
				this.__rect.y=bytes.readFloat();
				this.__rect.width=bytes.readFloat();
				this.__rect.height=bytes.readFloat();
				this.__segments=new Array();
				
				var seg:ISegment;
				var segType:uint;
				var segPoints:Array;
				
				while(bytes.position<bytes.length-1)
				{
					segType=bytes.readByte();
					switch(segType)
					{
						case 0:
							segPoints=new Array(1);
							segPoints[0]=new Point(bytes.readFloat(),bytes.readFloat());
							seg=new StartPoint(Point(segPoints[0]));
							this.__segments.push(seg);
							break;
						case 1:
							segPoints=new Array(1);
							segPoints[0]=new Point(bytes.readFloat(),bytes.readFloat());
							seg=new Line(Point(segPoints[0]));
							this.__segments.push(seg);
							break;
						case 2:
							segPoints=new Array(2);
							segPoints[0]=new Point();
							segPoints[1]=new Point();
							Point(segPoints[0]).x=bytes.readFloat();
							Point(segPoints[0]).y=bytes.readFloat();
							Point(segPoints[1]).x=bytes.readFloat();
							Point(segPoints[1]).y=bytes.readFloat();
							seg=new QuadraticBezier(Point(segPoints[0]),Point(segPoints[1]));
							this.__segments.push(seg);
							break;
						case 3:
							segPoints=new Array(4);
							segPoints[0]=new Point();
							segPoints[1]=new Point();
							segPoints[2]=new Point();
							segPoints[3]=new Point();
							Point(segPoints[0]).x=bytes.readFloat();
							Point(segPoints[0]).y=bytes.readFloat();
							Point(segPoints[1]).x=bytes.readFloat();
							Point(segPoints[1]).y=bytes.readFloat();
							Point(segPoints[2]).x=bytes.readFloat();
							Point(segPoints[2]).y=bytes.readFloat();
							Point(segPoints[3]).x=bytes.readFloat();
							Point(segPoints[3]).y=bytes.readFloat();
							seg=new CubicBezier(Point(segPoints[0]),Point(segPoints[1]),Point(segPoints[2]),Point(segPoints[3]));
							this.__segments.push(seg);
							break;
					}
				}
			}
			else
			{
				this.__type=1;
				this.__rect=new Rectangle();
				this.__segments=new Array();
			}
		}
		
		public function addSegment(seg:ISegment):void
		{
			this.__segments.push(seg);
		}
		
		/**
		 * 呈现该轮廓到指定的Graphics，其外观应在调用该方法之前在参数g:Graphics中定义
		 * @param g
		 * @param offsetX 沿X轴的偏移
		 * 
		 */		
		public function rend(g:Graphics,offsetX:Number=0,offsetY:Number=0):void
		{
			for(var i:int=0;i<this.__segments.length;i++)
			{
				ISegment(this.__segments[i]).draw(g,offsetX,offsetY);
			}
		}
		
		public function get type():uint
		{
			return this.__type;
		}
		
		public function get bytes():uint
		{
			return this.__bytes;
		}
		
		public function get rect():Rectangle
		{
			return this.__rect;
		}
		public function set rect(value:Rectangle):void
		{
			this.__rect=value;
		}
		
		/**
		 * 获取当前轮廓包含的线段数组
		 * @return 
		 * 
		 */		
		public function get segments():Array
		{
			return this.__segments;
		}
		
		/**
		 * Glyph实例的字符串表示
		 * @return 
		 * 
		 */		
		public function toString():String
		{
			var str:String="Type="+__type+";\n";
			str+="Bytes="+__bytes+";\n";
			str+="Rect="+__rect.toString()+";\n";
			for(var i:int=0;i<this.__segments.length;i++)
			{
				str+=ISegment(this.__segments[i]).toString()+";\n";
			}
			return str;
		}
		
		private var __type:uint;
		private var __bytes:uint;
		private var __rect:Rectangle;
		private var __segments:Array;
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeByte(this.__type);
			_bytes.writeUnsignedInt(0);
			_bytes.writeFloat(this.__rect.x);
			_bytes.writeFloat(this.__rect.y);
			_bytes.writeFloat(this.__rect.width);
			_bytes.writeFloat(this.__rect.height);
			
			for(var i:int=0;i<this.__segments.length;i++)
			{
				_bytes.writeBytes(ISegment(this.__segments[i]).getBytes());
			}
			_bytes.position=1;
			_bytes.writeUnsignedInt(_bytes.length-1);
			_bytes.position=0;
			return _bytes;
		}
	}
}