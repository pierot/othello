/**
* @author Pieter Michels
*/

package be.wellconsidered.utils 
{
	import flash.text.TextField;
	
	public class StringUtil
	{
		private static var instance:StringUtil;
		
		public static function getInstance():StringUtil
		{
			if (instance == null){ instance = new StringUtil(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function StringUtil(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use StringUtil.getInstance() instead of new."); }
		}	
		
		public function clearWhiteSpace(text:String):String
		{
			return text.split("\r").join("");
		}
		
		public function lastVisibleLineDotted(textfield:TextField):void
		{
			var last_line:int = textfield.getLineIndexAtPoint(0, textfield.height - 5) - 1;
			var last_line_txt:String = textfield.getLineText(last_line) + "...";
			var last_line_firstchar:int = textfield.getLineOffset(last_line);
			
			textfield.replaceText(last_line_firstchar, textfield.length, last_line_txt);
		}
		
		public function beginsWith(p_string:String, p_begin:String):Boolean 
		{
			if (p_string == null) { return false; }
			
			return p_string.indexOf(p_begin) == 0;
		}
		
		public function isEmpty(p_string:String):Boolean 
		{
			if (p_string == null) { return true; }
			
			return !p_string.length;
		}
		
		public function isNumeric(p_string:String):Boolean 
		{
			if (p_string == null) { return false; }
			
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			
			return regx.test(p_string);
		}
		
		public function stripTags(p_string:String):String 
		{
			if (p_string == null) { return ''; }
			
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}
	}
}

internal class SingletonBlocker {}
