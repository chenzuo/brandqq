package com.brandqq.lib.controls
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	import mx.controls.Label;
	import mx.controls.Image;
	
	import com.brandqq.Resources.Cursors;
	import com.brandqq.lib.events.ColourPickerEvent;
	import com.brandqq.lib.util.ColorUtil;
	
	[Event(name="onColorChange",type="com.brandqq.lib.events.ColourPickerEvent")]

	public final class ColourPicker extends Canvas
	{
		public function ColourPicker(clrs:Array=null)
		{
			super();
			super.horizontalScrollPolicy="off";
			super.verticalScrollPolicy="off";
			super.clipContent=true;
			super.setStyle("borderStyle","solid");
			super.setStyle("backgroundColor",0xFFFFFF);
			
			__colors=clrs;
			addEventListener(FlexEvent.CREATION_COMPLETE,initComponent);
		}
		
		private function initComponent(e:FlexEvent):void
		{
			if(__colors==null)
			{
				__colors=__defaultColors;
			}
			__alphas=new Array(__colors.length);
			__ratios=new Array(__colors.length);
			var i:uint;
			for(i=0;i<__alphas.length;i++)
			{
				__alphas[i]=1;
			}
			for(i=0;i<__ratios.length;i++)
			{
				__ratios[i]=i*255/(__colors.length-1);
			}
			
			__fillArea=new Canvas();
			__fillArea.width=this.width-35;
			__fillArea.height=this.height-30;
			__fillArea.x=__fillArea.y=5;
			__fillArea.horizontalScrollPolicy="off";
			__fillArea.verticalScrollPolicy="off";
			__fillArea.addEventListener(MouseEvent.MOUSE_DOWN,onFillAreaMouseDown);
			
			__lineArea=new Canvas();
			__lineArea.width=20;
			__lineArea.height=this.height-30;
			__lineArea.x=__fillArea.width+10;
			__lineArea.y=5;
			__lineArea.horizontalScrollPolicy="off";
			__lineArea.verticalScrollPolicy="off";
			__lineArea.addEventListener(MouseEvent.MOUSE_DOWN,onLineAreaMouseDown);
			
			__valueArea=new Canvas();
			__valueArea.width=64;
			__valueArea.height=15;
			__valueArea.x=5;
			__valueArea.y=__fillArea.height+10;
			
			__valueLabel=new Label();
			__valueLabel.text="";
			__valueLabel.x=5+__valueArea.width+5;
			__valueLabel.y=__fillArea.height+10;
			__valueLabel.setStyle("fontFamily","宋体");
			__valueLabel.setStyle("fontSize",14);
			
			__colorCrossPoint=new Image();//主光标
			__colorCrossPoint.source=Cursors.COLOR_CROSS;
			__colorCrossPoint.x=__fillArea.width/2-CROSS_POINT_RADIUS;
			__colorCrossPoint.y=__fillArea.height/2-CROSS_POINT_RADIUS;
			
			__colorArrowPoint=new Image();//调整光标
			__colorArrowPoint.source=Cursors.ARROW_LEFT;
			__colorArrowPoint.x=10;
			__colorArrowPoint.y=__lineArea.height/2-ARROW_POINT_RADIUS;

			__fillArea.addChild(__colorCrossPoint);
			__lineArea.addChild(__colorArrowPoint);

			fillColors();
			fillGradientColor(getFillAreaColor());
			
			setSelectedColor(getLineAreaColor(),false);
			
			addChild(__fillArea);
			addChild(__lineArea);
			addChild(__valueArea);
			addChild(__valueLabel);
			
			removeEventListener(FlexEvent.CREATION_COMPLETE,initComponent);
		}
		
		/**
		 * 主填充区
		 * 
		 */		
		private function fillColors():void
		{
			var matr:Matrix = new Matrix();
  			matr.createGradientBox(__fillArea.width, __fillArea.height, 0, 0, 0);
  			
  			__fillArea.graphics.clear();
  			
			__fillArea.graphics.beginGradientFill(GradientType.LINEAR,__colors,__alphas,__ratios,matr,SpreadMethod.REFLECT);
			__fillArea.graphics.drawRect(0,0,__fillArea.width,__fillArea.height);
	
			if(__colors==__defaultColors)
			{
				matr.createGradientBox(__fillArea.width, __fillArea.height/2, Math.PI/2, 0, 0);
				__fillArea.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[1,0],[0,0xFF],matr,SpreadMethod.REFLECT);
				__fillArea.graphics.drawRect(0,__fillArea.height/2,__fillArea.width,__fillArea.height/2);
			}
			
			__fillArea.graphics.endFill();
			
			//绘制边框
			__fillArea.graphics.lineStyle(1,0,1,true,"none");
			__fillArea.graphics.drawRect(0,0,__fillArea.width,__fillArea.height);
			
			if(__fillAreaBitmap!=null)
			{
				__fillAreaBitmap.dispose();
			}
			
			__fillAreaBitmap=new BitmapData(__fillArea.width,__fillArea.height);
			__fillAreaBitmap.draw(__fillArea);
		}
		
		/**
		 * 填充亮度调整区
		 * @param clr
		 * 
		 */		
		private function fillGradientColor(clr:uint):void
		{
			var clrs:Array=[0xffffff,clr,0x000000];
			var alphas:Array=[1,1,1];
			var ratios:Array = [0x00,0x88,0xFF];
 			var matr:Matrix = new Matrix();
			matr.createGradientBox(10, __lineArea.height, Math.PI/2, 0, 0);
			
			__lineArea.graphics.clear();
			__lineArea.graphics.lineStyle(1,0,1,true,"none");
			__lineArea.graphics.beginGradientFill(GradientType.LINEAR,clrs,alphas,ratios,matr,SpreadMethod.REFLECT);
			__lineArea.graphics.drawRect(0,0,10,__lineArea.height);
			__lineArea.graphics.endFill();
			
			if(__lineAreaBitmap!=null)
			{
				__lineAreaBitmap.dispose();
			}
			__lineAreaBitmap=new BitmapData(10,__lineArea.height);
			__lineAreaBitmap.draw(__lineArea);
		}
		
		private function onFillAreaMouseDown(e:MouseEvent):void
		{
			//重置渐变点到中点
			__colorArrowPoint.y=__lineArea.height/2-ARROW_POINT_RADIUS;
			
			__colorCrossPoint.x=__fillArea.mouseX-CROSS_POINT_RADIUS;
			__colorCrossPoint.y=__fillArea.mouseY-CROSS_POINT_RADIUS;
			
			var clr:uint=getFillAreaColor();
			fillGradientColor(clr);//重新绘制渐变区
			
			setCrossPointColor(clr);//设置主光标颜色
			setSelectedColor(getLineAreaColor());
			
			__colorCrossPoint.alpha=0;
			__colorCrossPoint.startDrag(false,new Rectangle(CROSS_POINT_RADIUS*-1+1,
															CROSS_POINT_RADIUS*-1+1,
															__fillArea.width,
															__fillArea.height));
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onFillAreaMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void
				{
					__colorCrossPoint.stopDrag();
					__colorCrossPoint.alpha=1;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,onFillAreaMouseMove);
					stage.removeEventListener(MouseEvent.MOUSE_UP,this);
				}
			);
		}
		
		private function onLineAreaMouseDown(e:MouseEvent):void
		{
			__colorArrowPoint.startDrag(false,new Rectangle(10,
															ARROW_POINT_RADIUS*-1+1,
															0,
															__lineArea.height));
			setSelectedColor(getLineAreaColor());
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onLineAreaMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void
				{
					__colorArrowPoint.stopDrag();
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,onLineAreaMouseMove);
					stage.removeEventListener(MouseEvent.MOUSE_UP,this);
				}
			);
		}
		
		private function onFillAreaMouseMove(e:MouseEvent):void
		{
			__colorCrossPoint.alpha=0;
			var clr:uint=getFillAreaColor();
			setCrossPointColor(clr);//设置主光标颜色
			fillGradientColor(clr);//重新绘制渐变区
			setSelectedColor(getLineAreaColor());
		}
		
		private function onLineAreaMouseMove(e:MouseEvent):void
		{
			setSelectedColor(getLineAreaColor());
		}
		
		private function getFillAreaColor():uint
		{
			if(__fillAreaBitmap==null)
			{
				return 0x0;
			}
			return __fillAreaBitmap.getPixel32(__colorCrossPoint.x+CROSS_POINT_RADIUS,
											   __colorCrossPoint.y+CROSS_POINT_RADIUS);
		}
		
		private function getLineAreaColor():uint
		{
			if(__lineAreaBitmap==null)
			{
				return 0x0;
			}
			return __lineAreaBitmap.getPixel32(5,__colorArrowPoint.y+ARROW_POINT_RADIUS);
		}
		
		private function setSelectedColor(value:uint,dispatch:Boolean=true):void
		{
			__selectedColor=value;
			__valueArea.graphics.clear();
			__valueArea.graphics.lineStyle(0,0);
			__valueArea.graphics.beginFill(__selectedColor);
			__valueArea.graphics.drawRect(0,0,__valueArea.width,__valueArea.height);
			__valueArea.graphics.endFill();
			__valueLabel.text=ColorUtil.getRGBString(__selectedColor);
			
			if(dispatch)
			{
				this.dispatchEvent(new ColourPickerEvent(ColourPickerEvent.COLOR_CHANGE,__selectedColor));
			}
		}
		
		public function reset():void
		{
			colors=__defaultColors;
		}
		
		public function set colors(value:Array):void
		{
			if(value==null)
			{
				return;
			}
			
			if(value.length<2)
			{
				return;
			}
			
			if(__colors!=value)
			{
				__colors=value;
				__alphas=new Array(__colors.length);
				__ratios=new Array(__colors.length);
				
				var i:uint;
				for(i=0;i<__alphas.length;i++)
				{
					__alphas[i]=1;
				}
				for(i=0;i<__ratios.length;i++)
				{
					__ratios[i]=i*255/(__colors.length-1);
				}
				
				fillColors();
				fillGradientColor(getFillAreaColor());
				setSelectedColor(getLineAreaColor(),false);
			}
		}
		
		public function get selectedColor():uint
		{
			return __selectedColor;
		}
		
		private function rgbToString(rgb:uint):String
		{
			var r:String="";
			var g:String="";
			var b:String="";
			var str:String;
			var n:uint=rgb>>16;
			str="00"+n.toString(16).toUpperCase();
			r=str.substr(str.length-2,2);
			
			n=rgb>>8&0x00ff;
			str="00"+n.toString(16).toUpperCase();
			g=str.substr(str.length-2,2);
			
			n=rgb&0x0000ff;
			str="00"+n.toString(16).toUpperCase();
			b=str.substr(str.length-2,2);
			
			return "R:"+r+" G:"+g+" B:"+b;
		}
		
		//设置颜色光标的颜色，避免和背景颜色重叠
		public function setCrossPointColor(pointColor:uint):void
		{
			var clrTrans:ColorTransform=new ColorTransform();
			clrTrans.color=0xffffff-pointColor;
			__colorCrossPoint.transform.colorTransform=clrTrans;
		}

		private var __colors:Array;
		private var __alphas:Array;
		private var __ratios:Array;
		
		private var __selectedColor:uint=0x0;
		
		//光谱
		private var __defaultColors:Array=[0xff0000,0xff00ff,0x00ffff,0x00ff00,0xffff00,0xff0000];
		private const CROSS_POINT_RADIUS:Number=9.5;
		private const ARROW_POINT_RADIUS:Number=4.5;
		
		private var __fillArea:Canvas;//主填充区
		private var __lineArea:Canvas;//亮度调整区
		private var __valueArea:Canvas;//颜色显示区
		private var __valueLabel:Label;//色值显示
		private var __colorCrossPoint:Image;
		private var __colorArrowPoint:Image;
		private var __fillAreaBitmap:BitmapData;
		private var __lineAreaBitmap:BitmapData;
	}
}