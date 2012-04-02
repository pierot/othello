/**
* @author Pieter Michels
*/

package be.wellconsidered.utils 
{
	import flash.display.DisplayObjectContainer;
	
	public class DisplayListUtil
	{
		private static var instance:DisplayListUtil;
		
		public static function getInstance():DisplayListUtil
		{
			if (instance == null){ instance = new DisplayListUtil(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function DisplayListUtil(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use DisplayListUtil.getInstance() instead of new."); }
		}	
		
		public function removeAll(doc:DisplayObjectContainer):void
		{
			try
			{
				while(doc.removeChildAt(0)){}
			}
			catch(re:RangeError){}
		}
	}
}

internal class SingletonBlocker {}
