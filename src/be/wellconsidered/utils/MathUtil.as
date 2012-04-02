/**
* @author Pieter Michels
*/

package be.wellconsidered.utils 
{
	public class MathUtil
	{
		private static var instance:MathUtil;
		
		public static function getInstance():MathUtil
		{
			if (instance == null){ instance = new MathUtil(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function MathUtil(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use MathUtil.getInstance() instead of new."); }
		}	
		
		public function random(min:Number, max:Number):Number
		{
			return min + Math.random() * (max + Math.abs(min));  		
		}
	}
}

internal class SingletonBlocker {}
