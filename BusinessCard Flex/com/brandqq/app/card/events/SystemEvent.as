package com.brandqq.app.card.events
{
	import flash.events.Event;

	public class SystemEvent extends Event
	{
		public static const INIT:String="init";
		public static const PROGRESS:String="progress";
		public static const COMPLETED:String="completed";
		
		public function SystemEvent(type:String,currentState:String,data:Object=null)
		{
			super(type);
			this.__currentState=currentState;
			this.__currentData=data;
		}
		/**
		 * 当前状态
		 * @return 
		 * 
		 */		
		public function get currentState():String
		{
			return this.__currentState;
		}
		
		public function get currentData():Object
		{
			return this.__currentData;
		}
		
		private var __currentState:String;
		private var __currentData:Object;
	}
}