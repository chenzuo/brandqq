package com.brandqq.app.card.events
{
	import flash.events.Event;
	import flash.display.DisplayObject;

	public final class CardElementEvent extends Event
	{
		public static const ELEMENT_SELECTED:String="elementSelected";
		
		public function CardElementEvent(type:String,element:DisplayObject)
		{
			super(type);
			__element=element;
		}
		
		public function get element():DisplayObject
		{
			return this.__element;
		}
		
		private var __element:DisplayObject;
	}
}