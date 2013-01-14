package com.brandqq.logo.FontGlyph
{
	import flash.geom.Point;
	import mx.controls.Alert;
	
	public final class GlyphCollection
	{
		public function GlyphCollection(data:String)
		{
			var xml:XMLList=new XMLList(data).child("G");
			this.__glyphs=new Array();
			var g:Glyph;
			var gNode:XMLList;
			var pNodes:XMLList;
			var t:String;
			var size:Point;
			var segs:Array;
			var seg:ISegment;
			var ps:Array;
			var pt:String;
			var pp:String;
			
			for(var i:int=0;i<xml.length();i++)
			{
				gNode=XMLList(xml[i]);
				t=gNode.child("T").children()[0];
				ps=gNode.child("P").attribute("s").toString().split(",");
				size=new Point(Number(ps[0]),Number(ps[1]));
				segs=new Array();
				pNodes=gNode.child("P").child("S");
				for(var j:int=0;j<pNodes.length();j++)
				{
					pt=pNodes[j].attribute("t");
					pp=pNodes[j].attribute("p");
					if(pt=="0")
					{
						seg=new StartPoint(toPoint(pp));
					}
					else if(pt=="1")
					{
						seg=new LineSegment(toPoint(pp));
					}
					else if(pt=="2")
					{
						seg=new CurveSegment(toPoints(pp));
					}
					segs.push(seg);
				}
				g=new Glyph(t,size,segs);
				__glyphs.push(g);
			}
		}
		
		public function get glyphs():Array
		{
			return this.__glyphs;
		}
		
		public function get glyphNum():int
		{
			return this.__glyphs.length;
		}
		
		public function contains(char:String):Boolean
		{
			return this.getGlyphByChar(char)!=null;
		}
		
		public function getGlyphByChar(char:String):Glyph
		{
			if(this.__glyphs.length<=0)
			{
				return null;
			}
			
			for(var i:int=0;i<this.__glyphs.length;i++)
			{
				if(Glyph(this.__glyphs[i]).character==char)
				{
					return this.__glyphs[i] as Glyph;
				}
			}
			
			return null;
		}
		
		public function getGlyphByIndex(idx:int):Glyph
		{
			return this.__glyphs[idx];
		}
		
		private function toPoint(points:String):Point
		{
			var ps:Array=points.split(",");
			return new Point(Number(ps[0]),Number(ps[1]));
		}
		
		private function toPoints(points:String):Array
		{
			var ps:Array=points.split(",");
			var pa:Array=new Array();
			pa.push(new Point(Number(ps[0]),Number(ps[1])));
			pa.push(new Point(Number(ps[2]),Number(ps[3])));
			pa.push(new Point(Number(ps[4]),Number(ps[5])));
			pa.push(new Point(Number(ps[6]),Number(ps[7])));
			return pa;
		}
		
		private var __glyphs:Array;
	}
}