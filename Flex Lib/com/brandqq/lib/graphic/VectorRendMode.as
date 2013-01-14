package com.brandqq.lib.graphic
{
	/**
	 * 表示矢量轮廓呈现方式的枚举
	 * SOLIDFILL：指示填充呈现，默认以此方式呈现
	 * OUTLINE：指示轮廓呈现
	 * 当指定OUTLINE方式时，将忽略轮廓中定义的border和borderColor以及colorTrans属性，而一固定的线条粗细和颜色呈现
	 * @author Administrator
	 * 
	 */	
	public final class VectorRendMode
	{
		public static const SOLIDFILL:uint=0x0;
		public static const OUTLINE:uint=0x1;
		
		public static function checkRendModeValue(value:uint):uint
		{
			if(value!=SOLIDFILL && value!=OUTLINE)
			{
				return SOLIDFILL;
			}
			return value;
		}
	}
}