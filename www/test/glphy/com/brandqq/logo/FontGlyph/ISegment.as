package com.brandqq.logo.FontGlyph
{
	import flash.display.Graphics;
	
	public interface ISegment
	{
		function get type():int;
		function draw(g:Graphics):void;
		function get xml():String;
	}
}