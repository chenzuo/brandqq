package com.brandqq.lib.logo
{
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.geom.*;
	
	import com.brandqq.IO.*;
	import com.brandqq.lib.graphic.*;
	import com.brandqq.lib.util.StringUtil;
	import com.brandqq.lib.events.FileEvent;
	import com.brandqq.Resources.Requests;
	
	
	
	[Event(name="fileOpen",type="com.brandqq.lib.events.FileEvent")]
	[Event(name="fileSave",type="com.brandqq.lib.events.FileEvent")]
	
	/**
	 * 表示一个Logo文件
	 * @author mickeydream@hotmail.com
	 * 字段				类型			备注
		Signature:LOGO	string
		Version			uint		版本
		Guid			string(32)
		Uid				uint
		TitleBytes		uint
		Title			string		If TitleBytes>0
		RemarkBytes		uint
		Remark			String		If RemarkBytes>0
		Date			String(8)
		Rect			Rectangle
		SymbolBytes		uint
		Symbols			Array		If SymbolBytes>0
		TextBytes		uint
		Texts			Array		If TextBytes>0
		ThumbnailBytes	uint
		Thumbnail		Thumbnail	If ThumbnailBytes>0
	 */	
	public final class LogoFile extends EventDispatcher implements IByte,IFile
	{
		/**
		 * 构造函数
		 * @return 
		 * 
		 */		
		public function LogoFile()
		{
			this.__symbols=new Array();
			this.__texts=new Array();
			this.__rect=new Rectangle();
			this.__thumbnail=null;
		}
		
		
		public static function EMPTY():LogoFile
		{
			var logo:LogoFile=new LogoFile();
			logo.__rect.x=0;
			logo.__rect.y=0;
			logo.__rect.width=FileEnum.LOGO_THUMBNAIL_WIDTH;
			logo.__rect.height=FileEnum.LOGO_THUMBNAIL_HEIGHT;
			logo.__guid="00000000000000000000000000000000";
			logo.__date="00000000";
			logo.__title="";
			logo.__uid=0;
			logo.__remark="";
			
			var symbol:Symbol=new Symbol();
			symbol.depth=0;
			symbol.rect=logo.__rect;
			symbol.transform.matrix=new Matrix();
			symbol.transform.colorTransform=new ColorTransform();
			symbol.glyph=new Glyph();
			symbol.glyph.addSegment(new StartPoint(new Point(0,0)));
			symbol.glyph.addSegment(new Line(new Point(FileEnum.LOGO_THUMBNAIL_WIDTH,0)));
			symbol.glyph.addSegment(new Line(new Point(FileEnum.LOGO_THUMBNAIL_WIDTH,FileEnum.LOGO_THUMBNAIL_HEIGHT)));
			symbol.glyph.addSegment(new Line(new Point(0,FileEnum.LOGO_THUMBNAIL_HEIGHT)));
			symbol.glyph.addSegment(new Line(new Point(0,0)));
			symbol.glyph.addSegment(new Line(new Point(FileEnum.LOGO_THUMBNAIL_WIDTH,FileEnum.LOGO_THUMBNAIL_HEIGHT)));
			symbol.glyph.addSegment(new StartPoint(new Point(FileEnum.LOGO_THUMBNAIL_WIDTH,0)));
			symbol.glyph.addSegment(new Line(new Point(0,FileEnum.LOGO_THUMBNAIL_HEIGHT)));
			logo.__symbols.push(symbol);
			return logo;
		}
		
		public function get isEmptyLogo():Boolean
		{
			if(__guid=="00000000000000000000000000000000")
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 获取LogoFile版本
		 * @return 
		 * 
		 */		
		public function get version():uint
		{
			return this.__version;
		}
		
		/**
		 * 获取LogoFile的guid
		 * @return 
		 * 
		 */		
		public function get guid():String
		{
			return this.__guid;
		}
		/**
		 * 设置获取LogoFile的guid
		 * @param value
		 * 
		 */		
		public function set guid(value:String):void
		{
			this.__guid=value;
		}
		
		/**
		 * 获取LogoFile的用户ID
		 * @return 
		 * 
		 */		
		public function get uid():uint
		{
			return this.__uid;
		}
		/**
		 * 设置LogoFile的用户ID
		 * @param value
		 * 
		 */		
		public function set uid(value:uint):void
		{
			this.__uid=value;
		}
		
		
		/**
		 * 获取LogoFile的标题
		 * @return 
		 * 
		 */		
		public function get title():String
		{
			return this.__title;
		}
		/**
		 * 设置LogoFile的标题
		 * @param value
		 * 
		 */		
		public function set title(value:String):void
		{
			this.__title=value;
		}
		
		/**
		 * 获取LogoFile的备注信息
		 * @return 
		 * 
		 */		
		public function get remark():String
		{
			return this.__remark;
		}
		/**
		 * 设置LogoFile的备注信息
		 * @param value
		 * 
		 */		
		public function set remark(value:String):void
		{
			this.__remark=value;
		}
		
		/**
		 * 获取LogoFile的创建日期
		 * @return 
		 * 
		 */		
		public function get date():String
		{
			return this.__date;
		}
		/**
		 * 设置LogoFile的创建日期
		 * @param value
		 * 
		 */		
		public function set date(value:String):void
		{
			this.__date=value;
		}
		
		/**
		 * 获取LogoFile的位置和大小，位置相对于编辑容器
		 * @return 
		 * 
		 */		
		public function get rect():Rectangle
		{
			return this.__rect;
		}
		/**
		 * 设置LogoFile的位置和大小
		 * @param value
		 * 
		 */		
		public function set rect(value:Rectangle):void
		{
			this.__rect=value;
		}
		
		/**
		 * 获取LogoFile包含的所有Symbol
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
		 * 获取LogoFile包含的所有Text
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
		 * 获取LogoFile包含的所有Symbol和Text
		 * @return 
		 * 
		 */		
		public function get elements():Array
		{
			var array:Array=new Array();
			var i:int;
			for(i=0;i<this.__symbols.length;i++)
			{
				array.push(this.__symbols[i]);
			}
			for(i=0;i<this.__texts.length;i++)
			{
				array.push(this.__texts[i]);
			}
			array.sortOn("depth",Array.NUMERIC);
			return array;
		}
		
		/**
		 * 获取LogoFile的缩略位图
		 * @return 
		 * 
		 */		
		public function get thumbnail():Thumbnail
		{
			return this.__thumbnail;
		}
		/**
		 * 设置LogoFile的缩略位图
		 * @param value
		 * 
		 */		
		public function set thumbnail(value:Thumbnail):void
		{
			this.__thumbnail=value;
		}
		
		/**
		 * 获取当前Logo包含的所有颜色表
		 * @return 
		 * 
		 */
		public function get colorList():Array
		{
			var _colors:Array=new Array();
			var i:int;
			for(i=0;i<this.__symbols.length;i++)
			{
				_colors.splice(_colors.length,0,Symbol(this.__symbols[i]).colorList);
			}
			for(i=0;i<this.__texts.length;i++)
			{
				_colors.splice(_colors.length,0,Text(this.__texts[i]).colorList);
			}
			
			var _returnColors:Array=new Array();
			for(i=0;i<_colors.length;i++)
			{
				if(_returnColors.indexOf(_colors[i])==-1)
				{
					_returnColors.push(_colors[i]);
				}
			}
			return _returnColors;
		}
		
		private const __Signature:String="LOGO";
		private var __version:uint;
		private var __guid:String="";
		private var __uid:uint=0;
		private var __title:String="";
		private var __remark:String="";
		private var __date:String="";
		private var __rect:Rectangle;
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
			_bytes.writeBytes(StringUtil.toBytes(this.__Signature));
			_bytes.writeUnsignedInt(FileEnum.LOGO_FILE_VERSION);//version
			_bytes.writeBytes(StringUtil.toBytes(StringUtil.rightPad(this.__guid,32)));
			_bytes.writeUnsignedInt(this.__uid);
			
			//title
			var bLen:uint=StringUtil.getByteLength(this.__title);
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
			{
				_bytes.writeBytes(StringUtil.toBytes(this.__title));
			}
			
			//remark
			bLen=StringUtil.getByteLength(this.__remark);
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
			{
				_bytes.writeBytes(StringUtil.toBytes(this.__remark));
			}
			
			//date
			_bytes.writeBytes(StringUtil.toBytes(StringUtil.rightPad(this.__date,8)));
			
			//rect
			_bytes.writeFloat(this.__rect.x);
			_bytes.writeFloat(this.__rect.y);
			_bytes.writeFloat(this.__rect.width);
			_bytes.writeFloat(this.__rect.height);
			
			var i:uint;
			var _mBytes:ByteArray;
			var _tempBytes:ByteArray=new ByteArray();
			
			bLen=0;
			//symbols byte length and bytes
			for(i=0;i<this.__symbols.length;i++)
			{
				_mBytes=IByte(this.__symbols[i]).getBytes();
				_tempBytes.writeBytes(_mBytes);
				bLen+=_mBytes.length;
			}
			
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
			{
				_bytes.writeBytes(_tempBytes);
			}
			
			//texts byte length and bytes
			bLen=0;
			_tempBytes=new ByteArray();
			for(i=0;i<this.__texts.length;i++)
			{
				_mBytes=IByte(this.__texts[i]).getBytes();
				_tempBytes.writeBytes(_mBytes);
				bLen+=_mBytes.length;
			}
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
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
		
		//implements IFile
		public function setFileBytes(bytes:ByteArray):void
		{
			bytes.position=0;
			bytes.readMultiByte(4,"GB2312");//skip signature "LOGO"
			this.__version=bytes.readUnsignedInt();
			this.__guid=bytes.readMultiByte(32,"GB2312");
			this.__uid=bytes.readUnsignedInt();
			
			//title
			var bLen:uint=bytes.readUnsignedInt();
			if(bLen>0)
			{
				this.__title=bytes.readMultiByte(bLen,"GB2312");
			}
			
			//remark
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				this.__remark=bytes.readMultiByte(bLen,"GB2312");
			}
			
			this.__date=bytes.readMultiByte(8,"GB2312");
			
			//rect
			this.__rect=new Rectangle();
			this.__rect.x=bytes.readFloat();
			this.__rect.y=bytes.readFloat();
			this.__rect.width=bytes.readFloat();
			this.__rect.height=bytes.readFloat();
			
			var i:uint;
			var tempBytes:ByteArray;
			
			bLen=bytes.readUnsignedInt();//SymbolBytes
			if(bLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,bLen);
				var symbolCollection:SymbolCollection=new SymbolCollection(tempBytes);
				for(i=0;i<symbolCollection.symbols.length;i++)
				{
					this.__symbols.push(Symbol(symbolCollection.symbols[i]));
				}
			}
			
			bLen=bytes.readUnsignedInt();//TextBytes
			if(bLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,bLen);
				var textCollection:TextCollection=new TextCollection(tempBytes);
				for(i=0;i<textCollection.texts.length;i++)
				{
					this.__texts.push(Text(textCollection.texts[i]));
				}
			}
			
			//Thumbnail
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,bLen);
				this.__thumbnail=new Thumbnail(tempBytes);
			}
		}
		
		public function get fileType():String
		{
			return FileEnum.LOGO;
		}
		
		public function getFileBytes():ByteArray
		{
			return this.getBytes();
		}
	}
}