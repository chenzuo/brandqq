package com.brandqq.logo.FontGlyph
{
	import flash.geom.Point;
	import flash.display.Graphics;
	
	public final class Glyph
	{
		public function Glyph(char:String,size:Point,segments:Array=null)
		{
			this.__character=char;
			this.__glyphSize=size;
			if(segments==null)
			{
				this.__segments=new Array();
			}
			else
			{
				this.__segments=segments;
			}
		}
		
		public function addSegment(seg:ISegment):void
		{
			this.__segments.push(seg);
		}
		
		public function render(g:Graphics):void
		{
			for(var i:int=0;i<this.__segments.length;i++)
			{
				ISegment(this.__segments[i]).draw(g);
			}
		}
		
		public function get character():String
		{
			return this.__character;
		}
		
		public function get segments():Array
		{
			return this.__segments;
		}
		
		public function get glyphWidth():Number
		{
			return this.__glyphSize.x;
		}
		
		private var __character:String;
		private var __segments:Array;
		private var __glyphSize:Point;
	}
}