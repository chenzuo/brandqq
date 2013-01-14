package com.brandqq.IO
{
	/**
	 * 表示文件类型、相关默认尺寸的枚举
	 * @author Administrator
	 * 
	 */	
	public final class FileEnum
	{
		/**
		* LOGO文件类型
		*/		
		public static const LOGO:String="logo";
		/**
		* CARD文件类型
		*/		
		public static const CARD:String="card";
		
		/**
		* CARD模板文件类型
		*/		
		public static const CARD_TEMP:String="cardTemp";
		
		/**
		* LOGO文件当前版本
		*/		
		public static const LOGO_FILE_VERSION:uint=0x1;
		/**
		* CARD文件当前版本
		*/		
		public static const CARD_FILE_VERSION:uint=0x1;
		
		
		/**
		* LOGO文件缩略位图的宽度(px)
		*/		
		public static const LOGO_THUMBNAIL_WIDTH:uint=120;
		/**
		* LOGO文件缩略位图的高度(px)
		*/		
		public static const LOGO_THUMBNAIL_HEIGHT:uint=90;
		
		/**
		* CARD文件缩略位图的宽度(px)
		*/		
		public static const CARD_THUMBNAIL_WIDTH:uint=325;
		/**
		* CARD文件缩略位图的高度(px)
		*/		
		public static const CARD_THUMBNAIL_HEIGHT:uint=200;
	}
}