package com.brandqq.logo.FontGlyph
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public final class CurveSegment implements ISegment
	{
		public function CurveSegment(points:Array)
		{
			this.__p1=points[0];
			this.__c1=points[1];
			this.__c2=points[2];
			this.__p2=points[3];
			
			anchor1 = __p1;
            anchor5 = __p2;

            m1 = GetMidPoint(__p1, __c1);
            m2 = GetMidPoint(__c1, __c2);
            m3 = GetMidPoint(__c2, __p2);
            m4 = GetMidPoint(m1, m2);
            m5 = GetMidPoint(m2, m3);

            anchor3 = GetMidPoint(m4, m5);

            m6 = GetMidPoint(__p1, m1);
            m7 = GetMidPoint(__p2, m3);

            m8 = GetMidPoint(m4, anchor3);
            m9 = GetMidPoint(anchor3, m5);

            control1 = GetMidPoint(m6, m1);
            control2 = GetMidPoint(m4, m8);
            control3 = GetMidPoint(m9, m5);
            control4 = GetMidPoint(m3, m7);

            anchor2 = GetMidPoint(control1, control2);
            anchor4 = GetMidPoint(control3, control4);
		}
		
		public function get type():int
		{
			return this.__TYPE;
		}
		
		public function draw(g:Graphics):void
		{
        	g.curveTo(control1.x,control1.y,anchor2.x,anchor2.y);
        	g.curveTo(control2.x,control2.y,anchor3.x,anchor3.y);
        	g.curveTo(control3.x,control3.y,anchor4.x,anchor4.y);
        	g.curveTo(control4.x,control4.y,anchor5.x,anchor5.y);
		}
		
		public function get xml():String
		{
			var _xml:String="";
			_xml+="<S t=\""+this.__TYPE+"\" p=\"";
			_xml+=this.__p1.x+","+this.__p1.y+",";
			_xml+=this.__c1.x+","+this.__c1.y+",";
			_xml+=this.__c2.x+","+this.__c2.y+",";
			_xml+=this.__p2.x+","+this.__p2.y+"\"";
			_xml+="/>";
			return _xml;
		}
				
		private function GetMidPoint(s:Point,e:Point):Point
		{
			return Point.interpolate(s,e,0.5);
		}
		
		private var __p1:Point;//start point
		private var __c1:Point;//control point 1
		private var __c2:Point;//control point 2
		private var __p2:Point;//end point
		
		private var anchor1:Point, anchor2:Point, anchor3:Point, anchor4:Point, anchor5:Point;
        private var control1:Point, control2:Point, control3:Point, control4:Point;
		private var m1:Point,m2:Point,m3:Point,m4:Point,m5:Point,m6:Point,m7:Point,m8:Point,m9:Point;
		
		private const __TYPE:int=2;
	}
}