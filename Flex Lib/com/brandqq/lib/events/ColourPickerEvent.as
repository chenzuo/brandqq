package com.brandqq.lib.events
{
	import flash.events.Event;
	
	public final class ColourPickerEvent extends Event
	{
		public static const COLOR_CHANGE:String="onColorChange";
		
		public function ColourPickerEvent(type:String,color:uint)
		{
			super(type);
			__color=color;
		}
		
		public function set color(value:uint):void
		{
			__color=value;
		}
		public function get color():uint
		{
			return __color;
		}
		
		
		private var __color:uint;
		
	}
}