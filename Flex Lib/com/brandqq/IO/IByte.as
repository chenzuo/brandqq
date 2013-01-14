package com.brandqq.IO
{
	import flash.utils.ByteArray;
	/**
	 * IByte
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public interface IByte
	{
		/**
		 * 将指定对象的ByteArray写入指定的目标ByteArray
		 * @param bytes
		 * 
		 */		
		function writeTo(bytes:ByteArray):void;
		
		/**
		 * 获取指定对象的ByteArray
		 * @return 
		 * 
		 */		
		function getBytes():ByteArray;
	}
}