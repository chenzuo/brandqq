package com.brandqq.lib.events
{
	import flash.events.Event;

	public final class LayoutEvent extends Event
	{
		public static const CHANGE:String="onChange";
		
		
		public function LogoAlignWindowEvent(value:String,isMatchCanvas:Boolean)
		{
			super(CHANGE);
			__paramValue=value;
			__isMatchCanvas=isMatchCanvas;
		}
		
		public function get paramValue():String
		{
			return this.__paramValue.toLowerCase();
		}
		
		public function get isMatchCanvas():Boolean
		{
			return this.__isMatchCanvas;
		}
		
		private var __paramValue:String;
		private var __isMatchCanvas:Boolean;
	}
}