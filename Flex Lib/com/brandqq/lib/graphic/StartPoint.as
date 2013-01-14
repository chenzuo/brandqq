package com.brandqq.lib.graphic
{
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import com.brandqq.IO.IByte;
	
	/**
	 * 表示一条线段的起点
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
	public final class StartPoint implements ISegment
	{
		public function StartPoint(p:Point)
		{
			this.__point=p;
		}
		
		public function toString():String
		{
			return "{Type=0,x="+__point.x+",y="+__point.y+"}";
		}
		
		private var __point:Point;
		
		
		//implements ISegment
		public function get type():int
		{
			return 0;
		}
		
		public function draw(g:Graphics,offsetX:Number=0,offsetY:Number=0):void
		{
			g.moveTo(this.__point.x+offsetX,this.__point.y+offsetY);
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
			_bytes.writeFloat(this.__point.x);
			_bytes.writeFloat(this.__point.y);
			return _bytes;
		}
		
		public function get points():String
		{
			return this.__point.toString();
		}
	}
}