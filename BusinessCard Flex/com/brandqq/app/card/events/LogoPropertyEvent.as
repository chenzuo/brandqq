package com.brandqq.app.card.events
{
	import flash.events.Event;

	public final class LogoPropertyEvent extends Event
	{
		public static const CHANGE:String="onLogoPropChange";
		
		public function LogoPropertyEvent(type:String,propName:String,propValue:Number,
											lockSize:Boolean=true,lockFaces:Boolean=true)
		{
			super(type);
			__propName=propName;
			__propValue=propValue;
			__lockSize=lockSize;
			__lockFaces=lockFaces;
		}
		
		public function get propName():String
		{
			return this.__propName;
		}
		
		public function get propValue():Number
		{
			return this.__propValue;
		}
		
		public function get lockSize():Boolean
		{
			return this.__lockSize;
		}
		
		public function get lockFaces():Boolean
		{
			return this.__lockFaces;
		}
		
		private var __propName:String;
		private var __propValue:Number;
		private var __lockSize:Boolean;
		private var __lockFaces:Boolean;
	}
}