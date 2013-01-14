package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	import com.brandqq.IO.IByte;
	/**
	 * 表示一个RGB颜色
	 * @author mickeydream@hotmail.com
	 * 字段	类型		描述			备注
		R	byte	Red分量		0-255
		G	byte	Green分量	0-255
		B	byte	Blue分量		0-255
	 */	
	public class RGB implements IByte
	{
		public function RGB(rgb:uint=0x0)
		{
			if(rgb==0x0)
			{
				this.__r=0;
				this.__g=0;
				this.__b=0;
			}
			else
			{
				this.__r=rgb>>16;
				this.__g=rgb>>8 & 0x00ff;
				this.__b=rgb & 0x0000ff;
			}
		}
		
		
		public function get color():uint
		{
			return (this.__r<<16)|(this.__g<<8)|this.__b;
		}
		public function set color(rgb:uint):void
		{
			this.__r=rgb>>16;
			this.__g=rgb>>8 & 0x00ff;
			this.__b=rgb & 0x0000ff;
		}
		
		/**
		 * 获取R分量
		 */		
		public function get r():uint
		{
			return this.__r;
		}
		/**
		 * 设置R分量
		 */	
		public function set r(value:uint):void
		{
			this.__r=value;
		}
		
		/**
		 * 获取G分量
		 */	
		public function get g():uint
		{
			return this.__g;
		}
		
		/**
		 * 设置G分量
		 */	
		public function set g(value:uint):void
		{
			this.__g=value;
		}
		
		/**
		 * 获取B分量
		 */	
		public function get b():uint
		{
			return this.__b;
		}
		/**
		 * 设置B分量
		 */	
		public function set b(value:uint):void
		{
			this.__b=value;
		}
		
		public function toString():String
		{
			return "{R="+__r+",G="+__g+",B="+__b+"}";
		}
		
		
		protected var __r:uint;
		protected var __g:uint;
		protected var __b:uint;
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeUnsignedInt(this.__r);
			_bytes.writeUnsignedInt(this.__g);
			_bytes.writeUnsignedInt(this.__b);
			return _bytes;
		}
	}
}