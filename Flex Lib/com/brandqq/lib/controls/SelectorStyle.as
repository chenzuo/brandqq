package com.brandqq.lib.controls
{
	/**
	 * 表示选择器控件的呈现样式
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public final class SelectorStyle
	{
		//contains 8 control handlers and the rotation handler
		public static var Normal:String="normal";
		
		//contains 4 control handlers
		public static var Simple:String="simple";
		
		//contains 8 control handlers and the rotation handler and a rotation center point
		public static var Super:String="super";
		
		//display the rect,and allow move
		public static var Base:String="base";
		
		//only display the rect on the selected item
		public static var Select:String="select";
		
		public static function checkAvalibleStyle(s:String):String
		{
			if(s!=Normal && s!=Simple && s!=Super)
			{
				return Normal;
			}
			return s;
		}
	}
}