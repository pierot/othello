/**
* @author Pieter Michels
*/

package be.wellconsidered.utils 
{
	import flash.display.Bitmap;
	
	public class BitmapUtil
	{
		private static var instance:BitmapUtil;
		
		public static function getInstance():BitmapUtil
		{
			if (instance == null){ instance = new BitmapUtil(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function BitmapUtil(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use BitmapUtil.getInstance() instead of new."); }
		}	
		
		public function copyBitmap(bmp:Bitmap):Bitmap
		{
			 return new Bitmap(bmp.bitmapData);
		}
	}
}

internal class SingletonBlocker {}
