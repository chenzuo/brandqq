package com.brandqq.IO
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	
	import com.brandqq.lib.events.DataLoadEvent;
	
	
	[Event(name="onOpen",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onOpen",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onError",type="com.brandqq.lib.events.DataLoadEvent")]
	
	/**
	 * 表示一个XML格式的文件读取对象
	 * @author Administrator
	 * 
	 */	
	public final class XmlReader extends EventDispatcher
	{
		/**
		 * 构造函数
		 * @param req 由Resources.Requests定义的读取请求
		 * @return 
		 * 
		 */		
		public function XmlReader(req:URLRequest)
		{
			this.__request=req;
			this.__loader=new URLLoader();
			this.__loader.addEventListener(Event.COMPLETE,onLoadedEventHandler);
			this.__loader.addEventListener(IOErrorEvent.IO_ERROR,onLoadedErrorEventHandler);
			this.__loader.addEventListener(IOErrorEvent.NETWORK_ERROR,onLoadedErrorEventHandler);
		}
		
		/**
		 * 开始读取
		 * 
		 */		
		public function read():void
		{
			this.__loader.load(this.__request);
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_OPEN));
		}
		
		/**
		 * 读取完成时，获取XML数据
		 * @return 
		 * 
		 */		
		public function getData():XMLList
		{
			return new XMLList(this.__loader.data);
		}
		
		/**
		 * URLLoader事件侦听器，仅侦听OPEN和COMPLETE
		 * @param e
		 * 
		 */		
		private function onLoadedEventHandler(e:Event):void
		{
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADED));
		}
		
		private function onLoadedErrorEventHandler():void
		{
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_ERROR));
		}
		
		private var __loader:URLLoader;
		private var __request:URLRequest;
	}
}