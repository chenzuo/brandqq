// ActionScript file
import flash.geom.Rectangle;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.FocusEvent;
import flash.geom.ColorTransform;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Matrix;
import flash.events.KeyboardEvent;

import mx.controls.NumericStepper;
import mx.events.NumericStepperEvent;
import mx.events.ColorPickerEvent;
import mx.events.IndexChangedEvent;
import mx.containers.Canvas;
import mx.core.UIComponent;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.core.Application;
import mx.controls.Image;
import mx.controls.Label;
import mx.containers.Panel;
import mx.controls.TextInput;

import com.brandqq.lib.util.StringUtil;
import com.brandqq.lib.util.ColorUtil;
import com.brandqq.lib.util.MatrixTransformer;
import com.brandqq.IO.XmlReader;
import com.brandqq.Resources.Requests;
import com.brandqq.lib.events.DataLoadEvent;
import com.brandqq.lib.graphic.Symbol;
import mx.events.MenuEvent;

[Embed(source="SystemSkin.swf",symbol="LogoSign")]
private const EMBED_LOGOSIGN:Class;

[Embed(source="SystemSkin.swf",symbol="Snap_H")]
private const EMBED_Snap_H:Class;
[Embed(source="SystemSkin.swf",symbol="Snap_V")]
private const EMBED_Snap_V:Class;

[Embed(source="SystemSkin.swf",symbol="Align_Center")]
private const EMBED_Align_Center:Class;
[Embed(source="SystemSkin.swf",symbol="Align_Middle")]
private const EMBED_Align_Middle:Class;

[Embed(source="SystemSkin.swf",symbol="ClockWise")]
private const EMBED_ClockWise:Class;
[Embed(source="SystemSkin.swf",symbol="Delete")]
private const EMBED_Delete:Class;

private function initApp():void
{
	PropertyPanel.addEventListener(MouseEvent.DOUBLE_CLICK,function(e:MouseEvent):void
		{
			if(e.stageY>PropertyPanel.y && e.stageY<PropertyPanel.y+30)
			{
				if(PropertyPanel.height==200)
				{
					PropertyPanel.height=30;
				}
				else
				{
					PropertyPanel.height=200;
				}
			}
		}
	);
	loadTemplates();
	CardFaces.addEventListener(KeyboardEvent.KEY_DOWN,onCardFacesKeyDown);
}

private function onCardFacesKeyDown(e:KeyboardEvent):void
{
	if(e.ctrlKey && e.keyCode==67)//Ctrl+C
	{
		__CopyPasteActionFlag=CardFaces.selectedIndex+1;
	}
	else if(e.ctrlKey && e.keyCode==86)//Ctrl+V
	{
		if(__CopyPasteActionFlag==0)//无拷贝
		{
			return;
		}
		
		if(__CopyPasteActionFlag-1==CardFaces.selectedIndex)//源和目标相同
		{
			return;
		}
		
		try
		{
		var i:int;
		if(CardFaces.selectedIndex==0)
		{
			for(i=1;i<BackFace.numChildren;i++)
			{
				currentObject=BackFace.getChildAt(i);
				cloneCurrentObject(FrontFace);
			}
			for(i=0;i<BackFaceSymbolsLayer.numChildren;i++)
			{
				currentObject=BackFaceSymbolsLayer.getChildAt(i);
				cloneCurrentObject(FrontFaceSymbolsLayer);
			}
		}
		else
		{
			for(i=1;i<FrontFace.numChildren;i++)
			{
				currentObject=FrontFace.getChildAt(i);
				cloneCurrentObject(BackFace);
			}
			for(i=0;i<FrontFaceSymbolsLayer.numChildren;i++)
			{
				currentObject=FrontFaceSymbolsLayer.getChildAt(i);
				cloneCurrentObject(BackFaceSymbolsLayer);
			}
		}
		}
		catch(err:Error)
		{
			Alert.show(err+'');
		}
		__CopyPasteActionFlag=0;//清除拷贝
	}
}

