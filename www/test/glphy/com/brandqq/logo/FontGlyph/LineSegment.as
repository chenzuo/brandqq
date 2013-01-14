package com.brandqq.logo.FontGlyph
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public final class LineSegment implements ISegment
	{
		public function LineSegment(p:Point)
		{
			this.__point=p;
		}
		
		public function get type():int
		{
			return this.__TYPE;
		}
		
		public function draw(g:Graphics):void
		{
			g.lineTo(this.__point.x,this.__point.y);
		}
		
		public function get xml():String
		{
			return "<S t=\""+this.__TYPE+"\" p=\""+this.__point.x+","+this.__point.y+"\" />";
		}
		
		private var __point:Point;
		
		private const __TYPE:int=1;
	}
}