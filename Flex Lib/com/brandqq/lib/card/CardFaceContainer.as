package com.brandqq.lib.card
{
	import mx.events.FlexEvent;
	import mx.core.UIComponent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import com.brandqq.IO.FileEnum;
	import com.brandqq.lib.logo.LogoGraphic;
	import com.brandqq.lib.controls.SelectorContainer;
	import com.brandqq.lib.controls.Selector;
	import com.brandqq.lib.controls.SelectorStyle;
	import com.brandqq.lib.graphic.IVector;
	import com.brandqq.lib.graphic.Symbol;
	import com.brandqq.lib.graphic.Text;
	
	//test imports
	import mx.controls.Alert;
	

	/**
	 * 表示一个CardFace的编辑容器
	 * @author Administrator
	 * 
	 */	
	public final class CardFaceContainer extends SelectorContainer
	{
		/**
		 * 构造函数
		 * @return
		 * 
		 */		
		public function CardFaceContainer(isEnableSelector:Boolean=false)
		{
			super();
			this.__enableSelector=false;
		}
		
	}
}