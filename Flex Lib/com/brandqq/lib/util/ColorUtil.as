package com.brandqq.lib.util
{
	public final class ColorUtil
	{
		public static function getRGBString(clr:uint):String
		{
			var r:String="";
			var g:String="";
			var b:String="";
			var str:String;
			var rgb:Array=RGB(clr);
			str="00"+rgb[0].toString(16).toUpperCase();
			r=str.substr(str.length-2,2);
			
			str="00"+rgb[1].toString(16).toUpperCase();
			g=str.substr(str.length-2,2);
			
			str="00"+rgb[2].toString(16).toUpperCase();
			b=str.substr(str.length-2,2);
			
			return "R:"+r+" G:"+g+" B:"+b;
		}
		
		public static function toHexString(clr:uint):String
		{
			var r:String="";
			var g:String="";
			var b:String="";
			var str:String;
			var rgb:Array=RGB(clr);
			str="00"+rgb[0].toString(16).toUpperCase();
			r=str.substr(str.length-2,2);
			
			str="00"+rgb[1].toString(16).toUpperCase();
			g=str.substr(str.length-2,2);
			
			str="00"+rgb[2].toString(16).toUpperCase();
			b=str.substr(str.length-2,2);
			
			return "0x"+r+g+b;
		}
		
		public static function RGB(clr:uint):Array
		{
			var obj:Array=[0x0,0x0,0x0];
			obj[0]=clr>>16;
			obj[1]=clr>>8&0x00ff;
			obj[2]=clr&0x0000ff;
			return obj;
		}
		
		public static function RGBToCMYK(clr:uint):Array
		{
			var rgb:Array=RGB(clr);
			var cmyk:Array=[0x0,0x0,0x0,0x0];
			cmyk[0]=0xFF-rgb[0];
			cmyk[1]=0xFF-rgb[1];
			cmyk[2]=0xFF-rgb[2];
			cmyk[3]=Math.min(cmyk[0],cmyk[1],cmyk[2]);
			if(cmyk[3]>0)
			{
				cmyk[0]-=-cmyk[3];
				cmyk[1]-=-cmyk[3];
				cmyk[2]-=-cmyk[3];
			}
			return cmyk;
		}
		
		public static function CMYKToRGB(c:uint,m:uint,y:uint,k:uint):Array
		{
			var rgb:Array=[0x0,0x0,0x0];
			if((c+k)<255)
			{
				rgb[0]=255-c-k;
			}
			if((m+k)<255)
			{
				rgb[1]=255-m-k;
			}
			if((y+k)<255)
			{
				rgb[2]=255-y-k;
			}
			return rgb;
		}
	}
}