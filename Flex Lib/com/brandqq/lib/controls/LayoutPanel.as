package com.brandqq.lib.controls
{
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.managers.PopUpManager;
	import flash.events.MouseEvent;

	public final class LayoutPanel extends Panel
	{
		public function LayoutPanel()
		{
			super();
			super.title="对齐和布局";
			this.__showCloseButton=false;
			this.__closeButtonStyleName="";
			
			
		}
		
		public function get showCloseButton():Boolean
		{
			return this.__showCloseButton;
		}
		public function set showCloseButton(value:Boolean):void
		{
			this.__showCloseButton=value;
			if(__closeButton==null)
			{
				__closeButton=new Button();
				__closeButton.toolTip="关闭";
				__closeButton.styleName=__closeButtonStyleName;
				__closeButton.x=this.width-__closeButton.width;
				__closeButton.y=3;
				__closeButton.addEventListener(MouseEvent.CLICK,onClose);
			}
			if(value)
			{
				this.titleBar.addChild(__closeButton);
			}
			else
			{
				this.titleBar.removeChild(__closeButton);
			}
		}
		
		public function set closeButtonStyleName(value:String):void
		{
			this.__closeButtonStyleName=value;
			__closeButton.styleName=this.__closeButtonStyleName;
		}
		
		private function onClose(e:MouseEvent):void
		{
			if(this.isPopUp)
			{
				PopUpManager.removePopUp(this);
			}
			else
			{
				this.parent!=null?this.parent.removeChild(this):this.visible=false;
			}
		}
		
		private var __closeButton:Button;
		private var __showCloseButton:Boolean;
		private var __closeButtonStyleName:String;
	}
}