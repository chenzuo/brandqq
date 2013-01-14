package com.brandqq.lib.card
{
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	
	import com.brandqq.IO.IByte;
	import com.brandqq.IO.IFile;
	import com.brandqq.IO.FileEnum;
	import com.brandqq.IO.FileReader;
	import com.brandqq.IO.FileWriter;
	import com.brandqq.lib.graphic.Thumbnail;
	import com.brandqq.lib.events.FileEvent;
	import com.brandqq.Resources.Requests;
	import com.brandqq.lib.logo.LogoFile;
	import com.brandqq.lib.util.StringUtil;
	
	[Event(name="fileOpen",type="com.brandqq.lib.events.FileEvent")]
	[Event(name="fileSave",type="com.brandqq.lib.events.FileEvent")]
	/**
	 * 
	 * @author Administrator
	 * 字段					类型				备注
		Signature		string		标志字段，Always “CARD”
		Version			uint		版本
		Guid			string(32)	Guid,空时使用‘?’补齐
		Uid				uint	
		NameBytes		uint	
		Name			string		If NameBytes>0
		Width			uint		300dpi下的象素宽度
		Height			uint		300dpi下的象素高度
		FrontFaceBytes	uint		存储FrontFace所用的字节数
		FrontFace		CardFace	If FrontFaceBytes>0
		BackFaceBytes	uint		存储BackFace所用的字节数
		BackFace		CardFace	If BackFaceBytes>0
		LogoFileBytes	uint	
		LogoFile		LogoFile	If LogoFileBytes>0
	 */	
	public final class CardFile extends EventDispatcher implements IByte,IFile
	{
		/**
		 * 构造函数
		 * @return 
		 * 
		 */		
		public function CardFile(asTemp:Boolean=false)
		{
			super();
			__saveAsTemp=asTemp;
		}
		
		/**
		 * 获取Card文件版本
		 * @return 
		 * 
		 */		
		public function get version():uint
		{
			return this.__version;
		}
		
		/**
		 * 获取当前Card文件的guid
		 * @return 
		 * 
		 */		
		public function get guid():String
		{
			return this.__guid;
		}
		/**
		 * 设置当前Card文件的
		 * @param value
		 * 
		 */		
		public function set guid(value:String):void
		{
			this.__guid=value;
		}
		
		/**
		 * 获取当前Card文件的用户ID
		 * @return 
		 * 
		 */		
		public function get uid():uint
		{
			return this.__uid;
		}
		/**
		 * 设置当前Card文件的用户ID
		 * @param value
		 * 
		 */		
		public function set uid(value:uint):void
		{
			this.__uid=value;
		}
		
		/**
		 * 获取当前Card文件的名称
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return this.__name;
		}
		/**
		 * 设置当前Card文件的名称
		 * @param value
		 * 
		 */		
		public function set name(value:String):void
		{
			this.__name=value;
		}
		
		/**
		 * 获取当前Card文件的宽度(px)
		 * @return 
		 * 
		 */		
		public function get width():uint
		{
			return this.__width;
		}
		public function set width(value:uint):void
		{
			this.__width=value;
		}
		/**
		 * 获取当前Card文件的高度(px)
		 * @return 
		 * 
		 */		
		public function get height():uint
		{
			return this.__height;
		}
		public function set height(value:uint):void
		{
			this.__height=value;
		}
		
		/**
		 * 获取当前Card文件的正面
		 * @return 
		 * 
		 */		
		public function get frontFace():CardFace
		{
			return this.__frontFace;
		}
		public function set frontFace(value:CardFace):void
		{
			this.__frontFace=value;
		}
		
		/**
		 * 获取当前Card文件的背面
		 * @return 
		 * 
		 */		
		public function get backFace():CardFace
		{
			return this.__backFace;
		}
		public function set backFace(value:CardFace):void
		{
			this.__backFace=value;
		}
		
		/**
		 * 获取当前Card文件包含的LogoFile
		 * @return 
		 * 
		 */		
		public function get logoFile():LogoFile
		{
			return this.__logoFile;
		}
		public function set logoFile(value:LogoFile):void
		{
			this.__logoFile=value;
		}
		
		private const __Signature:String="CARD";
		private var __version:uint=FileEnum.CARD_FILE_VERSION;
		private var __guid:String="";
		private var __uid:uint=0x0;
		private var __name:String="";
		private var __width:uint=0;
		private var __height:uint=0;
		private var __frontFace:CardFace;
		private var __backFace:CardFace;
		private var __logoFile:LogoFile;
		
		private var __saveAsTemp:Boolean=false;
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeMultiByte(this.__Signature,"GB2312");
			_bytes.writeUnsignedInt(this.__version);
			_bytes.writeMultiByte(StringUtil.rightPad(this.__guid,32),"GB2312");
			_bytes.writeUnsignedInt(this.__uid);
			var len:uint=StringUtil.getByteLength(this.__name);
			_bytes.writeUnsignedInt(len);
			if(len>0)
			{
				_bytes.writeMultiByte(this.__name,"GB2312");
			}
			
			//width and height
			_bytes.writeUnsignedInt(this.__width);
			_bytes.writeUnsignedInt(this.__height);
			
			var _tempBytes:ByteArray;
			
			//front face
			if(this.__frontFace==null)
			{
				_bytes.writeUnsignedInt(0);
			}
			else
			{
				_tempBytes=this.__frontFace.getBytes();
				_bytes.writeUnsignedInt(_tempBytes.length);
				_bytes.writeBytes(_tempBytes);
			}
			
			//back face
			if(this.__backFace==null)
			{
				_bytes.writeUnsignedInt(0);
			}
			else
			{
				_tempBytes=this.__backFace.getBytes();
				_bytes.writeUnsignedInt(_tempBytes.length);
				_bytes.writeBytes(_tempBytes);
			}
			
			//logoFile
			if(this.__logoFile==null)
			{
				_bytes.writeUnsignedInt(0);
			}
			else
			{
				_tempBytes=this.__logoFile.getBytes();
				_bytes.writeUnsignedInt(_tempBytes.length);
				_bytes.writeBytes(_tempBytes);
			}
			
			return _bytes;
		}
		
		//implements IFile
		public function setFileBytes(bytes:ByteArray):void
		{
			bytes.position=0;
			bytes.readMultiByte(4,"GB2312");//skip signature "CARD"
			this.__version=bytes.readUnsignedInt();
			this.__guid=bytes.readMultiByte(32,"GB2312");
			this.__uid=bytes.readUnsignedInt();
			
			var bLen:uint=bytes.readUnsignedInt();
			if(bLen>0)
			{
				this.__name=bytes.readMultiByte(bLen,"GB2312");
			}
			
			this.__width=bytes.readUnsignedInt();
			this.__height=bytes.readUnsignedInt();
			
			var tempBytes:ByteArray;
			
			//FrontFace
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,bLen);
				this.__frontFace=CardFace.createFromBytes(tempBytes,CardFace.FACE_FRONT);
			}
			
			//BackFace
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,bLen);
				this.__backFace=CardFace.createFromBytes(tempBytes,CardFace.FACE_BACK);
			}
			
			//LogoFile
			bLen=bytes.readUnsignedInt();
			if(bLen>0)
			{
				tempBytes=new ByteArray();
				bytes.readBytes(tempBytes,0,bLen);
				this.__logoFile=new LogoFile();
				this.__logoFile.setFileBytes(tempBytes);
			}
		}
		public function get fileType():String
		{
			if(__saveAsTemp)
			{
				return FileEnum.CARD_TEMP;
			}
			else
			{
				return FileEnum.CARD;
			}
		}
		public function getFileBytes():ByteArray
		{
			return this.getBytes();
		}
	}
}