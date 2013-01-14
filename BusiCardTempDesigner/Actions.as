// ActionScript file
import mx.managers.PopUpManager;
import mx.core.Application;
import mx.core.IFlexDisplayObject;
import mx.controls.Button;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.controls.Image;
import mx.controls.TextInput;
import mx.containers.Canvas;

import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.display.Bitmap;
import flash.utils.ByteArray;
 
import com.brandqq.IO.FileReader;
import com.brandqq.IO.FileWriter;
import com.brandqq.IO.FileEnum;
import com.brandqq.Resources.Requests;
import com.brandqq.lib.events.DataLoadEvent;
import com.brandqq.lib.graphic.*
import com.brandqq.lib.card.*;
import com.brandqq.lib.graphic.Thumbnail;
import com.brandqq.lib.util.PNGEncoder;
import mx.core.BitmapAsset;


private function openCard():void
{
	CardFaces.selectedIndex=1;
	PropertyPanel.enabled=false;
	__popUpWindow=PopUpManager.createPopUp(Sprite(Application.application),CardTempsWindow,true);
	PopUpManager.centerPopUp(__popUpWindow);
	CardTempsWindow(__popUpWindow).addEventListener(ListWindowEvent.ITEM_SELECTED,onCardTempSelected);
}

private function importSymbol():void
{
	__popUpWindow=PopUpManager.createPopUp(Sprite(Application.application),SymbolsWindow,true);
	PopUpManager.centerPopUp(__popUpWindow);
	SymbolsWindow(__popUpWindow).addEventListener(ListWindowEvent.ITEM_SELECTED,onSymbolItemSelected);
}

private function onSymbolItemSelected(e:ListWindowEvent):void
{
	var reader:FileReader=new FileReader(Requests.cardTempSymbolGlyphRequest(e.relateId));
	reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
	{
		var symbol:Symbol=new Symbol();
		symbol.glyph=new Glyph(reader.fileBytes);
		symbol.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
		if(CardFaces.selectedIndex==0)
		{
			FrontFaceSymbolsLayer.addChild(symbol);
		}
		else
		{
			BackFaceSymbolsLayer.addChild(symbol);
		}
		currentObject=symbol;
		PopUpManager.removePopUp(__popUpWindow);
	});
	reader.read();
}

private function onCardTempSelected(e:ListWindowEvent):void
{
	//Clear Canvas
	var i:uint;
	for(i=1;i<FrontFace.numChildren;i++)
	{
		FrontFace.removeChild(FrontFace.getChildAt(i));
	}
	for(i=0;i<FrontFaceSymbolsLayer.numChildren;i++)
	{
		FrontFaceSymbolsLayer.removeChild(FrontFaceSymbolsLayer.getChildAt(i));
	}
	
	
	if(BackFace!=null)
	{
		for(i=1;i<BackFace.numChildren;i++)
		{
			BackFace.removeChild(BackFace.getChildAt(i));
		}
		for(i=0;i<BackFaceSymbolsLayer.numChildren;i++)
		{
			BackFaceSymbolsLayer.removeChild(BackFaceSymbolsLayer.getChildAt(i));
		}
	}
	CardGuid.text=e.relateId;
	for each(var obj:Object in TempStyle.dataProvider)
	{
		if(obj.@code==e.options[0])
		{
			TempStyle.selectedItem=obj;
		}
	}
	CardName.text=e.options[1];
	loadCard(e.relateId);
	PopUpManager.removePopUp(__popUpWindow);
	CardFaces.selectedIndex=0;
}

private function loadCard(guid:String):void
{
	var _reader:FileReader=new FileReader(Requests.openFileRequest(FileEnum.CARD_TEMP,guid));
	_reader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
		{
			PropertyPanel.enabled=false;
		}
	);
	_reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
		{
			PropertyPanel.enabled=true;
			try
			{
				var file:CardFile=new CardFile();
				file.setFileBytes(_reader.fileBytes);
				
				for each(var obj:Object in CardSize.dataProvider)
				{
					if(obj.w==Math.round(file.width/DPI*25.4) && obj.h==Math.round(file.height/DPI*25.4))
					{
						CardSize.selectedItem=obj;
					}
				}
			}
			catch(err:Error)
			{
				Alert.show("ERR:"+err);
			}
			PropertyPanel.enabled=true;
			rendCardTemp(file);
		}
	);
	_reader.read();
}

