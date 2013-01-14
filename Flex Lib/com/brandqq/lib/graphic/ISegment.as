package com.brandqq.lib.graphic
{
	import flash.display.Graphics;
	import com.brandqq.IO.IByte;
	
	/**
	 * ISegment
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public interface ISegment extends IByte
	{
		function get type():int;
		function draw(g:Graphics,offsetX:Number=0,offsetY:Number=0):void;
		function get points():String; 
		function toString():String;
	}
}