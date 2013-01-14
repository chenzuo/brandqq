package com.brandqq.lib.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * 表示数据传输事件
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public class DataLoadEvent extends Event
	{
		public static var ON_OPEN:String="onOpen";
		public static var ON_LOADING:String="onLoading";
		public static var ON_LOADED:String="onLoaded";
		public static var ON_ERROR:String="onError";
		
		public function DataLoadEvent(type:String,loaded:uint=0,total:uint=0,data:ByteArray=null)
		{
			super(type);
			this.__loadedBytes=loaded;
			this.__totalBytes=total;
			this.__data=data;
		}
		
		public function get loadedBytes():uint
		{
			return this.__loadedBytes;
		}
		
		public function get totalBytes():uint
		{
			return this.__totalBytes;
		}
		
		public function get data():ByteArray
		{
			return this.__data;
		}
		
		private var __loadedBytes:uint;
		private var __totalBytes:uint;
		private var __data:ByteArray;
	}
}