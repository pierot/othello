/**
* @author Pieter Michels
*/

package be.wellconsidered.utils 
{
	public class ArrayUtil
	{
		private static var instance:ArrayUtil;
		
		public static function getInstance():ArrayUtil
		{
			if (instance == null){ instance = new ArrayUtil(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function ArrayUtil(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use ArrayUtil.getInstance() instead of new."); }
		}	
		
		public function clone(array:Array):Array
		{
			 return array.concat();
		}
		
		public function shuffle(array:Array):Array
		{
			var len:Number = array.length; 
			var rand:Number;
			var temp:*;
			for(var i:int = 0; i < len; i++)
			{ 
					rand = Math.floor(Math.random()*len); 
					temp = array[i]; 
					array[i] = array[rand]; 
					array[rand] = temp; 
			}
		}
	}
}

internal class SingletonBlocker {}
