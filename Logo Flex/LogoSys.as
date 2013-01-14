// ActionScript file
import mx.managers.PopUpManager;
import mx.controls.Alert;
import com.brandqq.lib.logo.LogoContainer;
import com.brandqq.lib.logo.LogoFile;
import com.brandqq.lib.graphic.Symbol;
import com.brandqq.lib.controls.PopUpBox;
import com.brandqq.lib.controls.PopUpBoxType;
import com.brandqq.lib.events.PopUpEvent;
import com.brandqq.app.logo.SystemEvent;
import com.brandqq.app.logo.SystemInitializer;
import mx.events.ListEvent;
import mx.events.IndexChangedEvent;
import flash.events.MouseEvent;
import flash.events.ErrorEvent;
      
private function init():void
{
	var systemInitializer:SystemInitializer=new SystemInitializer();
	systemInitializer.addEventListener(SystemEvent.INIT,function(e:SystemEvent):void
		{
			showPopupBox(e.currentState);
		}
	); 
	systemInitializer.addEventListener(SystemEvent.PROGRESS,function(e:SystemEvent):void
		{
			__popupBox.setMessage(e.currentState);
		}
	);
	systemInitializer.addEventListener(SystemEvent.COMPLETED,function(e:SystemEvent):void
		{
			hidePopupBox();
			AppViewstack.addEventListener(IndexChangedEvent.CHANGE,onAppViewstackChange);
			initComponentsData();
		}
	);
	systemInitializer.init();
}
 
private function onAppError(e:ErrorEvent):void
{
	//
}

private function initComponentsData():void
{
	LogoSysTopBar.refresh();
	if(__symbolCategoryData!=null)
	{
		LogoSymbolCateList.DataList.dataProvider=__symbolCategoryData.Category.(@parent=="0").Child;
		LogoSymbolCateList.DataList.addEventListener(ListEvent.ITEM_CLICK,onSymbolCategoryChange);
		LogoSymbolSubCateList.DataList.addEventListener(ListEvent.ITEM_CLICK,onSymbolSubCategoryChange);
	}
}

/**
* 显示PopUp
*/
public static function showPopupBox(msg:String):void
{
	if(__popupBox==null)
	{
		__popupBox=PopUpBox(PopUpManager.createPopUp(DisplayObject(Application.application),PopUpBox,true));
		__popupBox.addEventListener(PopUpEvent.CLOSE,function(e:PopUpEvent):void
			{
					hidePopupBox();
			}
		);
	}
	else
	{
		PopUpManager.addPopUp(__popupBox,DisplayObject(Application.application),true);
	}
	PopUpManager.centerPopUp(__popupBox);
	__popupBox.setMessage(msg);
	__popupBox.visible=true;
}

public static function setPopupBoxMessage(msg:String):void
{
	__popupBox.setMessage(msg);
}

/**
* 隐藏PopUp
*/
public static function hidePopupBox():void
{
	if(__popupBox==null) return;
	__popupBox.visible=false;
}

/**
* 视图切换
*/
private function onAppViewstackChange(e:IndexChangedEvent):void
{
	if(e.newIndex==1)//图形列表视图
	{
		LogoSymbolsList.loadData(LogoSymbolSubCateList.DataList.selectedItem.@code);
		if(!LogoSymbolsList.DataList.hasEventListener(ListEvent.ITEM_DOUBLE_CLICK))
		{
			LogoSymbolsList.DataList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onLogoSymbolDBClick);
		}
		StepButton2.enabled=true;
	}
	else if(e.newIndex==2)//编辑视图 文字 颜色布局
	{
		StepButton3.enabled=true;
		StepButton4.enabled=true;
		StepButton5.enabled=true;
		LogoEditorHBox.addSymbol(LogoSymbolsList.DataList.selectedItem.@code);
	}
	else if(e.newIndex==3)//保存视图
	{
		if(LogoEditorHBox.LogoContainer.getChildren().length==0)
		{
			Alert.show("当前画布是空白！");
			onStepButtonsClick(4);
			return;
		}
		var file:LogoFile=LogoEditorHBox.LogoContainer.writeFile("","",0,"");
		LogoSaverPanel.rendGraphic(file);
	}
}

/**
* 步骤切换
*/
private function onStepButtonsClick(step:uint):void
{
	switch(step)
	{
		case 1:
			AppViewstack.selectedIndex=0;
			break;
		case 2:
			AppViewstack.selectedIndex=1;
			break;
		case 3:
			AppViewstack.selectedIndex=2;
			break;
		case 4:
			AppViewstack.selectedIndex=2;
			break;
		case 5:
			AppViewstack.selectedIndex=3;
			break;
	}
}
  
/**
* 选择主分类
*/
private function onSymbolCategoryChange(e:ListEvent):void
{
	var code:String=LogoSymbolCateList.DataList.selectedItem.@code;
	if(code.length==3)
	{
		LogoSymbolSubCateList.width=300;
		LogoSymbolSubCateList.visible=true;
		LogoSymbolSubCateList.DataList.dataProvider=__symbolCategoryData.Category.(@parent==code).Child;
	}
}

/**
* 选择子分类
*/
private function onSymbolSubCategoryChange(e:ListEvent):void
{
	var code:String=LogoSymbolSubCateList.DataList.selectedItem.@code;
	if(code.length==6)
	{
		AppViewstack.selectedIndex=1;
	}
}

/**
* 选择Logo图形
*/
private function onLogoSymbolDBClick(e:ListEvent):void
{
	AppViewstack.selectedIndex=2;
}

public static function set symbolCategoryData(value:XMLList):void
{
	__symbolCategoryData=value;
}

public static function get systemFontsData():XMLList
{
	return __systemFontsData;
}
public static function set systemFontsData(value:XMLList):void
{
	__systemFontsData=value;
}

public static function set systemNamedColorsData(value:XMLList):void
{
	__systemNamedColorsData=value;
}
public static function get systemNamedColorsData():XMLList
{
	return __systemNamedColorsData;
}

public static const CANVAS_WIDTH:Number=560;
public static const CANVAS_HEIGHT:Number=400;

private static var __symbolCategoryData:XMLList;//图形分类
private static var __systemFontsData:XMLList;//系统字体
private static var __systemNamedColorsData:XMLList;//系统字体

private static var __popupBox:PopUpBox;
