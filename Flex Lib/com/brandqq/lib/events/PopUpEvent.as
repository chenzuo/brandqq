package com.brandqq.lib.events
{
	import flash.events.Event;

	/**
	 * 由PopUpBox触发的事件
	 * @author Administrator
	 * 
	 */	
	public class PopUpEvent extends Event
	{
		public static const CLOSE:String="close";
		public function PopUpEvent(type:String)
		{
			super(type);
		}
	}
}