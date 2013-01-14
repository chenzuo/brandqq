package com.brandqq.lib.events
{
	import flash.events.Event;

	/**
	 * 轮廓数据呈现事件
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public final class RenderEvent extends Event
	{
		public static var ON_RENDING:String="onRending";
		public static var ON_REND_OVER:String="onRendOver";
		
		public function RenderEvent(type:String)
		{
			super(type);
		}
	}
}