package com.brandqq.lib.graphic
{
	import com.brandqq.IO.IByte;
	import flash.utils.ByteArray;
	/**
	 * 表示一个RGBA颜色
	 * @author mickeydream@hotmail.com
	 * 字段	类型		描述			备注
		R	byte	Red分量		0-255
		G	byte	Green分量	0-255
		B	byte	Blue分量		0-255
		A	byte	Alpha		0-100
	 */
	public final class RGBA extends RGB
	{
		public function RGBA(rgb:uint=0x0,alpha:uint=100)
		{
			super(rgb);
			this.__a=alpha;
			if(this.__a>100)
			{
				this.__a=100;
			}
		}
		
		public function get a():uint
		{
			return this.__a;
		}
		public function set a(value:uint):void
		{
			this.__a=value;
		}
		
		override public function toString():String
		{
			return "{R="+__r+",G="+__g+",B="+__b+",A="+__a+"}";
		}
		
		private var __a:uint;
		
		//implements IByte
		public override function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public override function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeUnsignedInt(this.__r);
			_bytes.writeUnsignedInt(this.__g);
			_bytes.writeUnsignedInt(this.__b);
			_bytes.writeUnsignedInt(this.__a);
			return _bytes;
		}
	}
}