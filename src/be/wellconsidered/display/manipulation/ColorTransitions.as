/**
* @author Pieter Michels
*/

package be.wellconsidered.display.manipulation 
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	public class ColorTransitions 
	{
		private static var instance:ColorTransitions;
		
		private var redIdentify:Array 	= 	[1, 0, 0, 0, 0];
		private var greenIdentify:Array = 	[0, 1, 0, 0, 0];
		private var blueIdentify:Array 	= 	[0, 0, 1, 0, 0];
		private var alphaIdentify:Array = 	[0, 0, 0, 1, 0];
		
		public static function getInstance():ColorTransitions
		{
			if (instance == null){ instance = new ColorTransitions(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function ColorTransitions(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use ColorTransitions.getInstance() instead of new."); }
		}
		
		public function setSaturation(target:DisplayObject, amount:Number):void
		{
			// A desaturated channel has a luminance of 30% red, 59% green,
			// and 11% blue. Its row in the matrix would be the following -
			// this will be used to blend with the identity rows to show
			// a variable grayscale or desaturation in the image
			var grayluma:Array 			= [.3, .59, .11, 0, 0];
			var colMatrix:Array 		= new Array();
			var cmf:ColorMatrixFilter 	= new ColorMatrixFilter();
			
			colMatrix = colMatrix.concat( interpolateArrays(grayluma, redIdentify, amount));
			colMatrix = colMatrix.concat( interpolateArrays(grayluma, greenIdentify, amount));
			colMatrix = colMatrix.concat( interpolateArrays(grayluma, blueIdentify, amount));
			colMatrix = colMatrix.concat( alphaIdentify ); // alpha not affected
			
			cmf.matrix = colMatrix;
			
			target.filters = [cmf];
		}
		
		public function overBright(target:DisplayObject, amount:Number):void
		{
			var cmf:ColorMatrixFilter 	= new ColorMatrixFilter();
			var overbriteLuma:Array 	= [1, 1, 1, 0, 0];
			var colMatrix:Array 		= new Array();
			
			amount = 1 - amount;
			
			colMatrix = colMatrix.concat( interpolateArrays(overbriteLuma, redIdentify, amount));
			colMatrix = colMatrix.concat( interpolateArrays(overbriteLuma, greenIdentify, amount));
			colMatrix = colMatrix.concat( interpolateArrays(overbriteLuma, blueIdentify, amount));
			colMatrix = colMatrix.concat( alphaIdentify ); // alpha not affected
			
			cmf.matrix = colMatrix;
			
			target.filters = [cmf];
		}
		
		public function interpolateArrays(arr1:Array, arr2:Array, t:Number):Array
		{
			var result:Array 	= arr1.length >= arr2.length ? arr1.slice() : arr2.slice();
			var i:int 			= result.length;
			
			while (i--) { result[i] = arr1[i] + (arr2[i] - arr1[i]) * t; }
			
			return result;
		}
	}	
}

internal class SingletonBlocker {}
