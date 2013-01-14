package com.brandqq.app.card.events
{
	import flash.events.Event;

	public final class AppStepEvent extends Event
	{
		public static const TEXT_RENDING:String="onTextRending";
		public static const TEXT_RENDED:String="onTextRended";
		public static const SAVE:String="onSave";
		
		public function AppStepEvent(type:String)
		{
			super(type);
		}
	}
}