package com.brandqq.app.card
{
	import flash.events.EventDispatcher;
	
	import com.brandqq.IO.*;
	import com.brandqq.Resources.Requests;
	import com.brandqq.lib.events.DataLoadEvent;
	import com.brandqq.user.User;
	import com.brandqq.lib.logo.LogoFile;
	import com.brandqq.app.card.events.SystemEvent;
	
	[Event(name="init",type="com.brandqq.app.card.events.SystemEvent")]
	[Event(name="progress",type="com.brandqq.app.card.events.SystemEvent")]
	[Event(name="completed",type="com.brandqq.app.card.events.SystemEvent")]
	
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
						initUserLogoList();
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void
					{
						initUserLogoList();
					}
				);
			__xmlReader.read();
		}
		
		/**
		 * 初始化当前用户Logo列表
		 * 
		 */
		private function initUserLogoList():void
		{
			var __xmlReader:XmlReader=new XmlReader(Requests.userLogoListRequest());
			__xmlReader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.PROGRESS,"正在初始化用户Logo列表..."));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
					{
						BusinessCard.userLogosData=__xmlReader.getData();
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
						BusinessCard.systemFontsData=__xmlReader.getData();
						initTempsList();
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void
					{
						initTempsList();
					}
				);
			__xmlReader.read();
		}

		/**
		* 初始化名片模板数据
		*/
		private function initTempsList():void
		{
			var __xmlReader:XmlReader=new XmlReader(Requests.cardTemplatesRequest());
			__xmlReader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
					{
						dispatchEvent(new SystemEvent(SystemEvent.PROGRESS,"正在初始化名片模板数据..."));
					}
				);
			__xmlReader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
					{
						BusinessCard.cardTemplatesData=__xmlReader.getData();
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