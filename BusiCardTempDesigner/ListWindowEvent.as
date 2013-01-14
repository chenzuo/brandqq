package
{
	import flash.events.Event;

	public class ListWindowEvent extends Event
	{
		public static const ITEM_SELECTED:String="onItemSelected";
		
		public function ListWindowEvent(type:String,id:String,options:Array=null)
		{
			super(type);
			__relateId=id;
			__options=options;
		}
		
		public function get relateId():String
		{
			return __relateId;
		}
		
		public function get options():Array
		{
			return __options;
		}
		
		private var __relateId:String;
		private var __options:Array;
	}
}