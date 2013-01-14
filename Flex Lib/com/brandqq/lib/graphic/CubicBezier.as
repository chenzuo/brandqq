package com.brandqq.lib.graphic
{
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	
	import com.brandqq.IO.IByte;
	/**
	 * 表示一条三次贝塞尔曲线
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
	public final class CubicBezier implements ISegment
	{
		/**
		 * 构造函数
		 * @param p1 表示三次贝塞尔曲线的起点
		 * @param p2 表示三次贝塞尔曲线的第一个控制点
		 * @param p3 表示三次贝塞尔曲线的第二个控制点
		 * @param p4 表示三次贝塞尔曲线的终点
		 * @return 
		 * 
		 */		
		public function CubicBezier(p1:Point,p2:Point,p3:Point,p4:Point)
		{
			this.__p1=p1;
			this.__c1=p2;
			this.__c2=p3;
			this.__p2=p4;
			
			this.__anchor1 = this.__p1;
            this.__anchor5 = this.__p2;

            this.__m1 = Point.interpolate(this.__p1, this.__c1,0.5);
            this.__m2 = Point.interpolate(this.__c1, this.__c2,0.5);
            this.__m3 = Point.interpolate(this.__c2, this.__p2,0.5);
            this.__m4 = Point.interpolate(this.__m1, this.__m2,0.5);
            this.__m5 = Point.interpolate(this.__m2, this.__m3,0.5);

            this.__anchor3 = Point.interpolate(this.__m4, this.__m5,0.5);

            this.__m6 = Point.interpolate(this.__p1, this.__m1,0.5);
            this.__m7 = Point.interpolate(this.__p2, this.__m3,0.5);

            this.__m8 = Point.interpolate(this.__m4, this.__anchor3,0.5);
            this.__m9 = Point.interpolate(this.__anchor3, this.__m5,0.5);

            this.__control1 = Point.interpolate(this.__m6, this.__m1,0.5);
            this.__control2 = Point.interpolate(this.__m4, this.__m8,0.5);
            this.__control3 = Point.interpolate(this.__m9, this.__m5,0.5);
            this.__control4 = Point.interpolate(this.__m3, this.__m7,0.5);

            this.__anchor2 = Point.interpolate(this.__control1, this.__control2,0.5);
            this.__anchor4 = Point.interpolate(this.__control3, this.__control4,0.5);
		}
		
		/**
		 * 将一条三次贝塞尔曲线转换为四条近似的二次贝塞尔曲线，并以Array返回
		 * @return 
		 * 
		 */		
		public function get quadraticBeziers():Array
		{
			var __qBeziers:Array=new Array();
			__qBeziers.push(new QuadraticBezier(this.__control1,this.__anchor2));
			__qBeziers.push(new QuadraticBezier(this.__control2,this.__anchor3));
			__qBeziers.push(new QuadraticBezier(this.__control3,this.__anchor4));
			__qBeziers.push(new QuadraticBezier(this.__control4,this.__anchor5));
			return __qBeziers;
		}
		
		public function toString():String
		{
			var str:String="{Type=3,";
			str+="x1="+__p1.x+",y1="+__p1.y;
			str+="x2="+__c1.x+",y2="+__c1.y;
			str+="x3="+__c2.x+",y3="+__c2.y;
			str+="x4="+__p2.x+",y4="+__p2.y;
			return str;
		}
		
		private var __p1:Point;//start point
		private var __c1:Point;//__control point 1
		private var __c2:Point;//__control point 2
		private var __p2:Point;//end point
		
		private var __anchor1:Point, __anchor2:Point, __anchor3:Point, __anchor4:Point, __anchor5:Point;
        private var __control1:Point, __control2:Point, __control3:Point, __control4:Point;
		private var __m1:Point,__m2:Point,__m3:Point,__m4:Point;
		private var __m5:Point,__m6:Point,__m7:Point,__m8:Point,__m9:Point;
		
		//implements ISegment
		public function get type():int
		{
			return 3;
		}
		
		public function draw(g:Graphics,offsetX:Number=0,offsetY:Number=0):void
		{
			//g.moveTo(this.__anchor1.x,this.__anchor1.y);
			g.curveTo(__control1.x+offsetX,__control1.y+offsetY,__anchor2.x+offsetX,__anchor2.y+offsetY);
        	g.curveTo(__control2.x+offsetX,__control2.y+offsetY,__anchor3.x+offsetX,__anchor3.y+offsetY);
        	g.curveTo(__control3.x+offsetX,__control3.y+offsetY,__anchor4.x+offsetX,__anchor4.y+offsetY);
        	g.curveTo(__control4.x+offsetX,__control4.y+offsetY,__anchor5.x+offsetX,__anchor5.y+offsetY);
		}
		
		public function get points():String
		{
			return this.__p1.toString()+";"+this.__c1.toString()+";"+this.__c2.toString()+";"+this.__p2.toString();
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
			_bytes.writeFloat(this.__p1.x);
			_bytes.writeFloat(this.__p1.y);
			_bytes.writeFloat(this.__c1.x);
			_bytes.writeFloat(this.__c1.y);
			_bytes.writeFloat(this.__c2.x);
			_bytes.writeFloat(this.__c2.y);
			_bytes.writeFloat(this.__p2.x);
			_bytes.writeFloat(this.__p2.y);
			return _bytes;
		}
		
	}
}