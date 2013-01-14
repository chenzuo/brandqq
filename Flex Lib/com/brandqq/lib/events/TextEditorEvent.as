package com.brandqq.lib.events
{
	import flash.events.Event;
	import com.brandqq.lib.controls.TextEditor;

	/**
	 * TextEditor控件事件
	 * @author Administrator
	 * 
	 */	
	public final class TextEditorEvent extends Event
	{
		public static const ON_SELECTED:String="onSelected";
		public static const ON_CHANGE:String="onChange";
		
		public function TextEditorEvent(type:String,textEditor:TextEditor)
		{
			super(type);
			__text=textEditor;
		}
		
		public function get textEditor():TextEditor
		{
			return this.__text;
		}
		
		private var __text:TextEditor;
	}
}