private function rendCardTemp(file:CardFile):void
{
	var front:CardFace=file.frontFace;
	
	var oLogo:Image;
	var oText:TextInput;

	FrontFace.setStyle("backgroundColor",front.bgColor);
	if(front.hasLogo)
	{
		oLogo=getNewLogoSign();
		oLogo.move(front.logoRect.x,front.logoRect.y);
		oLogo.setActualSize(front.logoRect.width,front.logoRect.height);
		FrontFace.addChild(oLogo);
	}
	 
	for each(var objFS:Symbol in front.symbols)
	{
		objFS.rend();
		FrontFaceSymbolsLayer.addChild(objFS);
		objFS.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
	}
	
	for each(var objFT:Text in front.texts)
	{
		oText=new TextInput();
		oText.text=objFT.string;
		oText.x=objFT.rect.x;
		oText.y=objFT.rect.y;
		oText.width=objFT.rect.width;
		oText.height=objFT.rect.height;
		oText.setStyle("fontFamily",objFT.font);
		oText.setStyle("fontSize",objFT.fontSize);
		if(objFT.align==TextDecoration.CENTER)
		{
			oText.setStyle("textAlign","center");
		}
		else if(objFT.align==TextDecoration.RIGHT)
		{
			oText.setStyle("textAlign","right");
		}
		else
		{
			oText.setStyle("textAlign","left");
		}
		if(objFT.style==TextDecoration.BOLD_ITALIC)
		{
			oText.setStyle("fontWeight","bold");
			oText.setStyle("fontStyle","italic");
		}
		else if(objFT.style==TextDecoration.BOLD)
		{
			oText.setStyle("fontWeight","bold");
		}
		else if(objFT.style==TextDecoration.ITALIC)
		{
			oText.setStyle("fontStyle","italic");
		}
		if(objFT.transform.colorTransform!=null)
		{
			oText.setStyle("color",objFT.transform.colorTransform.color);
		}
		oText.styleName="textObj";
		oText.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
		FrontFace.addChildAt(oText,objFT.depth);
	}
	
	if(file.backFace!=null)
	{
		var back:CardFace=file.backFace;
		
		BackFace.setStyle("backgroundColor",back.bgColor);
		
		if(back.hasLogo)
		{
			oLogo=getNewLogoSign();
			oLogo.move(back.logoRect.x,back.logoRect.y);
			oLogo.setActualSize(back.logoRect.width,back.logoRect.height);
			BackFace.addChild(oLogo);
		}
		
		for each(var objBS:Symbol in back.symbols)
		{
			objBS.rend();
			BackFaceSymbolsLayer.addChild(objBS);
			objBS.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
		}
		
		for each(var objBT:Text in back.texts)
		{
			oText=new TextInput();
			oText.text=objBT.string;
			oText.x=objBT.rect.x;
			oText.y=objBT.rect.y;
			oText.width=objBT.rect.width;
			oText.height=objBT.rect.height;
			oText.setStyle("fontFamily",objBT.font);
			oText.setStyle("fontSize",objBT.fontSize);
			if(objBT.align==TextDecoration.CENTER)
			{
				oText.setStyle("textAlign","center");
			}
			else if(objBT.align==TextDecoration.RIGHT)
			{
				oText.setStyle("textAlign","right");
			}
			else
			{
				oText.setStyle("textAlign","left");
			}
			if(objBT.style==TextDecoration.BOLD_ITALIC)
			{
				oText.setStyle("fontWeight","bold");
				oText.setStyle("fontStyle","italic");
			}
			else if(objBT.style==TextDecoration.BOLD)
			{
				oText.setStyle("fontWeight","bold");
			}
			else if(objBT.style==TextDecoration.ITALIC)
			{
				oText.setStyle("fontStyle","italic");
			}
			if(objBT.transform.colorTransform!=null)
			{
				oText.setStyle("color",objBT.transform.colorTransform.color);
			}
			oText.styleName="textObj";
			oText.addEventListener(MouseEvent.MOUSE_DOWN,onObjectMouseDownEvent);
			BackFace.addChild(oText);
		}
	}
}

