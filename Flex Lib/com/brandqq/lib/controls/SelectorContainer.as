package com.brandqq.lib.controls
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.controls.Alert;
	
	import com.brandqq.lib.graphic.IVector;
	import com.brandqq.lib.graphic.Thumbnail;
	import com.brandqq.lib.graphic.Symbol;
	import com.brandqq.lib.util.PNGEncoder;
	import com.brandqq.lib.events.SelectorContainerEvent;
	import flash.utils.ByteArray;
	import flash.geom.Matrix;
	
	[Event(name="onItemsSelected",type="com.brandqq.lib.events.SelectorContainerEvent")]
	[Event(name="onItemsUnSelected",type="com.brandqq.lib.events.SelectorContainerEvent")]

	public class SelectorContainer extends UIComponent
	{
		public function SelectorContainer()
		{
			super();
			super.percentHeight=100;
			super.percentWidth=100;
			__enableSelector=true;
			addEventListener(MouseEvent.MOUSE_DOWN,onContainerMouseDownEventHandler);
			addEventListener(KeyboardEvent.KEY_DOWN,onContainerKeyEventHandler);
			addEventListener(KeyboardEvent.KEY_UP,onContainerKeyEventHandler);
		}
		
		public function getChildren():Array
		{
			var children:Array=new Array();
			for(var i:int=0;i<this.numChildren;i++)
			{
				if(this.getChildAt(i) is IVector)
				{
					children.push(this.getChildAt(i));
				}
			}
			return children;
		}
		
		public function clearChildren():void
		{
			for(var i:int=0;i<this.numChildren;i++)
			{
				this.removeChild(this.getChildAt(i));
			}
		}
		
		public function getChildrenRectangle():Rectangle
		{
			var _rect:Rectangle=new Rectangle();
			for each(var obj:DisplayObject in this.getChildren())
			{
				_rect=_rect.union(obj.getRect(this));
			}
			return _rect;
		}
		
		public function getNewDepth():uint
		{
			if(super.numChildren>0)
			{
				return super.numChildren-1;
			}
			return 0;
		}
		
		private function onContainerKeyEventHandler(e:KeyboardEvent):void
		{
			Alert.show(e.keyCode+'');
			if(!__enableSelector)
			{
				return;
			}
			
			if(__selectedItem==null)
			{
				return;
			}
			
			switch(e.keyCode)
			{
				case 0x2E:
				case 0x8:
					removeChild(DisplayObject(__selectedItem));
					break;
				case 0x25://left
					break;
				case 0x26://up
					break;
				case 0x27://right
					break;
				case 0x28://down
					break;
			}
		}
		
		public function set enableMouseDown(value:Boolean):void
		{
			if(value)
			{
				addEventListener(MouseEvent.MOUSE_DOWN,onContainerMouseDownEventHandler);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN,onContainerMouseDownEventHandler);
			}
		}
		
		public function onContainerMouseDownEventHandler(e:MouseEvent):void
		{
			if(!__enableSelector)
			{
				return;
			}
			this.setFocus();
			var obj:DisplayObject=getHitObject(this.mouseX,this.mouseY);
			if(obj==null)
			{
				__selectedItem=null;
				
				if(Selector.selectedItem!=null || Selector.selectedItems!=null)
				{
					Selector.selectItem(null);
				}
				
				this.dispatchEvent(new SelectorContainerEvent(SelectorContainerEvent.ITEMS_UNSELECTED));
				
				__mouseInitPoint=new Point(this.mouseX,this.mouseY);
				__selectRect=new Rectangle();
				__selectedItems=null;
				
				addEventListener(MouseEvent.MOUSE_MOVE,onContainerMouseMoveEvent);
				stage.addEventListener(MouseEvent.MOUSE_UP,onContainerStageMouseUpEvent);
				return;
			}
			if(obj is IVector)
			{
				__selectedItem=IVector(obj);
				Selector.selectItem(obj);
				this.dispatchEvent(new SelectorContainerEvent(SelectorContainerEvent.ITEMS_SELECTED,[obj]));
				return;
			}
		}
		
		private function onContainerStageMouseUpEvent(e:MouseEvent):void
		{
			if(hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				removeEventListener(MouseEvent.MOUSE_MOVE,onContainerMouseMoveEvent);
			}
			this.graphics.clear();
			__selectedItems=getSelectedItems();
			if(__selectedItems!=null)
			{
				if(__selectedItems.length==1)
				{
					__selectedItem=IVector(__selectedItems[0]);
					Selector.selectItem(DisplayObject(__selectedItems[0]),false);
				}
				else
				{
					Selector.selectItems(__selectedItems,this);
				}
				this.dispatchEvent(new SelectorContainerEvent(SelectorContainerEvent.ITEMS_SELECTED,__selectedItems));
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,onContainerStageMouseUpEvent);
		}
		
		private function onContainerMouseMoveEvent(e:MouseEvent):void
		{
			if (this.mouseX>=__mouseInitPoint.x && this.mouseY>=__mouseInitPoint.y) 
			{
				__selectRect.width=this.mouseX-__mouseInitPoint.x;
				__selectRect.height=this.mouseY-__mouseInitPoint.y;
				__selectRect.x=__mouseInitPoint.x;
				__selectRect.y=__mouseInitPoint.y;
			} 
			else if (this.mouseX>=__mouseInitPoint.x && this.mouseY<=__mouseInitPoint.y) 
			{
				__selectRect.width=this.mouseX-__mouseInitPoint.x;
				__selectRect.height=__mouseInitPoint.y-this.mouseY;
				__selectRect.x=__mouseInitPoint.x;
				__selectRect.y=this.mouseY;
			} 
			else if (this.mouseX<=__mouseInitPoint.x && this.mouseY>=__mouseInitPoint.y) 
			{
				__selectRect.width=__mouseInitPoint.x-this.mouseX;
				__selectRect.height=this.mouseY-__mouseInitPoint.y;
				__selectRect.x=this.mouseX;
				__selectRect.y=__mouseInitPoint.y;
			} 
			else {
				__selectRect.width=__mouseInitPoint.x-this.mouseX;
				__selectRect.height=__mouseInitPoint.y-this.mouseY;
				__selectRect.x=this.mouseX;
				__selectRect.y=this.mouseY;
			}
			this.graphics.clear();
			this.graphics.lineStyle(0,0x316AC5,1,true,"none");
			this.graphics.drawRect(
								__selectRect.x,
								__selectRect.y,
								__selectRect.width,
								__selectRect.height);
		}
		
		
		
		//检验两个矩形是否包含或者相交
		public static function isIntersectRectangles(rect1:Rectangle,rect2:Rectangle):Boolean
		{
			var _bigRect:Rectangle=new Rectangle();
			_bigRect=_bigRect.union(rect1);
			_bigRect=_bigRect.union(rect2);
			if(_bigRect.width<rect1.width+rect2.width &&
				_bigRect.height<rect1.height+rect2.height)
			{
				return true;
			}
			return false;
		}
		
		protected function selectNothing():void
		{
			if(Selector.selectedItem!=null || Selector.selectedItems!=null)
			{
				Selector.selectItem(null);
			}
		}
		
		private function getSelectedItems():Array
		{
			if(__selectRect==null)
			{
				return null;
			}
			if(__selectRect.isEmpty())
			{
				return null;
			}
			var _items:Array=new Array();
			var _itemRect:Rectangle;
			
			for(var i:int=0;i<this.numChildren;i++)
			{
				_itemRect=this.getChildAt(i).getRect(this);
				if(isIntersectRectangles(_itemRect,__selectRect))
				{
					_items.push(this.getChildAt(i));
				}
			}
			if(_items.length==0)
			{
				return null;
			}
			return _items;
		}

		private function getHitObject(local_x:Number, local_y:Number):DisplayObject
		{
			var _r:Rectangle;
			for(var i:int=0;i<this.numChildren;i++)
			{
				_r=this.getChildAt(i).getRect(this);
				if(_r.contains(local_x,local_y))
				{
					return this.getChildAt(i);
				}
			}
			return null;
		}
		
		public function get selectedItem():IVector
		{
			return __selectedItem;
		}
		
		public function get selectedItems():Array
		{
			return __selectedItems;
		}
		
		public function get enableSelector():Boolean
		{
			return __enableSelector;
		}
		public function set enableSelector(value:Boolean):void
		{
			__enableSelector=value;
		}
		
		override public function set hitArea(value:Sprite):void
		{
			super.hitArea=value;
			value.mouseEnabled=false;
		}
		
		public function getThumbnail():Thumbnail
		{
			var rect:Rectangle=getChildrenRectangle();
			var bitmapData:BitmapData=new BitmapData(rect.width,rect.height);
			var drawObj:Symbol;
			var drawObjMatrix:Matrix;
			for each(var obj:IVector in this.getChildren())
			{
				drawObj=Symbol(obj);
				drawObjMatrix=drawObj.transform.matrix;
				drawObjMatrix.tx-=rect.x;
				drawObjMatrix.ty-=rect.y;
				bitmapData.draw(drawObj,drawObjMatrix,drawObj.transform.colorTransform,null,null,true);
			}
			var bytes:ByteArray=PNGEncoder.encode(bitmapData);
			var thumb:Thumbnail=new Thumbnail(bytes,bitmapData.width,bitmapData.height);
			bitmapData.dispose();
			return thumb;
		}
		
		public function get selectedItemsRect():Rectangle
		{
			var array:Array=__selectedItems;
			if(array!=null)
			{
				var _r:Rectangle=new Rectangle();
				for(var i:uint=0;i<array.length;i++)
				{
					_r=_r.union(DisplayObject(array[i]).getRect(this));
				}
				return _r;
			}
			return null;
		}
		
		public function alignElements(align:String,global:Boolean=false):void
		{
			if(selectedItem==null && selectedItems==null)
			{
				return;
			}
			if(selectedItems.length>1)
			{
				switch(align.toLowerCase())
				{
					case "left":
						
					case "center":
					case "right":
					case "top":
					case "middle":
					case "bottom":
				}
			}
			else if(selectedItems.length==1)
			{
				
			}
			else
			{
				
			}
		}
		
		public function distributeElements(direction:String,global:Boolean=false):void
		{
			
		}
		
		public function matchElementsSize(option:String,global:Boolean=false):void
		{
			
		}
		
		private var __startDrawRectPoint:Point;
		private var __endDrawRectPoint:Point;
		protected var __selectedItem:IVector;
		protected var __selectedItems:Array;
		protected var __enableSelector:Boolean;
		
		private var __mouseInitPoint:Point;
		private var __selectRect:Rectangle;
	}
}