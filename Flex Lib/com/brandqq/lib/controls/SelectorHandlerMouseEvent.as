package com.brandqq.lib.controls
{
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	/**
	 * 选择控件的控制柄鼠标事件
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	internal class SelectorHandlerMouseEvent extends MouseEvent
	{
		public static var ON_MOUSEDOWN:String="onHandlerMouseDown";
		
		public function SelectorHandlerMouseEvent(type:String,handler:SelectorHandler)
		{
			super(type);
			this.__handler=handler;
		}
		
		public function get handler():SelectorHandler
		{
			return this.__handler;
		}
		
		private var __handler:SelectorHandler;
	}
}