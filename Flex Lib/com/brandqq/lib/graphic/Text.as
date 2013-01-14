package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	import flash.geom.*;
	
	import com.brandqq.IO.IByte;
	import com.brandqq.lib.graphic.RGB;
	import com.brandqq.lib.graphic.Glyph;
	import com.brandqq.lib.util.StringUtil;
	import com.brandqq.lib.graphic.RGBA;
	
	/**
	 * 表示一个文本串，可包含轮廓数据
	 * @author mickeydream@hotmail.com
	 * 字段				类型			描述							备注
		Tag				string		标志字符						4 bytes,always 'TEXT'
		Bytes			uint		存储Text所使用的字节数			不包含Tag
		Rect			Rectangle	Text矩形	
		Depth			uint		Text深度	
		StringBytes		uint		String字节长度	
		String			string		
		FontBytes		uint		使用的字体名称字符串的字节长度	
		Font			string		使用的字体名称	
		FontSize		uint		字体大小	
		Style			byte		0 常规
									1 粗体
									2 斜体
									3 粗斜体
		Ailgn			byte		0 左对齐
									1 居中
									2 右对齐
		Border			float		边框粗细	-1表示无
		BorderColor		RGBA		边框颜色	
		MatrixBytes		uint		记录Glyph的变换矩阵使用的字节数	
		Matrix			Matrix		Glyph的变换矩阵				If MatrixBytes>0
		ColorTransBytes	uint		记录Glyph的颜色调整使用的字节数	
		ColorTrans		ColorTrans	Glyph的颜色调整				If ColorTransBytes>0
		GlyphBytes		uint		存储Glyph使用的字节数
		Glyph			Glyph 		表示文本串的轮廓				If GlyphBytes>0
	 */	
	public class Text extends Symbol
	{
		/**
		 * 构造函数
		 * @param str
		 * @param font
		 * @param size
		 * @param depth
		 * @param style
		 * @param align
		 * @return 
		 * 
		 */		
		public function Text(str:String="",font:String="",size:uint=12,depth:uint=1,style:uint=0x0,align:uint=0x0)
		{
			super();
			this.__string=str;
			this.__font=font;
			this.__fontSize=size;
			this.__depth=depth;
			this.__style=TextDecoration.checkStyleValue(style);
			this.__align=TextDecoration.checkAlignValue(align);
		}
		
		/**
		 * 构造函数，从指定字节流初始化Text对象
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function createFromBytes(bytes:ByteArray):Text
		{
			var textObj:Text=new Text();
			var bLen:uint;
			
			bytes.position=0;
			bytes.readMultiByte(4,"GB2312");//skip tag bytes
			textObj.__bytes=bytes.readUnsignedInt();
			
			//rect
			textObj.__rect.x=bytes.readFloat();
			textObj.__rect.y=bytes.readFloat();
			textObj.__rect.width=bytes.readFloat();
			textObj.__rect.height=bytes.readFloat();
			
			textObj.x=textObj.__rect.x;
			textObj.y=textObj.__rect.y;
			textObj.width=textObj.__rect.width;
			textObj.height=textObj.__rect.height;
			
			//depth
			textObj.__depth=bytes.readUnsignedInt();
			
			//string content
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				textObj.__string=bytes.readMultiByte(bLen,"GB2312");
			}
			
			//font name
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				textObj.__font=bytes.readMultiByte(bLen,"GB2312");
			}
			
			//font size
			textObj.__fontSize=bytes.readUnsignedInt();
			
			//style
			textObj.__style=bytes.readByte();
			
			//align
			textObj.__align=bytes.readByte();
			
			//border
			textObj.__border=bytes.readFloat();
			if(textObj.__border>=0)
			{
				textObj.__borderColor=new RGBA();
				textObj.__borderColor.r=bytes.readUnsignedInt();
				textObj.__borderColor.g=bytes.readUnsignedInt();
				textObj.__borderColor.b=bytes.readUnsignedInt();
				textObj.__borderColor.a=bytes.readUnsignedInt();
			}
			
			//matrix
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				var mt:Matrix=new Matrix();
				mt.a=bytes.readFloat();
				mt.b=bytes.readFloat();
				mt.c=bytes.readFloat();
				mt.d=bytes.readFloat();
				mt.tx=bytes.readFloat();
				mt.ty=bytes.readFloat();
				textObj.transform.matrix=mt;
			}
			
			//colorTransform
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
				textObj.transform.colorTransform=ct;
			}
			
			//glyph
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				var _glyphBytes:ByteArray=new ByteArray();
				bytes.readBytes(_glyphBytes,0,bLen);
				textObj.__glyph=new Glyph(_glyphBytes);
			}
			
			return textObj;
		}
		
		override public function get TAG():String
		{
			return this.__TAG;
		}
		
		/**
		 * 获取文本内容
		 * @return 
		 * 
		 */		
		public function get string():String
		{
			return this.__string;
		}
		/**
		 * 设置文本内容
		 * @param value
		 * 
		 */		
		public function set string(value:String):void
		{
			this.__string=value;
		}
		
		/**
		 * 获取字体名称
		 * @return 
		 * 
		 */		
		public function get font():String
		{
			return this.__font;
		}
		/**
		 * 设置字体名称
		 * @param value
		 * 
		 */		
		public function set font(value:String):void
		{
			this.__font=value;
		}
		
		/**
		 * 获取字体大小
		 * @return 
		 * 
		 */		
		public function get fontSize():uint
		{
			return this.__fontSize;
		}
		/**
		 * 设置字体大小
		 * @param value
		 * 
		 */		
		public function set fontSize(value:uint):void
		{
			this.__fontSize=value;
		}
		
		/**
		 * 获取文本样式
		 * @return 
		 * 
		 */		
		public function get style():uint
		{
			return this.__style;
		}
		/**
		 * 设置文本样式,Bold,Style Or All
		 * @param value
		 * 
		 */		
		public function set style(value:uint):void
		{
			this.__style=value;
		}
		
		/**
		 * 获取文本对齐方式
		 * @return 
		 * 
		 */		
		public function get align():uint
		{
			return this.__align;
		}
		/**
		 * 设置文本对齐方式
		 * @param value
		 * 
		 */		
		public function set align(value:uint):void
		{
			this.__align=value;
		}
		
		public function getAlignedRect():Rectangle
		{
			if(this.__glyph==null)
			{
				return this.__rect;
			}
			
			var r:Rectangle=this.__rect.clone();
			switch(this.__align)
			{
				case TextDecoration.CENTER:
					r.x+=r.width/2-this.__glyph.rect.width/2;
					break;
				case TextDecoration.RIGHT:
					r.x+=r.width-this.__glyph.rect.width;
					break;
			}
			return r;
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
			str+="String:"+this.__string+"\n";
			str+="Font:"+this.__font+"\n";
			str+="FontSize:"+this.__fontSize+"\n";
			str+="Align:"+this.__align+"\n";
			str+="Style:"+this.__style+"\n";
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
		
		private const __TAG:String="TEXT";
		
		private var __string:String="";
		private var __font:String="";
		private var __fontSize:uint;
		private var __style:uint;
		private var __align:uint;
		
		//implements IByte
		override public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		override public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			var bLen:uint;
			var tempBytes:ByteArray;
			
			_bytes.writeBytes(StringUtil.toBytes(this.__TAG));
			_bytes.writeUnsignedInt(0);//all byte length,__TAG not included in
			
			//rect
			_bytes.writeFloat(this.__rect.x);
			_bytes.writeFloat(this.__rect.y);
			_bytes.writeFloat(this.__rect.width);
			_bytes.writeFloat(this.__rect.height);
			
			_bytes.writeUnsignedInt(this.__depth);
			
			//string
			bLen=StringUtil.getByteLength(this.__string);
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
			{
				_bytes.writeBytes(StringUtil.toBytes(this.__string));
			}
			
			//font name
			bLen=StringUtil.getByteLength(this.__font);
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
			{
				_bytes.writeBytes(StringUtil.toBytes(this.__font));
			}
			
			//font size
			_bytes.writeUnsignedInt(this.__fontSize);
			
			//style
			_bytes.writeByte(this.__style);
			
			//align
			_bytes.writeByte(this.__align);
			
			//border
			_bytes.writeFloat(this.__border);
			
			if(this.__border>=0)
			{
				_bytes.writeBytes(this.__borderColor.getBytes());
			}
			
			//matrix
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
				_bytes.writeUnsignedInt(0x0);
			}
			
			//colorTrans
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
				_bytes.writeUnsignedInt(0x0);
			}
			
			//glyph
			if(this.__glyph!=null)
			{
				tempBytes=this.__glyph.getBytes();
				_bytes.writeUnsignedInt(tempBytes.length);
				_bytes.writeBytes(tempBytes);
			}
			else
			{
				_bytes.writeUnsignedInt(0x0);
			}

			//update byte length
			_bytes.position=4;
			_bytes.writeUnsignedInt(_bytes.length-4);//the tag bytes not included
			_bytes.position=0;
			return _bytes;
		}
	}
}