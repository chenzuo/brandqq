package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	
	/**
	 * 表示一组Symbol对象
	 * 从一个ByteArray中读取出这样一组Symbol
	 * @author Administrator
	 * 
	 */	
	public final class SymbolCollection
	{
		public function SymbolCollection(bytes:ByteArray)
		{
			this.__symbols=new Array();
			bytes.position=0;
			
			var len:uint;
			var symbolBytes:ByteArray;
			while(bytes.position<bytes.length-1)
			{
				bytes.readMultiByte(4,"GB2312");//skip the tag:SYMB
				len=bytes.readUnsignedInt();//a uint type include 4 bytes
				bytes.position-=8;
				symbolBytes=new ByteArray();
				bytes.readBytes(symbolBytes,0,len+4);
				this.__symbols.push(Symbol.createFromBytes(symbolBytes));
			}
		}
		
		public function get symbols():Array
		{
			return this.__symbols;
		}
		
		private var __symbols:Array;
	}
}