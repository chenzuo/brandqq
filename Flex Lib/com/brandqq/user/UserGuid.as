package com.brandqq.user
{
	public final class UserGuid
	{
		public static const LOGO:String="LOGO";
		public static const CARD:String="CARD";
		public static const CARDTEMP:String="CARDTEMP";
		
		public function UserGuid(type:String,guid:String)
		{
			this.__type=type;
			this.__guid=guid;
		}
		
		public function get type():String
		{
			return this.__type;
		}
		public function set type(value:String):void
		{
			this.__type=value;
		}
		
		public function get guid():String
		{
			return this.__guid;
		}
		public function set guid(value:String):void
		{
			this.__guid=value;
		}
		
		private var __type:String;
		private var __guid:String;
	}
}