private function saveCard(e:MouseEvent):void
{
	if(FrontFace.numChildren==1 && FrontFaceSymbolsLayer.numChildren<1)
	{
		Alert.show("名片正面不可为空白！");
		return;
	} 
	
	if(CardName.text=="")
	{
		Alert.show("模板标题不可为空！");
		return;
	}
	
	if(TempStyle.selectedItem.@code=="")
	{
		Alert.show("必须选择一个模板风格！");
		return;
	}
	
	var cardFile:CardFile=new CardFile(true);
	cardFile.guid=CardGuid.text;
	cardFile.name=CardName.text;
	cardFile.width=Number(CardSize.selectedItem.w)/25.4*DPI;
	cardFile.height=Number(CardSize.selectedItem.h)/25.4*DPI;
	cardFile.uid=0;
	
	var logo:DisplayObject; 
	var symbol:Symbol;
	var input:TextInput;
	var txtObj:Text;
	var ct:ColorTransform;
	
	var front:CardFace=new CardFace();
	front.bgColor=uint(FrontFace.getStyle("backgroundColor"));
	if(FrontFace.getChildByName("QQ_LOGOSIGN")!=null) 
	{
		logo=FrontFace.getChildByName("QQ_LOGOSIGN");
		front.hasLogo=true;
		front.logoDepth=FrontFace.getChildIndex(logo);
		front.logoRect=logo.getRect(FrontFace);
	}
	
	var i:uint;
	
	for(i=0;i<FrontFaceSymbolsLayer.numChildren;i++)
	{
		if(FrontFaceSymbolsLayer.getChildAt(i) is Symbol)
		{ 
			symbol=FrontFaceSymbolsLayer.getChildAt(i) as Symbol;
			symbol.depth=i;
			symbol.setRect(symbol.getRect(FrontFaceSymbolsLayer));
			front.symbols.push(symbol);
		}
	}
	 
	for(i=0;i<FrontFace.numChildren;i++)
	{
		if(FrontFace.getChildAt(i) is TextInput)
		{
			try
			{
			input=TextInput(FrontFace.getChildAt(i));
			txtObj=new Text();
			txtObj.string=input.text;
			txtObj.depth=i;
			txtObj.font=input.getStyle("fontFamily")+'';
			txtObj.fontSize=uint(input.getStyle("fontSize"));
			txtObj.style=TextDecoration.NORMAL;
			
			if(input.getStyle("textAlign")=="center")
			{
				txtObj.align=TextDecoration.CENTER;
			}
			else if(input.getStyle("textAlign")=="right")
			{
				txtObj.align=TextDecoration.RIGHT;
			}
			else
			{
				txtObj.align=TextDecoration.LEFT;
			}
			
			if(input.getStyle("fontWeight")=="bold")
			{
				txtObj.style=TextDecoration.BOLD;
			}
			else if(input.getStyle("fontStyle")=="italic")
			{
				txtObj.style=TextDecoration.ITALIC;
			}
			else if(input.getStyle("fontStyle")=="italic" && input.getStyle("fontWeight")=="bold")
			{ 
				txtObj.style=TextDecoration.BOLD_ITALIC;
			}
			
			ct=new ColorTransform();
			ct.color=uint(input.getStyle("color"));
			txtObj.transform.colorTransform=ct;
			txtObj.setRect(new Rectangle(input.x,input.y,input.width,input.height));
			front.texts.push(txtObj);
			
			}
			catch(err:Error)
			{
				Alert.show(err+'');
			}
		} 
	}
	cardFile.frontFace=front;
	//缩略图
	cardFile.frontFace.thumbnail=new Thumbnail(getFaceThumbnail(FrontFace));
	
	if(BackFace!=null)
	{
		//背面 
		if(BackFace.numChildren>1)
		{
			var back:CardFace=new CardFace(CardFace.FACE_BACK);
			back.bgColor=uint(BackFace.getStyle("backgroundColor"));
			//背面Logo
			if(BackFace.getChildByName("QQ_LOGOSIGN")!=null)
			{
				logo=BackFace.getChildByName("QQ_LOGOSIGN");
				back.hasLogo=true;
				back.logoDepth=BackFace.getChildIndex(logo);
				back.logoRect=logo.getRect(BackFace);
			}
			//背面图形
			for(i=0;i<BackFaceSymbolsLayer.numChildren;i++)
			{
				if(BackFaceSymbolsLayer.getChildAt(i) is Symbol)
				{
					symbol=Symbol(BackFaceSymbolsLayer.getChildAt(i));
					symbol.depth=i;
					back.symbols.push(symbol);
				}
			}
			//背面文字
			for(i=0;i<BackFace.numChildren;i++)
			{
				if(BackFace.getChildAt(i) is TextInput)
				{
					input=TextInput(BackFace.getChildAt(i));
					txtObj=new Text();
					txtObj.string=input.text;
					txtObj.depth=i;
					txtObj.font=input.getStyle("fontFamily")+'';
					txtObj.fontSize=uint(input.getStyle("fontSize"));
					txtObj.style=TextDecoration.NORMAL; 
					
					if(input.getStyle("textAlign")=="center")
					{
						txtObj.align=TextDecoration.CENTER;
					}
					else if(input.getStyle("textAlign")=="right")
					{
						txtObj.align=TextDecoration.RIGHT;
					}
					else
					{
						txtObj.align=TextDecoration.LEFT;
					}
					
					if(input.getStyle("fontWeight")=="bold")
					{
						txtObj.style=TextDecoration.BOLD;
					}
					else if(input.getStyle("fontStyle")=="italic")
					{
						txtObj.style=TextDecoration.ITALIC;
					}
					else if(input.getStyle("fontStyle")=="italic" && input.getStyle("fontWeight")=="bold")
					{
						txtObj.style=TextDecoration.BOLD_ITALIC;
					}
					
					ct=new ColorTransform();
					ct.color=uint(input.getStyle("color"));
					txtObj.transform.colorTransform=ct;
					txtObj.setRect(new Rectangle(input.x,input.y,input.width,input.height));
					back.texts.push(txtObj);
				}
			}
			cardFile.backFace=back;
			//缩略图
			cardFile.backFace.thumbnail=new Thumbnail(getFaceThumbnail(BackFace));
		}
	} 
		
	var tempFile:CardTempFile=new CardTempFile(TempStyle.selectedItem.@code,cardFile);
	
	var writer:FileWriter=new FileWriter(tempFile);
	writer.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
		{
			PropertyPanel.title="正在保存......";
			PropertyPanel.enabled=false;
		}
	);
	writer.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
		{
			PropertyPanel.title="模板属性";
			PropertyPanel.enabled=true;
		}
	);
	writer.save();
}


