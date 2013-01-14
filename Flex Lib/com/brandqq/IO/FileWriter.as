package com.brandqq.IO
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	
	import com.brandqq.lib.events.DataLoadEvent;
	import com.brandqq.Resources.Requests;
	import mx.controls.Alert;
	
	[Event(name="onOpen",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onError",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onLoading",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onLoaded",type="com.brandqq.lib.events.DataLoadEvent")]
	/**
	 * 以二进制方式上传本地数据到远程
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public final class FileWriter extends EventDispatcher
	{
		/**
		 * 构造函数
		 * @param file 实现IFile接口的对象
		 * @param guid 此值将作为存储时使用的文件名
		 * @return 
		 * 
		 */		
		public function FileWriter(file:IFile)
		{
			this.__file=file;
		}
		
		/**
		 * 开始保存
		 * 
		 */		
		public function save():void
		{
			this.__loader=new URLLoader();
			this.__loader.addEventListener(ProgressEvent.PROGRESS,onLoaderProgressEventHandler);
			this.__loader.addEventListener(Event.COMPLETE,onLoaderEventHandler);
			this.__loader.addEventListener(IOErrorEvent.IO_ERROR,onLoaderErrorEventHandler);
			this.__loader.load(Requests.saveFileRequest(this.__file));
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_OPEN));
		}
		
		/**
		 * URLLoader事件侦听器
		 * @param e
		 * 
		 */		
		private function onLoaderEventHandler(e:Event):void
		{
			if(e.type==Event.COMPLETE)
			{
				this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADED));
			}
		}
		
		private function onLoaderProgressEventHandler(e:ProgressEvent):void
		{
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADING,ProgressEvent(e).bytesLoaded,ProgressEvent(e).bytesTotal));
		}
		
		private function onLoaderErrorEventHandler(e:IOErrorEvent):void
		{
			Alert.show(e+'');
			this.dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_ERROR));
		}
				
		
		/**
		 * 获取当前要保存的文件
		 * @return 
		 * 
		 */		
		public function get file():IFile
		{
			return this.__file;
		}

		private var __file:IFile;
		private var __loader:URLLoader;
	}
}