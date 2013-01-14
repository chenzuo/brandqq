package com.brandqq.lib.logo
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import flash.display.DisplayObject;
	
	import com.brandqq.IO.FileEnum;
	import com.brandqq.lib.logo.LogoFile;
	import com.brandqq.lib.graphic.Symbol;
	import com.brandqq.lib.graphic.Text;
	import com.brandqq.lib.graphic.IVector;
	import com.brandqq.lib.graphic.VectorRendMode;
	
	import mx.controls.Alert;
	import flash.geom.Point;
	/**
	 * 表示Logo非编辑状态下的矢量呈现
	 * @author Administrator
	 * 
	 */	
	public class LogoGraphic extends UIComponent implements IVector
	{
		public function LogoGraphic(file:LogoFile=null)
		{
			super();
			super.x=0;
			super.y=0;
			
			container=new UIComponent();
			container.addEventListener(FlexEvent.CREATION_COMPLETE,function(e:FlexEvent):void
			{
				rend();
				container.removeEventListener(FlexEvent.CREATION_COMPLETE,this);
			});
			addChild(container);

			if(file==null)
			{
				file=LogoFile.EMPTY();
			}
			__logoFile=file;
		}
		
		private function rend():void
		{
			clear();
			
			width=FileEnum.LOGO_THUMBNAIL_WIDTH;
			height=FileEnum.LOGO_THUMBNAIL_HEIGHT;
			
			var newSize:Point=new Point(__logoFile.rect.width,__logoFile.rect.height);
			
			//较宽
			if(__logoFile.rect.width/__logoFile.rect.height > FileEnum.LOGO_THUMBNAIL_WIDTH/FileEnum.LOGO_THUMBNAIL_HEIGHT)
			{
				newSize.x=FileEnum.LOGO_THUMBNAIL_WIDTH;
				newSize.y=__logoFile.rect.height*FileEnum.LOGO_THUMBNAIL_WIDTH/__logoFile.rect.width;
			}
			//符合
			else if(__logoFile.rect.width/__logoFile.rect.height == FileEnum.LOGO_THUMBNAIL_WIDTH/FileEnum.LOGO_THUMBNAIL_HEIGHT)
			{
				newSize.x=FileEnum.LOGO_THUMBNAIL_WIDTH;
				newSize.y=FileEnum.LOGO_THUMBNAIL_HEIGHT;
			}
			else//较高
			{
				newSize.x=__logoFile.rect.width*FileEnum.LOGO_THUMBNAIL_HEIGHT/__logoFile.rect.height;
				newSize.y=FileEnum.LOGO_THUMBNAIL_HEIGHT;
			}
			
			container.width=FileEnum.LOGO_THUMBNAIL_WIDTH;
			container.height=FileEnum.LOGO_THUMBNAIL_HEIGHT;
			container.scaleX=newSize.x/__logoFile.rect.width;
			container.scaleY=newSize.y/__logoFile.rect.height;
			container.x=0;
			container.y=0;
			container.x+=(FileEnum.LOGO_THUMBNAIL_WIDTH-newSize.x)/2;
			container.y+=(FileEnum.LOGO_THUMBNAIL_HEIGHT-newSize.y)/2;
			
			var newObj:Symbol;
			for each(var obj:Symbol in __logoFile.elements)
			{
				if(obj is Text)
				{
					newObj=Text.createFromBytes(obj.getBytes()) as Symbol;
				}
				else
				{
					newObj=Symbol.createFromBytes(obj.getBytes());
				}
				if(__logoFile.isEmptyLogo)
				{
					newObj.rend(0,0,VectorRendMode.OUTLINE);
				}
				else
				{
					newObj.rend();
				}
				container.addChild(newObj);
				newObj.x-=__logoFile.rect.x;
				newObj.y-=__logoFile.rect.y;
			}
		}
				
		private function clear():void
		{
			this.graphics.clear();
			if(container!=null)
			{
				this.removeChild(container);
			}
			container=new UIComponent();
			addChild(container);
		}
		
		public function get logoFile():LogoFile
		{
			return __logoFile;
		}
		public function set logoFile(value:LogoFile):void
		{
			__logoFile=value;
			if(value!=null)
			{
				rend();
			}
		}
		
		override public function set width(value:Number):void
		{
			super.width=value;
			container.x=0;
			container.width=value;
		}
		
		override public function set height(value:Number):void
		{
			super.height=value;
			container.y=0;
			container.height=value;
		}
		
		private var __logoFile:LogoFile;
		private var container:UIComponent;
		private var __children:Array;
	}
}