package com.brandqq.lib.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import mx.managers.CursorManager;
	
	import com.brandqq.Resources.Cursors;
	
	[Event(name="onHandlerMouseDown",type="com.brandqq.lib.controls.SelectorHandlerMouseEvent")]
	
	/**
	 * 选择控件的控制柄
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	internal class SelectorHandler extends Sprite
	{
		public function SelectorHandler(_name:String)
		{
			super();
			this.name=_name;
			init();
			
			this.addEventListener(MouseEvent.ROLL_OVER,onHandlersMouseEvent);
			this.addEventListener(MouseEvent.ROLL_OUT,onHandlersMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onHandlersMouseEvent);
		}
		
		public function setCursor():void
		{
			switch(this.name)
			{
				case "H1":
				case "H3":
					CursorManager.setCursor(Cursors.RESIZE_L,2,-9,-9);
					break;
				case "H2":
				case "H4":
					CursorManager.setCursor(Cursors.RESIZE_R,2,-9,-9);
					break;
				case "H5":
				case "H7":
					CursorManager.setCursor(Cursors.RESIZE_V,2,-9,-9);
					break;
				case "H6":
				case "H8":
					CursorManager.setCursor(Cursors.RESIZE_H,2,-9,-9);
					break;
				case "HA":
					CursorManager.setCursor(Cursors.ROTATION,2,-9,-9);
					break;
				case "HB":
					CursorManager.removeAllCursors();
					break;
			}
		}
		
		private function onHandlersMouseEvent(e:MouseEvent):void
		{
			if(e.type==MouseEvent.ROLL_OUT)
			{
				CursorManager.removeAllCursors();
			}
			else if(e.type==MouseEvent.ROLL_OVER)
			{
				this.setCursor();
			}
			else if(e.type==MouseEvent.MOUSE_DOWN)
			{
				this.dispatchEvent(new SelectorHandlerMouseEvent(SelectorHandlerMouseEvent.ON_MOUSEDOWN,this));
			}
		}
		
		private function init():void
		{
			switch(this.name)
			{
				case "H1":
				case "H2":
				case "H3":
				case "H4":
				case "H5":
				case "H6":
				case "H7":
				case "H8":
					drawRect();
					break;
				case "HA":
					drawCircle1();
					break;
				case "HB":
					drawCross();
					break;
			}
		}
		
		private function drawRect():void
		{
			this.graphics.lineStyle(0,0);
			this.graphics.beginFill(0xffffff,1);
			this.graphics.moveTo(0,0);
			this.graphics.drawRect(R1*-1,R1*-1,R1*2,R1*2);
			this.graphics.endFill();
		}
		
		private function drawCircle1():void
		{
			this.graphics.lineStyle(0,0);
			this.graphics.beginFill(0x00ff00,1);
			this.graphics.drawCircle(0,0,R2);
			this.graphics.endFill();
		}
		
		private function drawCross():void
		{
			this.graphics.beginFill(0x00ff00,1);
			this.graphics.drawCircle(0,0,R2);
			this.graphics.endFill();
		}
		
		public static const R1:Number=2.5;
		public static const R2:Number=2.5;
	}
}