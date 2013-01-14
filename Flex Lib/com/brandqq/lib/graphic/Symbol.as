package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	import flash.display.Sprite;
	import flash.geom.*;
	
	import com.brandqq.IO.IByte;
	import com.brandqq.lib.util.StringUtil;
	
	/**
	 * 表示一个矢量图形
	 * @author mickeydream@hotmail.com
	 * 字段				类型			描述							备注
		Tag				string		标志字符						4 bytes,always 'SYMB'
		Bytes			uint		存储Symbol所使用的字节数		不包含Tag
		Rect			Rectangle	Symbol矩形	
		Depth			uint		Symbol深度	
		Border			float		边框粗细	-1表示无
		BorderColor		RGBA		边框颜色	
		MatrixBytes		uint		记录Glyph的变换矩阵使用的字节数	
		Matrix			Matrix		Glyph的变换矩阵				If MatrixBytes>0
		ColorTransBytes	uint		记录Glyph的颜色调整使用的字节数	
		ColorTrans		ColorTrans	Glyph的颜色调整				If ColorTransBytes>0
		Glyph			Glyph
	 */	
	public class Symbol extends Sprite implements IByte, IVector
	{
		public function Symbol()
		{
			super();
			this.__border=-1;
			this.__borderColor=new RGBA();
			this.__rect=new Rectangle(0,0,100,100);
		}
		
		/**
		 * 直接从ByteArray构建Symbol
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function createFromBytes(bytes:ByteArray):Symbol
		{
			var symbol:Symbol=new Symbol();
			bytes.position=0;
			bytes.readMultiByte(4,"GB2312");//skip tag bytes
			symbol.__bytes=bytes.readUnsignedInt();
			
			//rect
			symbol.__rect.x=bytes.readFloat();
			symbol.__rect.y=bytes.readFloat();
			symbol.__rect.width=bytes.readFloat();
			symbol.__rect.height=bytes.readFloat();
			
			symbol.x=symbol.__rect.x;
			symbol.y=symbol.__rect.y;
			symbol.width=symbol.__rect.width;
			symbol.height=symbol.__rect.height;
			
			//depth
			symbol.__depth=bytes.readUnsignedInt();
			
			symbol.__border=bytes.readFloat();
			if(symbol.__border>=0)
			{
				symbol.__borderColor=new RGBA(0);
				symbol.__borderColor.r=bytes.readUnsignedInt();
				symbol.__borderColor.g=bytes.readUnsignedInt();
				symbol.__borderColor.b=bytes.readUnsignedInt();
				symbol.__borderColor.a=bytes.readUnsignedInt();
			}
			
			var bLen:uint=bytes.readUnsignedInt();
			if(bLen>0)
			{
				var mt:Matrix=new Matrix();
				mt.a=bytes.readFloat();
				mt.b=bytes.readFloat();
				mt.c=bytes.readFloat();
				mt.d=bytes.readFloat();
				mt.tx=bytes.readFloat();
				mt.ty=bytes.readFloat();
				symbol.transform.matrix=mt;
			}
			
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				var ct:ColorTransform=new ColorTransform();
				with(ct)
				{
					redMultiplier=bytes.readFloat();
					redOffset=bytes.readFloat();
					greenMultiplier=bytes.readFloat();
					greenOffset=bytes.readFloat();
					blueMultiplier=bytes.readFloat();
					blueOffset=bytes.readFloat();
					alphaMultiplier=bytes.readFloat();
					alphaOffset=bytes.readFloat();
				}
				symbol.transform.colorTransform=ct;
			}
			
			if(bytes.position<bytes.length-1)
			{
				var _glyphBytes:ByteArray=new ByteArray();
				bytes.readBytes(_glyphBytes);
				symbol.__glyph=new Glyph(_glyphBytes);
			}
			
			return symbol;
		}
		
		/**
		 * 获取Symbol的标签
		 * @return 
		 * 
		 */		
		public function get TAG():String
		{
			return this.__TAG;
		}
		
		/**
		 * 获取/设置当前对象的选中状态
		 * @return 
		 * 
		 */		
		public function get selected():Boolean
		{
			return this.__selected;
		}
		public function set selected(value:Boolean):void
		{
			this.__selected=value;
		}
		
		/**
		 * 获取边框线粗细，-1时忽略边框线
		 * @return 
		 * 
		 */		
		public function get border():Number
		{
			return this.__border;
		}
		public function set border(value:Number):void
		{
			this.__border=value;
		}
		
		/**
		 * 获取边框线颜色，border=-1时忽略
		 * @return 
		 * 
		 */		
		public function get borderColor():RGBA
		{
			return this.__borderColor;
		}
		public function set borderColor(value:RGBA):void
		{
			this.__borderColor=value;
		}
		
		/**
		 * 获取Z顺序
		 * @return 
		 * 
		 */		
		public function get depth():uint
		{
			return this.__depth;
		}
		public function set depth(value:uint):void
		{
			this.__depth=value;
		}
		
		public function setColor(clr:uint):void
		{
			var ct:ColorTransform=this.transform.colorTransform;
			if(ct==null)
			{
				ct=new ColorTransform();
			}
			ct.color=clr;
			this.transform.colorTransform=ct;
		}
		
		public function get rect():Rectangle
		{
			return this.__rect;
		}
		public function set rect(value:Rectangle):void
		{
			this.__rect=value;
			super.x=this.__rect.x;
			super.y=this.__rect.y;
			super.width=this.__rect.width;
			super.height=this.__rect.height;
		}
		
		/**
		 * 获取轮廓数据
		 * @return 
		 * 
		 */		
		public function get glyph():Glyph
		{
			return this.__glyph;
		}
		/**
		 * 设置轮廓数据，以便填充
		 * @param value
		 * 
		 */		
		public function set glyph(value:Glyph):void
		{
			this.__glyph=value;
		}
		
		/**
		 * 呈现当前对象
		 * 
		 */		
		public function rend(offsetX:Number=0,offsetY:Number=0,mode:uint=VectorRendMode.SOLIDFILL):void
		{
			if(__glyph!=null)
			{
				graphics.clear();
				if(mode==VectorRendMode.SOLIDFILL)
				{
					graphics.beginFill(0x000000,1);
					if(__border>=0)
					{
						graphics.lineStyle(__border,__borderColor.color,__borderColor.a/100,true,"none");
					}
				}
				else
				{
					graphics.lineStyle(0,0,1,false,"none");
				}
				__glyph.rend(graphics,offsetX,offsetY);
				if(mode==VectorRendMode.SOLIDFILL)
				{
					graphics.endFill();
				}
			}
		}
		
		/**
		 * 获取已在当前Symbol中使用的颜色列表
		 * @return 
		 * 
		 */		
		public function get colorList():Array
		{
			var _colors:Array=new Array();
			if(this.__borderColor!=null)
			{
				_colors.push(this.__borderColor.color);
			}
			if(this.transform.colorTransform!=null)
			{
				_colors.push(this.transform.colorTransform.color);
			}
			return _colors;
		}
		
		override public function set x(value:Number):void
		{
			super.x=value;
			this.__rect.x=value;
		}
		
		override public function set y(value:Number):void
		{
			super.y=value;
			this.__rect.y=value;
		}
		
		override public function set width(value:Number):void
		{
			super.width=value;
			this.__rect.width=value;
		}
		
		override public function set height(value:Number):void
		{
			super.height=value;
			this.__rect.height=value;
		}
		
		override public function set transform(value:Transform):void
		{
			super.transform=value;
			if(value.colorTransform!=null)
			{
				this.transform.colorTransform=value.colorTransform;
			}
			if(value.matrix!=null)
			{
				this.transform.matrix=value.matrix;
				this.x=value.matrix.tx;
				this.y=value.matrix.ty;
			}
		}
		
		override public function toString():String
		{
			var str:String="TAG:"+__TAG+"\n";
			str+="Bytes:"+(this.getBytes().length-4)+"\n";
			str+="Rect:"+this.__rect.toString()+"\n";
			str+="Depth:"+this.depth+"\n";
			str+="Border:"+this.__border+"\n";
			str+="BorderColor:"+this.__borderColor+"\n";
			str+="Matrix:"+this.transform.matrix+"\n";
			str+="ColorTrans:"+this.transform.colorTransform+"\n";
			str+="Glyphs:\n";
			if(this.glyph==null)
			{
				str+="null\n";
			}
			else
			{
				str+=this.glyph.toString()+"\n";
			}
			return str;
		}
		
		
		private const __TAG:String="SYMB";
		
		protected var __selected:Boolean;
		
		protected var __rect:Rectangle;
		protected var __bytes:uint;
		protected var __depth:uint;
		protected var __border:Number;
		protected var __borderColor:RGBA;
		protected var __glyph:Glyph;
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeBytes(StringUtil.toBytes(this.__TAG));
			
			_bytes.writeUnsignedInt(0);//all byte length,__TAG not included in
			
			//rect
			_bytes.writeFloat(this.__rect.x);
			_bytes.writeFloat(this.__rect.y);
			_bytes.writeFloat(this.__rect.width);
			_bytes.writeFloat(this.__rect.height);
			
			_bytes.writeUnsignedInt(this.__depth);
			
			_bytes.writeFloat(this.__border);
			
			if(this.__border>=0)
			{
				_bytes.writeBytes(this.__borderColor.getBytes());
			}
			
			var tempBytes:ByteArray;
			
			var mt:Matrix=this.transform.matrix;
			if(mt!=null)
			{
				_bytes.writeUnsignedInt(0x18);//24 bytes
				_bytes.writeFloat(mt.a);
				_bytes.writeFloat(mt.b);
				_bytes.writeFloat(mt.c);
				_bytes.writeFloat(mt.d);
				_bytes.writeFloat(mt.tx);
				_bytes.writeFloat(mt.ty);
			}
			else
			{
				_bytes.writeUnsignedInt(0);
			}
			
			var ct:ColorTransform=this.transform.colorTransform;
			if(ct!=null)
			{
				_bytes.writeUnsignedInt(0x20);//32 bytes
				_bytes.writeFloat(ct.redMultiplier);
				_bytes.writeFloat(ct.redOffset);
				_bytes.writeFloat(ct.greenMultiplier);
				_bytes.writeFloat(ct.greenOffset);
				_bytes.writeFloat(ct.blueMultiplier);
				_bytes.writeFloat(ct.blueOffset);
				_bytes.writeFloat(ct.alphaMultiplier);
				_bytes.writeFloat(ct.alphaOffset);
			}
			else
			{
				_bytes.writeUnsignedInt(0);
			}
			
			if(this.__glyph!=null)
			{
				_bytes.writeBytes(this.__glyph.getBytes());
			}
			
			//update byte length
			_bytes.position=4;
			_bytes.writeUnsignedInt(_bytes.length-4);//the tag bytes not included
			_bytes.position=0;
			return _bytes;
		}
		
	}
}