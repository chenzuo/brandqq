package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	
	/**
	 * 表示一组Text
	 * 从指定的ByteArray读取这样一组Text
	 * @author Administrator
	 * 
	 */	
	public final class TextCollection
	{
		public function TextCollection(bytes:ByteArray)
		{
			this.__texts=new Array();
			bytes.position=0;
			
			var len:uint;
			var textBytes:ByteArray;
			while(bytes.position<bytes.length-1)
			{
				bytes.readMultiByte(4,"GB2312");//skip the tag:SYMB
				len=bytes.readUnsignedInt();//4 bytes
				bytes.position-=8;
				textBytes=new ByteArray();
				bytes.readBytes(textBytes,0,len+4);
				this.__texts.push(Text.createFromBytes(textBytes));
			}
		}
		
		public function get texts():Array
		{
			return this.__texts;
		}
		
		private var __texts:Array;
	}
}