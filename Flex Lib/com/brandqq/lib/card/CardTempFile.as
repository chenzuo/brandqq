package com.brandqq.lib.card
{
	import flash.utils.ByteArray;
	
	import com.brandqq.IO.IFile;
	import com.brandqq.IO.FileEnum;
	import com.brandqq.lib.util.StringUtil;

	/**
	 * 表示一个Card模板文件
	 * @author Administrator
	 * 字段			类型				描述
	 * StyleBytes	uint			存储Style所用的字节数
	 * Style		String			
	 * CardFile		CardFile		
	 */	

	public final class CardTempFile implements IFile
	{
		public function CardTempFile(style:String,cardFile:CardFile)
		{
			__tempStyle=style;
			__cardFile=cardFile;
		}
		
		public function get style():String
		{
			return __tempStyle;
		}
		public function set style(value:String):void
		{
			__tempStyle=value;
		}
		
		
		private var __tempStyle:String;
		private var __cardFile:CardFile;
		
		public function get guid():String
		{
			return __cardFile.guid;
		}
		
		public function get uid():uint
		{
			return __cardFile.uid;
		}
		
		public function get fileType():String
		{
			return FileEnum.CARD_TEMP;
		}
		
		public function getFileBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			var bLen:uint=StringUtil.getByteLength(__tempStyle);
			_bytes.writeUnsignedInt(bLen);
			if(bLen>0)
			{
				_bytes.writeBytes(StringUtil.toBytes(__tempStyle));
			}
			_bytes.writeBytes(__cardFile.getFileBytes());
			return _bytes;
		}
		
		public function setFileBytes(bytes:ByteArray):void
		{
			bytes.position=0;
			var bLen:uint=bytes.readUnsignedInt();
			if(bLen>0)
			{
				__tempStyle=bytes.readMultiByte(bLen,"GB2312");
			}
			else
			{
				__tempStyle="";
			}
			
			var _cardBytes:ByteArray=new ByteArray();
			bytes.readBytes(_cardBytes);
			__cardFile=new CardFile();
			__cardFile.setFileBytes(_cardBytes);
		}
	}
}