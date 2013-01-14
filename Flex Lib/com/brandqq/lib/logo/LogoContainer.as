package com.brandqq.lib.logo
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import com.brandqq.IO.FileEnum;
	import com.brandqq.IO.FileReader;
	import com.brandqq.Resources.Requests;
	import com.brandqq.lib.controls.Selector;
	import com.brandqq.lib.controls.SelectorContainer;
	import com.brandqq.lib.graphic.IVector;
	import com.brandqq.lib.graphic.Symbol;
	import com.brandqq.lib.graphic.Text;
	import com.brandqq.lib.graphic.Glyph;
	import com.brandqq.lib.events.DataLoadEvent;
	import com.brandqq.lib.util.StringUtil;
	
	//test imports
	import mx.controls.Alert;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	[Event(name="onOpen",type="com.brandqq.lib.events.DataLoadEvent")]
	[Event(name="onLoaded",type="com.brandqq.lib.events.DataLoadEvent")]
	
	/**
	 * 表示Logo的编辑容器
	 * @author Administrator
	 * 
	 */	
	public final class LogoContainer extends SelectorContainer
	{
		/**
		 * 构造函数
		 * @return 
		 * 
		 */
		public function LogoContainer()
		{
			super();
		}
		
		public function openLogo(guid:String):void
		{
			__logoFile=new LogoFile();
			var reader:FileReader=new FileReader(Requests.openFileRequest(FileEnum.LOGO,guid));
			reader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
				{
					dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_OPEN));
				}
			);
			reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
				{
					__logoFile.setFileBytes(reader.fileBytes);
					rendLogoFile();
					dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADED));
				}
			);
			reader.read();
		}
		
		private function rendLogoFile():void
		{
			var obj:Symbol;
			for(var i:uint=0;i<__logoFile.elements.length;i++)
			{
				obj=Symbol(__logoFile.elements[i]);
				obj.rend();
				addChild(Symbol(obj));
			}
		}
		
		
		public function addSymbol(symbolId:String):void
		{
			var reader:FileReader=new FileReader(Requests.logoSymbolGlyphRequest(symbolId));
			reader.addEventListener(DataLoadEvent.ON_OPEN,function(e:DataLoadEvent):void
				{
					dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_OPEN));
				}
			);
			reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
				{
					if(__currentSyombol==null)
					{
						__currentSyombol=new Symbol();
						__currentSyombol.depth=getNewDepth();
						addChildAt(__currentSyombol,__currentSyombol.depth);
					}
					__currentSyombol.glyph=new Glyph(reader.fileBytes);
					__currentSyombol.rend();
					__currentSyombol.transform.matrix=new Matrix();
					__currentSyombol.transform.colorTransform=new ColorTransform();
					__currentSyombol.x=this.width/2-__currentSyombol.rect.width/2;
					__currentSyombol.y=this.height/2-__currentSyombol.rect.height/2;
					selectNothing();
					dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADED));
				}
			);
			reader.read();
		}
		
		public function addText(text:String,font:String,size:uint,style:uint):void
		{
			var reader:FileReader=new FileReader(Requests.textGlyphRequest(text,font,size,style));
			reader.addEventListener(DataLoadEvent.ON_LOADED,function(e:DataLoadEvent):void
				{
					var textObj:Text;
					if(!(__selectedItem is Text))
					{
						textObj=new Text(text,font,size,getNewDepth(),style);
						textObj.transform.matrix=new Matrix();
						addChildAt(textObj,textObj.depth);
						textObj.x=this.width/2-textObj.rect.width/2;
						textObj.y=this.height/2-textObj.rect.height/2;
					}
					else
					{
						textObj=Text(__selectedItem);
					}
					textObj.string=text;
					textObj.font=font;
					textObj.fontSize=size;
					textObj.style=style;
					textObj.glyph=new Glyph(reader.fileBytes);
					textObj.rend();
					selectNothing();
					dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_LOADED));
				}
			);
			reader.read();
			dispatchEvent(new DataLoadEvent(DataLoadEvent.ON_OPEN));
		}
		
		public function writeFile(title:String,guid:String,uid:uint,remark:String):LogoFile
		{
			var file:LogoFile=new LogoFile();
			file.title=title;
			file.guid=guid;
			file.uid=uid;
			file.remark=remark;
			file.date=StringUtil.currentDateString;
			file.rect=getChildrenRectangle();
			for each(var obj:IVector in this.getChildren())
			{
				if(obj is Text)
				{
					file.texts.push(obj);
				}
				else
				{
					file.symbols.push(obj);
				}
			}
			file.thumbnail=this.getThumbnail();
			return file;
		}
		
		/**
		 * 获取当前包含的LogoFile
		 * @return 
		 * 
		 */
		public function get logoFile():LogoFile
		{
			return this.__logoFile;
		}
		
		private var __logoFile:LogoFile;
		private var __currentSyombol:Symbol;
		
	}
}