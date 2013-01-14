package com.brandqq.lib.util
{
	import flash.geom.*;
	public final class MatrixTransformer
	{
		public static function getPointRadians(p0:Point,p1:Point):Number
		{
			return Math.atan2(p0.y-p1.y,p0.x-p1.x)*180/Math.PI;
		}
		
		public static function move(m:Matrix,tx:Number,ty:Number):void
		{
			m.translate(tx,ty);
		}
		
		public static function getScaleX(m:Matrix):Number
		{
			return Math.sqrt(m.a*m.a + m.b*m.b);
		}
	
		public static function setScaleX(m:Matrix, scaleX:Number):void
		{
			var oldValue:Number = getScaleX(m);
			// avoid division by zero 
			if (oldValue)
			{
				var ratio:Number = scaleX / oldValue;
				m.a *= ratio;
				m.b *= ratio;
			}
			else
			{
				var skewYRad:Number = getSkewYRadians(m);
				m.a = Math.cos(skewYRad) * scaleX;
				m.b = Math.sin(skewYRad) * scaleX;
			}
		}
	
	   	public static function getScaleY(m:Matrix):Number
		{
			return Math.sqrt(m.c*m.c + m.d*m.d);
		}
	
		public static function setScaleY(m:Matrix, scaleY:Number):void
		{
			var oldValue:Number = getScaleY(m);
			// avoid division by zero 
			if (oldValue)
			{
				var ratio:Number = scaleY / oldValue;
				m.c *= ratio;
				m.d *= ratio;
			}
			else
			{
				var skewXRad:Number = getSkewXRadians(m);
				m.c = -Math.sin(skewXRad) * scaleY;
				m.d =  Math.cos(skewXRad) * scaleY;
			}
		}
	
		public static function getSkewXRadians(m:Matrix):Number
		{
			return Math.atan2(-m.c, m.d);
		}
	
	
		public static function setSkewXRadians(m:Matrix, skewX:Number):void
		{
			var scaleY:Number = getScaleY(m);
			m.c = -scaleY * Math.sin(skewX);
			m.d =  scaleY * Math.cos(skewX);
		}
	
		public static function getSkewYRadians(m:Matrix):Number
		{
			return Math.atan2(m.b, m.a);
		} 
	
		public static function setSkewYRadians(m:Matrix, skewY:Number):void
		{
			var scaleX:Number = getScaleX(m);
			m.a = scaleX * Math.cos(skewY);
			m.b = scaleX * Math.sin(skewY);
		}
	
		public static function getSkewX(m:Matrix):Number
		{
			return Math.atan2(-m.c, m.d) * (180/Math.PI);
		}
	
	   	public static function setSkewX(m:Matrix, skewX:Number):void
		{
			setSkewXRadians(m, skewX*(Math.PI/180));
		}
	
		public static function getSkewY(m:Matrix):Number
		{
			return Math.atan2(m.b, m.a) * (180/Math.PI);
		}
	
		public static function setSkewY(m:Matrix, skewY:Number):void
		{
			setSkewYRadians(m, skewY*(Math.PI/180));
		}	
	
	   	public static function getRotationRadians(m:Matrix):Number
		{
			return getSkewYRadians(m);
		}
	
		public static function setRotationRadians(m:Matrix, rotation:Number):void
		{
			var oldRotation:Number = getRotationRadians(m);
			var oldSkewX:Number = getSkewXRadians(m);
			setSkewXRadians(m, oldSkewX + rotation-oldRotation);
			setSkewYRadians(m, rotation);		
		}
	
		public static function getRotation(m:Matrix):Number
		{
			return getRotationRadians(m)*(180/Math.PI);
		}
	
		public static function setRotation(m:Matrix, rotation:Number):void
		{
			setRotationRadians(m, rotation*(Math.PI/180));
		}
	
		public static function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, angleDegrees:Number):void
		{
			var point:Point = new Point(x, y);
			point = m.transformPoint(point);
			m.tx -= point.x;
			m.ty -= point.y;
			m.rotate(angleDegrees*(Math.PI/180));
			m.tx += point.x;
			m.ty += point.y;
		}
	
		public static function rotateAroundExternalPoint(m:Matrix, x:Number, y:Number, angleDegrees:Number):void
		{
			m.tx -= x;
			m.ty -= y;
			m.rotate(angleDegrees*(Math.PI/180));
			m.tx += x;
			m.ty += y;
		}
		
		public static function resetMatrixABCD(m:Matrix):void
		{
			m.a=m.d=1;
			m.b=m.c=0;
		}
	
	    public static function matchInternalPointWithExternal(m:Matrix, internalPoint:Point, externalPoint:Point):void
		{
			var internalPointTransformed:Point = m.transformPoint(internalPoint);
			var dx:Number = externalPoint.x - internalPointTransformed.x;
			var dy:Number = externalPoint.y - internalPointTransformed.y;	
			m.tx += dx;
			m.ty += dy;
		}
	}
}