package com.brandqq.lib.events
{
	import flash.events.Event;

	public final class SelectorContainerEvent extends Event
	{
		public static const ITEMS_SELECTED:String="onItemsSelected";
		public static const ITEMS_UNSELECTED:String="onItemsUnSelected";
		
		public function SelectorContainerEvent(type:String,items:Array=null)
		{
			super(type);
			this.__selectedItems=items;
			if(type==ITEMS_SELECTED && this.__selectedItems==null)
			{
				this.stopPropagation();
			}
			if(type==ITEMS_SELECTED && this.__selectedItems.length==0)
			{
				this.stopPropagation();
			}
		}
		
		public function get selectedItems():Array
		{
			return this.__selectedItems;
		}
		
		public function get isMultiSelect():Boolean
		{
			if(this.__selectedItems==null)
			{
				return false;
			}
			if(this.__selectedItems.length<=1)
			{
				return false;
			}
			return true;
		}
		
		private var __selectedItems:Array;
	}
}