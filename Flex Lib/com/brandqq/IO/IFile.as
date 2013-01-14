package com.brandqq.IO
{
	import flash.utils.ByteArray;
	
	/**
	 * 表示一个文件对象，可以获取或设置该文件的ByteArray
	 * @author Administrator
	 * 
	 */	
	public interface IFile
	{
		function get fileType():String;
		function get guid():String;
		function get uid():uint;
		function getFileBytes():ByteArray;
		function setFileBytes(bytes:ByteArray):void;
	}
}