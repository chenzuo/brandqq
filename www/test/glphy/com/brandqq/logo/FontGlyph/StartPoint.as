package com.brandqq.logo.FontGlyph
{
	import flash.geom.Point;
	import flash.display.Graphics;
	
	public final class StartPoint implements ISegment
	{
		public function StartPoint(p:Point)
		{
			this.__point=p;
		}
		
		public function get type():int
		{
			return this.__TYPE;
		}
		
		public function draw(g:Graphics):void
		{
			g.moveTo(this.__point.x,this.__point.y);
		}
		
		public function get xml():String
		{
			return "<S t=\""+this.__TYPE+"\" p=\""+this.__point.x+","+this.__point.y+"\" />";
		}
		
		private var __point:Point;//moveTo point
		
		private var __TYPE:int=0;
	}
}