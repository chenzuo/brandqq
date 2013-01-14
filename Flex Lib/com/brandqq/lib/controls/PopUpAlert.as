package com.brandqq.lib.controls
{
	import mx.containers.TitleWindow;
	import mx.managers.PopUpManager;
	import flash.display.DisplayObject;
	import mx.events.FlexEvent;
	import mx.controls.Label;
	import flash.geom.Rectangle;
	import flash.events.Event;

	public class PopUpAlert extends TitleWindow
	{
		public function PopUpAlert()
		{
			super();
			super.title="";
			super.setStyle("backgroundColor",0x000000);
			super.setStyle("backgroundAlpha",.8);
			super.setStyle("borderColor",0x000000);
			super.setStyle("borderAlpha",.8);
			
			__message=new Label();
			
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			addEventListener(Event.CLOSE,onClose);
		}
		
		private function onCreationComplete(e:FlexEvent):void
		{
			addChild(__message);
		}
		
		private function onClose(e:Event):void
		{
			PopUpManager.removePopUp(this);
		}
		
		public static function alert(msg:String,relatedObject:DisplayObject,modal:Boolean=false):void
		{
			if(__instance==null)
			{
				__instance=new PopUpAlert();
			}
			__instance.__message.text=msg;
			PopUpManager.addPopUp(__instance,relatedObject.parent,modal);
			var rect:Rectangle=relatedObject.getRect(relatedObject.parent);
			__instance.move(rect.x,rect.y);
		}
		
		private static var __instance:PopUpAlert;
		private var __message:Label;
	}
}