package com.brandqq.lib.controls
{
	import flash.geom.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.events.FlexEvent;
	import mx.controls.Alert;
	
	import com.brandqq.Resources.Cursors;
	import com.brandqq.lib.util.MatrixTransformer;
	/**
	 * DisplayObject对象选择器控件
	 * 实现ISelectorContainer的容器才能使用该控件，否则可能出现异常情况
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public final class Selector extends UIComponent
	{
		/**
		 * 构造函数
		 * @param style
		 * @return 
		 * 
		 */
		public function Selector()
		{
			super();
			this.__style=SelectorStyle.Normal;
			this.__isMultiSelect=false;
			this._handler1=new SelectorHandler("H1");
			this._handler1.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler1);
			
			this._handler2=new SelectorHandler("H2");
			this._handler2.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler2);
			
			this._handler3=new SelectorHandler("H3");
			this._handler3.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler3);
			
			this._handler4=new SelectorHandler("H4");
			this._handler4.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler4);
			
			this._handler5=new SelectorHandler("H5");
			this._handler5.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler5);
			
			this._handler6=new SelectorHandler("H6");
			this._handler6.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler6);
			
			this._handler7=new SelectorHandler("H7");
			this._handler7.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler7);
			
			this._handler8=new SelectorHandler("H8");
			this._handler8.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handler8);
			
			this._handlerA=new SelectorHandler("HA");
			this._handlerA.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handlerA);
			
			this._handlerB=new SelectorHandler("HB");
			this._handlerB.addEventListener(SelectorHandlerMouseEvent.ON_MOUSEDOWN,onHandlerMouseEventHandle);
			this.addChild(this._handlerB);
			
			this.visible=false;
			
			addEventListener(MouseEvent.MOUSE_DOWN,onSelectorMouseDownHandler,false);
		}
		
		//显示控制点
		private function showHandlers():void
		{
			var hIds:Array=new Array();
			var _oH:SelectorHandler;
			var _oHP:Point;
			var _r:Rectangle=this.__selectorRect;
			
			if(this._rotateCenterPoint==null)
			{
				this._rotateCenterPoint=new Point(_r.width/2,_r.height/2);
			}
			
			switch(this.__style)
			{
				case SelectorStyle.Normal:
					hIds=new Array("H1","H2","H3","H4","H5","H6","H7","H8","HA");
					break;
				case SelectorStyle.Simple:
					hIds=new Array("H1","H2","H3","H4");
					break;
				case SelectorStyle.Super:
					hIds=new Array("H1","H2","H3","H4","H5","H6","H7","H8","HA","HB");
					break;
				case SelectorStyle.Base:
					hIds=new Array();
					break;
				default:
					hIds=new Array();
					break;
			}
			
			for(var i:int=0;i<this.numChildren;i++)
			{
				_oH=SelectorHandler(this.getChildAt(i));
				if(hIds.indexOf(_oH.name)!=-1)
				{
					switch(_oH.name)
					{
						case "H1":
							_oHP=new Point(0,0);
							break;
						case "H2":
							_oHP=new Point(_r.width,0);
							break;
						case "H3":
							_oHP=new Point(_r.width,_r.height);
							break;
						case "H4":
							_oHP=new Point(0,_r.height);
							break;
						case "H5":
							_oHP=new Point(_r.width/2,0);
							break;
						case "H6":
							_oHP=new Point(_r.width,_r.height/2);
							break;
						case "H7":
							_oHP=new Point(_r.width/2,_r.height);
							break;
						case "H8":
							_oHP=new Point(0,_r.height/2);
							break;
						case "HA":
							_oHP=new Point(_r.width/2,-10);
							break;
						case "HB":
							_oHP=new Point(_r.width/2,_r.height/2);
							break;
					}
					_oH.visible=true;
					_oH.x=_oHP.x;
					_oH.y=_oHP.y;
				}
				else
				{
					_oH.visible=false;
				}
			}
		}
		
		//选择多个对象
		public static function selectItems(items:Array,parentContainer:SelectorContainer):void
		{
			if(parentContainer==null)
			{
				return;
			}
			if(parentContainer.selectedItemsRect==null)
			{
				return;
			}
			if(parentContainer.selectedItemsRect.isEmpty())
			{
				return;
			}
			if(items==null)
			{
				if(__instance!=null)
				{
					__instance.reset();
				}
				return;
			}
			if(items.length==0)
			{
				if(__instance!=null)
				{
					__instance.reset();
				}
				return;
			}
			
			if(__instance==null)
			{
				__instance=new Selector();
			}
			
			if(__instance.__selectedItems==items)
			{
				return;
			}
			__instance.__style=SelectorStyle.Base;
			__instance.__isMultiSelect=true;
			__instance.__selectedItems=items;
			__instance.__parent=parentContainer;
			__instance.__selectorRect=parentContainer.selectedItemsRect;
			__instance.__parent.addChild(__instance);
			__instance.displaySelector();
		}
		
		
		/**
		 * 开始选择一个对象
		 * @param item
		 * 
		 */
		public static function selectItem(item:DisplayObject=null,autoDispatchMouseDown:Boolean=true,style:String="normal"):void
		{
			try{
			if(item==null)
			{
				if(__instance!=null)
				{
					__instance.reset();
				}
				return;
			}
			
			if(!(item.parent is SelectorContainer))
			{
				return;
			}
			
			if(__instance==null)
			{
				__instance=new Selector();
			}
			
			if(__instance.__selectedItem==item)
			{
				return;
			}
						
			__instance.__style=SelectorStyle.checkAvalibleStyle(style);
			__instance.__isMultiSelect=false;
			var mt:Matrix=item.transform.matrix;
			if(mt==null)
			{
				mt=new Matrix();
				item.transform.matrix=mt;
			}
			__instance._selectedItemMatrix=mt;
			__instance.__selectedItem=item;
			__instance.__parent=SelectorContainer(item.parent);
			__instance.__selectorRect=__instance.__selectedItem.getRect(DisplayObject(__instance.__parent));
			__instance.__parent.addChild(__instance);
			__instance.displaySelector();
			if(autoDispatchMouseDown)
			{
				__instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
			}catch(err:Error){Alert.show("Selector:"+err+'')}
		}
		
		//显示选择器
		private function displaySelector(b:Boolean=true):void
		{
			if(b)
			{
				this.visible=true;
				this.transform.matrix=new Matrix();
				this.move(this.__selectorRect.x,this.__selectorRect.y);
				showHandlers();
				drawSelectorGraphic();
				return;
			}
			
			this.graphics.clear();
			this.visible=false;
		}
		
		private function drawSelectorGraphic():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0,0x316AC5);
			this.graphics.beginFill(0x316AC5,.05);
			this.graphics.drawRect(0,0,this.__selectorRect.width,this.__selectorRect.height);
			this.graphics.endFill();
		}
		
		private function reset():void
		{
			if(this.__parent!=null)
			{
				this.__parent.enableMouseDown=true;
				this.__parent.removeChild(this);
			}
			if(stage!=null)
			{
				if(stage.hasEventListener(MouseEvent.MOUSE_UP))
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP,onSelectorStageMouseUpHandler);
				}
			}
			this.__selectedItem=null;
			this.__selectedItems=null;
		}
		
		/**
		 * 在选择器上按下鼠标
		 * @param e
		 * 
		 */
		private function onSelectorMouseDownHandler(e:MouseEvent):void
		{
			if(this.__selectedItem==null && this.__selectedItems==null)
			{
				return;
			}
			this.__parent.enableMouseDown=false;
			CursorManager.setCursor(Cursors.MOVE,2,-9,-9);
			this.startDrag(false,this.selectorDragRect);
			_currentHandler=null;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSelectorStageMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,onSelectorStageMouseUpHandler);
		}
		
		/**
		 * 在舞台上释放鼠标
		 * @param e
		 * 
		 */		
		private function onSelectorStageMouseUpHandler(e:MouseEvent):void
		{
			this._isMouseDown=false;
			this.stopDrag();
			CursorManager.removeAllCursors();
			
			if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSelectorStageMouseMoveHandler);
			}
			if(!this.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,onSelectorMouseDownHandler);
			}
			this.__parent.enableMouseDown=true;
			stage.removeEventListener(MouseEvent.MOUSE_UP,onSelectorStageMouseUpHandler);
		}
		
		/**
		 * 在控制点上按下鼠标
		 * @param e
		 * 
		 */		
		private function onHandlerMouseEventHandle(e:SelectorHandlerMouseEvent):void
		{
			if(this.willTrigger(MouseEvent.MOUSE_DOWN))
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onSelectorMouseDownHandler);
			}
			
			this._currentHandler=e.handler;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSelectorStageMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,onSelectorStageMouseUpHandler);
		}
		
		//计算选择器的允许拖动范围
		private function get selectorDragRect():Rectangle
		{
			var __rect:Rectangle=new Rectangle();
			__rect.width=DisplayObject(this.__parent).width-this.__selectorRect.width;
			__rect.height=DisplayObject(this.__parent).height-this.__selectorRect.height;
			return __rect;
		}
				
		//获取当前样式
		public static function get style():String
		{
			if(__instance==null)
			{
				__instance=new Selector();
			}
			return __instance.__style;
		}
		
		//设置选择器样式
		public static function set style(s:String):void
		{
			if(__instance==null)
			{
				__instance=new Selector();
			}
			if(s==__instance.__style)
			{
				return;
			}
			__instance.__style=SelectorStyle.checkAvalibleStyle(s);
			__instance.showHandlers();
		}
		
		
		/**
		 * 在舞台上移动鼠标
		 * @param e
		 * 
		 */		
		private function onSelectorStageMouseMoveHandler(e:MouseEvent):void
		{
			var _mt:Matrix;
			var _rotateAngle:Number;
			if(_currentHandler!=null)//控制点事件
			{
				_currentHandler.setCursor();
				_currentPoint=new Point(e.stageX,e.stageY);
				_currentPoint=this.globalToLocal(_currentPoint);
				switch(this._currentHandler.name)
				{
					case "H1":
						_currentHandler.x=_currentPoint.x;
						_currentHandler.y=_currentPoint.y;
						resizeSelector();
						break;
					case "H2":
						_currentHandler.x=_currentPoint.x;
						_currentHandler.y=_currentPoint.y;
						this._handler1.y=_currentPoint.y;
						resizeSelector();
						break;
					case "H3":
						_currentHandler.x=_currentPoint.x;
						_currentHandler.y=_currentPoint.y;
						resizeSelector();
						break;
					case "H4":
						_currentHandler.x=_currentPoint.x;
						_currentHandler.y=_currentPoint.y;
						this._handler3.y=_currentPoint.y;
						resizeSelector();
						break;
					case "H5":
						_currentHandler.y=_currentPoint.y;
						this._handler1.y=_currentPoint.y;
						resizeSelector();
						break;
					case "H6":
						_currentHandler.x=_currentPoint.x;
						this._handler3.x=_currentPoint.x;
						resizeSelector();
						break;
					case "H7":
						_currentHandler.y=_currentPoint.y;
						this._handler3.y=_currentPoint.y;
						resizeSelector();
						break;
					case "H8":
						_currentHandler.x=_currentPoint.x;
						this._handler1.x=_currentPoint.x;
						resizeSelector();
						break;
					case "HA":
						_mt=this.transform.matrix;
						_rotateAngle=MatrixTransformer.getPointRadians(this._rotateCenterPoint,this._currentPoint);
						MatrixTransformer.rotateAroundInternalPoint(_mt,
																	this._rotateCenterPoint.x,
																	this._rotateCenterPoint.y,
																	_rotateAngle);
						this.transform.matrix=_mt;
						
						_mt=__selectedItem.transform.matrix;
						var _internalPoint:Point=this.localToGlobal(new Point(this._rotateCenterPoint.x,this._rotateCenterPoint.y));
						_internalPoint=__selectedItem.globalToLocal(_internalPoint);
						MatrixTransformer.rotateAroundInternalPoint(_mt,
										_internalPoint.x,
										_internalPoint.y,
										_rotateAngle);
						__selectedItem.transform.matrix=_mt;
						break;
					case "HB":
						this._handlerB.startDrag(false,
								new Rectangle(3,3,this.__selectorRect.width-3,this.__selectorRect.height-3));
						//设置旋转中心点
						this._rotateCenterPoint=new Point(this._handlerB.x,this._handlerB.y);
						break;
				}
			}
			else// 选择器事件
			{
				if(!__isMultiSelect)
				{
					_mt=__selectedItem.transform.matrix;
					_mt.tx+=this.transform.matrix.tx-this.__selectorRect.x;
					_mt.ty=this.transform.matrix.ty-this.__selectorRect.y;
					__selectedItem.transform.matrix=_mt;
				}
				else//多选
				{
					
				}
			}
		}
		
		private function resizeSelector():void
		{
			//var p:Point=this.localToGlobal(new Point(this._handler1.x,this._handler1.y));
			this.__selectorRect.x=this.x;
			this.__selectorRect.y=this.y;
			this.__selectorRect.width=this._handler3.x-this._handler1.x;
			this.__selectorRect.height=this._handler3.y-this._handler1.y;
			this.displaySelector();
			this.__selectedItem.x=this.__selectorRect.x;
			this.__selectedItem.y=this.__selectorRect.y;
			this.__selectedItem.width=this.__selectorRect.width;
			this.__selectedItem.height=this.__selectorRect.height;
		}
		
		public static function get selectedItem():DisplayObject
		{
			if(__instance==null)
			{
				return null;
			}
			return __instance.__selectedItem;
		}
		
		public static function get selectedItems():Array
		{
			if(__instance==null)
			{
				return null;
			}
			return __instance.__selectedItems;
		}
		
		private var __selectedItem:DisplayObject;
		private var __selectedItems:Array;
		private var __parent:SelectorContainer;
		private var __style:String;
		private var __selectorRect:Rectangle;
		private var __isMultiSelect:Boolean;
		
		private var _handler1:SelectorHandler;//left top
		private var _handler2:SelectorHandler;//right top
		private var _handler3:SelectorHandler;//right bottom
		private var _handler4:SelectorHandler;//left bottom
		private var _handler5:SelectorHandler;//top
		private var _handler6:SelectorHandler;//right
		private var _handler7:SelectorHandler;//bottom
		private var _handler8:SelectorHandler;//left
		private var _handlerA:SelectorHandler;//rotation
		private var _handlerB:SelectorHandler;//rotation center point
		
		private var _currentHandler:SelectorHandler;
		private var _currentPoint:Point;
		private var _isMouseDown:Boolean=false;
		
		private var _selectedItemMatrix:Matrix;
		private var _rotateCenterPoint:Point;
		
		
		private static var __instance:Selector;
		
	}
}