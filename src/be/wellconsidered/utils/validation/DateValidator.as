/**
* @author Pieter Michels
*/

package be.wellconsidered.utils.validation 
{
	public class DateValidator 
	{
		private var _reDate:RegExp = /^\d{2}(|\/|)\d{2}\1\d{4}$/gim;
		
		private static var instance:DateValidator;
		
		public static function getInstance():DateValidator
		{
			if (instance == null){ instance = new DateValidator(new SingletonBlocker()); }

			return instance;
		}

		public function DateValidator(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use DateValidator.getInstance() instead of new."); }
		}
		
		/**
		* Belgian date format (dd/mm/yyyy);
		*/
		public function isBelgianDate(value:String):Boolean
		{
			return _reDate.test(value);
		}
	}
}

internal class SingletonBlocker {}
