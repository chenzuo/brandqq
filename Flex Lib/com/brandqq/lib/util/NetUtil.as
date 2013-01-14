package com.brandqq.lib.util
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	public final class NetUtil
	{
		public static function getUrl(url:String,target:String="_self"):void
		{
			navigateToURL(new URLRequest(url),target);
		}
	}
}