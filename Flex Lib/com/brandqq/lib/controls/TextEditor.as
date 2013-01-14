package com.brandqq.lib.controls
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextRenderer;
	import flash.events.FocusEvent;
	import flash.events.Event;
	
	import mx.utils.StringUtil;
	
	import com.brandqq.lib.graphic.Text;
	import com.brandqq.lib.graphic.TextDecoration;
	import com.brandqq.lib.events.TextEditorEvent;
	import flash.geom.ColorTransform;

	[Event(name="onSelected",type="com.brandqq.lib.events.TextEditorEvent")]
	[Event(name="onChange",type="com.brandqq.lib.events.TextEditorEvent")]
	
	/**
	 * 表示一个文本编辑控件
	 * 其外观和文本内容基于一个com.brandqq.lib.graphicText对象
	 * @author Administrator
	 * 
	 */	
	public final class TextEditor extends TextField
	{
		public function TextEditor(textObj:Text=null)
		{
			super();
			super.type="input";
			super.border=false;
			super.selectable=true;
			super.multiline=false;
			
			__text=textObj;
			if(textObj!=null)
			{
				setText(textObj);
			}
			
			addEventListener(FocusEvent.FOCUS_IN,onFocusEventHandler);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusEventHandler);
			addEventListener(Event.CHANGE,onChangeEventHandler);
		}
		
		private function onFocusEventHandler(e:FocusEvent):void
		{
			if(e.type==FocusEvent.FOCUS_IN)
			{
				super.border=true;
				this.dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_SELECTED,this));
			}
			else if(e.type==FocusEvent.FOCUS_OUT)
			{
				if(StringUtil.trim(text)=="")
				{
					super.border=true;
				}
				else
				{
					super.border=false;
				}
			}
		}
		
		private function onChangeEventHandler(e:Event):void
		{
			if(__text!=null)
			{
				if(__text.string!=this.text)
				{
					dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_CHANGE,this));
				}
				__text.string=this.text;
			}
		}
		
		public function setText(textObj:Text):void
		{
			txtFormat=new TextFormat();
			txtFormat.font=textObj.font;
			txtFormat.size=textObj.fontSize;
			text=textObj.string;
			
			if(StringUtil.trim(text)=="")
			{
				super.border=true;
			}
			
			switch(textObj.align)
			{
				case TextDecoration.CENTER:
					txtFormat.align=TextFormatAlign.CENTER;
					break;
				case TextDecoration.RIGHT:
					txtFormat.align=TextFormatAlign.RIGHT;
					break;
				default:
					txtFormat.align=TextFormatAlign.LEFT;
					break;
			}
			
			switch(textObj.style)
			{
				case TextDecoration.BOLD:
					txtFormat.bold=true;
					break;
				case TextDecoration.ITALIC:
					txtFormat.italic=true;
					break;
				case TextDecoration.BOLD_ITALIC:
					txtFormat.bold=true;
					txtFormat.italic=true;
			}
						
			txtFormat.color=textObj.transform.colorTransform==null?0x0:textObj.transform.colorTransform.color;
			
			super.setTextFormat(txtFormat);
			this.x=textObj.rect.x;
			this.y=textObj.rect.y;
			this.width=textObj.rect.width;
			this.height=textObj.rect.height;
		}
		
		override public function setTextFormat(format:TextFormat, beginIndex:int=-1.0, endIndex:int=-1.0):void
		{
			super.setTextFormat(format);
			if(__text!=null)
			{
				if(__text.font!=txtFormat.font)
				{
					dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_CHANGE,this));
				}
				__text.font=txtFormat.font;
				
				if(__text.fontSize!=uint(txtFormat.size))
				{
					dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_CHANGE,this));
				}
				__text.fontSize=uint(txtFormat.size);
				switch(txtFormat.align)
				{
					case TextFormatAlign.CENTER:
						__text.align=TextDecoration.CENTER;
						break;
					case TextFormatAlign.RIGHT:
						__text.align=TextDecoration.RIGHT;
						break;
					default:
						__text.align=TextDecoration.LEFT;
						break;
				}
				
				__text.style=TextDecoration.NORMAL;
				if(txtFormat.bold==true)
				{
					if(__text.style!=TextDecoration.BOLD)
					{
						dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_CHANGE,this));
					}
					__text.style=TextDecoration.BOLD;
				}
				if(txtFormat.italic==true)
				{
					if(__text.style!=TextDecoration.ITALIC)
					{
						dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_CHANGE,this));
					}
					__text.style=TextDecoration.ITALIC;
				}
				if(txtFormat.italic==true && txtFormat.bold==true)
				{
					if(__text.style!=TextDecoration.BOLD_ITALIC)
					{
						dispatchEvent(new TextEditorEvent(TextEditorEvent.ON_CHANGE,this));
					}
					__text.style=TextDecoration.BOLD_ITALIC;
				}
				
				var ct:ColorTransform=__text.transform.colorTransform;
				if(ct==null)
				{
					ct=new ColorTransform();
				}
				ct.color=uint(txtFormat.color);
				__text.transform.colorTransform=ct;
				
			}
		}
		
		public function getTextObject():Text
		{
			if(__text==null)
			{
				return null;
			}			
			return __text;
		}
		
		public function get format():TextFormat
		{
			return txtFormat;
		}
		public function set format(value:TextFormat):void
		{
			txtFormat=value;
		}
		
		private var __text:Text;
		
		[Bindable]
		private var txtFormat:TextFormat;
	}
}