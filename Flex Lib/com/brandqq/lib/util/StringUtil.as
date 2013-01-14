package com.brandqq.lib.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * 定义一系列字符串常用方法
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public class StringUtil
	{
		/**
		 * 以GB2312编码返回字符串的字节长度
		 * @param str
		 * @return 
		 * 
		 */		
		public static function getByteLength(str:String):uint
		{
			return toBytes(str).length;
		}
		
		/**
		 * 从左侧开始，以指定字符填充指定字符串到指定长度
		 * 返回GB2312编码的字符串
		 * @param source
		 * @param len
		 * @param withChar
		 * @return 
		 * 
		 */		
		public static function leftPad(source:String,len:uint,withChar:String="?"):String
		{
			var byteLen:uint=getByteLength(source);
			if(byteLen==len)
			{
				return source;
			}
			
			if(byteLen>len)
			{
				return toBytes(source).readMultiByte(len,"GB2312");
			}
			
			var padChar:String=toBytes(withChar).readMultiByte(1,"GB2312");
			var bytes:ByteArray=new ByteArray();
			while(bytes.position<len-byteLen)
			{
				bytes.writeMultiByte(padChar,"GB2312");
			}
			bytes.writeBytes(toBytes(source));
			bytes.position=0;
			return bytes.readMultiByte(len,"GB2312");
		}
		
		/**
		 * 与StringUtil.leftPad方法类似
		 * @param source
		 * @param len
		 * @param withChar
		 * @return 
		 * 
		 */		
		public static function rightPad(source:String,len:uint,withChar:String="?"):String
		{
			var byteLen:uint=getByteLength(source);
			if(byteLen==len)
			{
				return source;
			}
			
			if(byteLen>len)
			{
				return toBytes(source).readMultiByte(len,"GB2312");
			}
			
			var padChar:String=toBytes(withChar).readMultiByte(1,"GB2312");
			var bytes:ByteArray=new ByteArray();
			bytes.writeBytes(toBytes(source));
			var i:uint=0;
			while(i<len-byteLen)
			{
				bytes.writeMultiByte(padChar,"GB2312");
				i++;
			}
			bytes.position=0;
			return bytes.readMultiByte(len,"GB2312");
		}
		
		/**
		 * 用编码方式转换指定字符串，并返回ByteArray
		 * @param value
		 * @param charSet
		 * @return 
		 * 
		 */		
		public static function toBytes(value:String,charSet:String="GB2312"):ByteArray
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeMultiByte(value,charSet);
			bytes.position=0;
			return bytes;
		}
		
		/**
		 * 以大写方式返回一个长度为32的伪GUID字符串
		 * @return 
		 * 
		 */		
		public static function get newGuid():String
		{
			var uid:String = "";
			var ALPHA_CHARS:String = "0123456789abcdef";
			var i:Number;
			var j:Number;
			for (i=0; i<8; i++)
			{
				uid += ALPHA_CHARS.charAt(Math.round(Math.random()*15));
			}
			for (i=0; i<3; i++)
			{
				for (j=0; j<4; j++)
				{
					uid += ALPHA_CHARS.charAt(Math.round(Math.random()*15));
				}
			}
			
			var time:Number = new Date().getTime();
			uid += ("0000000"+time.toString(16).toUpperCase()).substr(-8);
			for (i=0; i<4; i++)
			{
				uid += ALPHA_CHARS.charAt(Math.round(Math.random()*15));
			}
			return uid.toUpperCase();
		}
		
		/**
		 * 转化一个字符为Boolean型
		 * 当指定值为空字符串,0,false或f时(忽略大小写)，返回false,否则返回true
		 * @param str
		 * @return 
		 * 
		 */		
		public static function toBoolean(str:String):Boolean
		{
			str=str.toLowerCase().replace(" ","");
			if(str=="" || str=="0" || str=="false" || str=="f")
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 用正则表达式检查一个字符串是否符合Email格式
		 * @param str
		 * @return 
		 * 
		 */
		public static function isEmail(str:String):Boolean
		{
			var reg:RegExp=/^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			return reg.test(str);
		}
		
		
		public static function trim(str:String):String
	    {
	        var startIndex:int = 0;
	        while (isWhitespace(str.charAt(startIndex)))
	            ++startIndex;
	
			var endIndex:int = str.length - 1;
	        while (isWhitespace(str.charAt(endIndex)))
	            --endIndex;
	
	        if (endIndex >= startIndex)
	            return str.slice(startIndex, endIndex + 1);
	        else
	            return "";
	    }
		
		public static function isWhitespace(character:String):Boolean
	    {
	        switch (character)
	        {
	            case " ":
	            case "\t":
	            case "\r":
	            case "\n":
	            case "\f":
	                return true;
	
				default:
	                return false;
	        }
	    }
		
		public static function get currentDateString():String
		{
			var y:String,m:String,d:String;
			var dt:Date=new Date();
			y=dt.getFullYear().toString();
			m="0"+dt.getMonth().toString();
			m=m.substr(m.length-2,2);
			d="0"+dt.getDay().toString();
			d=d.substr(d.length-2,2);
			return y+m+d;
		}
	}
}