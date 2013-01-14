// ActionScript file
import mx.events.ResizeEvent;
import flash.events.MouseEvent;import mx.managers.PopUpManager;import mx.managers.CursorManager;import mx.core.Application;
import mx.controls.Alert;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;import com.brandqq.IO.*;import com.brandqq.lib.controls.PopUpBox;import com.brandqq.lib.controls.PopUpBoxType;import com.brandqq.lib.controls.TextEditor;import com.brandqq.lib.events.PopUpEvent;import com.brandqq.lib.events.DataLoadEvent;
import com.brandqq.lib.logo.LogoFile;import com.brandqq.lib.util.StringUtil;import com.brandqq.user.User;import com.brandqq.Resources.Requests;
import com.brandqq.app.card.SystemInitializer;import com.brandqq.app.card.events.SystemEvent;
import com.brandqq.app.card.events.CardElementEvent;
import com.brandqq.app.card.events.CardTextEvent;
import com.brandqq.app.card.events.AppStepEvent;
import com.brandqq.app.card.events.LogoPropertyEvent;
/**
* 系统初始化
*/
private function init():void
{
	//初始化基本数据	var _sysInitializer:SystemInitializer=new SystemInitializer();	_sysInitializer.addEventListener(SystemEvent.INIT,function(e:SystemEvent):void		{			showPopupBox(e.currentState);			CursorManager.setBusyCursor();		}	);	_sysInitializer.addEventListener(SystemEvent.PROGRESS,function(e:SystemEvent):void		{			__popupBox.setMessage(e.currentState);		}	);	_sysInitializer.addEventListener(SystemEvent.COMPLETED,function(e:SystemEvent):void		{			hidePopupBox();			BusinessCardTopBar.visible=true;			BusinessCardBody.visible=true;			BusinessCardBottomBar.visible=true;			//初始化用户状态			BusinessCardTopBar.refresh();			Alert.show(User.current.toString());			//初始化用户Logo数据			UserLogoList.dataProvider=__userLogosData.Logo;						//初始化名片模板数据			CardTempsList.dataProvider=__cardTemplatesData.Temps.Temp;			CardTempsList.selectedIndex=0;			CardTempsStyle.dataProvider=__cardTemplatesData.Styles.Style;			CursorManager.removeBusyCursor();		}	);	_sysInitializer.init();		RendedTextList=new Array();
}/**
* 显示PopUp
*/
public static function showPopupBox(msg:String):void{	__popupBox=PopUpBox(PopUpManager.createPopUp(DisplayObject(Application.application),PopUpBox,true));	__popupBox.addEventListener(PopUpEvent.CLOSE,function(e:PopUpEvent):void		{				hidePopupBox();		}	);	PopUpManager.centerPopUp(__popupBox);	__popupBox.setMessage(msg);	__popupBox.visible=true;
}/*** 隐藏PopUp*/public static function hidePopupBox():void{	if(__popupBox==null) return;	__popupBox.visible=false; 
}
/*** 切换当前步骤*/private function onViewStackIndexChange(e:IndexChangedEvent):void{	if(e.newIndex==1)	{		CardFacesTabNavigator.tempGuid=CardTempsList.selectedItem.@guid;		CardFacesTabNavigator.logoFile=__currentLogoFile;		if(__currentLogoFile!=null)		{			CardSettingBar.colorList=__currentLogoFile.colorList;		}	}	else if(e.newIndex==2)	{		previewCard();
	}
}
/*** CardTabNavigator.elementSelected*/private function onCardElementSelected(e:CardElementEvent):void{	if(e.element is TextEditor)	{		 	}}/*** Card text's properties change*/private function onCardTextEvent(e:CardTextEvent):void{	CardFacesTabNavigator.setTextProperty(e.type,e.propertyValue);}/*** 生成名片预览*/private function previewCard():void{	CardPreviewPanelBox.rendFile(CardFacesTabNavigator.cardFile);}/*** 保存名片*/private function SaveCardFile():void{	if(StringUtil.trim(CardTitle.text)=="" || StringUtil.trim(CardTitle.text)==__cardDefaultTitle)	{		CardTitle.setFocus();		return;	}		if(!User.loginStatus)	{		Alert.show("您目前处于未登录状态，请登录！");		return;	}		if(__savedCardFileGuid=="")	{		__savedCardFileGuid=StringUtil.newGuid;	}	try{	CursorManager.setBusyCursor();	CardFacesTabNavigator.cardFile.guid=__savedCardFileGuid;	CardFacesTabNavigator.cardFile.name=StringUtil.trim(CardTitle.text);	CardFacesTabNavigator.cardFile.uid=User.current.uid;		CardPreviewPanelBox.updateThumbnails();		var writer:FileWriter=new FileWriter(CardFacesTabNavigator.cardFile);	writer.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void		{			BusinessCardBottomBar.enabled=false;			CardPreviewPanel.enabled=false;			SaveCardProgressBar.visible=true;		}	);	writer.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void		{			BusinessCardBottomBar.enabled=true;			CardPreviewPanel.enabled=true;			SaveCardProgressBar.visible=false;			CursorManager.removeBusyCursor();		}	);	writer.save();	}catch(e:Error){Alert.show(e+'');}}private function onUserLogoListItemChange():void{	if(UserLogoList.selectedIndex<0)	{		return;	}	var _id:String=UserLogoList.selectedItem.Guid;	var reader:FileReader=new FileReader(Requests.openFileRequest(FileEnum.LOGO,_id));	reader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void		{			CurrentLogoButton.label="加载...";			CurrentLogoButton.enabled=false;		}	);	reader.addEventListener(DataLoadEvent.ON_ERROR,function(e:DataLoadEvent):void		{			CurrentLogoButton.label="编辑";		}	);	reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void		{			CurrentLogoButton.label="编辑";			CurrentLogoButton.enabled=true;			__currentLogoFile=new LogoFile();			__currentLogoFile.setFileBytes(reader.fileBytes);			CurrentLogo.logoFile=__currentLogoFile;			if(ViewStack.selectedIndex==1)//编辑			{				CardFacesTabNavigator.logoFile=__currentLogoFile;				CardSettingBar.colorList=__currentLogoFile.colorList;			}		}	);	reader.read();}public static function get logoGuid():String{	return __logoGuid;}public static function set logoGuid(value:String):void{	__logoGuid=value;}public static function get selectedCardTempGuid():String{	return __selectedCardTempGuid;}public static function set selectedCardTempGuid(value:String):void{	__selectedCardTempGuid=value;}public static function get popupBox():PopUpBox{	return __popupBox;}public static function get userLogosData():XMLList{	return __userLogosData;}public static function set userLogosData(value:XMLList):void{	__userLogosData=value;}public static function get cardTemplatesData():XMLList{	return __cardTemplatesData;}public static function set cardTemplatesData(value:XMLList):void{	__cardTemplatesData=value;}public static function get systemFontsData():XMLList{	return __systemFontsData;}public static function set systemFontsData(value:XMLList):void{	__systemFontsData=value; }private static var __logoGuid:String="";//当前LogoGuidprivate var __currentLogoFile:LogoFile;//当前Logo文件private static var __selectedCardTempGuid:String="";//当前Card Template Guidprivate var __savedCardFileGuid:String="";private static var __popupBox:PopUpBox;private static var __userLogosData:XMLList;//用户Logo列表private static var __cardTemplatesData:XMLList;//模板列表private static var __systemFontsData:XMLList;//系统字体private static var __systemIndustriesData:XMLList;//系统行业分类[Bindable]private var __cardDefaultTitle:String="请输入名片标题";public static var RendedTextList:Array;//已渲染的文字列表public static var CardPreviewZoomFactor:uint=1;//预览缩放系数