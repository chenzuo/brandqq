package com.brandqq.app.card.events
{
	import flash.events.Event;

	public final class CardTextEvent extends Event
	{
		public static const FONT_CHANGE:String="fontChange";
		public static const FONT_SIZE_CHANGE:String="fontSizeChange";
		public static const TEXT_ALIGN_CHANGE:String="textAlignChange";
		public static const TEXT_COLOR_CHANGE:String="textColorChange";
		
		public function CardTextEvent(type:String,property:*)
		{
			super(type);
			__propertyValue=property;
			switch(type)
			{
				case FONT_CHANGE:
					__font=property;
					break;
				case FONT_SIZE_CHANGE:
					__fontSize=property;
					break;
				case TEXT_ALIGN_CHANGE:
					__align=property;
					break;
				case TEXT_COLOR_CHANGE:
					__color=property;
					break;
			}
		}
		
		public function get font():String
		{
			return this.__font;
		}
		
		public function get fontSize():uint
		{
			return this.__fontSize;
		}
		
		public function get align():String
		{
			return this.__align;
		}
		
		public function get color():uint
		{
			return this.__color;
		}
		
		public function get propertyValue():*
		{
			return this.__propertyValue;
		}
		
		private var __font:String;
		private var __fontSize:uint;
		private var __align:String;
		private var __color:uint;
		private var __propertyValue:*;
	}
}