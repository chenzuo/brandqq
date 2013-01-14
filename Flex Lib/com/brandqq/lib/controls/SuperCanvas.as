package com.brandqq.lib.controls
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.controls.Alert;
	import mx.containers.Canvas;

	/**
	 * 表示一个支持网格显示的Canvas
	 * @author Administrator
	 * 
	 */	
	public class SuperCanvas extends Canvas
	{
		/**
		 * 构造函数
		 * @return 
		 * 
		 */		
		public function SuperCanvas()
		{
			super();
			
			__bgColor=0xFFFFFF;
			__borderColor=0X666666;
			__border=true;
			__grid=false;
			__gridColor=0xF5F5F5;
			__gridSize=CanvasGridSize.SIZE16;
			addEventListener(FlexEvent.CREATION_COMPLETE,function(e:FlexEvent):void
				{
					updateGraphics();
					removeEventListener(FlexEvent.CREATION_COMPLETE,this);
				}
			);
		}
		
		/**
		 * 更新显示
		 * 当背景颜色，边框可见性，边框颜色，网格尺寸，颜色和可见性发生改变时调度
		 * 
		 */		
		private function updateGraphics():void
		{
			var w:Number=this.width;
			var h:Number=this.height;
			graphics.clear();
			graphics.beginFill(__bgColor,1);
			if(__border)
			{
				graphics.lineStyle(0,__borderColor,1,true,"none");
			}
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			if(__grid)
			{
				graphics.lineStyle(0,__gridColor,1,true,"none");
				
				var rows:uint=uint(w  / __gridSize);
				var cols:uint=uint(h / __gridSize);
				var i:uint;
				for(i=1;i<=rows;i++)
				{
					graphics.moveTo(i*__gridSize,0);
					graphics.lineTo(i*__gridSize,h);
				}
				for(i=1;i<=cols;i++)
				{
					graphics.moveTo(0,i*__gridSize);
					graphics.lineTo(w,i*__gridSize);
				}
			}
		}
		
		/**
		 * 设置Canvas背景颜色
		 * @param value
		 * 
		 */		
		public function set backgroundColor(value:uint):void
		{
			if(__bgColor!=value)
			{
				__bgColor=value;
				updateGraphics();
			}
		}
		
		/**
		 * 设置Canvas边框可见或不可见
		 * @param value
		 * 
		 */		
		public function set showBorder(value:Boolean):void
		{
			if(__border!=value)
			{
				__border=value;
				updateGraphics();
			}
		}
		
		/**
		 * 设置Canvas边框颜色
		 * @param value
		 * 
		 */		
		public function set borderColor(value:uint):void
		{
			if(__borderColor!=value)
			{
				__borderColor=value;
				updateGraphics();
			}
		}
		
		/**
		 * 设置Canvas网格可见性
		 * @param value
		 * 
		 */		
		public function set showGrid(value:Boolean):void
		{
			if(__grid!=value)
			{
				__grid=value;
				updateGraphics();
			}
		}
		
		/**
		 * 设置Canvas网格大小
		 * @param value
		 * 
		 */		
		public function set gridSize(value:uint):void
		{
			if(__gridSize!=value)
			{
				__gridSize=CanvasGridSize.checkSize(value);
				updateGraphics();
			}
		}
		
		/**
		 * 设置Canvas网格线颜色
		 * @param value
		 * 
		 */		
		public function set gridColor(value:uint):void
		{
			if(__gridColor!=value)
			{
				__gridColor=value;
				updateGraphics();
			}
		}
		
		private var __bgColor:uint;
		private var __borderColor:uint;
		private var __border:Boolean;
		private var __grid:Boolean;
		private var __gridColor:uint;
		private var __gridSize:uint;
	}
}