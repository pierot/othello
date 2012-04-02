/**
* @author Pieter Michels
*/

package be.wellconsidered.display.manipulation
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import be.wellconsidered.logging.Logger;
	
	public class ImageResize extends EventDispatcher
	{
		private static var instance:ImageResize;
		
		public static function getInstance():ImageResize
		{
			if (instance == null){ instance = new ImageResize(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function ImageResize(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use ImageResize.getInstance() instead of new."); }
		}	
		
		/**
		* Returns Bitmap object with one of the sides resized to max size.
		*/
		public function resizeImageMax(param_d:DisplayObject, param_s:int):Bitmap
		{
			var ratio:Number;
			var n_width:Number = param_s;
			var n_height:Number = param_s;
			
			if(param_d.height > param_d.width)
			{
				ratio = param_d.width / param_d.height;
				
				n_width = param_s;
				n_height =  param_s / ratio;
			}
			else if(param_d.width > param_d.height)
			{
				ratio = param_d.height / param_d.width;
				
				n_height = param_s;
				n_width = param_s / ratio;
			}
			
			var bmp_d:BitmapData = new BitmapData(n_width, n_height, true, 0x00000000);
			var mat:Matrix = new Matrix();
			
			// mat.translate((param_s - n_width) / , (param_s - n_height) / 4);
			mat.scale(n_width / param_d.width, n_height / param_d.height);
			
			bmp_d.draw(param_d, mat, null, null, new Rectangle(0, 0, n_width, n_height), true);	
			
			return new Bitmap(bmp_d, "auto", true);
		}
		
		/**
		* Returns Bitmap object with the specified sizes. Cropped if needed.
		*/
		public function resizeImage(param_d:DisplayObject, param_w:int, param_h:int):Bitmap
		{
			var ratio:Number;
			var n_width:Number = param_w;
			var n_height:Number = param_h;
			
			if(param_d.height > param_d.width)
			{
				ratio = param_d.width / param_d.height;
				
				n_width = param_w;
				n_height =  param_w / ratio;
			}
			else if(param_d.width > param_d.height)
			{
				ratio = param_d.height / param_d.width;
				
				n_height = param_h;
				n_width = param_h / ratio;
			}
			
			var bmp_d:BitmapData = new BitmapData(n_width, n_height, true, 0x00000000);
			var mat:Matrix = new Matrix();
			
			mat.translate((param_w - n_width) * .5, (param_h - n_height) * .5);
			mat.scale(n_width / param_d.width, n_height / param_d.height);
			
			bmp_d.draw(param_d, mat, null, null, null, true);	
			
			var bmp:Bitmap = new Bitmap(bmp_d, "auto", true); 			
			
			return (bmp.width > param_w || bmp.height > param_h) ? cropImage(bmp, param_w, param_h) : bmp;
		}
	
		/**
		* Crop image to specified width or height
		*/
		public function cropImage(param_d:DisplayObject, param_w:int, param_h:int):Bitmap
		{
			var bmp_d:BitmapData = new BitmapData(param_w, param_h, true, 0x00000000);
			
			bmp_d.draw(param_d, null, null, null, null, true);
			
			return new Bitmap(bmp_d, "auto", true);
		}
	}
}

internal class SingletonBlocker {}
