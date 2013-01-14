package com.brandqq.lib.graphic
{
	import flash.utils.ByteArray;
	import com.brandqq.IO.IByte;
	import com.brandqq.IO.FileEnum;
	
	/**
	 * 表示Png格式的缩略图
	 * @author mickeydream@hotmail.com
	 * 	字段		类型		描述					备注
		Tag		String	always THUM			4 bytes
		Width	uint	表示png的宽度	
		Height	uint	高度
		Png		Byte[]	存储Png所使用的字节数组 	
	 */	
	public final class Thumbnail implements IByte
	{
		/**
		 * 构造函数
		 */
		public function Thumbnail(data:ByteArray,w:uint=0,h:uint=0)
		{
			this.__width=w;
			this.__height=h;
			if(this.__width===0)
			{
				this.__width=FileEnum.CARD_THUMBNAIL_WIDTH;
			}
			if(this.__height===0)
			{
				this.__height=FileEnum.CARD_THUMBNAIL_HEIGHT;
			}
			this.__png=data;
		}
		
		/**
		 * 获取标签
		 */
		public function get Tag():String
		{
			return this.__TAG;
		}
		
		/**
		 * 获取缩略图宽度
		 */
		public function get width():uint
		{
			return this.__width;
		}
		
		/**
		 * 获取缩略图高度
		 */
		public function get height():uint
		{
			return this.__height;
		}
		
		private const __TAG:String="THUM";
		private var __width:uint;
		private var __height:uint;
		private var __png:ByteArray;
		
		//implements IByte
		public function writeTo(bytes:ByteArray):void
		{
			bytes.writeBytes(this.getBytes());
		}
		
		public function getBytes():ByteArray
		{
			var _bytes:ByteArray=new ByteArray();
			_bytes.writeMultiByte(this.__TAG,"GB2312");
			_bytes.writeUnsignedInt(this.__width);
			_bytes.writeUnsignedInt(this.__height);
			_bytes.writeBytes(this.__png);
			return _bytes;
		}
	}
}