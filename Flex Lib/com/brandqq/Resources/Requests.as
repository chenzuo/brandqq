package com.brandqq.Resources
{
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import com.brandqq.lib.card.CardTempFile;
	import com.brandqq.lib.card.CardFile;
	import com.brandqq.lib.card.CardFace;
	import com.brandqq.lib.logo.LogoFile;
	import com.brandqq.lib.graphic.Thumbnail;
	import com.brandqq.IO.IFile;
	import com.brandqq.IO.FileEnum;
	import com.brandqq.user.UserGuid;
	
	/**
	 * 定义系统常用的请求对象
	 * @author Administrator
	 * 
	 */	
	public final class Requests
	{
		/**
		 * 查询当前用户登录状态的请求
		 * @return 
		 *  
		 */		
		public static function userStatusRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_ROOT+"UserResponse.aspx";
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","STATUS"));
			_req.method=URLRequestMethod.POST;
			_req.data="v=1";
			return _req;
		}
		
		/**
		 * 用户登录的请求
		 * @param email
		 * @param pwd
		 * @return 
		 * 
		 */		
		public static function userLoginRequest(email:String,pwd:String):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","LOGIN"));
			_req.requestHeaders.push(new URLRequestHeader("EMAIL",email));
			_req.requestHeaders.push(new URLRequestHeader("PWD",pwd));
			_req.url=_ROOT+"UserResponse.aspx";
			_req.method=URLRequestMethod.POST;
			_req.data="v=1&Rnd="+Math.random().toString();
			return _req;
		}
		
		/**
		 * 用户退出登录的请求
		 * 
		 */		
		public static function userLogoutRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","LOGOUT"));
			_req.url=_ROOT+"UserResponse.aspx";
			_req.method=URLRequestMethod.POST;
			_req.data="v=1&Rnd="+Math.random().toString();
			return _req;
		}
		
		/**
		 * 用户LogoList的请求
		 * @param uid
		 * @return 
		 * 
		 */		
		public static function userLogoListRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","USER_LOGO_LIST"));
			_req.url=_ROOT+"UserResponse.aspx";
			_req.method=URLRequestMethod.POST;
			_req.data="v=1";
			return _req;
		}
		
		public static function userUpdateGuidRequest(guid:UserGuid):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","USER_UPDATE_GUID"));
			_req.requestHeaders.push(new URLRequestHeader("GUID_TYPE",guid.type));
			_req.requestHeaders.push(new URLRequestHeader("GUID",guid.guid));
			_req.url=_ROOT+"UserResponse.aspx";
			_req.method=URLRequestMethod.POST;
			_req.data="v=1";
			return _req;
		}
		
		/**
		 * 用户CardList的请求
		 * @param uid
		 * @return 
		 * 
		 */		
		public static function userCardListRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","USER_CARD_LIST"));
			_req.url=_ROOT+"UserResponse.aspx";
			_req.method=URLRequestMethod.POST;
			_req.data="v=1";
			return _req;
		}
		
		/**
		 * Logo图形轮廓数据的请求
		 * @param symbolId
		 * @return 
		 * 
		 */		
		public static function logoSymbolGlyphRequest(symbolId:String):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_GLYPH_ROOT+"LogoSymbols/"+symbolId+".glyph";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * 文本轮廓数据的请求
		 * @param text
		 * @param font
		 * @param size
		 * @param style
		 * @return 
		 * 
		 */		
		public static function textGlyphRequest(text:String,font:String,size:uint,style:uint):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","TEXT_GLYPH"));
			_req.url=_ROOT+"GlyphResponse.aspx";
			_req.method=URLRequestMethod.POST;
			
			var variables:URLVariables=new URLVariables();
			variables.TEXT=text;
			variables.FONT=font;
			variables.SIZE=size.toString();
			variables.STYLE=style.toString();
			_req.data=variables;
			return _req;
		}
		
		/**
		 * 打开文件进行读取的请求
		 * @param fileType
		 * @param guid
		 * @return 
		 * 
		 */		
		public static function openFileRequest(fileType:String,guid:String):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","READ_FILE"));
			_req.requestHeaders.push(new URLRequestHeader("FILE_TYPE",fileType));
			_req.requestHeaders.push(new URLRequestHeader("FILE_GUID",guid));
			_req.url=_ROOT+"FileResponse.aspx";
			_req.data="v=1";
			_req.method=URLRequestMethod.POST;
			return _req;
		}
		
		/**
		 * 保存文件的请求
		 * @param fileType
		 * @param guid
		 * @param uid
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function saveFileRequest(file:IFile):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.requestHeaders=new Array();
			_req.requestHeaders.push(new URLRequestHeader("FLEX_ACTION","SAVE_FILE"));
			_req.requestHeaders.push(new URLRequestHeader("FILE_TYPE",file.fileType));
			_req.requestHeaders.push(new URLRequestHeader("FILE_GUID",file.guid));
			_req.requestHeaders.push(new URLRequestHeader("FILE_UID",file.uid.toString()));
			
			_req.url=_ROOT+"FileResponse.aspx";
			_req.data=file.getFileBytes();
			_req.method=URLRequestMethod.POST;
			return _req;
		}
		
		/**
		 * 名片模板List的请求
		 * @return 
		 * 
		 */		
		public static function cardTemplatesRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"CardTemplates.xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * 名片模板缩略图的请求
		 * @param guid
		 * @param isBack
		 * @return 
		 * 
		 */		
		public static function cardTemplateThumbnailRequest(guid:String,isBack:Boolean):String
		{
			var _req:String;
			if(isBack)
			{
				_req=_THUMB_ROOT+"CardTemps/B/"+guid+".png";
			}
			else
			{
				_req=_THUMB_ROOT+"CardTemps/F/"+guid+".png";
			}
			return _req;
		}
		
		/**
		 * 名片模板图形列表的请求
		 * @param guid
		 * @param isBack
		 * @return 
		 * 
		 */		
		public static function cardTempSymbolsRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"CardTemplateSymbols.xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		
		/**
		 * 名片模板图形缩略图的请求
		 * @param guid
		 * @param isBack
		 * @return 
		 * 
		 */		
		public static function cardTempSymbolThumbnailRequest(id:String):String
		{
			var url:String=_THUMB_ROOT+"CardTempSymbols/"+id+".png";
			return url;
		}
		
		/**
		 * 名片模板图形轮廓的请求
		 * @param guid
		 * @param isBack
		 * @return 
		 * 
		 */		
		public static function cardTempSymbolGlyphRequest(id:String):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_GLYPH_ROOT+"CardTempSymbols/"+id+".glyph";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * 名片缩略图的请求
		 * @param guid
		 * @param isBack
		 * @return 
		 * 
		 */		
		public static function cardThumbnailRequest(guid:String,isBack:Boolean):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			if(isBack)
			{
				_req.url=_THUMB_ROOT+"Cards/B/"+guid+".png";
			}
			else
			{
				_req.url=_THUMB_ROOT+"Cards/F/"+guid+".png";
			}
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * Logo图形分类的请求
		 * @return 
		 * 
		 */		
		public static function logoSymbolCategoriesRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"LogoSymbolCategories.xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * Logo图形分类缩略图的请求
		 * @param symbolId
		 * @return
		 * 
		 */		
		public static function logoSymbolCategoryThumbnailRequest(cate:String):String
		{
			return _THUMB_ROOT+"LogoCategories/"+cate+".png";
		}
		
		/**
		 * Logo图形列表的请求
		 * @param cate
		 * @param pgIndex
		 * @param pgSize
		 * @return 
		 * 
		 */		
		public static function logoSymbolListRequest(cate:String):URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"/LogoSymbolCategories/"+cate+".xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * Logo图形缩略图的请求
		 * @param symbolId
		 * @return
		 * 
		 */		
		public static function logoSymbolThumbnailRequest(symbolId:String):String
		{
			return _THUMB_ROOT+"LogoSymbols/"+symbolId+".png";
		}
		
		/**
		 * Logo缩略图的请求
		 * @param guid
		 * @return 
		 * 
		 */		
		public static function logoThumbnailRequest(guid:String):String
		{
			return _THUMB_ROOT+"Logos/"+guid+".png";
		}
		
		/**
		 * 系统字体列表的请求
		 * @return 
		 * 
		 */		
		public static function systemFontsRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"SysFonts.xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * 系统字体预览图的请求
		 * @param fontCode
		 * @return 
		 * 
		 */		
		public static function systemFontsImageRequest(fontCode:String):String
		{
			return _THUMB_ROOT+"SysFonts/"+fontCode+".png";
		}
		
		/**
		 * 系统颜色的请求
		 * @return 
		 * 
		 */		
		public static function systemNamedColorsRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"SysColors.xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		/**
		 * 系统行业分类的请求
		 * @return 
		 * 
		 */		
		public static function systemIndustriesRequest():URLRequest
		{
			var _req:URLRequest=new URLRequest();
			_req.url=_XML_ROOT+"SysIndustries.xml";
			_req.method=URLRequestMethod.GET;
			return _req;
		}
		
		private static const _ROOT:String="/flexLib/";
		private static var _THUMB_ROOT:String=_ROOT+"Thumbnails/";
		private static var _GLYPH_ROOT:String=_ROOT+"Glyphs/";
		private static var _XML_ROOT:String=_ROOT+"Xmls/";
	}
}