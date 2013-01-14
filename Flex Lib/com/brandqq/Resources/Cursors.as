package com.brandqq.Resources
{
	import flash.display.MovieClip;

	/**
	 * 系统光标资源
	 * @author mickeydream@hotmail.com
	 *  
	 */	
	public class Cursors extends MovieClip
	{
		[Embed(source="cursor_move.png")]
		public static const MOVE:Class;
		
		[Embed(source="cursor_resize_h.png")]
		public static const RESIZE_H:Class;
		
		[Embed(source="cursor_resize_l.png")]
		public static const RESIZE_L:Class;
		
		[Embed(source="cursor_resize_r.png")]
		public static const RESIZE_R:Class;
		
		[Embed(source="cursor_resize_v.png")]
		public static const RESIZE_V:Class;
		
		[Embed(source="cursor_rotation.png")]
		public static const ROTATION:Class;
				
		[Embed(source="cursor_colorCross.png")]
		public static const COLOR_CROSS:Class;
		
		[Embed(source="cursor_letfArrow.png")]
		public static const ARROW_LEFT:Class;
	}
}