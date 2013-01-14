package com.brandqq.lib.controls
{
	import mx.containers.Panel;
	import mx.controls.ProgressBar;
	import flash.display.Sprite;
	import mx.controls.Button;
	import flash.events.MouseEvent;
	
	import com.brandqq.lib.events.PopUpEvent;
	
	[Event(name="close",type="com.brandqq.lib.events.PopUpEvent")]
	
	/**
	 * 表示一个定制的PopUp对象，用于等待操作
	 * @author Administrator
	 * 
	 */	
	public final class PopUpBox extends Panel
	{
		/**
		 * 构造函数
		 * @param type 指示PopUp的类型，PopUpBoxType的枚举值之一
		 * @param msg 显示的等待信息
		 * @param w	宽度
		 * @param h	高度
		 * @param close	指示是否显示关闭按钮
		 * @return 
		 * 
		 */		
		public function PopUpBox(type:String="waiting",msg:String="Waiting...",w:Number=400,h:Number=150,close:Boolean=false)
		{
			super();
			this.title="请稍候";
			this.__type=type;
			this.__canClose=close;
			
			this.layout="vertical";
			this.setStyle("horizontalAlign","center");
			this.setStyle("verticalAlign","middle");
			this.setStyle("backgroundColor",0);
			this.setStyle("backgroundAlpha",0.8);
			this.setStyle("borderColor",0);
			this.setStyle("borderAlpha",0.8);
			this.setStyle("color",0xFFFFFF);
			
			this.width=w;
			this.height=h;
			
			this.__progressBar=new ProgressBar();
			this.__progressBar.label=msg;
			this.__progressBar.setStyle("barColor",0x0080FF)
			this.__progressBar.percentWidth=80;
			this.__progressBar.height=25;
			switch(this.__type)
			{
				case PopUpBoxType.WAITING:
					this.__progressBar.indeterminate=true;
					break;
				case PopUpBoxType.WAITING_WITH_PROGRESS:
					this.__progressBar.indeterminate=false;
					this.__progressBar.mode="manual"
					break;
			}
			
			if(this.__canClose)
			{
				this.setCloseButton();
			}
			
			this.addChild(this.__progressBar);
		}
		
		/**
		 * Close事件侦听器，在外部定义处理句柄
		 * @param e
		 * 
		 */		
		private function onPopUpCloseEventHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
		
		/**
		 * 设置关闭按钮可见或不可见
		 * @param b
		 * 
		 */		
		private function setCloseButton(b:Boolean=true):void
		{
			if(this.__closeButton==null)
			{
				this.__closeButton=new Button();
				this.__closeButton.label="Close";
				this.__closeButton.x=this.titleBar.width-50;
				this.__closeButton.y=3;
				this.__closeButton.setActualSize(50,20);
				this.__closeButton.addEventListener(MouseEvent.CLICK,this.onPopUpCloseEventHandler);
				this.titleBar.addChild(this.__closeButton);
			}
			
			if(!b && this.titleBar.contains(this.__closeButton))
			{
				this.titleBar.removeChild(this.__closeButton);
				return;
			}
			
			if(b)
			{
				this.titleBar.addChild(this.__closeButton);
			}
		}
		
		/**
		 * 获取当前类型
		 * @return 
		 * 
		 */		
		public function get type():String
		{
			return this.__type;
		}
		/**
		 * 设置当前类型
		 * @param value
		 * 
		 */		
		public function set type(value:String):void
		{
			if(this.__type==value)
			{
				return;
			}
			this.__type=value;
			switch(this.__type)
			{
				case PopUpBoxType.WAITING:
					this.__progressBar.indeterminate=true;
					break;
				case PopUpBoxType.WAITING_WITH_PROGRESS:
					this.__progressBar.indeterminate=false;
					this.__progressBar.mode="manual"
					break;
			}
		}
		
		/**
		 * 获取关闭按钮的可用状态
		 * @return 
		 * 
		 */		
		public function get canClose():Boolean
		{
			return this.__canClose;
		}
		/**
		 * 设置关闭按钮的可用状态
		 * @param value
		 * 
		 */		
		public function set canClose(value:Boolean):void
		{
			if(this.__canClose==value)
			{
				return;
			}
			this.setCloseButton(value);
			this.__canClose=value;
		}
		
		/**
		 * 设置当前进度值
		 * @param v1
		 * @param v2
		 * 
		 */		
		public function setProgress(v1:Number,v2:Number):void
		{
			this.__progressBar.setProgress(v1,v2);
		}
		
		/**
		 * 设置等待消息
		 * @param msg
		 * 
		 */		
		public function setMessage(msg:String):void
		{
			this.__progressBar.label=msg;
		}
		
		private var __type:String;
		private var __canClose:Boolean;
		private var __closeButton:Button;
		private var __progressBar:ProgressBar;
		
	}
}