private function getFaceThumbnail(face:Canvas):ByteArray
{
	var bitmapData:BitmapData=new BitmapData(face.width,face.height,false,face.getStyle("backgroundColor"));
	var drawObj:DisplayObject;
	var i:int;
	
	if(face.id=="FrontFace")
	{
		for(i=0;i<FrontFaceSymbolsLayer.numChildren;i++)
		{
			drawObj=FrontFaceSymbolsLayer.getChildAt(i);
			bitmapData.draw(drawObj,drawObj.transform.matrix,drawObj.transform.colorTransform);
		}
	}
	else
	{
		for(i=0;i<BackFaceSymbolsLayer.numChildren;i++)
		{
			drawObj=BackFaceSymbolsLayer.getChildAt(i);
			bitmapData.draw(drawObj,drawObj.transform.matrix,drawObj.transform.colorTransform);
		}
	}
	
	for(i=1;i<face.numChildren;i++)
	{
		drawObj=face.getChildAt(i);
		if(drawObj is TextInput)
		{
			TextInput(drawObj).setStyle("borderStyle","none");
		}
		bitmapData.draw(drawObj,drawObj.transform.matrix,drawObj.transform.colorTransform);
		if(drawObj is TextInput)
		{
			TextInput(drawObj).setStyle("borderStyle","solid");
		}
	}
	
	var bytes:ByteArray=PNGEncoder.encode(bitmapData);
	return bytes;
}

public static function get cardTemplateSymbolsData():XMLList
{
	return __cardTemplateSymbolsData;
}
public static function set cardTemplateSymbolsData(value:XMLList):void
{
	__cardTemplateSymbolsData=value;
}

private static var __cardTemplateSymbolsData:XMLList;
private var __popUpWindow:IFlexDisplayObject;