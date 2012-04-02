/**
  * Ben Pritchard 
  * Reflection Class 
  * Pixelfumes.com 2006
  * ActionScript 3 Implementation of Reflect Class for AS 2 by pixelfumes.com
  */

package be.wellconsidered.display.manipulation
{
	import flash.display.*;
	import flash.geom.*;
  	
	public class Reflection
	{
		private var mcBMP:BitmapData;
		private var reflectionBMP:Bitmap;
		
		private var yDiff:Number = 0;
		
		public function Reflection(mc:Sprite, alpha:Number, ratio:Number, iHeight:Number = 0)
		{
			yDiff = iHeight > 0 ? (mc.height - iHeight) * 2 : yDiff;
			
			mcBMP = new BitmapData(mc.width, mc.height, true, 0x00FFFFFF);
			mcBMP.draw(mc);

			reflectionBMP = new Bitmap(mcBMP);

			mc.addChildAt(reflectionBMP, 1);
			mc.getChildAt(1).scaleY = -1;
			mc.getChildAt(1).y = mc.height;
			mc.addChildAt(new MovieClip(), 2);

			var fillType:String = GradientType.LINEAR;
		 	var colors:Array = [0xFFFFFF, 0xFFFFFF];
		 	var alphas:Array = [alpha / 100, 0];
		  	var ratios:Array = [0, ratio];
		  	var matr:Matrix = new Matrix();

		  	matr.createGradientBox(mc.width, mc.height, (90 / 180) * Math.PI, 0, 0);

		  	var spreadMethod:String = SpreadMethod.PAD;

			MovieClip(mc.getChildAt(2)).graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		    MovieClip(mc.getChildAt(2)).graphics.drawRect(0, 0, mc.width, mc.height / 2);

			mc.getChildAt(2).y = mc.height / 2;
			mc.getChildAt(2).cacheAsBitmap = true;
			mc.getChildAt(1).cacheAsBitmap = true;
			mc.getChildAt(1).mask = mc.getChildAt(2);
			
			mc.getChildAt(1).y -= yDiff;
			mc.getChildAt(2).y -= yDiff;
 		}
	}
}