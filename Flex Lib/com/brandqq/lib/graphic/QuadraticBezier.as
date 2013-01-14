package com.brandqq.lib.graphic
{
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	
	import com.brandqq.IO.IByte;
	
	/**
	 * 表示一条二次贝塞尔曲线
	 * @author mickeydream@hotmail.com
	 * 字段		类型		描述				备注
		Type	byte	Segment的类型		0 起点
										1 直线
										2 二次贝塞尔曲线
										3 三次贝塞尔曲线
		Points	Array	Segment包含的点	If Type=0 or 1, Point[1]
										If Type=2, Point[2]
										If Type=3, Point[4]
	 */
	public final class QuadraticBezier implements ISegment
	{
		public function QuadraticBezier(p1:Point,p2:Point)
		{
			this.__point1=p1;
			this.__point2=p2;
		}
		
		public function toString():String
		{
			return "{Type=2,x1="+__point1.x+",y1="+__point1.y+",x2="+__point2.x+",y2="+__point2.y+"}";
		}
		
		private var __point1:Point;
		private var __point2:Point;
		
		//implements ISegment
		public function get type():int
		{
			return 2;
		}
		
		public function draw(g:Graphics,offsetX:Number=0,offsetY:Number=0):void
		{
			g.curveTo(this.__point1.x+offsetX,this.__point1.y+offsetY,this.__point2.x+offsetX,this.__point2.y+offsetY);
		}
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeByte(this.type);
			_bytes.writeFloat(this.__point1.x);
			_bytes.writeFloat(this.__point1.y);
			_bytes.writeFloat(this.__point2.x);
			_bytes.writeFloat(this.__point2.y);
			return _bytes;
		}
		
		public function get points():String
		{
			return this.__point1.toString()+";"+this.__point2.toString();
		}
	}
}