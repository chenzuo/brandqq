package com.brandqq.IO
{
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import com.brandqq.lib.events.DataLoadEvent;
	
	[Event(name="onOpen",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onLoading",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onLoaded",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onError",type="com.brandqq.lib.events.DataLoadEvent")]
	
	/**
	 * 以二进制方式读取远程文件
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public final class FileReader extends EventDispatcher
	{
		/**
		 * 构造函数
		 * @param req 由Resources.Requests定义的请求对象
		 * @return 
		 * 
		 */		
		public function FileReader(req:URLRequest)
		{
			this.__request=req;
			__stream=new URLStream();
			__stream.addEventListener(ProgressEvent.PROGRESS,onStreamProgressEventHandler);
			__stream.addEventListener(Event.COMPLETE,onStreamCompletedEventHandler);
			__stream.addEventListener(IOErrorEvent.IO_ERROR,onStreamErrorEventHandler);
		}
		
		/**
		 * 开始读取操作
		 * 
		 */		
		public function read():void
		{
			__stream.load(this.__request);
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_OPEN));
		}
		
		/**
		 * 流事件侦听器:COMPLETE
		 * @param e
		 * 
		 */		
		private function onStreamCompletedEventHandler(e:Event):void
		{
			this.__fileBytes=new ByteArray();
			this.__stream.readBytes(this.__fileBytes);
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADED,
										this.__loadedBytes,this.__totalBytes,this.__fileBytes));
		}
		
		/**
		 * 流事件侦听器:IO_ERROR
		 * @param e
		 * 
		 */		
		private function onStreamErrorEventHandler(e:IOErrorEvent):void
		{
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_ERROR));
		}
		
		/**
		 * 流事件侦听器:PROGRESS
		 * @param e
		 * 
		 */		
		private function onStreamProgressEventHandler(e:ProgressEvent):void
		{
			this.__totalBytes=e.bytesTotal;
			this.__loadedBytes=e.bytesLoaded;
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADING,this.__loadedBytes,this.__totalBytes));
		}
		
		/**
		 * 获取当前已下载的字节数
		 * @return 
		 * 
		 */		
		public function get loadedBytes():uint
		{
			return this.__loadedBytes;
		}
		
		/**
		 * 获取目标文件的总字节数
		 * @return 
		 * 
		 */		
		public function get totalBytes():uint
		{
			return this.__totalBytes;
		}
		
		/**
		 * 获取当前完成的百分比
		 * @return 
		 * 
		 */		
		public function get percent():uint
		{
			if(this.__totalBytes<=0)
			{
				return 0;
			}
			return uint(this.__loadedBytes/this.__totalBytes*100);
		}
		
		/**
		 * 获取目标文件的字节数组，当COMPLETE时可用
		 * @return 
		 * 
		 */		
		public function get fileBytes():ByteArray
		{
			return this.__fileBytes;
		}
		
		private var __stream:URLStream;
		private var __request:URLRequest;
		private var __loadedBytes:uint;
		private var __totalBytes:uint;
		private var __fileBytes:ByteArray;
	}
}