package com.brandqq.app.logo
{
	import flash.events.EventDispatcher;
	import mx.controls.Alert;
	
	import com.brandqq.IO.*;
	import com.brandqq.Resources.Requests;
	import com.brandqq.lib.events.DataLoadEvent;
	import com.brandqq.user.User;
	
	[Event(name="init",type="com.brandqq.app.logo.SystemEvent")]
	[Event(name="progress",type="com.brandqq.app.logo.SystemEvent")]
	[Event(name="completed",type="com.brandqq.app.logo.SystemEvent")]
	
	public final class SystemInitializer extends EventDispatcher
	{		
		public function init():void
		{
			this.dispatchEvent(new SystemEvent(SystemEvent.INIT,"准备初始化..."));
			initUser();
		}
		
		/**
		 * 初始化当前用户
		 *  
		 */ 
		private function initUser():void
		{
			var __xmlReader:XmlReader=new XmlReader(Requests.userStatusRequest());
			__xmlReader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.PROGRESS,"初始化当前用户..."));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
					{
						User.initCurrent(__xmlReader.getData());
						initLogoSymbolCategory();
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void
					{
						initLogoSymbolCategory();
					}
				);
			__xmlReader.read();
		}
		
		/**
		 * 初始化当前用户Logo列表
		 * 
		 */
		private function initLogoSymbolCategory():void
		{
			var __xmlReader:XmlReader=new XmlReader(Requests.logoSymbolCategoriesRequest());
			__xmlReader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.PROGRESS,"正在初始化图形分类..."));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
					{
						LogoSys.symbolCategoryData=__xmlReader.getData();
						//Alert.show(__xmlReader.getData()+"");
						initSystemFonts();
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void
					{
						initSystemFonts();
					}
				);
			__xmlReader.read();
		}
		
		/**
		 * 初始化系统字体
		 * 
		 */		
		private function initSystemFonts():void
		{
			var __xmlReader:XmlReader=new XmlReader(Requests.systemFontsRequest());
			__xmlReader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.PROGRESS,"正在初始化系统字体..."));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
					{
						LogoSys.systemFontsData=__xmlReader.getData();
						initSystemColors();
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void
					{
						initSystemColors();
					}
				);
			__xmlReader.read();
		}
		
		/**
		 * 初始化系统颜色
		 * 
		 */		
		private function initSystemColors():void
		{
			var __xmlReader:XmlReader=new XmlReader(Requests.systemNamedColorsRequest());
			__xmlReader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.PROGRESS,"正在初始化系统颜色..."));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
					{
						LogoSys.systemNamedColorsData=__xmlReader.getData();
						dispatchEvent(new SystemEvent(SystemEvent.COMPLETED,""));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.COMPLETED,""));
					}
				);
			__xmlReader.read();
		}
	}
}