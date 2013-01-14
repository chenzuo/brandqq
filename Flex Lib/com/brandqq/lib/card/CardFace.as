package com.brandqq.lib.card
{
	import flash.utils.ByteArray;
	
	import com.brandqq.IO.IByte;
	import com.brandqq.lib.graphic.Thumbnail;
	import com.brandqq.lib.graphic.SymbolCollection;
	import com.brandqq.lib.graphic.TextCollection;
	import com.brandqq.lib.graphic.Symbol;
	import flash.geom.*;
	
	import mx.controls.Alert;
	
	/**
	 * 表示BusinessCard的一个面
	 * @author mickeydream@hotmail.com
	 * 字段					类型			描述
		Tag					string		标志字符,4 bytes,always FACE
		BgColor				uint		背景颜色,当前版本总是0xFFFFFF
		HasLogo				Boolean		是否包含Logo
		LogoRect			Rectangle	Logo放置位置,If HasLogo=true
		LogoDepth			uint		Logo放置顺序,If HasLogo=true
		LogoMatrixBytes		uint	
		LogoMatrix			Matrix		If HasLogo=true and MatrixBytes>0
		LogoColorTransBytes	uint	
		LogoColorTrans		ColorTrans	If HasLogo=true and ColorTransBytes>0
		SymbolBytes			uint	
		Symbols				Array		If SymbolBytes>0
		TextBytes			uint	
		Texts				Array		If TextBytes>0
		ThumbnailBytes		uint	
		Thumbnail			Thumbnail 	If ThumbnailBytes>0
	 */	
	public final class CardFace implements IByte
	{
		public static const FACE_FRONT:String="front";
		public static const FACE_BACK:String="back";
		
		
		public function CardFace(facetype:String="front")
		{
			this.__faceType=facetype;
			this.__hasLogo=false;
			this.__symbols=new Array();
			this.__texts=new Array();
		}
		
		/**
		 * 由ByteArray实例化CardFace
		 * @param bytes 
		 * @param file 关联的名片文件
		 * @param facetype
		 * @return 
		 * 
		 */
		public static function createFromBytes(bytes:ByteArray,facetype:String="front"):CardFace
		{
			var face:CardFace=new CardFace();
			face.__symbols=new Array();
			face.__texts=new Array();
			face.__faceType=facetype;
			
			bytes.position=0;
			bytes.readMultiByte(4,"GB2312");//skip tag:FACE
			face.__bgColor=bytes.readUnsignedInt();
			face.__hasLogo=bytes.readBoolean();
			
			var _byteLen:uint=0;
			
			if(face.__hasLogo)
			{
				face.__logoRect=new Rectangle();
				face.__logoRect.x=bytes.readFloat();
				face.__logoRect.y=bytes.readFloat();
				face.__logoRect.width=bytes.readFloat();
				face.__logoRect.height=bytes.readFloat();
				face.__logoDepth=bytes.readUnsignedInt();
				
				//Matrix2
				_byteLen=bytes.readUnsignedInt();
				if(_byteLen>0)
				{
					face.__logoMatrix=new Matrix();
					face.__logoMatrix.a=bytes.readFloat();
					face.__logoMatrix.b=bytes.readFloat();
					face.__logoMatrix.c=bytes.readFloat();
					face.__logoMatrix.d=bytes.readFloat();
					face.__logoMatrix.tx=bytes.readFloat();
					face.__logoMatrix.ty=bytes.readFloat();
				}
				
				//ColorTrans
				_byteLen=bytes.readUnsignedInt();
				if(_byteLen>0)
				{
					face.__logoColorTrans=new ColorTransform();
					with(face.__logoColorTrans)
					{
						alphaOffset=bytes.readFloat();
						alphaMultiplier=bytes.readFloat();
						redOffset=bytes.readFloat();
						redMultiplier=bytes.readFloat();
						greenOffset=bytes.readFloat();
						greenMultiplier=bytes.readFloat();
						blueOffset=bytes.readFloat();
						blueMultiplier=bytes.readFloat();
					}
				}
			}
			
			var tempBytes:ByteArray;
				
			//symbols
			_byteLen=bytes.readUnsignedInt();
			if(_byteLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,_byteLen);
				var symbolCollection:SymbolCollection=new SymbolCollection(tempBytes);
				face.__symbols=symbolCollection.symbols;
			}
			
			//texts
			_byteLen=bytes.readUnsignedInt();
			if(_byteLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,_byteLen);
				var textCollection:TextCollection=new TextCollection(tempBytes);
				face.__texts=textCollection.texts;
			}
			
			//Thumbnail
			_byteLen=bytes.readUnsignedInt();
			if(_byteLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,_byteLen);
				face.__thumbnail=new Thumbnail(tempBytes);
			}
			return face;
		}
		
		/**
		 * 获取当前CardFace类型,FACE_FRONT或FACE_BACK
		 * @return 
		 * 
		 */		
		public function get faceType():String
		{
			return this.__faceType;
		}
		public function set faceType(value:String):void
		{
			this.__faceType=value;
		}
		
		/**
		 * 获取背景颜色
		 * @return 
		 * 
		 */		
		public function get bgColor():uint
		{
			return this.__bgColor;
		}
		public function set bgColor(value:uint):void
		{
			this.__bgColor=value;
		}
		
		/**
		 * 指示当前CardFace是否需要显示Logo
		 * @return 
		 * 
		 */		
		public function get hasLogo():Boolean
		{
			return this.__hasLogo;
		}
		public function set hasLogo(value:Boolean):void
		{
			this.__hasLogo=value;
		}
		
		/**
		 * 显示Logo的位置定义，当hasLogo=true时有效
		 * @return 
		 * 
		 */		
		public function get logoRect():Rectangle
		{
			return this.__logoRect;
		}
		public function set logoRect(value:Rectangle):void
		{
			this.__logoRect=value;
		}
		
		/**
		 * Logo放置的Z顺序，当hasLogo=true时有效
		 * @return 
		 * 
		 */		
		public function get logoDepth():uint
		{
			return this.__logoDepth;
		}
		public function set logoDepth(value:uint):void
		{
			this.__logoDepth=value;
		}
		
		/**
		 * 应用于Logo的变形矩阵，当hasLogo=true时有效
		 * @return 
		 * 
		 */		
		public function get logoMatrix():Matrix
		{
			return this.__logoMatrix;
		}
		public function set logoMatrix(value:Matrix):void
		{
			this.__logoMatrix=value;
		}
		
		/**
		 * 应用于Logo的颜色调整，当hasLogo=true时有效
		 * @return 
		 * 
		 */
		public function get logoColorTrans():ColorTransform
		{
			return this.__logoColorTrans;
		}
		public function set logoColorTrans(value:ColorTransform):void
		{
			this.__logoColorTrans=value;
		}
		
		/**
		 * 当前CardFace包含的所有Symbol
		 * @return 
		 * 
		 */		
		public function get symbols():Array
		{
			return this.__symbols;
		}
		public function set symbols(value:Array):void
		{
			this.__symbols=value;
		}
		
		/**
		 * 当前CardFace包含的所有Text
		 * @return 
		 * 
		 */		
		public function get texts():Array
		{
			return this.__texts;
		}
		public function set texts(value:Array):void
		{
			this.__texts=value;
		}
		
		/**
		 * 当前CardFace的缩略位图
		 * @return 
		 * 
		 */		
		public function get thumbnail():Thumbnail
		{
			return this.__thumbnail;
		}
		public function set thumbnail(value:Thumbnail):void
		{
			this.__thumbnail=value;
		}
		
		//允许使用的最小 和 最大字号
		public static const MIN_FONTSIZE:uint=6;
		public static const MAX_FONTSIZE:uint=18;
		
		private const __Tag:String="FACE";
		
		private var __faceType:String;
		
		private var __bgColor:uint=0xFFFFFF;
		private var __hasLogo:Boolean;
		private var __logoRect:Rectangle;
		private var __logoDepth:uint=0x0;
		private var __logoMatrix:Matrix;
		private var __logoColorTrans:ColorTransform;
		private var __symbols:Array;
		private var __texts:Array;
		private var __thumbnail:Thumbnail;
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeMultiByte(this.__Tag,"GB2312");
			_bytes.writeUnsignedInt(this.__bgColor);
			_bytes.writeBoolean(this.__hasLogo);
			
			var _tempBytes:ByteArray;
			
			if(this.__hasLogo)
			{
				var _rect:Rectangle=(this.__logoRect==null?new Rectangle():this.__logoRect);
				_bytes.writeFloat(_rect.x);
				_bytes.writeFloat(_rect.y);
				_bytes.writeFloat(_rect.width);
				_bytes.writeFloat(_rect.height);
				_bytes.writeUnsignedInt(this.__logoDepth);
				
				//MatrixBytes
				var mt:Matrix=this.__logoMatrix;
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
				
				//ColorTransBytes
				var ct:ColorTransform=this.__logoColorTrans;
				if(this.__logoColorTrans!=null)
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
			}
			
			var i:int;
			var _byteLen:uint=0;
			var _mBytes:ByteArray;
			
			
			//symbols byte length and bytes
			_tempBytes=new ByteArray();
			for(i=0;i<this.__symbols.length;i++)
			{
				_mBytes=this.__symbols[i].getBytes();
				_tempBytes.writeBytes(_mBytes);
				_byteLen+=_mBytes.length;
			}
			
			_bytes.writeUnsignedInt(_byteLen);
			if(_byteLen>0)
			{
				_bytes.writeBytes(_tempBytes);
			}
			
			
			//texts byte length and bytes
			_byteLen=0;
			_tempBytes=new ByteArray();
			for(i=0;i<this.__texts.length;i++)
			{
				_mBytes=this.__texts[i].getBytes();
				_tempBytes.writeBytes(_mBytes);
				_byteLen+=_mBytes.length;
			}
			_bytes.writeUnsignedInt(_byteLen);
			if(_byteLen>0)
			{
				_bytes.writeBytes(_tempBytes);
			}
			
			if(this.__thumbnail==null)
			{
				_bytes.writeUnsignedInt(0);//not included Thumbnail
			}
			else
			{
				_mBytes=this.__thumbnail.getBytes();
				_bytes.writeUnsignedInt(_mBytes.length);
				_bytes.writeBytes(_mBytes);
			}
			
			return _bytes;
		}
	
	}
}