private function loadTemplates():void
{
	var _reader:XmlReader=new XmlReader(Requests.cardTemplatesRequest());
	_reader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
		{
			CardFaces.enabled=false;
			PropertyPanel.enabled=false;
		}
	);
	_reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
		{
			CardFaces.enabled=true;
			PropertyPanel.enabled=true;
			__templatesData=_reader.getData();
			TempStyle.dataProvider=__templatesData.Styles.Style;
			TempStyle.selectedIndex=1;
		}
	);
	_reader.read();
}

private function addLogoSign():void
{
	if(CardFaces.selectedIndex==0)
	{
		if(FrontFace.getChildByName("QQ_LOGOSIGN")!=null)
		{
			return;
		}
		FrontFace.addChild(getNewLogoSign());
	}
	else
	{
		if(BackFace.getChildByName("QQ_LOGOSIGN")!=null)
		{
			return;
		}
		BackFace.addChild(getNewLogoSign());
	}
}

private function getNewLogoSign():Image
{
	var logoSign:Image=new Image();
	logoSign.name="QQ_LOGOSIGN";
	logoSign.scaleContent=true;
	logoSign.source=EMBED_LOGOSIGN;
	logoSign.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
	currentObject=logoSign;
	return logoSign;
}

private function addNewTextObject(font:String="Arial",size:uint=12,
									align:String="left",bold:String="normal",
									style:String="normal",clr:uint=0x0,css:String="textObj",
									content:String="",placeTarget:DisplayObjectContainer=null):void
{
	var textObj:TextInput=new TextInput();
	textObj.setStyle("fontFamily",font);
	textObj.setStyle("fontSize",size);
	textObj.setStyle("textAlign",align);
	textObj.setStyle("fontWeight",bold);
	textObj.setStyle("fontStyle",style);
	textObj.setStyle("color",clr);
	textObj.styleName=css;
	textObj.text=content;
	textObj.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
	
	if(placeTarget==null)
	{
		if(CardFaces.selectedIndex==0)
		{
			FrontFace.addChild(textObj);
		}
		else
		{
			BackFace.addChild(textObj);
		}
	}
	else
	{
		placeTarget.addChild(textObj);
	}
	currentObject=DisplayObject(textObj);
}

private function onObjectMouseDownEvent(e:MouseEvent):void
{
	currentObject=DisplayObject(e.currentTarget);
	Sprite(e.currentTarget).startDrag(false,getCurrentObjectDragRect());
	stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUpEvent);
	stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMoveEvent);
}

private function getCurrentObjectDragRect():Rectangle
{
	var _r:Rectangle=new Rectangle();
	_r.x=0;
	_r.y=0;
	_r.width=currentObject.parent.width-currentObject.getRect(currentObject.parent).width;
	_r.height=currentObject.parent.height-currentObject.getRect(currentObject.parent).height;
	return _r;
}

private function onStageMouseUpEvent(e:MouseEvent):void
{
	try
	{
		Sprite(currentObject).stopDrag();
		currentObject=currentObject;
		stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUpEvent);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMoveEvent);
	}
	catch(err:Error)
	{
		//
	}
}

private function onStageMouseMoveEvent(e:MouseEvent):void
{
	currentObject_x=currentObject.x;
	currentObject_y=currentObject.y;
}

private function onTextObjectActived(e:MouseEvent):void
{
	currentObject=DisplayObject(e.target);
}

private function onObjectSizeChangeEvent(e:NumericStepperEvent):void
{
	if(currentObject==null)
	{
		return;
	}

	switch(NumericStepper(e.target).id)
	{
		case "ObjWidth":
			if(currentObject.name!="QQ_LOGOSIGN")
			{
				if(LockWH.selected)
				{
					currentObject.width=e.value;
					currentObject.height=currentObject.width/currentObject_WH;
					currentObject_width=currentObject.width;
					currentObject_height=currentObject.height;
				}
				else
				{
					currentObject.width=e.value;
				}
			}
			break;
		case "ObjHeight":
			if(currentObject.name!="QQ_LOGOSIGN")
			{
				if(LockWH.selected)
				{
					currentObject.height=e.value;
					currentObject.width=currentObject.height*currentObject_WH;
					currentObject_width=currentObject.width;
					currentObject_height=currentObject.height;
				}
				else
				{
					currentObject.height=e.value;
				}
			}
			break;
		case "ObjX":
			currentObject.x=e.value;
			break;
		case "ObjY":
			currentObject.y=e.value;
			break;
	}
}

