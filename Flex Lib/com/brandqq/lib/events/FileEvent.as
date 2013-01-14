package com.brandqq.lib.events
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.brandqq.IO.IFile;

	/**
	 * 表示文件打开或保存事件
	 * @author Administrator
	 * 
	 */	
	public class FileEvent extends Event
	{
		public static const FILE_OPEN:String="fileOpen";
		public static const FILE_SAVE:String="fileSave";
		
		public function FileEvent(type:String,req:URLRequest,fileObj:IFile)
		{
			super(type);
			this.__fileRequest=req;
			this.__file=fileObj;
		}
		
		public function get fileRequest():URLRequest
		{
			return this.__fileRequest;
		}
		
		public function get file():IFile
		{
			return this.__file;
		}
		
		private var __fileRequest:URLRequest;
		private var __file:IFile;
	}
}