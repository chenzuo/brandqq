package com.brandqq.lib.controls
{
	/**
	 * 表示网格可用尺寸的枚举
	 * @author Administrator
	 * 
	 */	
	internal class CanvasGridSize
	{
		public static const SIZE8:uint=0x8;
		public static const SIZE16:uint=0x16;
		public static const SIZE32:uint=0x32;
		
		/**
		 * 检验一个输入的尺寸，总是返回为枚举值之一
		 * @param value
		 * @return 
		 * 
		 */		
		public static function checkSize(value:uint):uint
		{
			if(value!=SIZE8 && value!=0x16 && value!=0x32)
			{
				return SIZE16;
			}
			return value;
		}
	}
}