private function onObjColorChangeEvent(e:ColorPickerEvent):void
{
	if(currentObject==null)
	{
		return;
	}
	if(currentObject.name=="QQ_LOGOSIGN")
	{
		return;
	}
	
	if(currentObject is TextInput)
	{
		TextInput(currentObject).setStyle("color",e.color);
	}
	else
	{
		var ct:ColorTransform=new ColorTransform();
		ct.color=e.color;
		currentObject.transform.colorTransform=ct;
	}
}

/**
* 变形菜单
*/
private function onTransformMenuClick(e:MenuEvent):void
{
	if(currentObject==null)
	{
		return;
	}
	var m:Matrix=currentObject.transform.matrix;
	if(m==null)
	{
		m=new Matrix();
	}
	switch(e.label)
	{
		case "旋转90度":
			rotateCurrentObject();
			break;
		case "水平翻转":
			MatrixTransformer.setScaleX(m,MatrixTransformer.getScaleX(m)*-1);
			
			break;
		case "垂直翻转":
			MatrixTransformer.setScaleY(m,MatrixTransformer.getScaleY(m)*-1);
			
			break;
		case "取消变形":
			m=new Matrix();
			break;
	}
	currentObject.transform.matrix=m;
}

/**
* 对齐菜单
*/
private function onAlignMenuClick(e:MenuEvent):void
{
	if(currentObject==null)
	{
		return;
	}
	switch(e.label)
	{
		case "水平居中":
			alignCurrentObject(1);
			break;
		case "垂直居中":
			alignCurrentObject(2);
			break;
	}
}


private function rotateCurrentObject(degree:Number=90):void
{
	if(!(currentObject is TextInput))
	{
		var m:Matrix=currentObject.transform.matrix;
		if(m==null)
		{
			m=new Matrix();
		}
		MatrixTransformer.rotateAroundInternalPoint(m,currentObject.width/2,currentObject.height/2,degree);
		currentObject.transform.matrix=m;
	}
}

private function fixCurrentObject(v:int):void
{
	if(currentObject==null)
	{
		return;
	}
	if(currentObject is TextInput)
	{
		if(v==1)//h
		{
			currentObject.width=currentObject.parent.width;
			currentObject.x=0;
		}
		else//v
		{
			currentObject.height=currentObject.parent.height;
			currentObject.y=0;
		}
		return;
	}
	var m:Matrix=currentObject.transform.matrix;
	if(m==null)
	{
		m=new Matrix();
	}
	var sFactor:Number;
	if(v==1)//h
	{
		sFactor=currentObject.parent.width/currentObject.width;
		m.scale(sFactor,1.0);
		m.tx=0;
	}
	else//v
	{
		sFactor=currentObject.parent.height/currentObject.height;
		m.scale(1.0,sFactor);
		m.ty=0;
	}
	currentObject.transform.matrix=m;
}

private function alignCurrentObject(v:int):void
{
	if(currentObject is TextInput)
	{
		if(v==1)//h
		{
			currentObject.x=currentObject.parent.width/2-currentObject.width/2;
		}
		else//v
		{
			currentObject.y=currentObject.parent.height/2-currentObject.height/2;
		}
		return;
	}
	var m:Matrix=currentObject.transform.matrix;
	if(m==null)
	{
		m=new Matrix();
	}
	if(v==1)//h
	{
		m.tx=currentObject.parent.width/2-currentObject.width/2;
	}
	else//v
	{
		m.ty=currentObject.parent.height/2-currentObject.height/2;
	}
	currentObject.transform.matrix=m;
}

