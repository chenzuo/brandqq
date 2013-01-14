package com.brandqq.lib.graphic
{
	/**
	 * 表示文本关联的样式和对齐方式，并提供关联的输入参数检验方法
	 * @author Administrator
	 * 
	 */	
	public final class TextDecoration
	{
		public static const LEFT:uint=0;
		public static const CENTER:uint=1;
		public static const RIGHT:uint=2;
		
		public static const NORMAL:uint=0;
		public static const BOLD:uint=1;
		public static const ITALIC:uint=2;
		public static const BOLD_ITALIC:uint=3;
		
		/**
		 * 检查输入的对齐参数，总是返回关联的枚举值之一
		 * @param value
		 * @return 
		 * 
		 */		
		public static function checkAlignValue(value:uint):uint
		{
			if(value!=LEFT && value!=CENTER && value!=RIGHT)
			{
				return LEFT;
			}
			return value;
		}
		
		/**
		 * 检查输入的样式参数，总是返回关联的枚举值之一
		 * @param value
		 * @return 
		 * 
		 */
		public static function checkStyleValue(value:uint):uint
		{
			if(value!=NORMAL && value!=BOLD && value!=ITALIC && value!=BOLD_ITALIC)
			{
				return NORMAL;
			}
			return value;
		}
	}
}