private function cloneCurrentObject(placeTarget:DisplayObjectContainer=null):void
{
	if(currentObject==null)
	{
		return;
	}
	
	if(currentObject is TextInput)
	{
		var obj:TextInput=TextInput(currentObject);
		addNewTextObject(obj.getStyle("fontFamily"),uint(obj.getStyle("fontSize")),
						obj.getStyle("textAlign"),obj.getStyle("fontWeight"),obj.getStyle("fontStyle"),
						uint(obj.getStyle("color")),obj.styleName.toString(),"",placeTarget);
		currentObject.x=obj.x+(placeTarget==null?10:0);
		currentObject.y=obj.y+(placeTarget==null?10:0);
		currentObject.width=obj.width;
		currentObject.height=obj.height;
	}
	else if(currentObject is Symbol)
	{
		var obj1:Symbol=Symbol(currentObject);
		var symbol:Symbol=new Symbol();
		symbol.glyph=obj1.glyph;
		var mt:Matrix=obj1.transform.matrix;
		symbol.transform.matrix=mt;
		var ct:ColorTransform=obj1.transform.colorTransform;
		symbol.transform.colorTransform=ct;
		symbol.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
		
		if(placeTarget==null)
		{
			if(CardFaces.selectedIndex==0)
			{
				FrontFaceSymbolsLayer.addChild(symbol);
			}
			else
			{
				BackFaceSymbolsLayer.addChild(symbol);
			}
		}
		else
		{
			placeTarget.addChild(symbol);
		}
		currentObject=symbol;
		currentObject.x+=(placeTarget==null?5:0);
		currentObject.y+=(placeTarget==null?5:0);
	}
}

private function get currentObjectIsBold():Boolean
{
	if(!currentObject is TextInput)
	{
		return false;
	}
	if(TextInput(currentObject).getStyle('fontWeight')=="bold")
	{
		return true;
	}
	return false;
}

private function get currentObjectIsItalic():Boolean
{
	if(!currentObject is TextInput)
	{
		return false;
	}
	if(TextInput(currentObject).getStyle('fontStyle')=="italic")
	{
		return true;
	}
	return false;
}


[Bindable]
private function get currentObject():DisplayObject
{
	return __currentObject;
}
private function set currentObject(value:DisplayObject):void
{
	__currentObject=value;
	currentObject_width=__currentObject.width;
	currentObject_height=__currentObject.height;
	currentObject_x=__currentObject.x;
	currentObject_y=__currentObject.y;
	currentObject_WH=__currentObject.width/__currentObject.height;
	if(__currentObject is TextInput)
	{
		currentObject_color=TextInput(__currentObject).getStyle("color");
		currentObject_isBold=(TextInput(__currentObject).getStyle("fontWeight")=="bold");
		currentObject_isItalic=(TextInput(__currentObject).getStyle("fontStyle")=="italic");
		currentObject_fontSize=TextInput(__currentObject).getStyle("fontSize") as Number;
		currentObject_fontName=TextInput(__currentObject).getStyle("fontFamily");
		if(TextInput(__currentObject).getStyle("textAlign")=="center")
		{
			currentObject_textAlign=1;
		}
		else if(TextInput(__currentObject).getStyle("textAlign")=="right")
		{
			currentObject_textAlign=2;
		}
		else
		{
			currentObject_textAlign=0;
		}
	}
	else
	{
		currentObject_color=__currentObject.transform.colorTransform.color;
	}
}

public static function get templatesData():XMLList
{
	return __templatesData;
}

[Bindable]
private var currentObject_width:Number;
[Bindable]
private var currentObject_height:Number;
[Bindable]
private var currentObject_WH:Number;
[Bindable]
private var currentObject_x:Number;
[Bindable]
private var currentObject_y:Number;
[Bindable]
private var currentObject_color:uint;
[Bindable]
private var currentObject_fontSize:Number;
[Bindable]
private var currentObject_fontName:String;
[Bindable]
private var currentObject_isBold:Boolean;
[Bindable]
private var currentObject_isItalic:Boolean;
[Bindable]
private var currentObject_textAlign:int=0;

private var __currentObject:DisplayObject;

private const DPI:Number=150;
private static var __templatesData:XMLList;
private var __CopyPasteActionFlag:uint=0x0;
